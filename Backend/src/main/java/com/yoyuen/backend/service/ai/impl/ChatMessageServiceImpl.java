package com.yoyuen.backend.service.ai.impl;

import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.yoyuen.backend.mapper.ChatMessageMapper;
import com.yoyuen.backend.model.ai.ChatMessage;
import com.yoyuen.backend.service.ai.ChatMessageService;
import org.springframework.ai.chat.messages.Message;

import java.util.List;

/**
 * @Author: YoyuEN
 * @Date: 2026/2/12
 * @Time: 13:12
 * @Description:
 */
public class ChatMessageServiceImpl extends ServiceImpl<ChatMessageMapper, ChatMessage> implements ChatMessageService {
    @Override
    public List<Message> toMessage(List<ChatMessage> chatMessages) {
        return List.of();
    }

    @Override
    public List<ChatMessage> fromMessage(List<Message> messages) {
        return List.of();
    }
}
