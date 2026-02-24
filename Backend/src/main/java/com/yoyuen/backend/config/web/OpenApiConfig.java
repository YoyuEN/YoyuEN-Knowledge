package com.yoyuen.backend.config.web;

import io.swagger.v3.oas.models.OpenAPI;
import io.swagger.v3.oas.models.info.Contact;
import io.swagger.v3.oas.models.info.Info;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

/**
 * OpenAPI / Knife4j 配置
 */
@Configuration
public class OpenApiConfig {

    @Bean
    public OpenAPI customOpenAPI() {
        return new OpenAPI()
                .info(new Info()
                        .title("YoyuEN Knowledge API")
                        .version("1.0")
                        .description("知识库管理系统 API 文档")
                        .contact(new Contact()
                                .name("YoyuEN")
                        )
                );
    }
}
