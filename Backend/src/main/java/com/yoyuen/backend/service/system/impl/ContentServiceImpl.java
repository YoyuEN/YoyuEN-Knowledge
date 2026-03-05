package com.yoyuen.backend.service.system.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.core.conditions.update.LambdaUpdateWrapper;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.yoyuen.backend.mapper.ContentMapper;
import com.yoyuen.backend.entity.Content;
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

    @Override
    public long countAll() {
        LambdaQueryWrapper<Content> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(Content::getDeleted, false);
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
                .orderByDesc(Content::getCreateTime)
                .last("LIMIT 5");
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

    @Transactional(rollbackFor = Exception.class)
    @Override
    public String addContent(Content content) {
        content.setCommentCount(0);
        content.setViewCount(0);
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
