package com.yoyuen.backend.controller.vo;

import com.fasterxml.jackson.annotation.JsonFormat;
import lombok.Data;

import java.time.LocalDateTime;

/**
 * @Author: YoyuEN
 * @Date: 2026/2/27
 * @Description: 照片视图对象
 */
@Data
public class PhotoVO {

    private String id;

    /**
     * MinIO 预签名访问URL
     */
    private String url;

    /**
     * 照片描述
     */
    private String description;

    @JsonFormat(pattern = "yyyy-MM-dd")
    private LocalDateTime createTime;
}
