package com.yoyuen.backend.service.ai.impl;

import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.yoyuen.backend.exception.BusinessException;
import com.yoyuen.backend.mapper.OriginFileResourceMapper;
import com.yoyuen.backend.model.ai.OriginFileResource;
import com.yoyuen.backend.model.user.SystemUser;
import com.yoyuen.backend.service.system.ObjectStoreService;
import com.yoyuen.backend.service.ai.OriginFileResourceService;
import com.yoyuen.backend.service.system.StorageFile;
import com.yoyuen.backend.utils.CoreCode;
import com.yoyuen.backend.utils.FileUtil;
import com.yoyuen.backend.utils.SecurityFrameworkUtil;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import javax.print.attribute.standard.Media;
import java.io.IOException;
import java.util.List;
import java.util.UUID;

/**
 * @Author: YoyuEN
 * @Date: 2026/2/5
 * @Time: 19:03
 * @Description:
 */
@Slf4j
@Service
@RequiredArgsConstructor
public class OriginFileResourceServiceImpl extends ServiceImpl<OriginFileResourceMapper, OriginFileResource>
        implements OriginFileResourceService {

    public static final String BUCKET_NAME = "OriginFile";

    private ObjectStoreService objectStoreService;

    @Override
    public List<Media> fromResourceId(List<String> resourceIds) {
        return List.of();
    }

    @Override
    public String uploadFile(MultipartFile file) {
        String originalFilename = file.getOriginalFilename();
        String objectName = objectNameWithUserId(originalFilename);
        String id = FileUtil.generatorFileId(BUCKET_NAME, objectName);
        String newObjectName = String.format("%s/%s", id, objectName);
        String path;
        String md5;
        try {
            md5 = FileUtil.md5(file.getResource().getFile());
            path = objectStoreService.uploadFile(file, BUCKET_NAME, newObjectName);
        }catch (IOException e) {
            throw new BusinessException(CoreCode.SYSTEM_ERROR, e.getMessage());
        }
        StorageFile fileInfo = objectStoreService.getFileInfo(BUCKET_NAME, newObjectName);
        OriginFileResource originFileResource = new OriginFileResource();
        originFileResource.setMd5(md5);
        originFileResource.setFileName(originalFilename);
        originFileResource.setPath(path);
        originFileResource.setId(fileInfo.getId());
        originFileResource.setBucketName(BUCKET_NAME);
        originFileResource.setObjectName(newObjectName);
        originFileResource.setIsImage(file.getContentType() != null && file.getContentType().startsWith("image"));
        originFileResource.setSize(fileInfo.getSize());
        originFileResource.setContentType(fileInfo.getContentType());
        this.saveOrUpdate(originFileResource);
        return originFileResource.getId();
    }

    @Override
    public String uploadFile(MultipartFile file, String knowledgeId) {
        return "";
    }

    private String objectNameWithUserId(String filename) {
        SystemUser loginUser = SecurityFrameworkUtil.getLoginUser();
        return loginUser.getId() + "/" + UUID.randomUUID().toString().replace("-", "") + "-" + filename;
    }
}
