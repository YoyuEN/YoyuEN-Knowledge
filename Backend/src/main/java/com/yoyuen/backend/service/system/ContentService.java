package com.yoyuen.backend.service.system;

import com.yoyuen.backend.entity.Content;

import java.util.List;

/**
 * @Author: YoyuEN
 * @Date: 2026/2/26
 * @Description: 内容服务接口
 */
public interface ContentService {

    /**
     * 根据ID获取内容
     */
    Content getById(String id);

    /**
     * 根据分类获取内容列表
     */
    List<Content> listByCategory(String category);

    /**
     * 获取推荐内容列表
     */
    List<Content> listRecommend();

    /**
     * 添加内容
     */
    String addContent(Content content);

    /**
     * 更新内容
     */
    boolean updateContent(Content content);

    /**
     * 删除内容
     */
    boolean removeContent(String id);

    /**
     * 增加浏览量
     */
    void incrementViewCount(String id);

    /**
     * 增加评论数
     */
    void incrementCommentCount(String id);
}
