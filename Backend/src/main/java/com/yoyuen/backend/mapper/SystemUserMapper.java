package com.yoyuen.backend.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.yoyuen.backend.model.user.SystemUser;
import org.apache.ibatis.annotations.Mapper;

/**
 * @Author: YoyuEN
 * @Date: 2026/2/12
 * @Time: 13:33
 * @Description:
 */
@Mapper
public interface SystemUserMapper extends BaseMapper<SystemUser> {
    SystemUser getUserWithRolesAndPermissions(String name);
}
