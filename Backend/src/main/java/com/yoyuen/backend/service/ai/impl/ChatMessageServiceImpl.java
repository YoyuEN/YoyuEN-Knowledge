package com.yoyuen.backend.service.ai.impl;

import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.yoyuen.backend.exception.BusinessException;
import com.yoyuen.backend.mapper.ChatMessageMapper;
import com.yoyuen.backend.model.entity.ai.ChatMessage;
import com.yoyuen.backend.service.ai.ChatMessageService;
import com.yoyuen.backend.service.ai.OriginFileResourceService;
import com.yoyuen.backend.utils.CoreCode;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.ai.chat.messages.AssistantMessage;
import org.springframework.ai.chat.messages.Message;
import org.springframework.ai.chat.messages.SystemMessage;
import org.springframework.ai.chat.messages.UserMessage;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.Comparator;
import java.util.List;

/**
 * @Author: YoyuEN
 * @Date: 2026/2/12
 * @Time: 13:12
 * @Description: 针对表【chat_message(对话消息)】的数据库操作Service实现
 */
@Slf4j
@Service
@RequiredArgsConstructor
public class ChatMessageServiceImpl extends ServiceImpl<ChatMessageMapper, ChatMessage> implements ChatMessageService {

    private final OriginFileResourceService originFileResourceService;

    @Override
    public List<Message> toMessage(List<ChatMessage> chatMessages) {
        // 根据messageNo排序 从低到高
        chatMessages.sort(Comparator.comparingInt(ChatMessage::getMessageNo));

        return chatMessages.stream().map(chatMessage -> {
            String role = chatMessage.getRole().toLowerCase();
            Message message = switch (role) {
                case "user" -> new UserMessage(chatMessage.getContent(),
                        originFileResourceService.fromResourceId(chatMessage.getResourceIds()));
                case "system" -> new SystemMessage(chatMessage.getContent());
                case "assistant" -> new AssistantMessage(chatMessage.getContent());
                default -> throw new BusinessException(CoreCode.SYSTEM_ERROR, "未知消息类型");
            };
            return message;
        }).toList();
    }

    @Override
    public List<ChatMessage> fromMessage(List<Message> messages) {
        List<ChatMessage> result = new ArrayList<>();
        int seq = 1;
        for (Message message : messages) {
            ChatMessage chatMessage = new ChatMessage();
            chatMessage.setMessageNo(seq++);
            chatMessage.setContent(message.getText());

            String role;
            boolean hasMedia = false;
            if (message instanceof UserMessage userMessage) {
                role = "user";
                hasMedia = userMessage.getMedia() != null && !userMessage.getMedia().isEmpty();
            } else if (message instanceof AssistantMessage) {
                role = "assistant";
            } else if (message instanceof SystemMessage) {
                role = "system";
            } else {
                role = "unknown";
            }
            chatMessage.setRole(role);
            chatMessage.setHasMedia(hasMedia);
            chatMessage.setResourceIds(new ArrayList<>());
            chatMessage.setIsClean(false);
            result.add(chatMessage);
        }
        return result;
    }

}
