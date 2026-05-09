package com.yoyuen.backend.config.web;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.yoyuen.backend.exception.GlobalExceptionHandler;
import com.yoyuen.backend.security.filter.JwtAuthenticationFilter;
import com.yoyuen.backend.utils.BaseResponse;
import com.yoyuen.backend.utils.ResultUtils;
import jakarta.annotation.PostConstruct;
import jakarta.servlet.http.HttpServletResponse;
import lombok.Data;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.http.MediaType;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.AuthenticationProvider;
import org.springframework.security.authentication.dao.DaoAuthenticationProvider;
import org.springframework.security.config.annotation.authentication.configuration.AuthenticationConfiguration;
import org.springframework.security.config.annotation.method.configuration.EnableMethodSecurity;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.annotation.web.configurers.AbstractHttpConfigurer;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.security.web.authentication.UsernamePasswordAuthenticationFilter;
import org.springframework.security.web.util.matcher.AntPathRequestMatcher;

import java.nio.charset.StandardCharsets;
import java.util.List;

/**
 * @Author: YoyuEN
 * @Date: 2026/2/13
 * @Description: Spring Security 配置
 */
@Configuration
@Data
@EnableMethodSecurity
@EnableWebSecurity
@RequiredArgsConstructor
@Slf4j
public class SecurityConfig {

    private final UserDetailsService userDetailsService;

    private final JwtAuthenticationFilter jwtAuthenticationFilter;

    private final SecurityProperties securityProperties;

    private final PasswordEncoder passwordEncoder;

    private final ObjectMapper objectMapper;

    /**
     * 设置 SecurityContext 跨异步线程继承，确保 SSE 流式响应在异步调度时不会丢失认证信息
     */
    @PostConstruct
    public void init() {
        SecurityContextHolder.setStrategyName(SecurityContextHolder.MODE_INHERITABLETHREADLOCAL);
    }

    @Bean
    public AuthenticationProvider authenticationProvider() {
        DaoAuthenticationProvider authProvider = new DaoAuthenticationProvider();
        authProvider.setUserDetailsService(userDetailsService);
        authProvider.setPasswordEncoder(passwordEncoder);
        return authProvider;
    }

    @Bean
    public SecurityFilterChain securityFilterChain(HttpSecurity httpSecurity) throws Exception {
        httpSecurity.csrf(AbstractHttpConfigurer::disable);
        List<String> allowList = securityProperties.getAllowList();
        log.info("allowList ====> {}", allowList);

        // 使用 AntPathRequestMatcher 替代默认的 MvcRequestMatcher
        // MvcRequestMatcher 依赖 HandlerMappingIntrospector，在 SSE 异步调度时可能匹配失败
        AntPathRequestMatcher[] allowMatchers = allowList.stream()
                .map(AntPathRequestMatcher::new)
                .toArray(AntPathRequestMatcher[]::new);

        httpSecurity
                .authorizeHttpRequests(req -> req.requestMatchers(allowMatchers).permitAll().anyRequest().authenticated())
                .exceptionHandling(ex -> ex
                        .authenticationEntryPoint((request, response, authException) -> {
                            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
                            response.setContentType(MediaType.APPLICATION_JSON_VALUE);
                            response.setCharacterEncoding(StandardCharsets.UTF_8.name());
                            BaseResponse<?> error = ResultUtils.error(401, "未登录或登录已过期，请重新登录");
                            response.getWriter().write(objectMapper.writeValueAsString(error));
                        })
                        .accessDeniedHandler((request, response, accessDeniedException) -> {
                            response.setStatus(HttpServletResponse.SC_FORBIDDEN);
                            response.setContentType(MediaType.APPLICATION_JSON_VALUE);
                            response.setCharacterEncoding(StandardCharsets.UTF_8.name());
                            BaseResponse<?> error = ResultUtils.error(403, "没有权限访问该资源");
                            response.getWriter().write(objectMapper.writeValueAsString(error));
                        })
                );
        httpSecurity.authenticationProvider(authenticationProvider())
                .addFilterBefore(jwtAuthenticationFilter, UsernamePasswordAuthenticationFilter.class);

        return httpSecurity.build();
    }

    @Bean
    public AuthenticationManager authenticationManager(AuthenticationConfiguration config) throws Exception {
        return config.getAuthenticationManager();
    }

    @Bean
    public GlobalExceptionHandler globalExceptionHandler() {
        return new GlobalExceptionHandler();
    }

}
