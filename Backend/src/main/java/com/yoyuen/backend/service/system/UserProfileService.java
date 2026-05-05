package com.yoyuen.backend.service.system;

import com.yoyuen.backend.entity.UserProfile;

public interface UserProfileService {

    UserProfile getProfile();

    boolean saveOrUpdateProfile(UserProfile profile);
}
