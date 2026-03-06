package com.yoyuen.backend.config;

import lombok.Data;
import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.context.annotation.Configuration;

/**
 * @Author: YoyuEN
 * @Date: 2026/3/6
 * @Description: 图生图配置类
 */
@Data
@Configuration
@ConfigurationProperties(prefix = "image.to-image")
public class ImageToImageConfig {
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
     * 图片风格
     */
    private String style;
}
