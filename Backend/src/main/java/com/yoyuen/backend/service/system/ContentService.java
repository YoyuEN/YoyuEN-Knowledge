package com.yoyuen.backend.service.system;

import com.yoyuen.backend.entity.Content;

import java.util.List;
import java.util.Map;

/**
 * @Author: YoyuEN
 * @Date: 2026/2/26
 * @Description: 内容服务接口
 */
public interface ContentService {

    /**
     * 获取所有有内容的分类列表
     */
    List<String> listCategories();

    /**
     * 根据分类统计内容数量
     */
    long countByCategory(String category);

    /**
     * 获取内容总数
     */
    long countAll();

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
     * 获取所有内容列表（后台管理用）
     */
    List<Content> listAll(String keyword, String status);

    /**
     * 切换推荐状态
     */
    boolean toggleRecommend(String id, Boolean isRecommend);

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

    /**
     * 获取最近 N 天每日发布数量（用于热力图）
     * key = yyyy-MM-dd，value = 当天发布数
     */
    Map<String, Integer> getActivityStats(int days);
}
