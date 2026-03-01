package com.yoyuen.backend.security.filter;

import com.yoyuen.backend.config.web.SecurityProperties;
import com.yoyuen.backend.security.service.JwtService;
import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import lombok.RequiredArgsConstructor;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.web.authentication.WebAuthenticationDetailsSource;
import org.springframework.stereotype.Component;
import org.springframework.util.AntPathMatcher;
import org.springframework.web.filter.OncePerRequestFilter;

import java.io.IOException;

/**
 * @Author: YoyuEN
 * @Date: 2026/2/25
 * @Time: 11:06
 * @Description:
 */
@RequiredArgsConstructor
@Component
public class JwtAuthenticationFilter extends OncePerRequestFilter {

    private final JwtService jwtService;

    private final UserDetailsService userDetailsService;

    private final SecurityProperties securityProperties;

    private final AntPathMatcher pathMatcher = new AntPathMatcher();

    @Override
    protected void doFilterInternal(HttpServletRequest request, HttpServletResponse response, FilterChain filterChain)
            throws ServletException, IOException {
        String servletPath = request.getServletPath();

        // 检查是否在白名单中，如果是则直接放行
        if (isAllowListed(servletPath)) {
            filterChain.doFilter(request, response);
            return;
        }

        // 1. 从Header提取Token
        final String authHeader = request.getHeader("Authorization");
        if (authHeader == null || !authHeader.startsWith("Bearer ")) {
            filterChain.doFilter(request, response);
            return;
        }

        final String jwt = authHeader.substring(7);
        final String username = jwtService.getUsernameFromToken(jwt);

        // 2. 验证Token有效性
        if (username != null && SecurityContextHolder.getContext().getAuthentication() == null) {
            try {
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
            catch (Exception e) {
                e.printStackTrace();
                response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
                return;
            }
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

}
