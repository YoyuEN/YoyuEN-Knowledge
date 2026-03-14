package com.yoyuen.backend.controller.vo;

import lombok.Data;

import java.time.LocalDateTime;
import java.util.List;

/**
 * @Author: YoyuEN
 * @Date: 2026/2/12
 * @Time: 9:58
 * @Description:
 */
@Data
public class ChatConversationVO {
    private String id;
    private String title;
    private String knowledgeBaseId;
    private LocalDateTime createTime;
    private List<ChatMessageVO> messages;
}
