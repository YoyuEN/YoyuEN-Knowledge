package com.yoyuen.backend.config;

import lombok.Data;
import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.stereotype.Component;

/**
 * @Author: YoyuEN
 * @Date: 2026/3/7
 * @Description: 火山引擎配置
 */
@Data
@Component
@ConfigurationProperties(prefix = "volcengine")
public class VolcengineProperties {
    private String accessKey;
    private String secretKey;
    private String region;
    private Cv cv = new Cv();
    private Ark ark = new Ark();

    @Data
    public static class Cv {
        private String endpoint = "https://visual.volcengineapi.com";
    }

    @Data
    public static class Ark {
        private String endpoint = "https://ark.cn-beijing.volces.com/api/v3";
        private String apiKey;
        private String model = "doubao-seedream-4-5-251128";
    }
}
