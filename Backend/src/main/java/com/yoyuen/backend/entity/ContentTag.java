package com.yoyuen.backend.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableLogic;
import com.baomidou.mybatisplus.annotation.TableName;
import com.yoyuen.backend.pojo.BaseEntity;
import lombok.Data;
import lombok.EqualsAndHashCode;

/**
 * @Author: YoyuEN
 * @Date: 2026/4/6
 * @Description: 内容标签实体
 */
@Data
@EqualsAndHashCode(callSuper = true)
@TableName("content_tag")
public class ContentTag extends BaseEntity {

    @TableId(value = "id", type = IdType.AUTO)
    private Long id;

    /**
     * 标签名称
     */
    @TableField("name")
    private String name;

    /**
     * 使用次数（冗余字段，用于快速查询）
     */
    @TableField("usage_count")
    private Long usageCount;

    /**
     * 逻辑删除字段
     */
    @TableLogic
    @TableField("deleted")
    private Boolean deleted;

    @TableField(exist = false)
    private static final long serialVersionUID = 1L;
}
