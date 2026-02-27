package com.yoyuen.backend.service.system;

import com.yoyuen.backend.controller.vo.PhotoVO;
import org.springframework.web.multipart.MultipartFile;

import java.util.List;

/**
 * @Author: YoyuEN
 * @Date: 2026/2/27
 * @Description: 照片服务接口
 */
public interface PhotoService {

    /**
     * 获取所有照片列表（含MinIO预签名URL）
     */
    List<PhotoVO> listPhotos();

    /**
     * 上传照片到MinIO并保存记录
     */
    PhotoVO upload(MultipartFile file, String description);

    /**
     * 删除照片（MinIO + DB）
     */
    boolean remove(String id);
}
