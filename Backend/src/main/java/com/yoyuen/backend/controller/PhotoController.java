package com.yoyuen.backend.controller;

import com.yoyuen.backend.controller.vo.PhotoVO;
import com.yoyuen.backend.service.system.PhotoService;
import com.yoyuen.backend.service.system.RedisService;
import com.yoyuen.backend.utils.BaseResponse;
import com.yoyuen.backend.utils.ResultUtils;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.util.List;
import java.util.concurrent.TimeUnit;

/**
 * @Author: YoyuEN
 * @Date: 2026/2/27
 * @Description: 照片控制器
 */
@Slf4j
@RestController
@RequestMapping("/photo")
@RequiredArgsConstructor
public class PhotoController {

    private final PhotoService photoService;
    private final RedisService redisService;

    /**
     * 获取照片列表
     */
    @GetMapping("/list")
    public BaseResponse<List<PhotoVO>> list() {
        String cacheKey = "photo:list";
        Object cached = redisService.get(cacheKey);
        if (cached != null) {
            log.debug("从缓存获取照片列表");
            return ResultUtils.success((List<PhotoVO>) cached);
        }

        List<PhotoVO> photos = photoService.listPhotos();
        redisService.set(cacheKey, photos, 10, TimeUnit.MINUTES);
        return ResultUtils.success(photos);
    }

    /**
     * 上传照片
     */
    @PreAuthorize("hasRole('ADMIN')")
    @PostMapping("/upload")
    public BaseResponse<PhotoVO> upload(
            @RequestParam("file") MultipartFile file,
            @RequestParam(value = "description", required = false, defaultValue = "") String description) {
        PhotoVO vo = photoService.upload(file, description);
        // 清除缓存
        redisService.delete("photo:list");
        return ResultUtils.success(vo);
    }

    /**
     * 删除照片
     */
    @PreAuthorize("hasRole('ADMIN')")
    @PostMapping("/remove")
    public BaseResponse<Boolean> remove(@RequestParam String id) {
        boolean result = photoService.remove(id);
        // 清除缓存
        redisService.delete("photo:list");
        return ResultUtils.success(result);
    }
}
