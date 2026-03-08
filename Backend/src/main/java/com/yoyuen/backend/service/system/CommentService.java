package com.yoyuen.backend.service.system;

import com.yoyuen.backend.entity.Comment;

import java.util.List;

/**
 * @Author: YoyuEN
 * @Date: 2026/2/26
 * @Description: 评论服务接口
 */
public interface CommentService {

    /**
     * 根据ID获取单条评论
     */
    Comment getById(String id);

    /**
     * 根据内容ID和类型获取评论列表（树形结构）
     */
    List<Comment> listByContent(String contentId, String contentType);

    /**
     * 添加评论
     */
    String addComment(Comment comment);

    /**
     * 删除评论
     */
    boolean removeComment(String id);

    /**
     * 获取推荐评论列表
     */
    List<Comment> listRecommend();

    /**
     * 获取所有评论列表（后台管理用）
     */
    List<Comment> listAll(String keyword, String status);

    /**
     * 审核通过评论
     */
    boolean approveComment(String id);

    /**
     * 切换推荐状态
     */
    boolean toggleRecommend(String id, Boolean isRecommend);

    /**
     * 获取评论数量
     */
    int countByContent(String contentId, String contentType);

    /**
     * 获取评论总数
     */
    long countAll();
}
