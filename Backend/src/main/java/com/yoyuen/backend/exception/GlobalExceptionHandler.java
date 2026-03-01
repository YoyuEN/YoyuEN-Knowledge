package com.yoyuen.backend.exception;

import com.yoyuen.backend.utils.BaseResponse;
import com.yoyuen.backend.utils.CoreCode;
import com.yoyuen.backend.utils.ResultUtils;
import lombok.extern.slf4j.Slf4j;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.RestControllerAdvice;

/**
 * @Author: YoyuEN
 * @Date: 2026/2/5
 * @Time: 18:06
 * @Description: 全局异常配置
 */

@RestControllerAdvice
@Slf4j
public class GlobalExceptionHandler {

    @ExceptionHandler(BusinessException.class)
    public BaseResponse<?> businessExceptionHandler(BusinessException e) {
        return ResultUtils.error(e.getCode(), e.getMessage());
    }

    @ExceptionHandler(RuntimeException.class)
    public BaseResponse<?> runtimeExceptionHandler(RuntimeException e) {
        e.printStackTrace();
        return ResultUtils.error(CoreCode.SYSTEM_ERROR, e.getMessage());
    }

}
