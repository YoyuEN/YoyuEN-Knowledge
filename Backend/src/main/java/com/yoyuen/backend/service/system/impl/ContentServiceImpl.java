package com.yoyuen.backend.service.system.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.core.conditions.update.LambdaUpdateWrapper;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.yoyuen.backend.entity.Content;
import com.yoyuen.backend.mapper.ContentMapper;
import com.yoyuen.backend.service.ai.ImageGenerationService;
import com.yoyuen.backend.service.ai.LLMService;
import com.yoyuen.backend.service.system.ContentService;
import lombok.RequiredArgsConstructor;
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
@RequiredArgsConstructor
public class ContentServiceImpl extends ServiceImpl<ContentMapper, Content> implements ContentService {

    private final ImageGenerationService imageGenerationService;
    private final LLMService llmService;

    @Override
    public long countAll() {
        LambdaQueryWrapper<Content> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(Content::getDeleted, false);
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

        if (content.getCover() == null || content.getCover().isEmpty()) {
            try {
                log.info("Generating cover for article: {}", content.getTitle());
                String coverUrl = imageGenerationService.generateCoverForContent(
                        content.getTitle(),
                        content.getContent()
                );
                if (coverUrl != null) {
                    content.setCover(coverUrl);
                } else {
                    content.setCover("default/default.jpg");
                }
            } catch (Exception e) {
                log.error("Generate cover failed", e);
                content.setCover("default/default.jpg");
            }
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
        return content.getId();
    }

    @Transactional(rollbackFor = Exception.class)
    @Override
    public boolean updateContent(Content content) {
        return this.updateById(content);
    }

    @Transactional(rollbackFor = Exception.class)
    @Override
    public boolean removeContent(String id) {
        return this.removeById(id);
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
