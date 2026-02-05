package com.yoyuen.backend.model.user;

import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import com.yoyuen.backend.pojo.BaseEntity;
import lombok.Data;
import lombok.EqualsAndHashCode;

import java.io.Serializable;

/**
 * @Author: YoyuEN
 * @Date: 2026/2/5
 * @Time: 19:25
 * @Description:
 */
@EqualsAndHashCode(callSuper = true)
@TableName(value = "system_user_role")
@Data
public class SystemUserRole extends BaseEntity implements Serializable {

    /**
     *
     */
    @TableId(value = "id")
    private Long id;

    /**
     * 用户ID
     */
    @TableField(value = "user_id")
    private Long userId;

    /**
     * 角色ID
     */
    @TableField(value = "role_id")
    private Long roleId;

    @TableField(exist = false)
    private static final long serialVersionUID = 1L;

}
