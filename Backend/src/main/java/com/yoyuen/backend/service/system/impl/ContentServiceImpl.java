package com.yoyuen.backend.service.system.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.core.conditions.update.LambdaUpdateWrapper;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.yoyuen.backend.entity.Content;
import com.yoyuen.backend.mapper.ContentMapper;
import com.yoyuen.backend.service.ai.ImageGenerationService;
import com.yoyuen.backend.service.ai.LLMService;
import com.yoyuen.backend.service.system.CommentService;
import org.springframework.scheduling.annotation.Async;
import com.yoyuen.backend.service.system.ContentService;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@Slf4j
@Service
public class ContentServiceImpl extends ServiceImpl<ContentMapper, Content> implements ContentService {

    private final ImageGenerationService imageGenerationService;
    private final LLMService llmService;
    private final CommentService commentService;

    public ContentServiceImpl(
            ImageGenerationService imageGenerationService,
            LLMService llmService,
            CommentService commentService
    ) {
        this.imageGenerationService = imageGenerationService;
        this.llmService = llmService;
        this.commentService = commentService;
    }

    @Override
    public long countAll() {
        LambdaQueryWrapper<Content> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(Content::getDeleted, false);
        return this.count(wrapper);
    }

    @Override
    public long countToday() {
        LocalDateTime startOfDay = LocalDateTime.now().toLocalDate().atStartOfDay();
        LambdaQueryWrapper<Content> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(Content::getDeleted, false)
                .ge(Content::getCreateTime, startOfDay);
        return this.count(wrapper);
    }

    @Override
    public long countRecentDays(int days) {
        if (days <= 0) {
            return 0;
        }
        LocalDateTime since = LocalDateTime.now().minusDays(days - 1L).toLocalDate().atStartOfDay();
        LambdaQueryWrapper<Content> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(Content::getDeleted, false)
                .ge(Content::getCreateTime, since);
        return this.count(wrapper);
    }

    @Override
    public long countByCategory(String category) {
        LambdaQueryWrapper<Content> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(Content::getCategory, category)
                .eq(Content::getDeleted, false);
        return this.count(wrapper);
    }

    @Override
    public List<String> listCategories() {
        LambdaQueryWrapper<Content> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(Content::getDeleted, false)
                .select(Content::getCategory)
                .groupBy(Content::getCategory);
        return this.list(wrapper).stream()
                .map(Content::getCategory)
                .distinct()
                .toList();
    }

    @Override
    public Content getById(String id) {
        return this.baseMapper.selectById(id);
    }

    @Override
    public List<Content> listByCategory(String category) {
        LambdaQueryWrapper<Content> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(Content::getCategory, category)
                .eq(Content::getDeleted, false)
                .orderByDesc(Content::getCreateTime);
        return this.list(wrapper);
    }

    @Override
    public List<Content> listRecommend() {
        LambdaQueryWrapper<Content> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(Content::getIsRecommend, true)
                .eq(Content::getDeleted, false)
                .orderByDesc(Content::getCreateTime)
                .last("LIMIT 2");
        return this.list(wrapper);
    }

    @Override
    public List<Content> listRecent(int limit) {
        LambdaQueryWrapper<Content> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(Content::getDeleted, false)
                .orderByDesc(Content::getCreateTime)
                .last("LIMIT " + limit);
        return this.list(wrapper);
    }

    @Override
    public List<Content> listTopByViews(int limit) {
        LambdaQueryWrapper<Content> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(Content::getDeleted, false)
                .orderByDesc(Content::getViewCount)
                .last("LIMIT " + limit);
        return this.list(wrapper);
    }

    @Override
    public List<Content> listAll(String keyword, String status) {
        LambdaQueryWrapper<Content> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(Content::getDeleted, false);

        if (keyword != null && !keyword.isEmpty()) {
            wrapper.and(w -> w.like(Content::getTitle, keyword)
                    .or()
                    .like(Content::getContent, keyword));
        }

        wrapper.orderByDesc(Content::getCreateTime);
        return this.list(wrapper);
    }

    @Transactional(rollbackFor = Exception.class)
    @Override
    public boolean toggleRecommend(String id, Boolean isRecommend) {
        LambdaUpdateWrapper<Content> wrapper = new LambdaUpdateWrapper<>();
        wrapper.eq(Content::getId, id)
                .set(Content::getIsRecommend, isRecommend);
        return this.update(wrapper);
    }

    @Transactional(rollbackFor = Exception.class)
    @Override
    public String addContent(Content content) {
        content.setCommentCount(0);
        content.setViewCount(0);

        boolean needAutoCover = content.getCover() == null || content.getCover().isEmpty();
        if (needAutoCover) {
            content.setCover("default/default.jpg");
        }

        if (content.getDescription() == null || content.getDescription().isEmpty()) {
            try {
                String rawContent = content.getContent() == null ? "" : content.getContent();
                String excerpt = rawContent.length() > 500 ? rawContent.substring(0, 500) : rawContent;
                String descriptionPrompt = String.format(
                        "根据以下文章标题和内容，生成一段简洁的文章描述。要求：不超过100字，只返回描述内容。\n\n标题：%s\n内容：%s",
                        content.getTitle(),
                        excerpt
                );
                String description = llmService.getChatModel().call(descriptionPrompt);
                content.setDescription(description == null ? "暂无描述" : description.trim());
            } catch (Exception e) {
                log.error("Generate description failed", e);
                content.setDescription("暂无描述");
            }
        }

        this.save(content);
        String contentId = content.getId();

        // 异步生成封面，不阻塞文章发布
        if (needAutoCover) {
            asyncGenerateCover(contentId, content.getTitle(), content.getContent());
        }

        return contentId;
    }

    /**
     * 异步生成封面并更新 — 封面生成耗时较长（LLM + 豆包API），不阻塞文章保存
     */
    @Async
    public void asyncGenerateCover(String contentId, String title, String content) {
        try {
            log.info("异步生成封面开始: article={}, title={}", contentId, title);
            String coverUrl = imageGenerationService.generateCoverForContent(title, content);
            if (coverUrl != null) {
                LambdaUpdateWrapper<Content> wrapper = new LambdaUpdateWrapper<>();
                wrapper.eq(Content::getId, contentId).set(Content::getCover, coverUrl);
                this.update(wrapper);
                log.info("异步封面生成成功并已更新: article={}, cover={}", contentId, coverUrl);
            } else {
                log.warn("异步封面生成返回null，保留默认封面: article={}", contentId);
            }
        } catch (Exception e) {
            log.error("异步封面生成异常: article={}, error={}", contentId, e.getMessage(), e);
        }
    }

    @Transactional(rollbackFor = Exception.class)
    @Override
    public boolean updateContent(Content content) {
        boolean updated = this.updateById(content);
        // 如果更新后没有封面，异步生成
        if (content.getCover() == null || content.getCover().isEmpty() || "default/default.jpg".equals(content.getCover())) {
            asyncGenerateCover(content.getId(), content.getTitle(), content.getContent());
        }
        return updated;
    }

    @Transactional(rollbackFor = Exception.class)
    @Override
    public boolean removeContent(String id) {
        boolean removed = this.removeById(id);
        if (removed) {
            int deletedComments = commentService.removeByContentId(id);
            log.info("内容 [{}] 已逻辑删除，级联逻辑删除评论 {} 条", id, deletedComments);
        }
        return removed;
    }

    @Override
    public void incrementViewCount(String id) {
        LambdaUpdateWrapper<Content> wrapper = new LambdaUpdateWrapper<>();
        wrapper.eq(Content::getId, id)
                .setSql("view_count = view_count + 1");
        this.update(wrapper);
    }

    @Override
    public void incrementCommentCount(String id) {
        LambdaUpdateWrapper<Content> wrapper = new LambdaUpdateWrapper<>();
        wrapper.eq(Content::getId, id)
                .setSql("comment_count = comment_count + 1");
        this.update(wrapper);
    }

    @Override
    public void decrementCommentCount(String id, int delta) {
        if (delta <= 0) {
            return;
        }
        LambdaUpdateWrapper<Content> wrapper = new LambdaUpdateWrapper<>();
        wrapper.eq(Content::getId, id)
                .setSql("comment_count = GREATEST(comment_count - " + delta + ", 0)");
        this.update(wrapper);
    }

    @Override
    public Map<String, Integer> getActivityStats(int days) {
        LocalDateTime since = LocalDateTime.now().minusDays(days - 1L).toLocalDate().atStartOfDay();
        LambdaQueryWrapper<Content> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(Content::getDeleted, false)
                .ge(Content::getCreateTime, since);
        List<Content> contents = this.list(wrapper);
        DateTimeFormatter fmt = DateTimeFormatter.ofPattern("yyyy-MM-dd");
        return contents.stream()
                .collect(Collectors.groupingBy(
                        c -> c.getCreateTime().format(fmt),
                        Collectors.collectingAndThen(Collectors.counting(), Long::intValue)
                ));
    }
}
