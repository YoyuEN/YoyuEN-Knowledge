package com.yoyuen.backend.model.entity.user;

import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;
import lombok.EqualsAndHashCode;

import java.io.Serial;
import java.util.ArrayList;
import java.util.List;

/**
 * @Author: YoyuEN
 * @Date: 2026/4/9
 * @Description: SystemUser 的具体实现类
 */
@Data
@TableName(value = "system_user")
@EqualsAndHashCode(callSuper = true)
public class SystemUserImpl extends SystemUser {

    @Serial
    private static final long serialVersionUID = 1L;

    public SystemUserImpl() {
        super();
        // 初始化集合，避免空指针
        if (this.getRoles() == null) {
            this.setRoles(new ArrayList<>());
        }
        if (this.getPermissions() == null) {
            this.setPermissions(new ArrayList<>());
        }
    }
}
