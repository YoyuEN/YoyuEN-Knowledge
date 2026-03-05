package com.yoyuen.backend.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import com.yoyuen.backend.pojo.BaseEntity;
import lombok.Data;
import lombok.EqualsAndHashCode;

/**
 * @Author: YoyuEN
 * @Date: 2026/2/27
 * @Description: 照片实体
 */
@Data
@EqualsAndHashCode(callSuper = true)
@TableName("photo")
public class Photo extends BaseEntity {

    @TableId(value = "id", type = IdType.ASSIGN_UUID)
    private String id;

    /**
     * MinIO 存储桶名称
     */
    @TableField("bucket_name")
    private String bucketName;

    /**
     * MinIO 对象名称（文件路径）
     */
    @TableField("object_name")
    private String objectName;

    /**
     * 缩略图对象名称
     */
    @TableField("thumbnail_name")
    private String thumbnailName;

    /**
     * 照片描述
     */
    @TableField("description")
    private String description;

    @TableField(exist = false)
    private static final long serialVersionUID = 1L;
}
