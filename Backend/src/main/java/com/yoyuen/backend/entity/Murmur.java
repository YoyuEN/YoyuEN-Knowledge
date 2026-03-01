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
 * @Date: 2026/2/26
 * @Description: 碎碎念/动态实体
 */
@Data
@EqualsAndHashCode(callSuper = true)
@TableName("murmur")
public class Murmur extends BaseEntity {

    @TableId(value = "id", type = IdType.ASSIGN_UUID)
    private String id;

    /**
     * 碎碎念内容
     */
    @TableField("text")
    private String text;

    @TableField(exist = false)
    private static final long serialVersionUID = 1L;
}
