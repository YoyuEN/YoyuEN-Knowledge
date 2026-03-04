package com.yoyuen.backend.controller.vo;

import lombok.Data;

import java.util.List;

/**
 * @Author: YoyuEN
 * @Date: 2026/3/4
 * @Description: 带引用信息的聊天响应
 */
@Data
public class ChatResponseWithReferencesVO {

    /**
     * AI回复内容
     */
    private String content;

    /**
     * 引用的文档列表
     */
    private List<DocumentReferenceVO> references;

    /**
     * 是否结束
     */
    private String finishReason;

    @Data
    public static class DocumentReferenceVO {
        /**
         * 文档ID
         */
        private Long documentId;

        /**
         * 文档名称
         */
        private String documentName;

        /**
         * 知识库ID
         */
        private String knowledgeBaseId;

        /**
         * 知识库名称
         */
        private String knowledgeBaseName;

        /**
         * 内容类型：article, comment
         */
        private String contentType;

        /**
         * 内容ID（文章ID或评论ID）
         */
        private String contentId;

        /**
         * 如果是评论，需要关联的文章ID
         */
        private String articleId;

        /**
         * 文章标题（article）或评论内容（comment）
         */
        private String title;

        /**
         * 作者/发布人
         */
        private String author;

        /**
         * 发布时间
         */
        private String publishTime;
    }
}
