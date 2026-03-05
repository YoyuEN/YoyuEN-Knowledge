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
import net.coobird.thumbnailator.Thumbnails;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
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
    private static final int THUMBNAIL_WIDTH = 800;
    private static final int THUMBNAIL_HEIGHT = 600;

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
            String thumbnailName = "thumb_" + timeStr + ext;

            // 上传原图
            objectStoreService.uploadFile(file, PHOTO_BUCKET, objectName);

            // 生成并上传缩略图
            try {
                ByteArrayOutputStream thumbOutput = new ByteArrayOutputStream();
                Thumbnails.of(file.getInputStream())
                        .size(THUMBNAIL_WIDTH, THUMBNAIL_HEIGHT)
                        .outputQuality(0.8)
                        .toOutputStream(thumbOutput);

                byte[] thumbBytes = thumbOutput.toByteArray();
                objectStoreService.uploadFile(
                    new ByteArrayInputStream(thumbBytes),
                    PHOTO_BUCKET,
                    thumbnailName,
                    file.getContentType(),
                    thumbBytes.length
                );
                log.info("[照片上传] 缩略图生成成功，size={}KB", thumbBytes.length / 1024);
            } catch (Exception e) {
                log.warn("[照片上传] 缩略图生成失败，使用原图，error={}", e.getMessage());
                thumbnailName = objectName; // 降级使用原图
            }

            Photo photo = new Photo();
            photo.setBucketName(PHOTO_BUCKET);
            photo.setObjectName(objectName);
            photo.setThumbnailName(thumbnailName);
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
                // 删除缩略图（如果不是原图）
                if (photo.getThumbnailName() != null && !photo.getThumbnailName().equals(photo.getObjectName())) {
                    objectStoreService.deleteFile(photo.getBucketName(), photo.getThumbnailName());
                }
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
        // 使用缩略图URL，如果没有则使用原图
        String thumbnailName = (photo.getThumbnailName() != null && !photo.getThumbnailName().isEmpty())
                ? photo.getThumbnailName()
                : photo.getObjectName();
        String url = objectStoreService.getTmpFileUrl(photo.getBucketName(), thumbnailName);
        vo.setUrl(url);
        return vo;
    }
}
