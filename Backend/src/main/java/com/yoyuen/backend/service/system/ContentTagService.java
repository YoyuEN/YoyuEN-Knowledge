package com.yoyuen.backend.service.system;

import com.yoyuen.backend.entity.ContentTag;

import java.util.List;

/**
 * @Author: YoyuEN
 * @Date: 2026/4/6
 * @Description: 内容标签服务接口
 */
public interface ContentTagService {

    /**
     * 获取所有标签
     */
    List<ContentTag> listAll();

    /**
     * 根据ID获取标签
     */
    ContentTag getById(Long id);

    /**
     * 根据名称获取标签
     */
    ContentTag getByName(String name);

    /**
     * 创建标签
     */
    ContentTag create(String name);

    /**
     * 更新标签
     */
    boolean update(Long id, String newName);

    /**
     * 删除标签
     */
    boolean remove(Long id);

    /**
     * 根据内容ID获取标签列表
     */
    List<ContentTag> listByContentId(String contentId);

    /**
     * 为内容设置标签
     */
    void setContentTags(String contentId, List<String> tagNames);

    /**
     * 删除内容的所有标签关联
     */
    void removeContentTags(String contentId);

    /**
     * 更新标签使用次数
     */
    void updateUsageCount(Long tagId);

    /**
     * 批量更新标签使用次数
     */
    void batchUpdateUsageCount();
}
