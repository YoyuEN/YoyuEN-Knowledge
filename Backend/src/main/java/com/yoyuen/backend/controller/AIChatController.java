package com.yoyuen.backend.controller;

import com.yoyuen.backend.controller.vo.ChatMessageVO;
import com.yoyuen.backend.service.ai.AIChatService;
import lombok.RequiredArgsConstructor;
import org.springframework.ai.chat.model.ChatResponse;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import reactor.core.publisher.Flux;

/**
 * @Author: YoyuEN
 * @Date: 2026/2/12
 * @Time: 17:48
 * @Description:
 */
@RestController
@RequestMapping("/ai")
@RequiredArgsConstructor
public class AIChatController {

    private final AIChatService chatService;

    @PostMapping("/chat/simple")
    public Flux<ChatResponse> chat(@RequestBody ChatMessageVO chatMessageVO) {
        return chatService.simpleChat(chatMessageVO);
    }
}
