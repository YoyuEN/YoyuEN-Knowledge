package com.yoyuen.backend.controller.vo;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;

/**
 * @Author: YoyuEN
 * @Date: 2026/4/9
 * @Description: 登录请求
 */
@Data
@Schema(description = "登录请求")
public class LoginRequest {

    @Schema(description = "用户名", example = "admin")
    private String username;

    @Schema(description = "密码", example = "123123")
    private String password;
}
