package com.yoyuen.backend.utils;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.Getter;

/**
 * @Author: YoyuEN
 * @Date: 2026/2/5
 * @Time: 18:09
 * @Description:
 */

@Data
@Getter
@AllArgsConstructor
public class Result<T> {
    private Integer code;
    private String message;
    private T data;

    public Result(Integer code, String message) {
        this.code = code;
        this.message = message;
    }
    public static <T> Result<T> success(ResponseCode responseCode) {
        return new Result<>(responseCode.getCode(), responseCode.getMessage());
    }

    public static <T> Result<T> success(ResponseCode responseCode, T data) {
        return new Result<>(responseCode.getCode(), responseCode.getMessage(), data);
    }

    public static <T> Result<T> fail(ResponseCode responseCode) {
        return new Result<>(responseCode.getCode(), responseCode.getMessage());
    }

    public static <T> Result<T> fail(ResponseCode responseCode, String message) {
        return new Result<>(responseCode.getCode(), responseCode.getMessage() + ": " + message);
    }
}
