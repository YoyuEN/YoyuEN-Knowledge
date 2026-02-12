package com.yoyuen.backend.service.ai.impl;

import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.yoyuen.backend.controller.vo.ChatConversationVO;
import com.yoyuen.backend.mapper.ChatConversationMapper;
import com.yoyuen.backend.model.ai.ChatConversation;
import com.yoyuen.backend.service.ai.ChatConversationService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

/**
 * @Author: YoyuEN
 * @Date: 2026/2/12
 * @Time: 13:09
 * @Description:
 */
@Slf4j
@Service
@RequiredArgsConstructor
public class ChatConversationServiceImpl extends ServiceImpl<ChatConversationMapper, ChatConversation> implements ChatConversationService {
    @Override
    public ChatConversationVO getConversation(String conversationId) {
        return null;
    }

    @Override
    public ChatConversationVO createConversation(ChatConversationVO chatConversationVO) {
        return null;
    }
}
