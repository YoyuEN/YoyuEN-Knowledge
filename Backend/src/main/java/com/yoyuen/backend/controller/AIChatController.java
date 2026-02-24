package com.yoyuen.backend.controller;

import com.yoyuen.backend.controller.vo.ChatMessageVO;
import com.yoyuen.backend.controller.vo.ChatRequestVO;
import com.yoyuen.backend.service.ai.AIChatService;
import lombok.RequiredArgsConstructor;
import org.springframework.ai.chat.model.ChatResponse;
import org.springframework.ai.chat.model.Generation;
import org.springframework.http.MediaType;
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

    @PostMapping(value = "/chat/simple", produces = MediaType.TEXT_EVENT_STREAM_VALUE)
    public Flux<ChatResponse> chat(@RequestBody ChatMessageVO chatMessageVO) {
        return chatService.simpleChat(chatMessageVO);
    }

    @PostMapping(value = "/chat/unify", produces = MediaType.TEXT_EVENT_STREAM_VALUE)
    public Flux<Generation> unifyChat(@RequestBody ChatRequestVO chatRequestVO) {
        return chatService.unifyChat(chatRequestVO).map(ChatResponse::getResult).flatMapSequential(Flux::just);
    }
}
