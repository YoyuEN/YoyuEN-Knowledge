package com.yoyuen.backend.service.system;

import com.yoyuen.backend.entity.Comment;

import java.util.List;

public interface CommentService {

    Comment getById(String id);

    List<Comment> listByContent(String contentId, String contentType);

    String addComment(Comment comment);

    boolean removeComment(String id);

    int removeByContentId(String contentId);

    List<Comment> listRecommend();

    List<Comment> listAll(String keyword, String status);

    boolean approveComment(String id);

    boolean toggleRecommend(String id, Boolean isRecommend);

    int countByContent(String contentId, String contentType);

    int countByContentId(String contentId);

    long countAll();

    long countToday();

    long countRecentDays(int days);
}
