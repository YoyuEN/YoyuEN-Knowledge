package com.yoyuen.backend.service.system.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.yoyuen.backend.controller.vo.PhotoVO;
import com.yoyuen.backend.entity.Photo;
import com.yoyuen.backend.mapper.PhotoMapper;
import com.yoyuen.backend.service.system.ObjectStoreService;
import com.yoyuen.backend.service.system.PhotoService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.List;

/**
 * @Author: YoyuEN
 * @Date: 2026/2/27
 * @Description: 照片服务实现类
 */
@Slf4j
@Service
@RequiredArgsConstructor
public class PhotoServiceImpl extends ServiceImpl<PhotoMapper, Photo> implements PhotoService {

    private static final String PHOTO_BUCKET = "photo";

    private final ObjectStoreService objectStoreService;

    @Override
    public List<PhotoVO> listPhotos() {
        LambdaQueryWrapper<Photo> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(Photo::getDeleted, false)
                .orderByDesc(Photo::getCreateTime);
        List<Photo> photos = this.list(wrapper);
        return photos.stream().map(this::toVO).toList();
    }

    @Transactional(rollbackFor = Exception.class)
    @Override
    public PhotoVO upload(MultipartFile file, String description) {
        try {
            String timeStr = LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyyMMdd_HHmmss"));
            String originalFilename = file.getOriginalFilename();
            String ext = (originalFilename != null && originalFilename.contains("."))
                    ? originalFilename.substring(originalFilename.lastIndexOf("."))
                    : ".jpg";
            String objectName = "photo_" + timeStr + ext;

            objectStoreService.uploadFile(file, PHOTO_BUCKET, objectName);

            Photo photo = new Photo();
            photo.setBucketName(PHOTO_BUCKET);
            photo.setObjectName(objectName);
            photo.setDescription(description);
            this.save(photo);

            return toVO(photo);
        } catch (Exception e) {
            log.error("[照片上传] 失败，error={}", e.getMessage(), e);
            throw new RuntimeException("照片上传失败: " + e.getMessage());
        }
    }

    @Transactional(rollbackFor = Exception.class)
    @Override
    public boolean remove(String id) {
        Photo photo = this.baseMapper.selectById(id);
        if (photo != null) {
            try {
                objectStoreService.deleteFile(photo.getBucketName(), photo.getObjectName());
            } catch (Exception e) {
                log.warn("[照片删除] MinIO删除失败，继续删除DB记录，objectName={}, error={}", photo.getObjectName(), e.getMessage());
            }
        }
        return this.removeById(id);
    }

    private PhotoVO toVO(Photo photo) {
        PhotoVO vo = new PhotoVO();
        vo.setId(photo.getId());
        vo.setDescription(photo.getDescription());
        vo.setCreateTime(photo.getCreateTime());
        String url = objectStoreService.getTmpFileUrl(photo.getBucketName(), photo.getObjectName());
        vo.setUrl(url);
        return vo;
    }
}
