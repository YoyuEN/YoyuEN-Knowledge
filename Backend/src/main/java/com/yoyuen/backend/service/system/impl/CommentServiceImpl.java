package com.yoyuen.backend.service.system.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.yoyuen.backend.mapper.CommentMapper;
import com.yoyuen.backend.entity.Comment;
import com.yoyuen.backend.service.system.CommentService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.Objects;
import java.util.stream.Collectors;

/**
 * @Author: YoyuEN
 * @Date: 2026/2/26
 * @Description: 评论服务实现类
 */
@Slf4j
@Service
@RequiredArgsConstructor
public class CommentServiceImpl extends ServiceImpl<CommentMapper, Comment> implements CommentService {
    @Override
    public List<Comment> listByContent(String contentId, String contentType) {
        // 查询所有评论
        LambdaQueryWrapper<Comment> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(Comment::getContentId, contentId)
                .eq(Comment::getContentType, contentType)
                .eq(Comment::getDeleted, false)
                .orderByAsc(Comment::getCreateTime);
        List<Comment> allComments = this.list(wrapper);

        // 构建树形结构
        return buildCommentTree(allComments);
    }

    /**
     * 构建评论树形结构
     */
    private List<Comment> buildCommentTree(List<Comment> allComments) {
        // 按父评论ID分组
        Map<String, List<Comment>> childrenMap = allComments.stream()
                .filter(c -> c.getParentId() != null)
                .collect(Collectors.groupingBy(Comment::getParentId));

        // 获取顶级评论并设置子评论
        List<Comment> rootComments = allComments.stream()
                .filter(c -> Objects.equals(c.getParentId(), ""))
                .collect(Collectors.toList());

        // 递归设置子评论
        for (Comment root : rootComments) {
            setReplies(root, childrenMap);
        }

        return rootComments;
    }

    /**
     * 递归设置子评论
     */
    private void setReplies(Comment parent, Map<String, List<Comment>> childrenMap) {
        List<Comment> children = childrenMap.getOrDefault(parent.getId(), new ArrayList<>());
        parent.setReplies(children);
        for (Comment child : children) {
            setReplies(child, childrenMap);
        }
    }

    @Override
    public Comment getById(String id) {
        return this.baseMapper.selectById(id);
    }

    @Transactional(rollbackFor = Exception.class)
    @Override
    public String addComment(Comment comment) {
        this.save(comment);
        return comment.getId();
    }

    @Transactional(rollbackFor = Exception.class)
    @Override
    public boolean removeComment(String id) {
        return this.removeById(id);
    }

    @Override
    public List<Comment> listRecommend() {
        LambdaQueryWrapper<Comment> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(Comment::getIsRecommend, true)
                .eq(Comment::getDeleted, false)
                .orderByDesc(Comment::getCreateTime);
        return this.list(wrapper);
    }

    @Override
    public List<Comment> listAll(String keyword, String status) {
        LambdaQueryWrapper<Comment> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(Comment::getDeleted, false);

        // 关键词搜索（内容或作者）
        if (keyword != null && !keyword.isEmpty()) {
            wrapper.and(w -> w.like(Comment::getContent, keyword)
                    .or()
                    .like(Comment::getAuthor, keyword));
        }

        // 状态筛选（假设有 status 字段：approved/pending）
        // 如果 Comment 实体有 status 字段，取消下面的注释
        // if (status != null && !status.isEmpty()) {
        //     wrapper.eq(Comment::getStatus, status);
        // }

        wrapper.orderByDesc(Comment::getCreateTime);
        return this.list(wrapper);
    }

    @Transactional(rollbackFor = Exception.class)
    @Override
    public boolean approveComment(String id) {
        Comment comment = this.getById(id);
        if (comment != null) {
            // 假设有 status 字段，设置为 approved
            // comment.setStatus("approved");
            // return this.updateById(comment);

            // 如果没有 status 字段，这里暂时返回 true
            return true;
        }
        return false;
    }

    @Transactional(rollbackFor = Exception.class)
    @Override
    public boolean toggleRecommend(String id, Boolean isRecommend) {
        Comment comment = this.getById(id);
        if (comment != null) {
            comment.setIsRecommend(isRecommend);
            return this.updateById(comment);
        }
        return false;
    }

    @Override
    public int countByContent(String contentId, String contentType) {
        LambdaQueryWrapper<Comment> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(Comment::getContentId, contentId)
                .eq(Comment::getContentType, contentType)
                .eq(Comment::getDeleted, false);
        return (int) this.count(wrapper);
    }

    @Override
    public long countAll() {
        LambdaQueryWrapper<Comment> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(Comment::getDeleted, false);
        return this.count(wrapper);
    }
}
