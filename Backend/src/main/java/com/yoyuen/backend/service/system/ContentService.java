package com.yoyuen.backend.service.system;

import com.yoyuen.backend.entity.Content;

import java.util.List;
import java.util.Map;

public interface ContentService {

    List<String> listCategories();

    long countByCategory(String category);

    long countAll();

    Content getById(String id);

    List<Content> listByCategory(String category);

    List<Content> listRecommend();

    List<Content> listAll(String keyword, String status);

    boolean toggleRecommend(String id, Boolean isRecommend);

    String addContent(Content content);

    boolean updateContent(Content content);

    boolean removeContent(String id);

    void incrementViewCount(String id);

    void incrementCommentCount(String id);

    void decrementCommentCount(String id, int delta);

    Map<String, Integer> getActivityStats(int days);
}
