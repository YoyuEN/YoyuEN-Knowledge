package com.yoyuen.backend.service.ai.impl;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.yoyuen.backend.config.VolcengineProperties;
import com.yoyuen.backend.service.ai.ImageGenerationService;
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
    private final RestTemplate restTemplate = new RestTemplate();
    private final ObjectMapper objectMapper = new ObjectMapper();

    @Override
    public String generateImage(String prompt) {
        throw new UnsupportedOperationException("火山引擎暂不支持文生图");
    }

    @Override
    public String generateCoverForContent(String title, String content) {
        throw new UnsupportedOperationException("火山引擎暂不支持文生图");
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
            requestBody.put("sequential_image_generation", "disabled");
            requestBody.put("response_format", "url");
            requestBody.put("size", "2K");
            requestBody.put("stream", false);
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

                        // 检查URL格式
                        if (resultUrl == null || !resultUrl.startsWith("http")) {
                            log.error("[火山引擎Ark] 返回的URL格式异常: {}", resultUrl);
                            return null;
                        }

                        // 下载结果图片并上传到 MinIO（永久保存）
                        try {
                            log.info("[火山引擎Ark] 开始下载结果图片，URL: {}", resultUrl);

                            // 使用 HttpURLConnection 直接下载，避免 RestTemplate 添加额外头部
                            URL downloadUrl = new URL(resultUrl);
                            HttpURLConnection connection = (HttpURLConnection) downloadUrl.openConnection();
                            connection.setRequestMethod("GET");
                            connection.setConnectTimeout(10000);
                            connection.setReadTimeout(30000);

                            int responseCode = connection.getResponseCode();
                            if (responseCode != HttpURLConnection.HTTP_OK) {
                                throw new RuntimeException("下载失败，HTTP状态码: " + responseCode);
                            }

                            byte[] resultBytes;
                            try (InputStream inputStream = connection.getInputStream()) {
                                resultBytes = inputStream.readAllBytes();
                            }
                            connection.disconnect();
                            if (resultBytes == null || resultBytes.length == 0) {
                                throw new RuntimeException("下载的图片为空");
                            }

                            String finalObjectName = "anime_" + System.currentTimeMillis() + ".jpg";
                            objectStoreService.uploadFile(
                                new ByteArrayInputStream(resultBytes),
                                resultBytes.length,
                                "photos",
                                finalObjectName,
                                "image/jpeg"
                            );
                            log.info("[火山引擎Ark] 结果图片已上传到MinIO: photos/{}, size={}KB",
                                finalObjectName, resultBytes.length / 1024);
                            return "photos/" + finalObjectName;
                        } catch (Exception e) {
                            log.error("[火山引擎Ark] 下载失败，返回临时URL: {}", e.getMessage());
                            // 降级：返回临时URL（24小时有效）
                            return resultUrl;
                        }
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
}
