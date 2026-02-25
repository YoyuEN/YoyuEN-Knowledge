package com.yoyuen.backend.security.service.impl;

import com.yoyuen.backend.mapper.SystemUserMapper;
import com.yoyuen.backend.model.entity.user.SystemUser;
import lombok.RequiredArgsConstructor;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Service;

/**
 * @Author: YoyuEN
 * @Date: 2026/2/25
 * @Time: 11:28
 * @Description:
 */
@Service
@RequiredArgsConstructor
public class UserDetailsServiceImpl implements UserDetailsService {

    private final SystemUserMapper systemUserMapper;

    @Override
    public UserDetails loadUserByUsername(String username) throws UsernameNotFoundException {
        SystemUser systemUser = systemUserMapper.getUserWithRolesAndPermissions(username);
        if (systemUser == null) {
            throw new UsernameNotFoundException("用户不存在");
        }
        return systemUser;
    }

}
