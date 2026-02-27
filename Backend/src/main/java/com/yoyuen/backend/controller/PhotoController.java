package com.yoyuen.backend.controller;

import com.yoyuen.backend.controller.vo.PhotoVO;
import com.yoyuen.backend.service.system.PhotoService;
import com.yoyuen.backend.utils.BaseResponse;
import com.yoyuen.backend.utils.ResultUtils;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.util.List;

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

    /**
     * 获取照片列表
     */
    @GetMapping("/list")
    public BaseResponse<List<PhotoVO>> list() {
        return ResultUtils.success(photoService.listPhotos());
    }

    /**
     * 上传照片
     */
    @PostMapping("/upload")
    public BaseResponse<PhotoVO> upload(
            @RequestParam("file") MultipartFile file,
            @RequestParam(value = "description", required = false, defaultValue = "") String description) {
        PhotoVO vo = photoService.upload(file, description);
        return ResultUtils.success(vo);
    }

    /**
     * 删除照片
     */
    @PostMapping("/remove")
    public BaseResponse<Boolean> remove(@RequestParam String id) {
        return ResultUtils.success(photoService.remove(id));
    }
}
