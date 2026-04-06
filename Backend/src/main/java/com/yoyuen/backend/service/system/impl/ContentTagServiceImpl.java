package com.yoyuen.backend.service.system.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.yoyuen.backend.entity.ContentTag;
import com.yoyuen.backend.entity.ContentTagRelation;
import com.yoyuen.backend.mapper.ContentTagMapper;
import com.yoyuen.backend.mapper.ContentTagRelationMapper;
import com.yoyuen.backend.service.system.ContentTagService;
import com.yoyuen.backend.service.system.RedisService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import java.util.concurrent.TimeUnit;
import java.util.stream.Collectors;

/**
 * @Author: YoyuEN
 * @Date: 2026/4/6
 * @Description: 内容标签服务实现
 */
@Slf4j
@Service
@RequiredArgsConstructor
public class ContentTagServiceImpl implements ContentTagService {

    private final ContentTagMapper contentTagMapper;
    private final ContentTagRelationMapper contentTagRelationMapper;
    private final RedisService redisService;

    private static final String TAG_LIST_CACHE_KEY = "content:tag:list";
    private static final String TAG_BY_ID_CACHE_PREFIX = "content:tag:id:";
    private static final String TAG_BY_NAME_CACHE_PREFIX = "content:tag:name:";
    private static final String CONTENT_TAGS_CACHE_PREFIX = "content:tags:";

    @Override
    public List<ContentTag> listAll() {
        // 先从缓存获取
        Object cached = redisService.get(TAG_LIST_CACHE_KEY);
        if (cached instanceof List<?>) {
            return (List<ContentTag>) cached;
        }

        // 从数据库查询
        List<ContentTag> tags = contentTagMapper.selectList(
                new LambdaQueryWrapper<ContentTag>()
                        .orderByDesc(ContentTag::getUsageCount)
                        .orderByAsc(ContentTag::getName)
        );

        // 缓存结果
        redisService.set(TAG_LIST_CACHE_KEY, tags, 10, TimeUnit.MINUTES);
        return tags;
    }

    @Override
    public ContentTag getById(Long id) {
        if (id == null) {
            return null;
        }

        // 先从缓存获取
        String cacheKey = TAG_BY_ID_CACHE_PREFIX + id;
        Object cached = redisService.get(cacheKey);
        if (cached instanceof ContentTag) {
            return (ContentTag) cached;
        }

        // 从数据库查询
        ContentTag tag = contentTagMapper.selectById(id);
        if (tag != null) {
            redisService.set(cacheKey, tag, 30, TimeUnit.MINUTES);
        }
        return tag;
    }

    @Override
    public ContentTag getByName(String name) {
        if (name == null || name.isBlank()) {
            return null;
        }

        // 先从缓存获取
        String cacheKey = TAG_BY_NAME_CACHE_PREFIX + name;
        Object cached = redisService.get(cacheKey);
        if (cached instanceof ContentTag) {
            return (ContentTag) cached;
        }

        // 从数据库查询
        ContentTag tag = contentTagMapper.selectOne(
                new LambdaQueryWrapper<ContentTag>()
                        .eq(ContentTag::getName, name)
        );

        if (tag != null) {
            redisService.set(cacheKey, tag, 30, TimeUnit.MINUTES);
        }
        return tag;
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public ContentTag create(String name) {
        if (name == null || name.isBlank()) {
            throw new IllegalArgumentException("标签名不能为空");
        }

        // 检查是否已存在
        ContentTag existing = getByName(name);
        if (existing != null) {
            throw new IllegalArgumentException("标签已存在");
        }

        // 创建新标签
        ContentTag tag = new ContentTag();
        tag.setName(name.trim());
        tag.setUsageCount(0L);
        tag.setCreateTime(LocalDateTime.now());
        tag.setUpdateTime(LocalDateTime.now());

        contentTagMapper.insert(tag);

        // 清除缓存
        clearCache();

        log.info("创建标签成功: {}", name);
        return tag;
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public boolean update(Long id, String newName) {
        if (id == null || newName == null || newName.isBlank()) {
            throw new IllegalArgumentException("参数不能为空");
        }

        ContentTag tag = getById(id);
        if (tag == null) {
            throw new IllegalArgumentException("标签不存在");
        }

        // 检查新名称是否已被使用
        ContentTag existing = getByName(newName);
        if (existing != null && !existing.getId().equals(id)) {
            throw new IllegalArgumentException("标签名已存在");
        }

        String oldName = tag.getName();
        tag.setName(newName.trim());
        tag.setUpdateTime(LocalDateTime.now());

        int result = contentTagMapper.updateById(tag);

        // 清除缓存
        clearCache();
        redisService.delete(TAG_BY_NAME_CACHE_PREFIX + oldName);

        log.info("更新标签成功: {} -> {}", oldName, newName);
        return result > 0;
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public boolean remove(Long id) {
        if (id == null) {
            throw new IllegalArgumentException("标签ID不能为空");
        }

        ContentTag tag = getById(id);
        if (tag == null) {
            return false;
        }

        // 检查是否有内容使用该标签
        Long count = contentTagRelationMapper.selectCount(
                new LambdaQueryWrapper<ContentTagRelation>()
                        .eq(ContentTagRelation::getTagId, id)
        );

        if (count > 0) {
            throw new IllegalArgumentException("标签仍被 " + count + " 篇内容使用，无法删除");
        }

        // 删除标签
        int result = contentTagMapper.deleteById(id);

        // 清除缓存
        clearCache();
        redisService.delete(TAG_BY_NAME_CACHE_PREFIX + tag.getName());

        log.info("删除标签成功: {}", tag.getName());
        return result > 0;
    }

    @Override
    public List<ContentTag> listByContentId(String contentId) {
        if (contentId == null || contentId.isBlank()) {
            return new ArrayList<>();
        }

        // 先从缓存获取
        String cacheKey = CONTENT_TAGS_CACHE_PREFIX + contentId;
        Object cached = redisService.get(cacheKey);
        if (cached instanceof List<?>) {
            return (List<ContentTag>) cached;
        }

        // 从数据库查询
        List<Long> tagIds = contentTagRelationMapper.selectTagIdsByContentId(contentId);
        if (tagIds.isEmpty()) {
            return new ArrayList<>();
        }

        List<ContentTag> tags = contentTagMapper.selectBatchIds(tagIds);

        // 缓存结果
        redisService.set(cacheKey, tags, 30, TimeUnit.MINUTES);
        return tags;
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void setContentTags(String contentId, List<String> tagNames) {
        if (contentId == null || contentId.isBlank()) {
            return;
        }

        // 删除旧的关联关系
        removeContentTags(contentId);

        if (tagNames == null || tagNames.isEmpty()) {
            return;
        }

        // 处理标签名称
        List<String> cleanedNames = tagNames.stream()
                .filter(name -> name != null && !name.isBlank())
                .map(String::trim)
                .distinct()
                .collect(Collectors.toList());

        if (cleanedNames.isEmpty()) {
            return;
        }

        // 获取或创建标签
        List<Long> tagIds = new ArrayList<>();
        for (String name : cleanedNames) {
            ContentTag tag = getByName(name);
            if (tag == null) {
                // 自动创建不存在的标签
                tag = create(name);
            }
            tagIds.add(tag.getId());
        }

        // 创建新的关联关系
        LocalDateTime now = LocalDateTime.now();
        for (Long tagId : tagIds) {
            ContentTagRelation relation = new ContentTagRelation();
            relation.setContentId(contentId);
            relation.setTagId(tagId);
            relation.setCreateTime(now);
            contentTagRelationMapper.insert(relation);
        }

        // 更新标签使用次数
        for (Long tagId : tagIds) {
            updateUsageCount(tagId);
        }

        // 清除缓存
        redisService.delete(CONTENT_TAGS_CACHE_PREFIX + contentId);
        clearCache();

        log.info("设置内容标签成功: contentId={}, tags={}", contentId, cleanedNames);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void removeContentTags(String contentId) {
        if (contentId == null || contentId.isBlank()) {
            return;
        }

        // 获取旧的标签ID列表
        List<Long> oldTagIds = contentTagRelationMapper.selectTagIdsByContentId(contentId);

        // 删除关联关系
        contentTagRelationMapper.delete(
                new LambdaQueryWrapper<ContentTagRelation>()
                        .eq(ContentTagRelation::getContentId, contentId)
        );

        // 更新标签使用次数
        for (Long tagId : oldTagIds) {
            updateUsageCount(tagId);
        }

        // 清除缓存
        redisService.delete(CONTENT_TAGS_CACHE_PREFIX + contentId);
        clearCache();
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void updateUsageCount(Long tagId) {
        if (tagId == null) {
            return;
        }

        // 统计使用次数
        Long count = contentTagRelationMapper.selectCount(
                new LambdaQueryWrapper<ContentTagRelation>()
                        .eq(ContentTagRelation::getTagId, tagId)
        );

        // 更新标签
        ContentTag tag = new ContentTag();
        tag.setId(tagId);
        tag.setUsageCount(count);
        tag.setUpdateTime(LocalDateTime.now());
        contentTagMapper.updateById(tag);

        // 清除缓存
        redisService.delete(TAG_BY_ID_CACHE_PREFIX + tagId);
        clearCache();
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void batchUpdateUsageCount() {
        List<ContentTag> allTags = contentTagMapper.selectList(null);
        for (ContentTag tag : allTags) {
            updateUsageCount(tag.getId());
        }
        log.info("批量更新标签使用次数完成，共更新 {} 个标签", allTags.size());
    }

    /**
     * 清除所有标签相关缓存
     */
    private void clearCache() {
        redisService.delete(TAG_LIST_CACHE_KEY);
    }
}
