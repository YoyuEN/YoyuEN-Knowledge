package com.yoyuen.backend.model.ai;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import com.baomidou.mybatisplus.extension.handlers.JacksonTypeHandler;
import com.yoyuen.backend.pojo.BaseEntity;
import com.yoyuen.backend.service.StorageFile;
import lombok.Data;
import lombok.EqualsAndHashCode;

import java.io.Serial;
import java.util.ArrayList;
import java.util.List;

/**
 * @Author: YoyuEN
 * @Date: 2026/2/5
 * @Time: 18:47
 * @Description:
 */
@Data
@TableName(value = "origin_file_source", autoResultMap = true)
@EqualsAndHashCode(callSuper = true)
public class OriginFileResource extends BaseEntity implements StorageFile {
    @Serial
    private static final long serialVersionUID = 1L;

    @TableId(type = IdType.INPUT)
    private String id;

    private String fileName;

    private String path;

    private Boolean isImage;

    private String bucketName;

    private String objectName;

    private String contentType;

    private Long size;

    private String md5;

    // 文档里的图片名称列表
    @TableField(typeHandler = JacksonTypeHandler.class)
    private List<String> images = new ArrayList<>();
}
