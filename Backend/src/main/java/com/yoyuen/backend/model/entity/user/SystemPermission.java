package com.yoyuen.backend.model.entity.user;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import com.yoyuen.backend.pojo.BaseEntity;
import lombok.Data;
import lombok.EqualsAndHashCode;

/**
 * @Author: YoyuEN
 * @Date: 2026/2/5
 * @Time: 19:27
 * @Description:
 */
@Data
@EqualsAndHashCode(callSuper = true)
@TableName(value = "system_permission")
public class SystemPermission extends BaseEntity {

    /**
     * 权限ID
     */
    @TableId(value = "id", type = IdType.AUTO)
    private Long id;

    /**
     * 权限名称
     */
    @TableField(value = "name")
    private String name;

    /**
     * 权限描述
     */
    @TableField(value = "description")
    private String description;

}
