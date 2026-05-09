package com.yoyuen.backend.config;

import org.springframework.ai.transformer.splitter.TokenTextSplitter;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.scheduling.annotation.EnableAsync;
import org.springframework.security.crypto.password.PasswordEncoder;

/**
 * @Author: YoyuEN
 * @Date: 2026/2/24
 * @Time: 10:16
 * @Description:
 */
@Configuration
@EnableAsync
public class AppConfig {
    @Bean
    public TokenTextSplitter tokenTextSplitter() {
        return new TokenTextSplitter();
    }

    /**
     * 使用明文密码（不加密）
     * 注意：生产环境不建议使用明文密码
     */
    @Bean
    public PasswordEncoder passwordEncoder() {
        return new PasswordEncoder() {
            @Override
            public String encode(CharSequence rawPassword) {
                // 直接返回明文密码
                return rawPassword.toString();
            }

            @Override
            public boolean matches(CharSequence rawPassword, String encodedPassword) {
                // 直接比较明文密码
                return rawPassword.toString().equals(encodedPassword);
            }
        };
    }
}
