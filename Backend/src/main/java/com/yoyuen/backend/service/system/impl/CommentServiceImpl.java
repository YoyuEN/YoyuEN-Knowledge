package com.yoyuen.backend.service.system.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.yoyuen.backend.entity.Comment;
import com.yoyuen.backend.mapper.CommentMapper;
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

@Slf4j
@Service
@RequiredArgsConstructor
public class CommentServiceImpl extends ServiceImpl<CommentMapper, Comment> implements CommentService {

    @Override
    public List<Comment> listByContent(String contentId, String contentType) {
        LambdaQueryWrapper<Comment> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(Comment::getContentId, contentId)
                .eq(Comment::getContentType, contentType)
                .eq(Comment::getDeleted, false)
                .orderByAsc(Comment::getCreateTime);
        List<Comment> allComments = this.list(wrapper);
        return buildCommentTree(allComments);
    }

    private List<Comment> buildCommentTree(List<Comment> allComments) {
        Map<String, List<Comment>> childrenMap = allComments.stream()
                .filter(c -> c.getParentId() != null)
                .collect(Collectors.groupingBy(Comment::getParentId));

        List<Comment> rootComments = allComments.stream()
                .filter(c -> Objects.equals(c.getParentId(), ""))
                .collect(Collectors.toList());

        for (Comment root : rootComments) {
            setReplies(root, childrenMap);
        }

        return rootComments;
    }

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

    @Transactional(rollbackFor = Exception.class)
    @Override
    public int removeByContentId(String contentId) {
        LambdaQueryWrapper<Comment> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(Comment::getContentId, contentId)
                .eq(Comment::getDeleted, false);
        long total = this.count(wrapper);
        if (total == 0) {
            return 0;
        }
        this.remove(wrapper);
        return (int) total;
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

        if (keyword != null && !keyword.isEmpty()) {
            wrapper.and(w -> w.like(Comment::getContent, keyword)
                    .or()
                    .like(Comment::getAuthor, keyword));
        }

        if (status != null && !status.isEmpty()) {
            wrapper.eq(Comment::getStatus, status);
        }

        wrapper.orderByDesc(Comment::getCreateTime);
        return this.list(wrapper);
    }

    @Transactional(rollbackFor = Exception.class)
    @Override
    public boolean approveComment(String id) {
        Comment comment = this.getById(id);
        if (comment == null) {
            return false;
        }
        comment.setStatus("approved");
        return this.updateById(comment);
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
    public int countByContentId(String contentId) {
        LambdaQueryWrapper<Comment> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(Comment::getContentId, contentId)
                .eq(Comment::getDeleted, false);
        return (int) this.count(wrapper);
    }

    @Override
    public long countAll() {
        LambdaQueryWrapper<Comment> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(Comment::getDeleted, false);
        return this.count(wrapper);
    }

    @Override
    public long countToday() {
        java.time.LocalDateTime startOfDay = java.time.LocalDateTime.now().toLocalDate().atStartOfDay();
        LambdaQueryWrapper<Comment> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(Comment::getDeleted, false)
                .ge(Comment::getCreateTime, startOfDay);
        return this.count(wrapper);
    }

    @Override
    public long countRecentDays(int days) {
        if (days <= 0) {
            return 0;
        }
        java.time.LocalDateTime since = java.time.LocalDateTime.now().minusDays(days - 1L).toLocalDate().atStartOfDay();
        LambdaQueryWrapper<Comment> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(Comment::getDeleted, false)
                .ge(Comment::getCreateTime, since);
        return this.count(wrapper);
    }
}
