package com.yoyuen.backend.service.ai.impl;

import com.yoyuen.backend.controller.vo.ChatMessageVO;
import com.yoyuen.backend.service.ai.AIChatService;
import org.springframework.ai.chat.model.ChatResponse;
import reactor.core.publisher.Flux;

/**
 * @Author: YoyuEN
 * @Date: 2026/2/12
 * @Time: 9:53
 * @Description:
 */
public class AIChatServiceImpl implements AIChatService {
    @Override
    public Flux<ChatResponse> simpleChat(String message) {
        return null;
    }

    @Override
    public Flux<ChatResponse> ragChat(ChatMessageVO chatMessageVO, String baseId) {
        return null;
    }
}
