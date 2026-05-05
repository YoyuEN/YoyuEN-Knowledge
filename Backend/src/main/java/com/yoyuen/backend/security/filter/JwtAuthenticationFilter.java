package com.yoyuen.backend.security.filter;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.yoyuen.backend.config.web.SecurityProperties;
import com.yoyuen.backend.security.service.JwtService;
import com.yoyuen.backend.utils.BaseResponse;
import com.yoyuen.backend.utils.ResultUtils;
import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.MediaType;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.web.authentication.WebAuthenticationDetailsSource;
import org.springframework.stereotype.Component;
import org.springframework.util.AntPathMatcher;
import org.springframework.web.filter.OncePerRequestFilter;

import java.io.IOException;
import java.nio.charset.StandardCharsets;

/**
 * @Author: YoyuEN
 * @Date: 2026/2/25
 * @Time: 11:06
 * @Description:
 */
@Slf4j
@RequiredArgsConstructor
@Component
public class JwtAuthenticationFilter extends OncePerRequestFilter {

    private final JwtService jwtService;

    private final UserDetailsService userDetailsService;

    private final SecurityProperties securityProperties;

    private final ObjectMapper objectMapper;

    private final AntPathMatcher pathMatcher = new AntPathMatcher();

    @Override
    protected void doFilterInternal(HttpServletRequest request, HttpServletResponse response, FilterChain filterChain)
            throws ServletException, IOException {
        String servletPath = request.getServletPath();
        boolean allowListed = isAllowListed(servletPath);

        // 1. 从Header提取Token
        final String authHeader = request.getHeader("Authorization");
        if (authHeader == null || !authHeader.startsWith("Bearer ")) {
            // 无Token：白名单放行，非白名单继续后续filter（最终由Spring Security判定）
            filterChain.doFilter(request, response);
            return;
        }

        final String jwt = authHeader.substring(7);

        // 2. 验证Token有效性并设置SecurityContext（白名单请求也解析Token，以支持@PreAuthorize方法级权限）
        try {
            final String username = jwtService.getUsernameFromToken(jwt);
            if (username != null && SecurityContextHolder.getContext().getAuthentication() == null) {
                UserDetails userDetails = userDetailsService.loadUserByUsername(username);

                if (jwtService.validateToken(jwt, username)) {
                    // 3. 构建Authentication对象并存入SecurityContext
                    UsernamePasswordAuthenticationToken authToken = new UsernamePasswordAuthenticationToken(userDetails,
                            null, userDetails.getAuthorities());
                    authToken.setDetails(new WebAuthenticationDetailsSource().buildDetails(request));
                    SecurityContextHolder.getContext().setAuthentication(authToken);

                    // 4. 无感刷新逻辑
                    if (jwtService.isTokenExpiringSoon(jwt)) {
                        String newToken = jwtService.refreshToken(jwt);
                        response.setHeader("New-Access-Token", newToken);
                    }
                }
            }
        }
        catch (Exception e) {
            // 非白名单请求：认证失败直接返回401
            if (!allowListed) {
                log.warn("JWT 认证失败 [{}]: {}", servletPath, e.getMessage());
                writeErrorResponse(response, 401, "未登录或登录已过期，请重新登录");
                return;
            }
            // 白名单请求：仅记录日志，不影响放行
            log.debug("JWT 解析失败（白名单路径） [{}]: {}", servletPath, e.getMessage());
        }

        filterChain.doFilter(request, response);
    }

    /**
     * 检查路径是否在白名单中
     */
    private boolean isAllowListed(String path) {
        return securityProperties.getAllowList().stream()
                .anyMatch(pattern -> pathMatcher.match(pattern, path));
    }

    /**
     * 写入统一格式的错误响应
     */
    private void writeErrorResponse(HttpServletResponse response, int status, String message) throws IOException {
        response.setStatus(status);
        response.setContentType(MediaType.APPLICATION_JSON_VALUE);
        response.setCharacterEncoding(StandardCharsets.UTF_8.name());
        BaseResponse<?> errorResponse = ResultUtils.error(status, message);
        objectMapper.writeValue(response.getOutputStream(), errorResponse);
    }

}
