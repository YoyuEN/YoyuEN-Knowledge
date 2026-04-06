package com.yoyuen.backend.controller;

import com.yoyuen.backend.entity.Content;
import com.yoyuen.backend.entity.ContentTag;
import com.yoyuen.backend.service.system.ContentService;
import com.yoyuen.backend.service.system.ContentTagService;
import com.yoyuen.backend.service.system.RedisService;
import com.yoyuen.backend.utils.BaseResponse;
import com.yoyuen.backend.utils.CoreCode;
import com.yoyuen.backend.utils.ResultUtils;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.*;
import java.util.stream.Collectors;

/**
 * @Author: YoyuEN
 * @Date: 2026/4/6
 * @Description: 数据迁移控制器
 */
@Slf4j
@RestController
@RequestMapping("/admin/migration")
@RequiredArgsConstructor
public class MigrationController {

    private final RedisService redisService;
    private final ContentService contentService;
    private final ContentTagService contentTagService;

    private static final String TAG_ALL_KEY = "content:tag:all";
    private static final String CONTENT_TAG_PREFIX = "content:tags:";

    /**
     * 将标签数据从 Redis 迁移到数据库
     */
    @PostMapping("/tags")
    public BaseResponse<Map<String, Object>> migrateTags() {
        try {
            log.info("开始迁移标签数据从 Redis 到数据库");

            // 1. 从 Redis 获取所有标签
            Object cached = redisService.get(TAG_ALL_KEY);
            List<String> tagNames = new ArrayList<>();
            if (cached instanceof List<?> list) {
                tagNames = list.stream()
                        .map(String::valueOf)
                        .filter(s -> s != null && !s.isBlank())
                        .distinct()
                        .collect(Collectors.toList());
            }

            log.info("从 Redis 读取到 {} 个标签", tagNames.size());

            // 2. 创建标签记录（如果不存在）
            Map<String, Long> tagNameToId = new HashMap<>();
            int createdCount = 0;
            int existingCount = 0;

            for (String name : tagNames) {
                try {
                    ContentTag existing = contentTagService.getByName(name);
                    if (existing != null) {
                        tagNameToId.put(name, existing.getId());
                        existingCount++;
                    } else {
                        ContentTag tag = contentTagService.create(name);
                        tagNameToId.put(name, tag.getId());
                        createdCount++;
                    }
                } catch (Exception e) {
                    log.warn("创建标签失败: {}, 错误: {}", name, e.getMessage());
                }
            }

            log.info("标签创建完成，新建: {}, 已存在: {}", createdCount, existingCount);

            // 3. 迁移文章标签关联
            List<Content> allContent = contentService.listAll(null, null);
            int relationCount = 0;
            int contentWithTagsCount = 0;

            for (Content content : allContent) {
                try {
                    Object tagsCached = redisService.get(CONTENT_TAG_PREFIX + content.getId());
                    if (tagsCached instanceof List<?> list) {
                        List<String> contentTags = list.stream()
                                .map(String::valueOf)
                                .filter(s -> s != null && !s.isBlank())
                                .distinct()
                                .collect(Collectors.toList());

                        if (!contentTags.isEmpty()) {
                            contentTagService.setContentTags(content.getId(), contentTags);
                            relationCount += contentTags.size();
                            contentWithTagsCount++;
                        }
                    }
                } catch (Exception e) {
                    log.warn("迁移文章标签失败: contentId={}, 错误: {}", content.getId(), e.getMessage());
                }
            }

            log.info("文章标签关联迁移完成，共 {} 篇文章，{} 个关联关系", contentWithTagsCount, relationCount);

            // 4. 更新使用次数
            contentTagService.batchUpdateUsageCount();
            log.info("标签使用次数更新完成");

            // 5. 返回迁移结果
            Map<String, Object> result = new HashMap<>();
            result.put("totalTags", tagNames.size());
            result.put("createdTags", createdCount);
            result.put("existingTags", existingCount);
            result.put("totalContent", allContent.size());
            result.put("contentWithTags", contentWithTagsCount);
            result.put("totalRelations", relationCount);
            result.put("message", "标签迁移完成");

            log.info("标签迁移成功: {}", result);
            return ResultUtils.success(result);

        } catch (Exception e) {
            log.error("标签迁移失败", e);
            return ResultUtils.error(CoreCode.SYSTEM_ERROR, "迁移失败: " + e.getMessage());
        }
    }

    /**
     * 清理 Redis 中的旧标签数据（迁移完成后调用）
     */
    @PostMapping("/tags/cleanup")
    public BaseResponse<String> cleanupRedisTags() {
        try {
            log.info("开始清理 Redis 中的旧标签数据");

            // 删除全局标签列表
            redisService.delete(TAG_ALL_KEY);

            // 删除所有文章的标签缓存
            List<Content> allContent = contentService.listAll(null, null);
            int deletedCount = 0;
            for (Content content : allContent) {
                String key = CONTENT_TAG_PREFIX + content.getId();
                redisService.delete(key);
                deletedCount++;
            }

            String message = String.format("Redis 标签数据清理完成，删除了 %d 个缓存键", deletedCount + 1);
            log.info(message);
            return ResultUtils.success(message);

        } catch (Exception e) {
            log.error("清理 Redis 标签数据失败", e);
            return ResultUtils.error(CoreCode.SYSTEM_ERROR, "清理失败: " + e.getMessage());
        }
    }
}
