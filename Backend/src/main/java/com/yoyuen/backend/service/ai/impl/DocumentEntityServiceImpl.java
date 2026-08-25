package com.yoyuen.backend.service.ai.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.yoyuen.backend.controller.vo.DocumentVO;
import com.yoyuen.backend.exception.BusinessException;
import com.yoyuen.backend.mapper.DocumentEntityMapper;
import com.yoyuen.backend.mapper.KnowledgeBaseMapper;
import com.yoyuen.backend.mapper.OriginFileResourceMapper;
import com.yoyuen.backend.model.entity.ai.DocumentEntity;
import com.yoyuen.backend.model.entity.ai.KnowledgeBase;
import com.yoyuen.backend.model.entity.ai.OriginFileResource;
import com.yoyuen.backend.objectstore.service.MinIOService;
import com.yoyuen.backend.service.ai.DocumentEntityService;
import com.yoyuen.backend.service.ai.LLMService;
import com.yoyuen.backend.service.system.ObjectStoreService;
import com.yoyuen.backend.utils.CoreCode;
import jakarta.servlet.ServletOutputStream;
import jakarta.servlet.http.HttpServletResponse;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.ai.document.Document;
import org.springframework.ai.vectorstore.SearchRequest;
import org.springframework.ai.vectorstore.VectorStore;
import org.springframework.ai.vectorstore.filter.Filter;
import org.springframework.ai.vectorstore.filter.FilterExpressionBuilder;
import org.springframework.beans.BeanUtils;
import org.springframework.stereotype.Service;

import java.io.IOException;
import java.io.InputStream;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.util.List;

/**
 * @Author: YoyuEN
 * @Date: 2026/2/24
 * @Time: 15:50
 * @Description:
 */
@Slf4j
@Service
@RequiredArgsConstructor
public class DocumentEntityServiceImpl implements DocumentEntityService {

    private final DocumentEntityMapper documentEntityMapper;

    private final OriginFileResourceMapper originFileResourceMapper;

    private final KnowledgeBaseMapper knowledgeBaseMapper;

    private final ObjectStoreService objectStoreService;

    private final LLMService llmService;

    private final MinIOService minIOService;

    @Override
    public Page<DocumentVO> listDocuments(DocumentVO document) {
        if (document.getKnowledgeBaseId() == null) {
            throw new BusinessException(CoreCode.PARAMS_ERROR);
        }
        LambdaQueryWrapper<DocumentEntity> qw = new LambdaQueryWrapper<>();
        if (document.getFileName() != null) {
            qw.like(DocumentEntity::getFileName, document.getFileName());
        }
        qw.eq(DocumentEntity::getBaseId, document.getKnowledgeBaseId());
        qw.orderByDesc(DocumentEntity::getCreateTime);
        Page<DocumentEntity> page = Page.of(document.getPageNo(), document.getPageSize());
        Page<DocumentEntity> documentPage = documentEntityMapper.selectPage(page, qw);
        List<DocumentVO> vos = transfer(documentPage.getRecords());
        Page<DocumentVO> res = new Page<>();
        BeanUtils.copyProperties(documentPage, res);
        res.setRecords(vos);
        return res;
    }

    @Override
    public int deleteByBaseIdAndFileNamePrefix(String baseId, String fileNamePrefix) {
        LambdaQueryWrapper<DocumentEntity> qw = new LambdaQueryWrapper<>();
        qw.eq(DocumentEntity::getBaseId, baseId);
        qw.likeRight(DocumentEntity::getFileName, fileNamePrefix);
        List<DocumentEntity> docs = documentEntityMapper.selectList(qw);
        if (docs.isEmpty()) return 0;

        VectorStore vectorStore = llmService.getVectorStore();
        for (DocumentEntity doc : docs) {
            try {
                // 1. 删除向量数据
                Filter.Expression filterExpression = new FilterExpressionBuilder()
                        .eq("document_id", doc.getId()).build();
                SearchRequest searchRequest = SearchRequest.defaults()
                        .withTopK(10000)
                        .withFilterExpression(filterExpression);
                List<org.springframework.ai.document.Document> vectors =
                        vectorStore.similaritySearch(searchRequest);
                if (!vectors.isEmpty()) {
                    List<String> ids = vectors.stream()
                            .map(org.springframework.ai.document.Document::getId).toList();
                    vectorStore.delete(ids);
                }
            } catch (Exception e) {
                log.warn("删除向量数据失败: docId={}", doc.getId(), e);
            }

            // 2. 删除 MinIO 文件 + OriginFileResource 记录
            if (doc.getResourceId() != null) {
                OriginFileResource originFile = originFileResourceMapper.selectById(doc.getResourceId());
                if (originFile != null) {
                    try {
                        ((MinIOService) objectStoreService).deleteFile(
                                originFile.getBucketName(), originFile.getObjectName());
                    } catch (Exception e) {
                        log.warn("删除MinIO文件失败: bucket={}, object={}",
                                originFile.getBucketName(), originFile.getObjectName(), e);
                    }
                    originFileResourceMapper.deleteById(originFile.getId());
                }
            }

            // 3. 删除文档实体记录
            documentEntityMapper.deleteById(doc);
        }
        log.info("按前缀批量删除文档: baseId={}, prefix={}, count={}", baseId, fileNamePrefix, docs.size());
        return docs.size();
    }

    @Override
    public Boolean deleteKnowledgeFile(DocumentVO documentVO) {
        Long docId = documentVO.getId();

        DocumentEntity document = documentEntityMapper.selectById(docId);
        if (document == null) {
            throw new BusinessException(CoreCode.FILE_NOT_FOUND);
        }

        try {
            documentEntityMapper.deleteById(docId);
            // 删除向量数据
            VectorStore vectorStore = llmService.getVectorStore();
            Filter.Expression filterExpression = new FilterExpressionBuilder().eq("document_id", docId).build();
            SearchRequest searchRequest = SearchRequest.defaults()
                    .withTopK(10000)
                    .withFilterExpression(filterExpression);

            List<Document> documents = vectorStore.similaritySearch(searchRequest);
            if (!documents.isEmpty()) {
                List<String> ids = documents.stream().map(Document::getId).toList();
                vectorStore.delete(ids);
            }
            return true;
        } catch (Exception e) {
            log.error("删除文档失败: id={}", docId, e);
            throw new BusinessException(CoreCode.SYSTEM_ERROR, e.getMessage());
        }
    }

    @Override
    public void download(Long fileId, HttpServletResponse response) {
        DocumentEntity document = documentEntityMapper.selectById(fileId);
        if (document == null) {
            throw new BusinessException(CoreCode.FILE_NOT_FOUND);
        }
        OriginFileResource originFileResource = originFileResourceMapper.selectById(document.getResourceId());
        if (originFileResource == null) {
            throw new BusinessException(CoreCode.FILE_NOT_FOUND);
        }
        InputStream file = minIOService.getFile(originFileResource.getBucketName(), originFileResource.getObjectName());

        // 设置响应头
        response.setContentType("application/octet-stream");
        response.setHeader("Content-Disposition", "attachment; filename=\""
                + URLEncoder.encode(originFileResource.getFileName(), StandardCharsets.UTF_8) + "\"");

        try (ServletOutputStream out = response.getOutputStream()) {
            byte[] buffer = new byte[1024];
            int length;
            while ((length = file.read(buffer)) != -1) {
                out.write(buffer, 0, length);
            }
            out.flush();
        }
        catch (IOException e) {
            throw new RuntimeException("文件下载失败", e);
        }
    }

    private List<DocumentVO> transfer(List<DocumentEntity> documentEntities) {
        return documentEntities.stream().map(item -> {
            String resourceId = item.getResourceId();
            OriginFileResource originFileResource = originFileResourceMapper.selectById(resourceId);
            String path = objectStoreService.getTmpFileUrl(originFileResource.getBucketName(),
                    originFileResource.getObjectName());
            KnowledgeBase knowledgeBase = knowledgeBaseMapper.selectById(item.getBaseId());
            DocumentVO documentVO = new DocumentVO();
            documentVO.setId(item.getId());
            documentVO.setFileName(item.getFileName());
            documentVO.setIsEmbedding(item.getIsEmbedding());
            documentVO.setBaseId(item.getBaseId());
            documentVO.setPath(path);
            documentVO.setKnowledgeBaseName(knowledgeBase.getName());
            documentVO.setFileType(originFileResource.getContentType());
            documentVO.setUploadTime(item.getCreateTime());
            return documentVO;
        }).toList();
    }

}
