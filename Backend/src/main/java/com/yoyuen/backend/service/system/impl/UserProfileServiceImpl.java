package com.yoyuen.backend.service.system.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.yoyuen.backend.entity.UserProfile;
import com.yoyuen.backend.mapper.UserProfileMapper;
import com.yoyuen.backend.service.system.UserProfileService;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
public class UserProfileServiceImpl extends ServiceImpl<UserProfileMapper, UserProfile> implements UserProfileService {

    @Override
    public UserProfile getProfile() {
        LambdaQueryWrapper<UserProfile> wrapper = new LambdaQueryWrapper<>();
        wrapper.orderByAsc(UserProfile::getCreateTime)
                .last("LIMIT 1");
        return this.getOne(wrapper);
    }

    @Transactional(rollbackFor = Exception.class)
    @Override
    public boolean saveOrUpdateProfile(UserProfile profile) {
        UserProfile existing = getProfile();
        if (existing != null) {
            profile.setId(existing.getId());
            return this.updateById(profile);
        }
        return this.save(profile);
    }
}
