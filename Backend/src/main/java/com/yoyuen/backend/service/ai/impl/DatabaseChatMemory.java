package com.yoyuen.backend.service.ai.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.yoyuen.backend.constant.AppConstant;
import com.yoyuen.backend.mapper.ChatMessageMapper;
import com.yoyuen.backend.model.entity.ai.ChatMessage;
import com.yoyuen.backend.service.ai.ChatMessageService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.ai.chat.memory.ChatMemory;
import org.springframework.ai.chat.messages.Message;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.ArrayList;
import java.util.List;

import static org.springframework.ai.chat.messages.AbstractMessage.MESSAGE_TYPE;

/**
 * @Author: YoyuEN
 * @Date: 2026/2/13
 * @Time: 13:45
 * @Description:
 */

@Slf4j
@Service
@RequiredArgsConstructor
public class DatabaseChatMemory implements ChatMemory {

    private final ChatMessageMapper chatMessageMapper;

    private final ChatMessageService chatMessageService;

    @Transactional(rollbackFor = Exception.class)
    @Override
    public void add(String conversationId, List<Message> messages) {
        log.info("messages:{}", messages);
        log.info("params:{}", messages.get(0).getMetadata());
        LambdaQueryWrapper<ChatMessage> qw = new LambdaQueryWrapper<>();
        qw.eq(ChatMessage::getIsClean, false);
        qw.eq(ChatMessage::getConversationId, conversationId);
        Long cnt = this.chatMessageMapper.selectCount(qw);
        ArrayList<ChatMessage> chatMessageList = new ArrayList<>();
        for (int i = 0; i < messages.size(); i++) {
            Message message = messages.get(i);
            ChatMessage chatMessage = new ChatMessage();
            chatMessage.setConversationId(conversationId);
            chatMessage.setMessageNo((int) (cnt + i + 1));
            chatMessage.setContent(message.getContent());
            chatMessage.setRole(message.getMetadata().get(MESSAGE_TYPE).toString());
            List<String> resourceIds = (List) message.getMetadata().get(AppConstant.CHAT_MEDIAS);
            if (resourceIds != null && !resourceIds.isEmpty()) {
                chatMessage.setHasMedia(true);
                chatMessage.setResourceIds(resourceIds);
            }
            else {
                chatMessage.setHasMedia(false);
                chatMessage.setResourceIds(List.of());
            }
            chatMessageList.add(chatMessage);
        }
        chatMessageMapper.insert(chatMessageList);
    }

    @Override
    public List<Message> get(String conversationId, int lastN) {
        LambdaQueryWrapper<ChatMessage> qw = new LambdaQueryWrapper<>();
        qw.eq(ChatMessage::getConversationId, conversationId);
        qw.orderByAsc(ChatMessage::getCreateTime);
        qw.eq(ChatMessage::getIsClean, false);
        qw.last(" LIMIT " + lastN);
        List<ChatMessage> chatMessages = chatMessageMapper.selectList(qw);
        log.info("Memory Context:{}", chatMessages);
        return chatMessageService.toMessage(chatMessages);
    }

    @Transactional(rollbackFor = Exception.class)
    @Override
    public void clear(String conversationId) {
        LambdaQueryWrapper<ChatMessage> qw = new LambdaQueryWrapper<>();
        qw.eq(ChatMessage::getConversationId, conversationId);
        List<ChatMessage> chatMessages = chatMessageMapper.selectList(qw);
        chatMessages.forEach(item -> {
            item.setIsClean(true);
        });
        chatMessageMapper.updateById(chatMessages);
    }

}
