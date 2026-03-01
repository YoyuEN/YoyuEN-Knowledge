package com.yoyuen.backend.model.enums;

import lombok.Getter;
import lombok.RequiredArgsConstructor;

/**
 * @Author: YoyuEN
 * @Date: 2026/2/26
 * @Description: 内容分类枚举
 */
@Getter
@RequiredArgsConstructor
public enum ContentCategory {

    UNKNOWN("unknown", "未知"),
    ARTICLE("article", "文章"),
    GAME("game", "游戏"),
    STUDY("study", "学习"),
    VIDEO("video", "视频");

    private final String value;
    private final String label;

    public static ContentCategory parse(String value) {
        if (value == null) {
            return ContentCategory.UNKNOWN;
        }
        return switch (value) {
            case "article" -> ContentCategory.ARTICLE;
            case "game" -> ContentCategory.GAME;
            case "study" -> ContentCategory.STUDY;
            case "video" -> ContentCategory.VIDEO;
            default -> ContentCategory.UNKNOWN;
        };
    }
}
