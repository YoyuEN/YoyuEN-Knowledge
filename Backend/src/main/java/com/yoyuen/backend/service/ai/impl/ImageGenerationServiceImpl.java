package com.yoyuen.backend.service.ai.impl;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.yoyuen.backend.config.ImageGenerationConfig;
import com.yoyuen.backend.service.ai.ImageGenerationService;
import com.yoyuen.backend.service.ai.LLMService;
import com.yoyuen.backend.service.system.ObjectStoreService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.*;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;

import java.io.InputStream;
import java.net.URL;
import java.util.HashMap;
import java.util.Map;
import java.util.UUID;

/**
 * @Author: YoyuEN
 * @Date: 2026/3/6
 * @Description: 文生图服务实现类
 */
@Slf4j
@Service
@RequiredArgsConstructor
public class ImageGenerationServiceImpl implements ImageGenerationService {

    private final ImageGenerationConfig config;
    private final LLMService llmService;
    private final ObjectStoreService objectStoreService;
    private final RestTemplate restTemplate = new RestTemplate();
    private final ObjectMapper objectMapper = new ObjectMapper();

    @Override
    public String generateImage(String prompt) {
        try {
            // 构建请求体
            Map<String, Object> requestBody = new HashMap<>();
            requestBody.put("model", config.getModel());

            Map<String, Object> input = new HashMap<>();
            input.put("prompt", prompt);
            input.put("negative_prompt", "低质量,模糊,变形");
            requestBody.put("input", input);

            Map<String, Object> parameters = new HashMap<>();
            parameters.put("size", config.getSize());
            parameters.put("n", 1);
            parameters.put("style", config.getStyle());
            requestBody.put("parameters", parameters);

            // 设置请求头
            HttpHeaders headers = new HttpHeaders();
            headers.setContentType(MediaType.APPLICATION_JSON);
            headers.set("Authorization", "Bearer " + config.getApiKey());
            headers.set("X-DashScope-Async", "enable");

            HttpEntity<Map<String, Object>> entity = new HttpEntity<>(requestBody, headers);

            // 发送请求
            log.info("调用文生图API，提示词: {}", prompt);
            ResponseEntity<String> response = restTemplate.postForEntity(
                    config.getBaseUrl(),
                    entity,
                    String.class
            );

            if (response.getStatusCode() == HttpStatus.OK) {
                JsonNode jsonNode = objectMapper.readTree(response.getBody());
                String taskId = jsonNode.path("output").path("task_id").asText();

                // 轮询获取结果
                return pollTaskResult(taskId);
            } else {
                log.error("文生图API调用失败: {}", response.getBody());
                return null;
            }
        } catch (Exception e) {
            log.error("生成图片失败", e);
            return null;
        }
    }

    @Override
    public String generateCoverForContent(String title, String content) {
        try {
            // 使用LLM生成图片提示词
            String promptGenerationPrompt = String.format(
                    "根据以下文章标题和内容，生成一个适合作为封面的插画风格图片描述。" +
                    "要求：简洁、视觉化、符合插画风格，不超过50字。" +
                    "只返回图片描述，不要其他内容。\n\n" +
                    "标题：%s\n内容摘要：%s",
                    title,
                    content.length() > 200 ? content.substring(0, 200) : content
            );

            String imagePrompt = llmService.getChatModel().call(promptGenerationPrompt);
            log.info("生成的图片提示词: {}", imagePrompt);

            // 生成图片
            String imageUrl = generateImage(imagePrompt);

            if (imageUrl != null) {
                // 下载图片并上传到MinIO
                return downloadAndUploadImage(imageUrl);
            }

            return null;
        } catch (Exception e) {
            log.error("生成文章封面失败", e);
            return null;
        }
    }

    /**
     * 轮询获取任务结果
     */
    private String pollTaskResult(String taskId) throws Exception {
        String queryUrl = "https://dashscope.aliyuncs.com/api/v1/tasks/" + taskId;
        HttpHeaders headers = new HttpHeaders();
        headers.set("Authorization", "Bearer " + config.getApiKey());
        HttpEntity<Void> entity = new HttpEntity<>(headers);

        int maxRetries = 30;
        int retryCount = 0;

        while (retryCount < maxRetries) {
            Thread.sleep(2000); // 等待2秒

            ResponseEntity<String> response = restTemplate.exchange(
                    queryUrl,
                    HttpMethod.GET,
                    entity,
                    String.class
            );

            JsonNode jsonNode = objectMapper.readTree(response.getBody());
            String status = jsonNode.path("output").path("task_status").asText();

            if ("SUCCEEDED".equals(status)) {
                String imageUrl = jsonNode.path("output").path("results").get(0).path("url").asText();
                log.info("图片生成成功: {}", imageUrl);
                return imageUrl;
            } else if ("FAILED".equals(status)) {
                log.error("图片生成失败: {}", jsonNode.path("output").path("message").asText());
                return null;
            }

            retryCount++;
        }

        log.error("图片生成超时");
        return null;
    }

    /**
     * 下载图片并上传到MinIO
     */
    private String downloadAndUploadImage(String imageUrl) {
        try {
            // 下载图片
            URL url = new URL(imageUrl);
            InputStream inputStream = url.openStream();

            // 生成文件名
            String fileName = "cover_" + UUID.randomUUID().toString() + ".png";

            // 获取文件大小（需要先读取到内存）
            byte[] imageBytes = inputStream.readAllBytes();
            long fileSize = imageBytes.length;

            // 上传到MinIO
            String objectPath = objectStoreService.uploadFile(
                    new java.io.ByteArrayInputStream(imageBytes),
                    fileSize,
                    "content-covers",
                    fileName,
                    "image/png"
            );

            // uploadFile已经返回完整路径：bucketName/objectName
            return objectPath;
        } catch (Exception e) {
            log.error("下载并上传图片失败", e);
            return null;
        }
    }
}
