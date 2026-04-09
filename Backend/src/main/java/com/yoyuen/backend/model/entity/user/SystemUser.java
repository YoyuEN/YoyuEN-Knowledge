package com.yoyuen.backend.model.entity.user;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import com.yoyuen.backend.pojo.BaseEntity;
import lombok.Data;
import lombok.EqualsAndHashCode;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.userdetails.UserDetails;

import java.io.Serial;
import java.util.Collection;
import java.util.HashSet;
import java.util.List;
import java.util.Set;
import java.util.stream.Collectors;

/**
 * @Author: YoyuEN
 * @Date: 2026/2/5
 * @Time: 19:22
 * @Description:
 */
@Data
@TableName(value = "system_user")
@EqualsAndHashCode(callSuper = true)
public abstract class SystemUser extends BaseEntity implements UserDetails {

    @Serial
    private static final long serialVersionUID = 1L;

    /**
     * 用户id
     */
    @TableId(value = "id", type = IdType.AUTO)
    private Long id;

    /**
     * 用户名
     */
    @TableField(value = "username")
    private String username;

    /**
     * 密码
     */
    @TableField(value = "password")
    private String password;

    /**
     * 头像URL
     */
    @TableField(value = "avatar")
    private String avatar;

    /**
     * 角色
     */
    @TableField(exist = false)
    private List<SystemRole> roles;

    /**
     * 权限
     */
    @TableField(exist = false)
    private List<SystemPermission> permissions;

    @Override
    public Collection<? extends GrantedAuthority> getAuthorities() {
        Set<GrantedAuthority> authorities = new HashSet<>();

        // 角色权限：ROLE_前缀
        authorities.addAll(roles.stream()
                .map(role -> new SimpleGrantedAuthority("ROLE_" + role.getName()))
                .collect(Collectors.toSet()));

        // 具体权限
        authorities.addAll(permissions.stream()
                .map(permission -> new SimpleGrantedAuthority(permission.getName()))
                .collect(Collectors.toSet()));

        return authorities;
    }

}
