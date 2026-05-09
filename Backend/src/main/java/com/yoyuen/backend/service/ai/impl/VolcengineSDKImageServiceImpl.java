package com.yoyuen.backend.service.ai.impl;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.yoyuen.backend.config.VolcengineProperties;
import com.yoyuen.backend.service.ai.ImageGenerationService;
import com.yoyuen.backend.service.ai.LLMService;
import com.yoyuen.backend.service.system.ObjectStoreService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.context.annotation.Primary;
import org.springframework.http.*;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;

import java.io.ByteArrayInputStream;
import java.io.InputStream;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;

/**
 * @Author: YoyuEN
 * @Date: 2026/3/7
 * @Description: 火山引擎 Ark API 图像处理服务实现（豆包大模型）
 */
@Slf4j
@Service
@Primary
@RequiredArgsConstructor
public class VolcengineSDKImageServiceImpl implements ImageGenerationService {

    private final VolcengineProperties volcengineProperties;
    private final ObjectStoreService objectStoreService;
    private final LLMService llmService;
    private final RestTemplate restTemplate = new RestTemplate();
    private final ObjectMapper objectMapper = new ObjectMapper();

    @Override
    public String generateImage(String prompt) {
        try {
            log.info("[豆包文生图] 开始生成图片，prompt: {}", prompt);

            Map<String, Object> requestBody = new HashMap<>();
            requestBody.put("model", volcengineProperties.getArk().getModel());
            requestBody.put("prompt", prompt);
            requestBody.put("response_format", "url");
            requestBody.put("size", "2560x1440");
            requestBody.put("watermark", false);

            String bodyJson = objectMapper.writeValueAsString(requestBody);

            HttpHeaders headers = new HttpHeaders();
            headers.setContentType(MediaType.APPLICATION_JSON);
            headers.set("Authorization", "Bearer " + volcengineProperties.getArk().getApiKey());

            HttpEntity<String> entity = new HttpEntity<>(bodyJson, headers);
            String url = volcengineProperties.getArk().getEndpoint() + "/images/generations";

            log.info("[豆包文生图] 请求URL: {}, body: {}", url, bodyJson);
            ResponseEntity<Map> response = restTemplate.exchange(url, HttpMethod.POST, entity, Map.class);

            if (response.getStatusCode() == HttpStatus.OK && response.getBody() != null) {
                Map<String, Object> result = response.getBody();
                log.info("[豆包文生图] 响应: {}", result);

                Object data = result.get("data");
                if (data instanceof List) {
                    List<?> dataList = (List<?>) data;
                    if (!dataList.isEmpty() && dataList.get(0) instanceof Map) {
                        Map<?, ?> firstItem = (Map<?, ?>) dataList.get(0);
                        String resultUrl = (String) firstItem.get("url");
                        log.info("[豆包文生图] 生成成功，结果URL: {}", resultUrl);

                        if (resultUrl == null || !resultUrl.startsWith("http")) {
                            log.error("[豆包文生图] URL格式异常: {}", resultUrl);
                            return null;
                        }

                        return downloadAndUploadToMinio(resultUrl, "content-covers", "cover_", "image/png");
                    }
                }
            }

            // 记录详细的错误响应
            log.error("[豆包文生图] 生成失败, HTTP状态码: {}, 响应体: {}",
                    response.getStatusCode(), response.getBody());
            return null;

        } catch (Exception e) {
            log.error("[豆包文生图] 生成异常: {}", e.getMessage(), e);
            return null;
        }
    }

    @Override
    public String generateCoverForContent(String title, String content) {
        try {
            // 使用 LLM 生成图片提示词
            String promptGenerationPrompt = String.format(
                    "根据以下文章标题和内容，生成一个适合作为封面的插画风格图片描述。" +
                    "要求：简洁、视觉化、符合插画风格，不超过50字。" +
                    "只返回图片描述，不要其他内容。\n\n" +
                    "标题：%s\n内容摘要：%s",
                    title,
                    content.length() > 200 ? content.substring(0, 200) : content
            );

            String imagePrompt = llmService.getChatModel().call(promptGenerationPrompt);
            log.info("[豆包封面生成] LLM生成的图片提示词: {}", imagePrompt);

            // 调用豆包文生图
            String imageUrl = generateImage(imagePrompt);

            if (imageUrl != null) {
                return imageUrl;
            }

            return null;
        } catch (Exception e) {
            log.error("[豆包封面生成] 生成文章封面失败", e);
            return null;
        }
    }

    @Override
    public String convertToAnime(byte[] imageBytes) {
        try {
            log.info("[火山引擎Ark] 开始动漫化处理，图片大小={}KB", imageBytes.length / 1024);

            // 1. 上传图片到 MinIO 获取公开 URL
            String tempObjectName = "temp/anime_input_" + UUID.randomUUID() + ".jpg";
            objectStoreService.uploadFile(
                new ByteArrayInputStream(imageBytes),
                imageBytes.length,
                "photos",
                tempObjectName,
                "image/jpeg"
            );

            String imageUrl = ((com.yoyuen.backend.objectstore.service.MinIOService) objectStoreService)
                    .getPublicUrl("photos", tempObjectName);
            log.info("[火山引擎Ark] 图片URL: {}", imageUrl);

            // 2. 构建请求体
            Map<String, Object> requestBody = new HashMap<>();
            requestBody.put("model", volcengineProperties.getArk().getModel());
            requestBody.put("prompt", "将图片转换为动漫风格");
            requestBody.put("image", imageUrl);
            requestBody.put("response_format", "url");
            requestBody.put("watermark", false);

            String bodyJson = objectMapper.writeValueAsString(requestBody);
            log.info("[火山引擎Ark] 请求体: {}", bodyJson);

            // 3. 构建请求头（Bearer Token 认证）
            HttpHeaders headers = new HttpHeaders();
            headers.setContentType(MediaType.APPLICATION_JSON);
            headers.set("Authorization", "Bearer " + volcengineProperties.getArk().getApiKey());

            HttpEntity<String> entity = new HttpEntity<>(bodyJson, headers);

            // 4. 调用 Ark API
            String url = volcengineProperties.getArk().getEndpoint() + "/images/generations";
            log.info("[火山引擎Ark] 请求URL: {}", url);

            ResponseEntity<Map> response = restTemplate.exchange(url, HttpMethod.POST, entity, Map.class);

            if (response.getStatusCode() == HttpStatus.OK && response.getBody() != null) {
                Map<String, Object> result = response.getBody();
                log.info("[火山引擎Ark] 响应: {}", result);

                // 5. 提取结果图片 URL
                Object data = result.get("data");
                if (data instanceof java.util.List) {
                    java.util.List<?> dataList = (java.util.List<?>) data;
                    if (!dataList.isEmpty() && dataList.get(0) instanceof Map) {
                        Map<?, ?> firstItem = (Map<?, ?>) dataList.get(0);
                        String resultUrl = (String) firstItem.get("url");
                        log.info("[火山引擎Ark] 动漫化成功，结果URL: {}", resultUrl);

                        if (resultUrl == null || !resultUrl.startsWith("http")) {
                            log.error("[火山引擎Ark] 返回的URL格式异常: {}", resultUrl);
                            return null;
                        }

                        return downloadAndUploadToMinio(resultUrl, "photos", "anime_", "image/jpeg");
                    }
                }
            }

            log.error("[火山引擎Ark] 动漫化失败，响应异常");
            return null;

        } catch (Exception e) {
            String errorMsg = e.getMessage();
            if (errorMsg != null && errorMsg.contains("InputImageSensitiveContentDetected")) {
                log.warn("[火山引擎Ark] 图片包含敏感内容，跳过动漫化");
            } else {
                log.error("[火山引擎Ark] 动漫化异常: {}", errorMsg, e);
            }
            return null;
        }
    }

    /**
     * 下载结果图片并上传到 MinIO（永久存储）
     */
    private String downloadAndUploadToMinio(String imageUrl, String bucket, String prefix, String contentType) {
        try {
            log.info("[豆包] 开始下载结果图片: {}", imageUrl);

            URL downloadUrl = new URL(imageUrl);
            HttpURLConnection connection = (HttpURLConnection) downloadUrl.openConnection();
            connection.setRequestMethod("GET");
            connection.setConnectTimeout(10000);
            connection.setReadTimeout(30000);

            int responseCode = connection.getResponseCode();
            if (responseCode != HttpURLConnection.HTTP_OK) {
                log.error("[豆包] 下载失败，HTTP状态码: {}", responseCode);
                return null;
            }

            byte[] resultBytes;
            try (InputStream inputStream = connection.getInputStream()) {
                resultBytes = inputStream.readAllBytes();
            }
            connection.disconnect();

            if (resultBytes == null || resultBytes.length == 0) {
                log.error("[豆包] 下载的图片为空");
                return null;
            }

            String baseName = prefix + System.currentTimeMillis();
            String objectName = baseName + (contentType.contains("png") ? ".png" : ".jpg");
            objectStoreService.uploadFile(
                new ByteArrayInputStream(resultBytes),
                resultBytes.length,
                bucket,
                objectName,
                contentType
            );
            log.info("[豆包] 图片已上传到MinIO: {}/{}, size={}KB", bucket, objectName, resultBytes.length / 1024);
            return bucket + "/" + objectName;
        } catch (Exception e) {
            log.error("[豆包] 下载上传失败: {}", e.getMessage());
            return null;
        }
    }
}
