package com.yoyuen.backend.controller;

import com.yoyuen.backend.controller.vo.ContentCategoryVO;
import com.yoyuen.backend.controller.vo.ContentVO;
import com.yoyuen.backend.controller.vo.KnowledgeBaseVO;
import com.yoyuen.backend.entity.Content;
import com.yoyuen.backend.service.ai.KnowledgeBaseService;
import com.yoyuen.backend.service.ai.OriginFileResourceService;
import com.yoyuen.backend.service.system.CommentService;
import com.yoyuen.backend.service.system.ContentService;
import com.yoyuen.backend.service.system.ObjectStoreService;
import com.yoyuen.backend.service.system.RedisService;
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
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.concurrent.TimeUnit;

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
    private final CommentService commentService;
    private final KnowledgeBaseService knowledgeBaseService;
    private final OriginFileResourceService originFileResourceService;
    private final ObjectStoreService objectStoreService;
    private final RedisService redisService;

    private static final String DEFAULT_BUCKET = "default";
    private static final String DEFAULT_COVER = "default.jpg";

    // 分类 type → 展示名称，维护在后端
    private static final Map<String, String> CATEGORY_NAME_MAP = new LinkedHashMap<>() {{
        put("article", "文章");
        put("game", "游戏");
        put("study", "学习");
        put("video", "视频");
    }};

    /**
     * 获取内容统计数据（文章数、评论数）
     */
    @GetMapping("/stats")
    public BaseResponse<Map<String, Long>> stats() {
        String cacheKey = "content:stats";
        Object cached = redisService.get(cacheKey);
        if (cached != null) {
            return ResultUtils.success((Map<String, Long>) cached);
        }
        Map<String, Long> stats = Map.of(
                "contentCount", contentService.countAll(),
                "commentCount", commentService.countAll()
        );
        redisService.set(cacheKey, stats, 5, TimeUnit.MINUTES);
        return ResultUtils.success(stats);
    }

    /**
     * 获取所有有内容的分类
     */
    @GetMapping("/categories")
    public BaseResponse<List<ContentCategoryVO>> listCategories() {
        String cacheKey = "content:categories";
        Object cached = redisService.get(cacheKey);
        if (cached != null) {
            return ResultUtils.success((List<ContentCategoryVO>) cached);
        }
        List<String> types = contentService.listCategories();
        List<ContentCategoryVO> categories = types.stream()
                .map(type -> {
                    long count = contentService.countByCategory(type);
                    return new ContentCategoryVO(type, CATEGORY_NAME_MAP.getOrDefault(type, type), count);
                })
                .toList();
        redisService.set(cacheKey, categories, 5, TimeUnit.MINUTES);
        return ResultUtils.success(categories);
    }

    /**
     * 根据ID获取内容详情
     */
    @GetMapping("/{id}")
    public BaseResponse<ContentVO> getById(@PathVariable String id) {
        // 尝试从缓存获取
        String cacheKey = "content:detail:" + id;
        Object cached = redisService.get(cacheKey);
        if (cached != null) {
            log.debug("从缓存获取内容详情: {}", id);
            return ResultUtils.success((ContentVO) cached);
        }

        // 缓存未命中，查询数据库
        Content content = contentService.getById(id);
        contentService.incrementViewCount(id);
        ContentVO vo = toVO(content);

        // 写入缓存，10分钟过期
        redisService.set(cacheKey, vo, 10, TimeUnit.MINUTES);
        return ResultUtils.success(vo);
    }

    /**
     * 根据分类获取内容列表
     */
    @GetMapping("/list/{category}")
    public BaseResponse<List<ContentVO>> listByCategory(@PathVariable String category) {
        // 尝试从缓存获取
        String cacheKey = "content:list:" + category;
        Object cached = redisService.get(cacheKey);
        if (cached != null) {
            log.debug("从缓存获取分类列表: {}", category);
            return ResultUtils.success((List<ContentVO>) cached);
        }

        // 缓存未命中，查询数据库
        List<Content> contents = contentService.listByCategory(category);
        List<ContentVO> voList = contents.stream().map(this::toVO).toList();

        // 写入缓存，5分钟过期
        redisService.set(cacheKey, voList, 5, TimeUnit.MINUTES);
        return ResultUtils.success(voList);
    }

    /**
     * 获取推荐内容列表
     */
    @GetMapping("/recommend")
    public BaseResponse<List<ContentVO>> listRecommend() {
        // 尝试从缓存获取
        String cacheKey = "content:recommend";
        Object cached = redisService.get(cacheKey);
        if (cached != null) {
            log.debug("从缓存获取推荐列表");
            return ResultUtils.success((List<ContentVO>) cached);
        }

        // 缓存未命中，查询数据库
        List<Content> contents = contentService.listRecommend();
        List<ContentVO> voList = contents.stream().map(this::toVO).toList();

        // 写入缓存，10分钟过期
        redisService.set(cacheKey, voList, 10, TimeUnit.MINUTES);
        return ResultUtils.success(voList);
    }

    /**
     * 获取最近 N 天每日发布数量（热力图数据）
     */
    @GetMapping("/activity")
    public BaseResponse<Map<String, Integer>> getActivityStats(
            @RequestParam(defaultValue = "100") int days) {
        // 尝试从缓存获取
        String cacheKey = "content:activity:" + days;
        Object cached = redisService.get(cacheKey);
        if (cached != null) {
            log.debug("从缓存获取热力图数据: {} 天", days);
            return ResultUtils.success((Map<String, Integer>) cached);
        }

        // 缓存未命中，查询数据库
        Map<String, Integer> stats = contentService.getActivityStats(days);

        // 写入缓存，1小时过期
        redisService.set(cacheKey, stats, 1, TimeUnit.HOURS);
        return ResultUtils.success(stats);
    }

    /**
     * 添加内容
     */
    @PostMapping("/create")
    public BaseResponse<String> create(@Valid @RequestBody ContentVO contentVO) {
        // 不再在这里设置默认封面，让 Service 层处理（自动生成或使用默认）
        Content content = toEntity(contentVO);
        String id = contentService.addContent(content);
        contentVO.setId(id);
        syncToKnowledgeBase(contentVO, "新增");

        // 清除相关缓存
        clearContentCache(contentVO.getCategory());
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

        // 清除相关缓存
        redisService.delete("content:detail:" + contentVO.getId());
        clearContentCache(contentVO.getCategory());
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
            // 清除相关缓存
            redisService.delete("content:detail:" + contentVO.getId());
            clearContentCache(existing.getCategory());
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
        // 若封面存的是 "bucket/objectName" 路径，则实时生成预签名 URL
        String cover = content.getCover();
        if (cover != null && cover.contains("/") && !cover.startsWith("http")) {
            int slash = cover.indexOf("/");
            String bucket = cover.substring(0, slash);
            String objectName = cover.substring(slash + 1);
            vo.setCover(objectStoreService.getTmpFileUrl(bucket, objectName));
        }
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
            originFileResourceService.uploadMarkdownWithMetadata(
                mdBytes,
                fileName,
                knowledgeId,
                "article",           // contentType
                contentVO.getId(),   // contentId
                null                 // articleId (文章本身不需要)
            );
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

    /**
     * 清除内容相关缓存
     */
    private void clearContentCache(String category) {
        // 清除分类列表缓存
        if (category != null) {
            redisService.delete("content:list:" + category);
        }
        // 清除推荐列表缓存
        redisService.delete("content:recommend");
        // 清除分类列表缓存
        redisService.delete("content:categories");
        // 清除统计缓存
        redisService.delete("content:stats");
        // 清除热力图缓存（可能有多个天数的缓存，这里只清除常用的）
        redisService.delete("content:activity:100");
        redisService.delete("content:activity:365");
    }
}
