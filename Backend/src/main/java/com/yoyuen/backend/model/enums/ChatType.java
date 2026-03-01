package com.yoyuen.backend.model.enums;

import lombok.Getter;
import lombok.RequiredArgsConstructor;

/**
 * @Author: YoyuEN
 * @Date: 2026/2/24
 * @Time: 0:43
 * @Description:
 */
@Getter
@RequiredArgsConstructor
public enum ChatType {

    // type ChatType = 'simple' | 'simpleRAG' | 'multimodal' | 'multimodalRAG';
    UNKNOWN("unknown"), SIMPLE("simple"), SIMPLE_RAG("simpleRAG"), MULTIMODAL("multimodal"),
    MULTIMODAL_RAG("multimodalRAG");

    private final String value;

    public static ChatType parse(String value) {
        if (value == null) {
            return ChatType.UNKNOWN;
        }
        return switch (value) {
            case "simple" -> ChatType.SIMPLE;
            case "simpleRAG" -> ChatType.SIMPLE_RAG;
            case "multimodal" -> ChatType.MULTIMODAL;
            case "multimodalRAG" -> ChatType.MULTIMODAL_RAG;
            default -> ChatType.UNKNOWN;
        };
    }

}
