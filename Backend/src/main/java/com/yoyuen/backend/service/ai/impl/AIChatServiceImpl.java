package com.yoyuen.backend.service.ai.impl;

import com.yoyuen.backend.controller.vo.ChatMessageVO;
import com.yoyuen.backend.service.ai.AIChatService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.ai.chat.model.ChatModel;
import org.springframework.ai.chat.model.ChatResponse;
import org.springframework.ai.chat.prompt.Prompt;
import org.springframework.stereotype.Service;
import reactor.core.publisher.Flux;

/**
 * @Author: YoyuEN
 * @Date: 2026/2/12
 * @Time: 9:53
 * @Description:
 */
@Slf4j
@Service
@RequiredArgsConstructor
public class AIChatServiceImpl implements AIChatService {

    private final ChatModel chatModel;

    @Override
    public Flux<ChatResponse> simpleChat(ChatMessageVO chatMessageVO) {
        log.info("simpleChat request: {}", chatMessageVO.getContent());
        Prompt prompt = new Prompt(chatMessageVO.getContent());
        return chatModel.stream(prompt);
    }

    @Override
    public Flux<ChatResponse> ragChat(ChatMessageVO chatMessageVO, String baseId) {
        return null;
    }
}
