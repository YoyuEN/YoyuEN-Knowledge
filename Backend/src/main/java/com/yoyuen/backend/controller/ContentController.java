package com.yoyuen.backend.controller;

import com.yoyuen.backend.controller.vo.ContentVO;
import com.yoyuen.backend.controller.vo.KnowledgeBaseVO;
import com.yoyuen.backend.entity.Content;
import com.yoyuen.backend.service.ai.KnowledgeBaseService;
import com.yoyuen.backend.service.ai.OriginFileResourceService;
import com.yoyuen.backend.service.system.ContentService;
import com.yoyuen.backend.service.system.ObjectStoreService;
import com.yoyuen.backend.utils.BaseResponse;
import com.yoyuen.backend.utils.ResultUtils;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.BeanUtils;
import org.springframework.web.bind.annotation.*;

import java.nio.charset.StandardCharsets;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.List;

/**
 * @Author: YoyuEN
 * @Date: 2026/2/26
 * @Description: 内容控制器
 */
@Slf4j
@RestController
@RequestMapping("/content")
@RequiredArgsConstructor
public class ContentController {

    private final ContentService contentService;
    private final KnowledgeBaseService knowledgeBaseService;
    private final OriginFileResourceService originFileResourceService;
    private final ObjectStoreService objectStoreService;

    private static final String DEFAULT_BUCKET = "default";
    private static final String DEFAULT_COVER = "default.jpg";

    /**
     * 根据ID获取内容详情
     */
    @GetMapping("/{id}")
    public BaseResponse<ContentVO> getById(@PathVariable String id) {
        Content content = contentService.getById(id);
        contentService.incrementViewCount(id);
        return ResultUtils.success(toVO(content));
    }

    /**
     * 根据分类获取内容列表
     */
    @GetMapping("/list/{category}")
    public BaseResponse<List<ContentVO>> listByCategory(@PathVariable String category) {
        List<Content> contents = contentService.listByCategory(category);
        return ResultUtils.success(contents.stream().map(this::toVO).toList());
    }

    /**
     * 获取推荐内容列表
     */
    @GetMapping("/recommend")
    public BaseResponse<List<ContentVO>> listRecommend() {
        List<Content> contents = contentService.listRecommend();
        return ResultUtils.success(contents.stream().map(this::toVO).toList());
    }

    /**
     * 添加内容
     */
    @PostMapping("/create")
    public BaseResponse<String> create(@Valid @RequestBody ContentVO contentVO) {
        if (contentVO.getCover() == null || contentVO.getCover().isBlank()) {
            contentVO.setCover(objectStoreService.getTmpFileUrl(DEFAULT_BUCKET, DEFAULT_COVER));
        }
        Content content = toEntity(contentVO);
        String id = contentService.addContent(content);
        contentVO.setId(id);
        syncToKnowledgeBase(contentVO, "新增");
        return ResultUtils.success(id);
    }

    /**
     * 更新内容
     */
    @PostMapping("/update")
    public BaseResponse<Boolean> update(@Valid @RequestBody ContentVO contentVO) {
        Content content = toEntity(contentVO);
        boolean result = contentService.updateContent(content);
        syncToKnowledgeBase(contentVO, "更新");
        return ResultUtils.success(result);
    }

    /**
     * 删除内容（先查询再删除，保留完整信息写入知识库）
     */
    @PostMapping("/remove")
    public BaseResponse<Boolean> remove(@RequestBody ContentVO contentVO) {
        Content existing = contentService.getById(contentVO.getId());
        boolean result = contentService.removeContent(contentVO.getId());
        if (existing != null) {
            syncToKnowledgeBase(toVO(existing), "删除");
        }
        return ResultUtils.success(result);
    }

    /**
     * Entity 转 VO
     */
    private ContentVO toVO(Content content) {
        if (content == null) return null;
        ContentVO vo = new ContentVO();
        BeanUtils.copyProperties(content, vo);
        vo.setCreatorId(content.getCreator());
        return vo;
    }

    /**
     * VO 转 Entity
     */
    private Content toEntity(ContentVO vo) {
        Content content = new Content();
        BeanUtils.copyProperties(vo, content);
        return content;
    }

    /**
     * 将内容同步写入 MD 文件并上传至知识库（knowledge-file bucket）
     */
    private void syncToKnowledgeBase(ContentVO contentVO, String operation) {
        try {
            List<KnowledgeBaseVO> bases = knowledgeBaseService.KnowledgeList();
            if (bases.isEmpty()) {
                log.warn("[知识库同步] 未找到任何知识库，跳过同步，title={}", contentVO.getTitle());
                return;
            }
            String knowledgeId = bases.get(0).getId();
            // 文件名：标题（去除特殊字符）+ 时间
            String safeTitle = contentVO.getTitle().replaceAll("[\\\\/:*?\"<>|\\s]", "_");
            LocalDateTime now = LocalDateTime.now();
            String timeStr = now.format(DateTimeFormatter.ofPattern("yyyyMMdd_HHmmss"));
            String fileName = safeTitle + "_" + timeStr + ".md";
            // 生成 Markdown 内容（时间由后端记录，不依赖前端传入的 createTime）
            byte[] mdBytes = buildMarkdown(contentVO, operation, now).getBytes(StandardCharsets.UTF_8);
            originFileResourceService.uploadMarkdown(mdBytes, fileName, knowledgeId);
            log.info("[知识库同步] 成功，operation={}, title={}, file={}", operation, contentVO.getTitle(), fileName);
        } catch (Exception e) {
            log.error("[知识库同步] 失败，operation={}, title={}, error={}", operation, contentVO.getTitle(), e.getMessage(), e);
        }
    }

    /**
     * 根据内容 VO 构建 Markdown 字符串
     */
    private String buildMarkdown(ContentVO contentVO, String operation, LocalDateTime now) {
        StringBuilder sb = new StringBuilder();
        sb.append("# ").append(contentVO.getTitle()).append("\n\n");
        sb.append("**分类**: ").append(contentVO.getCategory()).append("  \n");
        sb.append("**时间**: ").append(now.format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss"))).append("  \n");
        sb.append("\n");
        if (contentVO.getDescription() != null && !contentVO.getDescription().isBlank()) {
            sb.append("## 简介\n\n").append(contentVO.getDescription()).append("\n\n");
        }
        if (contentVO.getContent() != null && !contentVO.getContent().isBlank()) {
            sb.append("## 内容\n\n").append(contentVO.getContent()).append("\n");
        }
        return sb.toString();
    }
}
