package com.yoyuen.backend.controller;

import com.yoyuen.backend.controller.vo.ContentCategoryVO;
import com.yoyuen.backend.controller.vo.ContentTagVO;
import com.yoyuen.backend.controller.vo.ContentVO;
import com.yoyuen.backend.controller.vo.KnowledgeBaseVO;
import com.yoyuen.backend.entity.Content;
import com.yoyuen.backend.entity.ContentTag;
import com.yoyuen.backend.service.ai.KnowledgeBaseService;
import com.yoyuen.backend.service.ai.OriginFileResourceService;
import com.yoyuen.backend.service.system.CommentService;
import com.yoyuen.backend.service.system.ContentService;
import com.yoyuen.backend.service.system.ContentTagService;
import com.yoyuen.backend.service.system.ObjectStoreService;
import com.yoyuen.backend.service.system.RedisService;
import com.yoyuen.backend.utils.BaseResponse;
import com.yoyuen.backend.utils.CoreCode;
import com.yoyuen.backend.utils.ResultUtils;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.BeanUtils;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.*;
import java.util.concurrent.TimeUnit;
import java.util.stream.Collectors;

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
    private final ContentTagService contentTagService;

    private static final String CATEGORY_META_KEY = "content:category:meta";
    private static final String COVER_BUCKET = "default";

    private static final Map<String, String> DEFAULT_CATEGORY_NAME_MAP = new LinkedHashMap<>() {{
        put("article", "文章");
        put("game", "游戏");
        put("study", "学习");
        put("video", "视频");
    }};

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

    @GetMapping("/categories")
    public BaseResponse<List<ContentCategoryVO>> listCategories() {
        List<ContentCategoryVO> categories = buildCategoryList();
        return ResultUtils.success(categories);
    }

    @PreAuthorize("hasRole('ADMIN')")
    @PostMapping("/category/create")
    public BaseResponse<Boolean> createCategory(@RequestBody ContentCategoryVO categoryVO) {
        if (categoryVO == null || categoryVO.getType() == null || categoryVO.getType().isBlank() ||
                categoryVO.getName() == null || categoryVO.getName().isBlank()) {
            return ResultUtils.error(CoreCode.PARAMS_ERROR, "分类标识和名称不能为空");
        }
        Map<String, String> meta = getCategoryMeta();
        if (meta.containsKey(categoryVO.getType())) {
            return ResultUtils.error(CoreCode.OPERATION_ERROR, "分类标识已存在");
        }
        meta.put(categoryVO.getType(), categoryVO.getName());
        redisService.set(CATEGORY_META_KEY, meta);
        return ResultUtils.success(true);
    }

    @PreAuthorize("hasRole('ADMIN')")
    @PostMapping("/category/update")
    public BaseResponse<Boolean> updateCategory(@RequestBody Map<String, String> payload) {
        String oldType = payload.get("oldType");
        String newType = payload.get("newType");
        String name = payload.get("name");

        if (oldType == null || oldType.isBlank() || newType == null || newType.isBlank() || name == null || name.isBlank()) {
            return ResultUtils.error(CoreCode.PARAMS_ERROR, "分类参数不完整");
        }

        Map<String, String> meta = getCategoryMeta();
        if (!oldType.equals(newType) && meta.containsKey(newType)) {
            return ResultUtils.error(CoreCode.OPERATION_ERROR, "新的分类标识已存在");
        }

        meta.remove(oldType);
        meta.put(newType, name);
        redisService.set(CATEGORY_META_KEY, meta);

        if (!oldType.equals(newType)) {
            List<Content> contentList = contentService.listAll(null, null).stream()
                    .filter(c -> oldType.equals(c.getCategory()))
                    .toList();
            for (Content c : contentList) {
                c.setCategory(newType);
                contentService.updateContent(c);
                // 清除内容详情缓存
                redisService.delete("content:detail:" + c.getId());
            }
        }

        clearContentCache(newType);
        return ResultUtils.success(true);
    }

    @PreAuthorize("hasRole('ADMIN')")
    @PostMapping("/category/remove")
    public BaseResponse<Boolean> removeCategory(@RequestBody Map<String, String> payload) {
        String type = payload.get("type");
        if (type == null || type.isBlank()) {
            return ResultUtils.error(CoreCode.PARAMS_ERROR, "分类标识不能为空");
        }
        long count = contentService.countByCategory(type);
        if (count > 0) {
            return ResultUtils.error(CoreCode.OPERATION_ERROR, "该分类下仍有文章，无法删除");
        }

        Map<String, String> meta = getCategoryMeta();
        meta.remove(type);
        redisService.set(CATEGORY_META_KEY, meta);
        return ResultUtils.success(true);
    }

    @GetMapping("/tags")
    public BaseResponse<List<ContentTagVO>> listTags() {
        List<ContentTag> tags = contentTagService.listAll();
        List<ContentTagVO> result = tags.stream()
                .map(tag -> new ContentTagVO(tag.getName(), tag.getUsageCount()))
                .toList();
        return ResultUtils.success(result);
    }

    @PreAuthorize("hasRole('ADMIN')")
    @PostMapping("/tag/create")
    public BaseResponse<Boolean> createTag(@RequestBody Map<String, String> payload) {
        String name = payload.get("name");
        if (name == null || name.isBlank()) {
            return ResultUtils.error(CoreCode.PARAMS_ERROR, "标签名不能为空");
        }
        try {
            contentTagService.create(name);
            return ResultUtils.success(true);
        } catch (IllegalArgumentException e) {
            return ResultUtils.error(CoreCode.OPERATION_ERROR, e.getMessage());
        }
    }

    @PreAuthorize("hasRole('ADMIN')")
    @PostMapping("/tag/update")
    public BaseResponse<Boolean> updateTag(@RequestBody Map<String, String> payload) {
        String oldName = payload.get("oldName");
        String newName = payload.get("newName");
        if (oldName == null || oldName.isBlank() || newName == null || newName.isBlank()) {
            return ResultUtils.error(CoreCode.PARAMS_ERROR, "标签参数不完整");
        }

        try {
            ContentTag tag = contentTagService.getByName(oldName);
            if (tag == null) {
                return ResultUtils.error(CoreCode.NOT_FOUND_ERROR, "标签不存在");
            }
            contentTagService.update(tag.getId(), newName);
            return ResultUtils.success(true);
        } catch (IllegalArgumentException e) {
            return ResultUtils.error(CoreCode.OPERATION_ERROR, e.getMessage());
        }
    }

    @PreAuthorize("hasRole('ADMIN')")
    @PostMapping("/tag/remove")
    public BaseResponse<Boolean> removeTag(@RequestBody Map<String, String> payload) {
        String name = payload.get("name");
        if (name == null || name.isBlank()) {
            return ResultUtils.error(CoreCode.PARAMS_ERROR, "标签名不能为空");
        }

        try {
            ContentTag tag = contentTagService.getByName(name);
            if (tag == null) {
                return ResultUtils.error(CoreCode.NOT_FOUND_ERROR, "标签不存在");
            }
            contentTagService.remove(tag.getId());
            return ResultUtils.success(true);
        } catch (IllegalArgumentException e) {
            return ResultUtils.error(CoreCode.OPERATION_ERROR, e.getMessage());
        }
    }

    @GetMapping("/{id}")
    public BaseResponse<ContentVO> getById(@PathVariable String id) {
        String cacheKey = "content:detail:" + id;
        Object cached = redisService.get(cacheKey);
        if (cached != null) {
            return ResultUtils.success((ContentVO) cached);
        }

        Content content = contentService.getById(id);
        if (content == null) {
            return ResultUtils.error(CoreCode.NOT_FOUND_ERROR, "内容不存在");
        }
        contentService.incrementViewCount(id);
        ContentVO vo = toVO(content);

        redisService.set(cacheKey, vo, 10, TimeUnit.MINUTES);
        return ResultUtils.success(vo);
    }

    @GetMapping("/list/{category}")
    public BaseResponse<List<ContentVO>> listByCategory(@PathVariable String category) {
        String cacheKey = "content:list:" + category;
        Object cached = redisService.get(cacheKey);
        if (cached != null) {
            return ResultUtils.success((List<ContentVO>) cached);
        }

        List<Content> contents = contentService.listByCategory(category);
        List<ContentVO> voList = contents.stream().map(this::toVO).toList();

        redisService.set(cacheKey, voList, 5, TimeUnit.MINUTES);
        return ResultUtils.success(voList);
    }

    @GetMapping("/recommend")
    public BaseResponse<List<ContentVO>> listRecommend() {
        String cacheKey = "content:recommend";
        Object cached = redisService.get(cacheKey);
        if (cached != null) {
            return ResultUtils.success((List<ContentVO>) cached);
        }

        List<Content> contents = contentService.listRecommend();
        List<ContentVO> voList = contents.stream().map(this::toVO).toList();

        redisService.set(cacheKey, voList, 10, TimeUnit.MINUTES);
        return ResultUtils.success(voList);
    }

    @GetMapping("/all")
    public BaseResponse<List<ContentVO>> listAll(
            @RequestParam(required = false) String keyword,
            @RequestParam(required = false) String status) {
        List<Content> contents = contentService.listAll(keyword, status);
        List<ContentVO> voList = contents.stream().map(this::toVO).toList();
        return ResultUtils.success(voList);
    }

    @PreAuthorize("hasRole('ADMIN')")
    @PostMapping("/recommend")
    public BaseResponse<Boolean> toggleRecommend(@RequestBody ContentVO contentVO) {
        boolean result = contentService.toggleRecommend(contentVO.getId(), contentVO.getIsRecommend());
        redisService.delete("content:detail:" + contentVO.getId());
        clearContentCache(null);
        return ResultUtils.success(result);
    }

    @GetMapping("/activity")
    public BaseResponse<Map<String, Integer>> getActivityStats(@RequestParam(defaultValue = "100") int days) {
        String cacheKey = "content:activity:" + days;
        Object cached = redisService.get(cacheKey);
        if (cached != null) {
            return ResultUtils.success((Map<String, Integer>) cached);
        }

        Map<String, Integer> stats = contentService.getActivityStats(days);
        redisService.set(cacheKey, stats, 1, TimeUnit.HOURS);
        return ResultUtils.success(stats);
    }

    @PreAuthorize("hasRole('ADMIN')")
    @PostMapping(value = "/upload-cover", consumes = "multipart/form-data")
    public BaseResponse<Map<String, String>> uploadCover(@RequestParam("file") MultipartFile file) throws IOException {
        if (file == null || file.isEmpty()) {
            return ResultUtils.error(CoreCode.PARAMS_ERROR, "封面文件不能为空");
        }
        String ext = ".jpg";
        String original = file.getOriginalFilename();
        if (original != null && original.contains(".")) {
            ext = original.substring(original.lastIndexOf('.'));
        }
        String objectName = "content/cover_" + UUID.randomUUID() + ext;
        objectStoreService.uploadFile(file, COVER_BUCKET, objectName);
        String coverPath = COVER_BUCKET + "/" + objectName;
        String previewUrl = objectStoreService.getTmpFileUrl(COVER_BUCKET, objectName, 7 * 24 * 3600);

        Map<String, String> result = new HashMap<>();
        result.put("cover", coverPath);
        result.put("url", previewUrl);
        return ResultUtils.success(result);
    }

    @PreAuthorize("hasRole('ADMIN')")
    @PostMapping(value = "/upload-content-image", consumes = "multipart/form-data")
    public BaseResponse<Map<String, String>> uploadContentImage(@RequestParam("file") MultipartFile file) throws IOException {
        if (file == null || file.isEmpty()) {
            return ResultUtils.error(CoreCode.PARAMS_ERROR, "图片文件不能为空");
        }

        // 验证文件类型
        String contentType = file.getContentType();
        if (contentType == null || !contentType.startsWith("image/")) {
            return ResultUtils.error(CoreCode.PARAMS_ERROR, "只能上传图片文件");
        }

        // 验证文件大小（最大10MB）
        long maxSize = 10 * 1024 * 1024L;
        if (file.getSize() > maxSize) {
            return ResultUtils.error(CoreCode.PARAMS_ERROR, "图片大小不能超过10MB");
        }

        // 获取文件扩展名
        String ext = ".jpg";
        String original = file.getOriginalFilename();
        if (original != null && original.contains(".")) {
            ext = original.substring(original.lastIndexOf('.'));
        }

        // 上传图片文件，使用 content/image_ 前缀区分内容图片
        String objectName = "content/image_" + UUID.randomUUID() + ext;
        objectStoreService.uploadFile(file, COVER_BUCKET, objectName);
        String imagePath = COVER_BUCKET + "/" + objectName;
        String imageUrl = objectStoreService.getTmpFileUrl(COVER_BUCKET, objectName, 7 * 24 * 3600);

        Map<String, String> result = new HashMap<>();
        result.put("path", imagePath);
        result.put("url", imageUrl);

        log.info("文章内容图片上传成功: {}, 大小: {} bytes", objectName, file.getSize());
        return ResultUtils.success(result);
    }

    @PreAuthorize("hasRole('ADMIN')")
    @PostMapping(value = "/upload-video", consumes = "multipart/form-data")
    public BaseResponse<Map<String, Object>> uploadVideo(@RequestParam("file") MultipartFile file) throws IOException {
        if (file == null || file.isEmpty()) {
            return ResultUtils.error(CoreCode.PARAMS_ERROR, "视频文件不能为空");
        }

        // 验证文件类型
        String contentType = file.getContentType();
        if (contentType == null || !contentType.startsWith("video/")) {
            return ResultUtils.error(CoreCode.PARAMS_ERROR, "只能上传视频文件");
        }

        // 验证文件大小（最大500MB）
        long maxSize = 500 * 1024 * 1024L;
        if (file.getSize() > maxSize) {
            return ResultUtils.error(CoreCode.PARAMS_ERROR, "视频文件大小不能超过500MB");
        }

        // 获取文件扩展名
        String ext = ".mp4";
        String original = file.getOriginalFilename();
        if (original != null && original.contains(".")) {
            ext = original.substring(original.lastIndexOf('.'));
        }

        // 上传视频文件
        String objectName = "content/video_" + UUID.randomUUID() + ext;
        objectStoreService.uploadFile(file, COVER_BUCKET, objectName);
        String videoPath = COVER_BUCKET + "/" + objectName;
        String videoUrl = objectStoreService.getTmpFileUrl(COVER_BUCKET, objectName, 7 * 24 * 3600);

        // 生成视频封面（可选，这里简单返回一个默认封面）
        String coverObjectName = "content/video_cover_" + UUID.randomUUID() + ".jpg";
        String coverPath = COVER_BUCKET + "/" + coverObjectName;
        String coverUrl = objectStoreService.getTmpFileUrl(COVER_BUCKET, coverObjectName, 7 * 24 * 3600);

        Map<String, Object> result = new HashMap<>();
        result.put("url", videoUrl);
        result.put("path", videoPath);
        result.put("cover", coverUrl);
        result.put("coverPath", coverPath);
        result.put("duration", 0); // 视频时长需要通过FFmpeg等工具提取，这里暂时返回0

        log.info("视频上传成功: {}, 大小: {} bytes", objectName, file.getSize());
        return ResultUtils.success(result);
    }

    @PreAuthorize("hasRole('ADMIN')")
    @PostMapping("/extract-video-cover")
    public BaseResponse<Map<String, String>> extractVideoCover(@RequestBody Map<String, String> payload) {
        String videoUrl = payload.get("videoUrl");
        if (videoUrl == null || videoUrl.isBlank()) {
            return ResultUtils.error(CoreCode.PARAMS_ERROR, "视频URL不能为空");
        }

        // 这里可以实现视频封面提取逻辑
        // 暂时返回一个默认封面
        Map<String, String> result = new HashMap<>();
        result.put("cover", "");
        return ResultUtils.success(result);
    }

    @PreAuthorize("hasRole('ADMIN')")
    @PostMapping("/create")
    public BaseResponse<String> create(@Valid @RequestBody ContentVO contentVO) {
        Content content = toEntity(contentVO);
        String id = contentService.addContent(content);
        contentVO.setId(id);
        // 使用数据库存储标签
        contentTagService.setContentTags(id, contentVO.getTags());
        syncToKnowledgeBase(contentVO, "新增");

        clearContentCache(contentVO.getCategory());
        return ResultUtils.success(id);
    }

    @PreAuthorize("hasRole('ADMIN')")
    @PostMapping("/update")
    public BaseResponse<Boolean> update(@Valid @RequestBody ContentVO contentVO) {
        Content content = toEntity(contentVO);
        boolean result = contentService.updateContent(content);
        // 使用数据库存储标签
        contentTagService.setContentTags(contentVO.getId(), contentVO.getTags());
        syncToKnowledgeBase(contentVO, "更新");

        redisService.delete("content:detail:" + contentVO.getId());
        clearContentCache(contentVO.getCategory());
        return ResultUtils.success(result);
    }

    @PreAuthorize("hasRole('ADMIN')")
    @PostMapping("/remove")
    public BaseResponse<Boolean> remove(@RequestBody ContentVO contentVO) {
        if (contentVO == null || contentVO.getId() == null || contentVO.getId().isBlank()) {
            return ResultUtils.error(CoreCode.PARAMS_ERROR, "内容ID不能为空");
        }

        int commentCount = commentService.countByContentId(contentVO.getId());
        if (commentCount > 0) {
            return ResultUtils.error(CoreCode.OPERATION_ERROR, "该文章下仍有评论（" + commentCount + " 条），请先删除评论后再删除文章");
        }

        Content existing = contentService.getById(contentVO.getId());
        boolean result = contentService.removeContent(contentVO.getId());
        if (existing != null) {
            syncToKnowledgeBase(toVO(existing), "删除");
            // 删除标签关联
            contentTagService.removeContentTags(contentVO.getId());
            redisService.delete("content:detail:" + contentVO.getId());
            clearContentCache(existing.getCategory());
        }
        return ResultUtils.success(result);
    }

    private ContentVO toVO(Content content) {
        if (content == null) {
            return null;
        }
        ContentVO vo = new ContentVO();
        BeanUtils.copyProperties(content, vo);
        vo.setCreatorId(content.getCreator());

        Map<String, String> categoryMeta = getCategoryMeta();
        vo.setCategoryName(categoryMeta.getOrDefault(content.getCategory(), content.getCategory()));

        // 从数据库获取标签
        List<ContentTag> tags = contentTagService.listByContentId(content.getId());
        vo.setTags(tags.stream().map(ContentTag::getName).toList());

        String cover = content.getCover();
        if (cover != null && cover.contains("/") && !cover.startsWith("http")) {
            int slash = cover.indexOf('/');
            String bucket = cover.substring(0, slash);
            String objectName = cover.substring(slash + 1);
            vo.setCover(objectStoreService.getTmpFileUrl(bucket, objectName));
        }

        // 处理视频URL - 使用公开URL以支持更好的缓存和Range请求
        String videoUrl = content.getVideoUrl();
        if (videoUrl != null && videoUrl.contains("/") && !videoUrl.startsWith("http")) {
            int slash = videoUrl.indexOf('/');
            String bucket = videoUrl.substring(0, slash);
            String objectName = videoUrl.substring(slash + 1);
            // 对于视频文件，使用公开URL而不是临时签名URL，以支持浏览器缓存和断点续传
            if (objectStoreService instanceof com.yoyuen.backend.objectstore.service.MinIOService minioService) {
                vo.setVideoUrl(minioService.getPublicUrl(bucket, objectName));
            } else {
                vo.setVideoUrl(objectStoreService.getTmpFileUrl(bucket, objectName));
            }
        }

        return vo;
    }

    private Content toEntity(ContentVO vo) {
        Content content = new Content();
        BeanUtils.copyProperties(vo, content);
        return content;
    }

    private void syncToKnowledgeBase(ContentVO contentVO, String operation) {
        try {
            List<KnowledgeBaseVO> bases = knowledgeBaseService.KnowledgeList();
            if (bases.isEmpty()) {
                log.warn("[知识库同步] no knowledge base, skip, title={}", contentVO.getTitle());
                return;
            }
            // 查找网站内容知识库（通过名称或描述识别，优先使用第一个）
            String knowledgeId = bases.stream()
                    .filter(base -> "YoyuEN".equals(base.getName()) || "Profile".equals(base.getDescription()))
                    .findFirst()
                    .orElse(bases.get(0))
                    .getId();
            String safeTitle = contentVO.getTitle().replaceAll("[\\\\/:*?\"<>|\\s]", "_");
            LocalDateTime now = LocalDateTime.now();
            String timeStr = now.format(DateTimeFormatter.ofPattern("yyyyMMdd_HHmmss"));
            String fileName = safeTitle + "_" + timeStr + ".md";
            byte[] mdBytes = buildMarkdown(contentVO, operation, now).getBytes(StandardCharsets.UTF_8);
            originFileResourceService.uploadMarkdownWithMetadata(
                    mdBytes,
                    fileName,
                    knowledgeId,
                    "article",
                    contentVO.getId(),
                    null
            );
            log.info("[知识库同步] success operation={}, title={}, file={}", operation, contentVO.getTitle(), fileName);
        } catch (Exception e) {
            log.error("[知识库同步] failed operation={}, title={}, error={}", operation, contentVO.getTitle(), e.getMessage(), e);
        }
    }

    private String buildMarkdown(ContentVO contentVO, String operation, LocalDateTime now) {
        StringBuilder sb = new StringBuilder();
        sb.append("# ").append(contentVO.getTitle()).append("\n\n");
        sb.append("**操作**: ").append(operation).append("  \n");
        sb.append("**分类**: ").append(contentVO.getCategory()).append("  \n");
        sb.append("**时间**: ").append(now.format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss"))).append("  \n");
        if (contentVO.getTags() != null && !contentVO.getTags().isEmpty()) {
            sb.append("**标签**: ").append(String.join(", ", contentVO.getTags())).append("  \n");
        }
        sb.append("\n");
        if (contentVO.getDescription() != null && !contentVO.getDescription().isBlank()) {
            sb.append("## 简介\n\n").append(contentVO.getDescription()).append("\n\n");
        }
        if (contentVO.getContent() != null && !contentVO.getContent().isBlank()) {
            sb.append("## 内容\n\n").append(contentVO.getContent()).append("\n");
        }
        return sb.toString();
    }

    private void clearContentCache(String category) {
        if (category != null) {
            redisService.delete("content:list:" + category);
        }
        redisService.delete("content:recommend");
        redisService.delete("content:categories");
        redisService.delete("content:stats");
        redisService.delete("content:activity:100");
        redisService.delete("content:activity:365");
    }

    private Map<String, String> getCategoryMeta() {
        Map<String, String> result = new LinkedHashMap<>(DEFAULT_CATEGORY_NAME_MAP);
        Object cached = redisService.get(CATEGORY_META_KEY);
        if (cached instanceof Map<?, ?> map) {
            for (Map.Entry<?, ?> entry : map.entrySet()) {
                if (entry.getKey() != null && entry.getValue() != null) {
                    result.put(String.valueOf(entry.getKey()), String.valueOf(entry.getValue()));
                }
            }
        }
        return result;
    }

    private List<ContentCategoryVO> buildCategoryList() {
        Map<String, String> meta = getCategoryMeta();
        List<String> categoriesInContent = contentService.listCategories();
        Set<String> all = new LinkedHashSet<>();
        all.addAll(meta.keySet());
        all.addAll(categoriesInContent);

        return all.stream()
                .map(type -> new ContentCategoryVO(type, meta.getOrDefault(type, type), contentService.countByCategory(type)))
                .toList();
    }
}
