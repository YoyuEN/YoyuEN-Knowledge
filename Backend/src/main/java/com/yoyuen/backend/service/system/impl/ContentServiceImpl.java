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

import java.util.List;

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
                .orderByDesc(Content::getCreateTime);
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
}
