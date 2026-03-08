package com.yoyuen.backend.service.system.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.core.conditions.update.LambdaUpdateWrapper;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.yoyuen.backend.mapper.ContentMapper;
import com.yoyuen.backend.entity.Content;
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

/**
 * @Author: YoyuEN
 * @Date: 2026/2/26
 * @Description: 内容服务实现类
 */
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
    public List<Content> listAll(String keyword, String status) {
        LambdaQueryWrapper<Content> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(Content::getDeleted, false);

        // 关键词搜索（标题或内容）
        if (keyword != null && !keyword.isEmpty()) {
            wrapper.and(w -> w.like(Content::getTitle, keyword)
                    .or()
                    .like(Content::getContent, keyword));
        }

        // 状态筛选（这里假设 status 对应某个字段，如果没有可以去掉）
        // 如果你的 Content 实体有 status 字段，取消下面的注释
        // if (status != null && !status.isEmpty()) {
        //     wrapper.eq(Content::getStatus, status);
        // }

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

        // 如果没有封面，自动生成
        if (content.getCover() == null || content.getCover().isEmpty()) {
            try {
                log.info("开始为文章生成封面: {}", content.getTitle());
                String coverUrl = imageGenerationService.generateCoverForContent(
                        content.getTitle(),
                        content.getContent()
                );
                if (coverUrl != null) {
                    content.setCover(coverUrl);
                    log.info("封面生成成功: {}", coverUrl);
                } else {
                    log.warn("封面生成失败，使用默认封面");
                    content.setCover("default/default.jpg");
                }
            } catch (Exception e) {
                log.error("生成封面时发生异常", e);
                content.setCover("default/default.jpg");
            }
        }

        // 如果没有描述，自动生成
        if (content.getDescription() == null || content.getDescription().isEmpty()) {
            try {
                log.info("开始为文章生成描述: {}", content.getTitle());
                String descriptionPrompt = String.format(
                        "根据以下文章标题和内容，生成一段简洁的文章描述。" +
                        "要求：概括文章核心内容，不超过100字，语言简洁流畅。" +
                        "只返回描述内容，不要其他内容。\n\n" +
                        "标题：%s\n内容：%s",
                        content.getTitle(),
                        content.getContent().length() > 500 ? content.getContent().substring(0, 500) : content.getContent()
                );
                String description = llmService.getChatModel().call(descriptionPrompt);
                content.setDescription(description.trim());
                log.info("描述生成成功: {}", description);
            } catch (Exception e) {
                log.error("生成描述时发生异常", e);
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
