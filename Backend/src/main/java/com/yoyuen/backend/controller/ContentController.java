package com.yoyuen.backend.controller;

import com.yoyuen.backend.controller.vo.ContentCategoryVO;
import com.yoyuen.backend.controller.vo.ContentTagVO;
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
import com.yoyuen.backend.utils.CoreCode;
import com.yoyuen.backend.utils.ResultUtils;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.BeanUtils;
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

    private static final String CATEGORY_META_KEY = "content:category:meta";
    private static final String TAG_ALL_KEY = "content:tag:all";
    private static final String CONTENT_TAG_PREFIX = "content:tags:";

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
                redisService.delete(CONTENT_TAG_PREFIX + c.getId());
            }
        }

        clearContentCache(newType);
        return ResultUtils.success(true);
    }

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
        List<String> tags = getAllTags();
        Map<String, Long> counts = countTagUsage();
        List<ContentTagVO> result = tags.stream()
                .map(tag -> new ContentTagVO(tag, counts.getOrDefault(tag, 0L)))
                .sorted(Comparator.comparing(ContentTagVO::getCount).reversed())
                .toList();
        return ResultUtils.success(result);
    }

    @PostMapping("/tag/create")
    public BaseResponse<Boolean> createTag(@RequestBody Map<String, String> payload) {
        String name = payload.get("name");
        if (name == null || name.isBlank()) {
            return ResultUtils.error(CoreCode.PARAMS_ERROR, "标签名不能为空");
        }
        List<String> tags = getAllTags();
        if (tags.contains(name)) {
            return ResultUtils.error(CoreCode.OPERATION_ERROR, "标签已存在");
        }
        tags.add(name);
        tags.sort(String::compareTo);
        redisService.set(TAG_ALL_KEY, tags);
        return ResultUtils.success(true);
    }

    @PostMapping("/tag/update")
    public BaseResponse<Boolean> updateTag(@RequestBody Map<String, String> payload) {
        String oldName = payload.get("oldName");
        String newName = payload.get("newName");
        if (oldName == null || oldName.isBlank() || newName == null || newName.isBlank()) {
            return ResultUtils.error(CoreCode.PARAMS_ERROR, "标签参数不完整");
        }

        List<String> tags = getAllTags();
        if (!tags.contains(oldName)) {
            return ResultUtils.error(CoreCode.NOT_FOUND_ERROR, "标签不存在");
        }
        if (!oldName.equals(newName) && tags.contains(newName)) {
            return ResultUtils.error(CoreCode.OPERATION_ERROR, "新的标签名已存在");
        }

        tags.remove(oldName);
        tags.add(newName);
        tags.sort(String::compareTo);
        redisService.set(TAG_ALL_KEY, tags);

        List<Content> contents = contentService.listAll(null, null);
        for (Content content : contents) {
            List<String> contentTags = getContentTags(content.getId());
            if (contentTags.contains(oldName)) {
                List<String> replaced = contentTags.stream()
                        .map(tag -> oldName.equals(tag) ? newName : tag)
                        .distinct()
                        .toList();
                redisService.set(CONTENT_TAG_PREFIX + content.getId(), replaced);
            }
        }

        return ResultUtils.success(true);
    }

    @PostMapping("/tag/remove")
    public BaseResponse<Boolean> removeTag(@RequestBody Map<String, String> payload) {
        String name = payload.get("name");
        if (name == null || name.isBlank()) {
            return ResultUtils.error(CoreCode.PARAMS_ERROR, "标签名不能为空");
        }

        Map<String, Long> usage = countTagUsage();
        if (usage.getOrDefault(name, 0L) > 0) {
            return ResultUtils.error(CoreCode.OPERATION_ERROR, "标签仍被文章使用，无法删除");
        }

        List<String> tags = getAllTags();
        tags.remove(name);
        redisService.set(TAG_ALL_KEY, tags);
        return ResultUtils.success(true);
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

    @PostMapping("/create")
    public BaseResponse<String> create(@Valid @RequestBody ContentVO contentVO) {
        Content content = toEntity(contentVO);
        String id = contentService.addContent(content);
        contentVO.setId(id);
        saveContentTags(id, contentVO.getTags());
        syncToKnowledgeBase(contentVO, "新增");

        clearContentCache(contentVO.getCategory());
        return ResultUtils.success(id);
    }

    @PostMapping("/update")
    public BaseResponse<Boolean> update(@Valid @RequestBody ContentVO contentVO) {
        Content content = toEntity(contentVO);
        boolean result = contentService.updateContent(content);
        saveContentTags(contentVO.getId(), contentVO.getTags());
        syncToKnowledgeBase(contentVO, "更新");

        redisService.delete("content:detail:" + contentVO.getId());
        clearContentCache(contentVO.getCategory());
        return ResultUtils.success(result);
    }

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
            redisService.delete("content:detail:" + contentVO.getId());
            redisService.delete(CONTENT_TAG_PREFIX + contentVO.getId());
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

        vo.setTags(getContentTags(content.getId()));

        String cover = content.getCover();
        if (cover != null && cover.contains("/") && !cover.startsWith("http")) {
            int slash = cover.indexOf('/');
            String bucket = cover.substring(0, slash);
            String objectName = cover.substring(slash + 1);
            vo.setCover(objectStoreService.getTmpFileUrl(bucket, objectName));
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

    private List<String> getAllTags() {
        Object cached = redisService.get(TAG_ALL_KEY);
        if (cached instanceof List<?> list) {
            return list.stream().map(String::valueOf).distinct().collect(Collectors.toCollection(ArrayList::new));
        }
        return new ArrayList<>();
    }

    private List<String> getContentTags(String contentId) {
        Object cached = redisService.get(CONTENT_TAG_PREFIX + contentId);
        if (cached instanceof List<?> list) {
            return list.stream().map(String::valueOf).distinct().toList();
        }
        return List.of();
    }

    private void saveContentTags(String contentId, List<String> tags) {
        if (contentId == null || contentId.isBlank()) {
            return;
        }
        List<String> cleaned = tags == null ? List.of() : tags.stream()
                .filter(Objects::nonNull)
                .map(String::trim)
                .filter(s -> !s.isEmpty())
                .distinct()
                .toList();

        redisService.set(CONTENT_TAG_PREFIX + contentId, cleaned);

        List<String> all = getAllTags();
        Set<String> merged = new LinkedHashSet<>(all);
        merged.addAll(cleaned);
        redisService.set(TAG_ALL_KEY, new ArrayList<>(merged));
    }

    private Map<String, Long> countTagUsage() {
        Map<String, Long> usage = new HashMap<>();
        List<Content> contents = contentService.listAll(null, null);
        for (Content content : contents) {
            for (String tag : getContentTags(content.getId())) {
                usage.put(tag, usage.getOrDefault(tag, 0L) + 1);
            }
        }
        return usage;
    }
}
