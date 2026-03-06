package com.yoyuen.backend.config;

import lombok.Data;
import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.context.annotation.Configuration;

/**
 * @Author: YoyuEN
 * @Date: 2026/3/6
 * @Description: 文生图配置类
 */
@Data
@Configuration
@ConfigurationProperties(prefix = "image.generation")
public class ImageGenerationConfig {
    /**
     * API基础URL
     */
    private String baseUrl;

    /**
     * API密钥
     */
    private String apiKey;

    /**
     * 模型名称
     */
    private String model;

    /**
     * 图片尺寸
     */
    private String size;

    /**
     * 图片风格
     */
    private String style;
}
