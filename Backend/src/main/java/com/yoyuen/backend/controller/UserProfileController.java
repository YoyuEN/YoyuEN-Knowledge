package com.yoyuen.backend.controller;

import com.yoyuen.backend.entity.UserProfile;
import com.yoyuen.backend.service.system.UserProfileService;
import com.yoyuen.backend.utils.BaseResponse;
import com.yoyuen.backend.utils.ResultUtils;
import lombok.RequiredArgsConstructor;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/profile")
@RequiredArgsConstructor
public class UserProfileController {

    private final UserProfileService userProfileService;

    @GetMapping("/detail")
    public BaseResponse<UserProfile> detail() {
        return ResultUtils.success(userProfileService.getProfile());
    }

    @PreAuthorize("hasRole('ADMIN')")
    @PostMapping("/update")
    public BaseResponse<Boolean> update(@RequestBody UserProfile profile) {
        return ResultUtils.success(userProfileService.saveOrUpdateProfile(profile));
    }
}
