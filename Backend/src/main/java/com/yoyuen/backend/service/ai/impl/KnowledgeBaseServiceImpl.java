package com.yoyuen.backend.service.ai.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.yoyuen.backend.controller.vo.KnowledgeBaseVO;
import com.yoyuen.backend.controller.vo.SimpleBaseVO;
import com.yoyuen.backend.mapper.DocumentEntityMapper;
import com.yoyuen.backend.mapper.KnowledgeBaseMapper;
import com.yoyuen.backend.mapper.OriginFileResourceMapper;
import com.yoyuen.backend.mapper.SystemUserMapper;
import com.yoyuen.backend.model.entity.ai.DocumentEntity;
import com.yoyuen.backend.model.entity.ai.KnowledgeBase;
import com.yoyuen.backend.model.entity.ai.OriginFileResource;
import com.yoyuen.backend.model.entity.user.SystemUser;
import com.yoyuen.backend.service.ai.KnowledgeBaseService;
import com.yoyuen.backend.service.ai.LLMService;
import com.yoyuen.backend.service.system.ObjectStoreService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.ai.document.Document;
import org.springframework.ai.vectorstore.SearchRequest;
import org.springframework.ai.vectorstore.VectorStore;
import org.springframework.ai.vectorstore.filter.Filter;
import org.springframework.ai.vectorstore.filter.FilterExpressionBuilder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

/**
 * @Author: YoyuEN
 * @Date: 2026/2/12
 * @Time: 13:27
 * @Description:
 */
@Slf4j
@Service
@RequiredArgsConstructor
public class KnowledgeBaseServiceImpl extends ServiceImpl<KnowledgeBaseMapper, KnowledgeBase> implements KnowledgeBaseService {

    private final SystemUserMapper userMapper;
    private final DocumentEntityMapper documentEntityMapper;
    private final OriginFileResourceMapper originFileResourceMapper;
    private final LLMService llmService;
    private final ObjectStoreService objectStoreService;

    @Transactional(rollbackFor = Exception.class)
    @Override
    public String addKnowledgeBase(KnowledgeBaseVO knowledgeBaseVO) {
        KnowledgeBase knowledgeBase = new KnowledgeBase();
        knowledgeBase.setName(knowledgeBaseVO.getName());
        knowledgeBase.setDescription(knowledgeBaseVO.getDescription());
        this.save(knowledgeBase);
        return knowledgeBase.getId();
    }

    @Transactional(rollbackFor = Exception.class)
    @Override
    public Boolean updateKnowledgeBase(KnowledgeBaseVO knowledgeBaseVO) {
        KnowledgeBase knowledgeBase = this.getById(knowledgeBaseVO.getId());
        if (knowledgeBase != null) {
            knowledgeBase.setName(knowledgeBaseVO.getName());
            knowledgeBase.setDescription(knowledgeBaseVO.getDescription());
            return this.updateById(knowledgeBase);
        }
        return false;
    }

    @Transactional(rollbackFor = Exception.class)
    @Override
    public Integer removeKnowledgeBase(KnowledgeBaseVO knowledgeBaseVO) {
        String id = knowledgeBaseVO.getId();

        // 1. 查询该知识库下的所有文档
        LambdaQueryWrapper<DocumentEntity> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(DocumentEntity::getBaseId, id);
        List<DocumentEntity> documents = documentEntityMapper.selectList(wrapper);

        if (!documents.isEmpty()) {
            VectorStore vectorStore = llmService.getVectorStore();
            for (DocumentEntity document : documents) {
                // 1.1 删除向量数据
                try {
                    Filter.Expression filterExpression = new FilterExpressionBuilder()
                            .eq("document_id", document.getId()).build();
                    SearchRequest searchRequest = SearchRequest.defaults()
                            .withTopK(10000)
                            .withFilterExpression(filterExpression);
                    List<Document> vecDocs = vectorStore.similaritySearch(searchRequest);
                    if (!vecDocs.isEmpty()) {
                        List<String> vecIds = vecDocs.stream().map(Document::getId).toList();
                        vectorStore.delete(vecIds);
                    }
                } catch (Exception e) {
                    log.error("删除知识库 [{}] 文档 [{}] 向量数据失败: {}", id, document.getId(), e.getMessage());
                }

                // 1.2 删除 MinIO 物理文件及资源记录
                if (document.getResourceId() != null) {
                    OriginFileResource resource = originFileResourceMapper.selectById(document.getResourceId());
                    if (resource != null) {
                        try {
                            objectStoreService.deleteFile(resource.getBucketName(), resource.getObjectName());
                        } catch (Exception e) {
                            log.error("删除 MinIO 文件失败 {}/{}: {}", resource.getBucketName(), resource.getObjectName(), e.getMessage());
                        }
                        originFileResourceMapper.deleteById(resource.getId());
                    }
                }

                // 1.3 逻辑删除文档记录
                documentEntityMapper.deleteById(document.getId());
            }
            log.info("知识库 [{}] 级联清理完成，共处理 {} 个文档", id, documents.size());
        }

        boolean removed = this.removeById(id);
        return removed ? 1 : 0;
    }

    @Override
    public List<KnowledgeBaseVO> KnowledgeList() {
        List<KnowledgeBase> knowledgeBaseList = this.list();
        return transfer(knowledgeBaseList);
    }

    @Override
    public List<KnowledgeBaseVO> listKnowledge(String keyword, String category) {
        List<KnowledgeBase> knowledgeBaseList = this.list();

        // 简单的客户端过滤（如果需要数据库级别的过滤，可以使用 LambdaQueryWrapper）
        if (keyword != null && !keyword.isEmpty()) {
            knowledgeBaseList = knowledgeBaseList.stream()
                .filter(kb -> kb.getName().contains(keyword) ||
                             (kb.getDescription() != null && kb.getDescription().contains(keyword)))
                .toList();
        }

        return transfer(knowledgeBaseList);
    }

    @Override
    public KnowledgeBaseVO getKnowledgeById(String id) {
        KnowledgeBase knowledgeBase = this.getById(id);
        return knowledgeBase != null ? transfer(knowledgeBase) : null;
    }

    @Override
    public List<SimpleBaseVO> simpleList() {
        return transfer2Simple(this.list());
    }

    private List<KnowledgeBaseVO> transfer(List<KnowledgeBase> knowledgeBaseList) {
        return knowledgeBaseList.stream().map(this::transfer).toList();
    }

    private KnowledgeBaseVO transfer(KnowledgeBase knowledgeBase) {
        KnowledgeBaseVO knowledgeBaseVO = new KnowledgeBaseVO();
        knowledgeBaseVO.setId(knowledgeBase.getId());
        knowledgeBaseVO.setName(knowledgeBase.getName());
        knowledgeBaseVO.setDescription(knowledgeBase.getDescription());
        String creator = knowledgeBase.getCreator();
        if (creator != null) {
            SystemUser user = userMapper.getUserWithRolesAndPermissions(creator);
            knowledgeBaseVO.setAuthor(user.getId());
            knowledgeBaseVO.setAuthorName(user.getUsername());
        }
        return knowledgeBaseVO;
    }

    private List<SimpleBaseVO> transfer2Simple(List<KnowledgeBase> knowledgeBaseList) {
        return knowledgeBaseList.stream().map(item -> {
            SimpleBaseVO simpleBaseVO = new SimpleBaseVO();
            simpleBaseVO.setId(item.getId());
            simpleBaseVO.setName(item.getName());
            return simpleBaseVO;
        }).toList();
    }
}
