package com.yoyuen.backend.config;

import lombok.Data;
import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.context.annotation.Configuration;

/**
 * @Author: YoyuEN
 * @Date: 2026/2/5
 * @Time: 18:21
 * @Description:
 */

@Data
@Configuration
@ConfigurationProperties(prefix = "minio")
public class MinioProperties {
    private String endpoint;
    private String accessKey;
    private String secretKey;
    private String defaultBucket = "default";
    private int defaultExpiry = 3600; //默认一小时有效
}
