package com.yoyuen.backend.exception;

import com.yoyuen.backend.utils.ResponseCode;
import lombok.Getter;

/**
 * @Author: YoyuEN
 * @Date: 2026/2/5
 * @Time: 18:11
 * @Description: 自定义异常
 */
@Getter
public class ServiceExceptionHandler extends RuntimeException{
    private final ResponseCode responseCode;

    public ServiceExceptionHandler(ResponseCode responseCode) {
        super(responseCode.getMessage());
        this.responseCode = responseCode;
    }
}