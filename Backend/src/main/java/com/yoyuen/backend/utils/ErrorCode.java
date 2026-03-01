package com.yoyuen.backend.utils;

import lombok.Data;

/**
 * @Author: YoyuEN
 * @Date: 2026/2/5
 * @Time: 19:11
 * @Description:
 */
@Data
public class ErrorCode {

    /**
     * 错误码
     */
    private final Integer code;

    /**
     * 错误提示
     */
    private final String msg;

    public ErrorCode(Integer code, String message) {
        this.code = code;
        this.msg = message;
    }

}
