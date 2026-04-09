package com.yoyuen.backend.controller.vo;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Builder;
import lombok.Data;

/**
 * @Author: YoyuEN
 * @Date: 2026/4/9
 * @Description: 登录响应
 */
@Data
@Builder
@Schema(description = "登录响应")
public class LoginResponse {

    @Schema(description = "JWT Token")
    private String token;

    @Schema(description = "用户名")
    private String username;

    @Schema(description = "头像URL")
    private String avatar;
}
