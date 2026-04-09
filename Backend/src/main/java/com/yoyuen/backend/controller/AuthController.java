package com.yoyuen.backend.controller;

import com.yoyuen.backend.controller.vo.LoginRequest;
import com.yoyuen.backend.controller.vo.LoginResponse;
import com.yoyuen.backend.security.service.JwtService;
import com.yoyuen.backend.utils.BaseResponse;
import com.yoyuen.backend.utils.ResultUtils;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.BadCredentialsException;
import org.springframework.security.authentication.DisabledException;
import org.springframework.security.authentication.LockedException;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.AuthenticationException;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.web.bind.annotation.*;

/**
 * @Author: YoyuEN
 * @Date: 2026/4/9
 * @Description: 认证控制器
 */
@Slf4j
@RestController
@RequestMapping("/auth")
@RequiredArgsConstructor
@Tag(name = "认证管理", description = "用户登录、登出等认证相关接口")
public class AuthController {

    private final AuthenticationManager authenticationManager;
    private final JwtService jwtService;

    @PostMapping("/login")
    @Operation(summary = "用户登录", description = "通过用户名和密码登录，返回JWT token")
    public BaseResponse<LoginResponse> login(@RequestBody LoginRequest request) {
        try {
            // 1. 验证请求参数
            if (request.getUsername() == null || request.getUsername().trim().isEmpty()) {
                return ResultUtils.error(400, "用户名不能为空");
            }
            if (request.getPassword() == null || request.getPassword().trim().isEmpty()) {
                return ResultUtils.error(400, "密码不能为空");
            }

            // 2. 使用 Spring Security 进行身份验证
            Authentication authentication = authenticationManager.authenticate(
                    new UsernamePasswordAuthenticationToken(request.getUsername(), request.getPassword())
            );

            // 3. 验证成功，生成 JWT token
            UserDetails userDetails = (UserDetails) authentication.getPrincipal();
            String token = jwtService.generateToken(userDetails.getUsername());

            // 4. 获取用户头像
            String avatar = null;
            if (userDetails instanceof com.yoyuen.backend.model.entity.user.SystemUser) {
                avatar = ((com.yoyuen.backend.model.entity.user.SystemUser) userDetails).getAvatar();
            }

            // 5. 返回 token 和用户信息
            LoginResponse response = LoginResponse.builder()
                    .token(token)
                    .username(userDetails.getUsername())
                    .avatar(avatar)
                    .build();

            log.info("用户 {} 登录成功", request.getUsername());
            return ResultUtils.success(response);

        } catch (UsernameNotFoundException e) {
            log.warn("登录失败：用户不存在 - {}", request.getUsername());
            return ResultUtils.error(401, "用户不存在");
        } catch (BadCredentialsException e) {
            log.warn("登录失败：密码错误 - {}", request.getUsername());
            return ResultUtils.error(401, "用户名或密码错误");
        } catch (DisabledException e) {
            log.warn("登录失败：账号已被禁用 - {}", request.getUsername());
            return ResultUtils.error(403, "账号已被禁用，请联系管理员");
        } catch (LockedException e) {
            log.warn("登录失败：账号已被锁定 - {}", request.getUsername());
            return ResultUtils.error(403, "账号已被锁定，请联系管理员");
        } catch (AuthenticationException e) {
            log.error("登录失败：认证异常 - {}", request.getUsername(), e);
            return ResultUtils.error(401, "登录失败：" + e.getMessage());
        } catch (Exception e) {
            log.error("登录失败：系统异常 - {}", request.getUsername(), e);
            return ResultUtils.error(500, "系统错误，请稍后重试");
        }
    }

    @PostMapping("/logout")
    @Operation(summary = "用户登出", description = "登出当前用户（前端清除token）")
    public BaseResponse<String> logout() {
        // JWT 是无状态的，登出由前端清除 token 即可
        // 如果需要服务端控制，可以使用 Redis 黑名单机制
        return ResultUtils.success("登出成功");
    }

    @GetMapping("/info")
    @Operation(summary = "获取当前用户信息", description = "根据token获取当前登录用户信息")
    public BaseResponse<LoginResponse> getCurrentUser(Authentication authentication) {
        if (authentication == null || !authentication.isAuthenticated()) {
            return (BaseResponse<LoginResponse>) (BaseResponse<?>) ResultUtils.error(401, "未登录或登录已过期");
        }
        UserDetails userDetails = (UserDetails) authentication.getPrincipal();

        // 获取用户头像
        String avatar = null;
        if (userDetails instanceof com.yoyuen.backend.model.entity.user.SystemUser) {
            avatar = ((com.yoyuen.backend.model.entity.user.SystemUser) userDetails).getAvatar();
        }

        // 构建响应对象
        LoginResponse response = LoginResponse.builder()
                .username(userDetails.getUsername())
                .avatar(avatar)
                .build();

        return ResultUtils.success(response);
    }
}
