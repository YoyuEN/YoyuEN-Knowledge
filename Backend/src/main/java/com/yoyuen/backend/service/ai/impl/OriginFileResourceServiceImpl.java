package com.yoyuen.backend.service.ai.impl;

import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.yoyuen.backend.controller.vo.ResourceVO;
import com.yoyuen.backend.exception.BusinessException;
import com.yoyuen.backend.mapper.DocumentEntityMapper;
import com.yoyuen.backend.mapper.OriginFileResourceMapper;
import com.yoyuen.backend.model.entity.ai.DocumentEntity;
import com.yoyuen.backend.model.entity.ai.OriginFileResource;
import com.yoyuen.backend.model.entity.user.SystemUser;
import com.yoyuen.backend.service.ai.LLMService;
import com.yoyuen.backend.service.system.ObjectStoreService;
import com.yoyuen.backend.service.ai.OriginFileResourceService;
import com.yoyuen.backend.service.system.StorageFile;
import com.yoyuen.backend.utils.CoreCode;
import com.yoyuen.backend.utils.FileUtil;
import com.yoyuen.backend.utils.SecurityFrameworkUtil;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.ai.document.Document;
import org.springframework.ai.model.Media;
import org.springframework.ai.reader.tika.TikaDocumentReader;
import org.springframework.ai.transformer.splitter.TokenTextSplitter;
import org.springframework.ai.vectorstore.VectorStore;
import org.springframework.core.io.ByteArrayResource;
import org.springframework.core.io.Resource;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.MimeTypeUtils;
import org.springframework.web.multipart.MultipartFile;

import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.Path;
import java.util.List;
import java.util.Map;
import java.util.UUID;

/**
 * @Author: YoyuEN
 * @Date: 2026/2/5
 * @Time: 19:03
 * @Description: 针对表【origin_file_source(存储原始文件资源的表)】的数据库操作Service实现
 */
@Slf4j
@Service
@RequiredArgsConstructor
public class OriginFileResourceServiceImpl extends ServiceImpl<OriginFileResourceMapper, OriginFileResource>
        implements OriginFileResourceService {

    public static final String CHAT_BUCKET_NAME = "origin-file";

    public static final String KNOWLEDGE_BUCKET_NAME = "knowledge-file";

    private final ObjectStoreService objectStoreService;

    private final DocumentEntityMapper documentEntityMapper;

    private final TokenTextSplitter tokenTextSplitter;

    private final LLMService llmService;

    @Override
    public List<Media> fromResourceId(List<String> resourceIds) {
        if (resourceIds == null || resourceIds.isEmpty()) {
            return List.of();
        }
        List<OriginFileResource> originFileResources = this.listByIds(resourceIds);
        List<Media> medias = originFileResources.stream().map(item -> {
            // 获取文件资源的临时访问链接
            String fileUrl = objectStoreService.getTmpFileUrl(item.getBucketName(), item.getObjectName());
            String[] split = item.getFileName().split("\\.");
            String suffix = split[split.length - 1];
            try {
                // 下载到本地
                File file = FileUtil.downloadToTempFile(fileUrl, "chat_", suffix);
                String mimeType = FileUtil.detectMimeType(file);
                return new Media(
                        MimeTypeUtils.parseMimeType(mimeType),
                        new ByteArrayResource(Files.readAllBytes(Path.of(file.getPath())))
                );
            }
            catch (Exception e) {
                throw new BusinessException(CoreCode.SYSTEM_ERROR, e.getMessage());
            }
        }).toList();
        return medias;
    }

    @Transactional(rollbackFor = Exception.class)
    @Override
    public String uploadFile(MultipartFile file) {
        OriginFileResource upload = this.upload(file, CHAT_BUCKET_NAME);
        return upload.getId();
    }

    @Transactional(rollbackFor = Exception.class)
    @Override
    public Long uploadFile(MultipartFile file, String knowledgeId) {
        // 1. 先上传文件至MinIO
        OriginFileResource upload = this.upload(file, KNOWLEDGE_BUCKET_NAME);
        // 2. 存储到数据库
        DocumentEntity documentEntity = new DocumentEntity();
        documentEntity.setFileName(file.getOriginalFilename());
        documentEntity.setBaseId(knowledgeId);
        documentEntity.setPath(upload.getPath());
        documentEntity.setIsEmbedding(false);
        documentEntity.setResourceId(upload.getId());
        documentEntityMapper.insert(documentEntity);
        // 3. 向量化
        Resource resource;
        try {
            InputStream inputStream = objectStoreService.getFile(upload.getBucketName(), upload.getObjectName());
            resource = new ByteArrayResource(inputStream.readAllBytes());
        }
        catch (IOException e) {
            throw new BusinessException(CoreCode.SYSTEM_ERROR, e.getMessage());
        }
        TikaDocumentReader tikaDocumentReader = new TikaDocumentReader(resource);
        List<Document> rawDocumentList = tikaDocumentReader.read();
        List<Document> splitDocumentList = tokenTextSplitter.split(rawDocumentList);
        List<Document> hasMetaDocumentList = splitDocumentList.stream().map(item -> {
            Map<String, Object> metadata = item.getMetadata();
//            metadata.put("user_id", SecurityFrameworkUtil.getCurrUserId());
            metadata.put("knowledge_base_id", knowledgeId);
            metadata.put("document_id", documentEntity.getId());
            return new Document(item.getContent(), metadata);
        }).toList();
        VectorStore vectorStore = llmService.getVectorStore();
        vectorStore.accept(hasMetaDocumentList);
        // 4. 更新
        documentEntity.setIsEmbedding(true);
        documentEntityMapper.updateById(documentEntity);
        return documentEntity.getId();
    }

    @Override
    public List<ResourceVO> resourcesFromIds(List<String> resourceIds) {
        if (resourceIds == null || resourceIds.isEmpty()) {
            return List.of();
        }
        return resourceIds.stream().map(item -> {
            ResourceVO resourceVO = new ResourceVO();
            OriginFileResource originFileResource = this.getById(item);
            resourceVO.setResourceId(item);
            resourceVO.setFileType(originFileResource.getContentType());
            resourceVO.setFileName(originFileResource.getFileName());
            resourceVO.setPath(objectStoreService.getTmpFileUrl(originFileResource.getBucketName(),
                    originFileResource.getObjectName()));
            return resourceVO;
        }).toList();
    }

    private OriginFileResource upload(MultipartFile file, String bucketName) {
        String originalFilename = file.getOriginalFilename();
//        String objectName = objectNameWithUserId(originalFilename);
        //不使用用户验证
        String objectName = originalFilename;
        String newObjectName = objectName;
        String path;
        String md5;
        try {
            File tmpFile = FileUtil.createTempFile("know", "_" + file.getOriginalFilename());
            file.transferTo(tmpFile);
            md5 = FileUtil.md5(tmpFile);
            path = objectStoreService.uploadFile(tmpFile, bucketName, newObjectName);
        }
        catch (IOException e) {
            throw new BusinessException(CoreCode.SYSTEM_ERROR, e.getMessage());
        }
        StorageFile fileInfo = objectStoreService.getFileInfo(bucketName, newObjectName);
        OriginFileResource originFileResource = new OriginFileResource();
        originFileResource.setMd5(md5);
        originFileResource.setFileName(originalFilename);
        originFileResource.setPath(path);
        originFileResource.setId(fileInfo.getId());
        originFileResource.setBucketName(bucketName);
        originFileResource.setObjectName(newObjectName);
        originFileResource.setIsImage(file.getContentType() != null && file.getContentType().startsWith("image"));
        originFileResource.setSize(fileInfo.getSize());
        originFileResource.setContentType(fileInfo.getContentType());
        this.saveOrUpdate(originFileResource);
        return originFileResource;
    }

    @Transactional(rollbackFor = Exception.class)
    @Override
    public Long uploadMarkdown(byte[] content, String fileName, String knowledgeId) {
        // 1. 写入临时文件
        File tmpFile;
        String path;
        String md5;
        try {
            tmpFile = FileUtil.createTempFile("md_", "_" + fileName);
            Files.write(tmpFile.toPath(), content);
            md5 = FileUtil.md5(tmpFile);
        } catch (IOException e) {
            throw new BusinessException(CoreCode.SYSTEM_ERROR, e.getMessage());
        }
        // 2. 上传至 MinIO knowledge-file bucket
        // 文件名已含时间戳，天然唯一，直接作为 objectName 避免生成 "文件名/hash" 的伪目录结构
        String objectName = fileName;
        try {
            path = objectStoreService.uploadFile(tmpFile, KNOWLEDGE_BUCKET_NAME, objectName);
        } catch (IOException e) {
            throw new BusinessException(CoreCode.SYSTEM_ERROR, e.getMessage());
        }
        StorageFile fileInfo = objectStoreService.getFileInfo(KNOWLEDGE_BUCKET_NAME, objectName);
        // 3. 保存原始文件记录
        OriginFileResource originFileResource = new OriginFileResource();
        originFileResource.setMd5(md5);
        originFileResource.setFileName(fileName);
        originFileResource.setPath(path);
        originFileResource.setId(fileInfo.getId());
        originFileResource.setBucketName(KNOWLEDGE_BUCKET_NAME);
        originFileResource.setObjectName(objectName);
        originFileResource.setIsImage(false);
        originFileResource.setSize(fileInfo.getSize());
        originFileResource.setContentType("text/markdown");
        this.saveOrUpdate(originFileResource);
        // 4. 保存文档实体
        DocumentEntity documentEntity = new DocumentEntity();
        documentEntity.setFileName(fileName);
        documentEntity.setBaseId(knowledgeId);
        documentEntity.setPath(path);
        documentEntity.setIsEmbedding(false);
        documentEntity.setResourceId(originFileResource.getId());
        documentEntityMapper.insert(documentEntity);
        // 5. 向量化
        Resource resource = new ByteArrayResource(content);
        TikaDocumentReader tikaDocumentReader = new TikaDocumentReader(resource);
        List<Document> rawDocumentList = tikaDocumentReader.read();
        List<Document> splitDocumentList = tokenTextSplitter.split(rawDocumentList);
        List<Document> hasMetaDocumentList = splitDocumentList.stream().map(item -> {
            Map<String, Object> metadata = item.getMetadata();
            metadata.put("knowledge_base_id", knowledgeId);
            metadata.put("document_id", documentEntity.getId());
            return new Document(item.getContent(), metadata);
        }).toList();
        VectorStore vectorStore = llmService.getVectorStore();
        vectorStore.accept(hasMetaDocumentList);
        // 6. 更新嵌入状态
        documentEntity.setIsEmbedding(true);
        documentEntityMapper.updateById(documentEntity);
        return documentEntity.getId();
    }

    private String objectNameWithUserId(String filename) {
        SystemUser loginUser = SecurityFrameworkUtil.getLoginUser();
        return loginUser.getId() + "/" + UUID.randomUUID().toString().replace("-", "") + "-" + filename;
    }
}

