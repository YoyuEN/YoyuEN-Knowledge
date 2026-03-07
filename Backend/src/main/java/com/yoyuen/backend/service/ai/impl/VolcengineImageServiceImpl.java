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

import javax.crypto.Mac;
import javax.crypto.spec.SecretKeySpec;
import java.io.ByteArrayInputStream;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;
import java.time.ZoneOffset;
import java.time.ZonedDateTime;
import java.time.format.DateTimeFormatter;
import java.util.*;

/**
 * @Author: YoyuEN
 * @Date: 2026/3/7
 * @Description: 火山引擎图像处理服务实现
 *
 * 注意：当前签名验证存在问题，建议使用以下替代方案：
 * 1. 集成火山引擎官方 Java SDK (com.volcengine:volc-sdk-java)
 * 2. 使用百度飞桨 AnimeGAN（本地部署，无需签名）
 * 3. 使用 Replicate API（签名更简单）
 */
@Slf4j
@Service
// @Primary  // 签名问题未解决，暂时禁用
@RequiredArgsConstructor
public class VolcengineImageServiceImpl implements ImageGenerationService {

    private final VolcengineProperties volcengineProperties;
    private final ObjectStoreService objectStoreService;
    private final RestTemplate restTemplate = new RestTemplate();
    private final ObjectMapper objectMapper = new ObjectMapper();

    private static final String SERVICE = "cv";
    private static final String ACTION_ANIME = "CVProcess";
    private static final String VERSION = "2022-08-31";
    private static final String ALGORITHM = "HMAC-SHA256";

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
            log.info("[火山引擎] 开始动漫化处理，图片大小={}KB", imageBytes.length / 1024);

            // 1. 上传图片到 MinIO 临时目录
            String tempObjectName = "temp/anime_input_" + UUID.randomUUID() + ".jpg";
            objectStoreService.uploadFile(
                new ByteArrayInputStream(imageBytes),
                imageBytes.length,
                "photos",
                tempObjectName,
                "image/jpeg"
            );

            // 2. 获取公开 URL
            String imageUrl = ((com.yoyuen.backend.objectstore.service.MinIOService) objectStoreService)
                    .getPublicUrl("photos", tempObjectName);
            log.info("[火山引擎] 图片URL: {}", imageUrl);

            // 3. 构建请求体
            Map<String, Object> requestBody = new HashMap<>();
            requestBody.put("req_key", "anime_" + System.currentTimeMillis());
            requestBody.put("image_url", imageUrl);
            requestBody.put("render_spec", Map.of("render_type", "anime"));

            String bodyJson = objectMapper.writeValueAsString(requestBody);

            // 4. 构建查询参数
            String queryString = "Action=" + ACTION_ANIME + "&Version=" + VERSION;

            // 5. 构建请求头（包含签名）
            HttpHeaders headers = buildHeaders(queryString, bodyJson);
            HttpEntity<String> entity = new HttpEntity<>(bodyJson, headers);

            String url = volcengineProperties.getCv().getEndpoint() + "/?" + queryString;
            log.info("[火山引擎] 请求URL: {}", url);

            ResponseEntity<Map> response = restTemplate.exchange(url, HttpMethod.POST, entity, Map.class);

            if (response.getStatusCode() == HttpStatus.OK && response.getBody() != null) {
                Map<String, Object> result = response.getBody();
                log.info("[火山引擎] 响应: {}", result);

                if (result.containsKey("data")) {
                    Map<String, Object> data = (Map<String, Object>) result.get("data");
                    if (data.containsKey("image_url")) {
                        String resultUrl = data.get("image_url").toString();
                        log.info("[火山引擎] 动漫化成功，结果URL: {}", resultUrl);

                        // 下载结果并上传到 MinIO
                        byte[] resultBytes = restTemplate.getForObject(resultUrl, byte[].class);
                        String finalObjectName = "anime_" + System.currentTimeMillis() + ".jpg";
                        objectStoreService.uploadFile(
                            new ByteArrayInputStream(resultBytes),
                            resultBytes.length,
                            "photos",
                            finalObjectName,
                            "image/jpeg"
                        );

                        return "photos/" + finalObjectName;
                    }
                }
            }

            log.error("[火山引擎] 动漫化失败，响应: {}", response.getBody());
            return null;

        } catch (Exception e) {
            log.error("[火山引擎] 动漫化异常: {}", e.getMessage(), e);
            return null;
        }
    }

    /**
     * 构建火山引擎签名请求头
     */
    private HttpHeaders buildHeaders(String queryString, String body) throws Exception {
        HttpHeaders headers = new HttpHeaders();
        headers.setContentType(MediaType.APPLICATION_JSON);

        String timestamp = ZonedDateTime.now(ZoneOffset.UTC)
                .format(DateTimeFormatter.ofPattern("yyyyMMdd'T'HHmmss'Z'"));
        String date = timestamp.substring(0, 8);

        String payloadHash = sha256Hex(body);

        headers.set("X-Date", timestamp);
        headers.set("X-Content-Sha256", payloadHash);
        headers.set("Host", "visual.volcengineapi.com");

        // 构建签名
        String authorization = generateSignature(queryString, timestamp, date, payloadHash);
        headers.set("Authorization", authorization);

        return headers;
    }

    /**
     * 生成火山引擎 V4 签名
     */
    private String generateSignature(String queryString, String timestamp, String date, String payloadHash) throws Exception {
        String accessKey = volcengineProperties.getAccessKey();
        String secretKey = volcengineProperties.getSecretKey();
        String region = volcengineProperties.getRegion();

        log.info("[火山引擎] AccessKey: {}", accessKey);
        log.info("[火山引擎] Region: {}", region);
        log.info("[火山引擎] Timestamp: {}", timestamp);
        log.info("[火山引擎] Date: {}", date);
        log.info("[火山引擎] PayloadHash: {}", payloadHash);

        // 1. 创建规范请求
        String method = "POST";
        String uri = "/";

        // 规范化 headers（必须按字母顺序排序，注意冒号后没有空格）
        String canonicalHeaders = "content-type:application/json\n" +
                                  "host:visual.volcengineapi.com\n" +
                                  "x-content-sha256:" + payloadHash + "\n" +
                                  "x-date:" + timestamp + "\n";
        String signedHeaders = "content-type;host;x-content-sha256;x-date";

        String canonicalRequest = method + "\n" +
                                  uri + "\n" +
                                  queryString + "\n" +
                                  canonicalHeaders + "\n" +
                                  signedHeaders + "\n" +
                                  payloadHash;

        log.info("[火山引擎] 规范请求:\n{}", canonicalRequest);

        // 2. 创建待签名字符串
        String credentialScope = date + "/" + region + "/" + SERVICE + "/request";
        String hashedCanonicalRequest = sha256Hex(canonicalRequest);
        String stringToSign = ALGORITHM + "\n" +
                              timestamp + "\n" +
                              credentialScope + "\n" +
                              hashedCanonicalRequest;

        log.info("[火山引擎] 待签名字符串:\n{}", stringToSign);
        log.info("[火山引擎] HashedCanonicalRequest: {}", hashedCanonicalRequest);

        // 3. 计算签名密钥
        byte[] kDate = hmacSHA256(("VOLC" + secretKey).getBytes(StandardCharsets.UTF_8), date);
        byte[] kRegion = hmacSHA256(kDate, region);
        byte[] kService = hmacSHA256(kRegion, SERVICE);
        byte[] kSigning = hmacSHA256(kService, "request");

        // 4. 计算签名
        String signature = bytesToHex(hmacSHA256(kSigning, stringToSign));
        log.info("[火山引擎] Signature: {}", signature);

        // 5. 构建 Authorization 头
        String authorization = ALGORITHM + " Credential=" + accessKey + "/" + credentialScope +
               ", SignedHeaders=" + signedHeaders +
               ", Signature=" + signature;

        log.info("[火山引擎] Authorization: {}", authorization);

        return authorization;
    }

    private String sha256Hex(String data) throws Exception {
        MessageDigest digest = MessageDigest.getInstance("SHA-256");
        byte[] hash = digest.digest(data.getBytes(StandardCharsets.UTF_8));
        return bytesToHex(hash);
    }

    private byte[] hmacSHA256(byte[] key, String data) throws Exception {
        Mac mac = Mac.getInstance("HmacSHA256");
        mac.init(new SecretKeySpec(key, "HmacSHA256"));
        return mac.doFinal(data.getBytes(StandardCharsets.UTF_8));
    }

    private String bytesToHex(byte[] bytes) {
        StringBuilder result = new StringBuilder();
        for (byte b : bytes) {
            result.append(String.format("%02x", b));
        }
        return result.toString();
    }
}
