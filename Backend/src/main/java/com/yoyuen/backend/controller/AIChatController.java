package com.yoyuen.backend.controller;

import com.yoyuen.backend.controller.vo.ChatMessageVO;
import com.yoyuen.backend.controller.vo.ChatRequestVO;
import com.yoyuen.backend.service.ai.AIChatService;
import lombok.RequiredArgsConstructor;
import org.springframework.ai.chat.model.ChatResponse;
import org.springframework.ai.chat.model.Generation;
import org.springframework.http.MediaType;
import jakarta.validation.Valid;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import reactor.core.publisher.Flux;

import java.util.List;

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
    public Flux<Generation> unifyChat(@RequestBody @Valid ChatRequestVO chatRequestVO) {
        return chatService.unifyChat(chatRequestVO).map(ChatResponse::getResult).flatMapSequential(Flux::just);
    }

    @PostMapping(value = "/chat/simpleRAG", produces = MediaType.TEXT_EVENT_STREAM_VALUE)
    public Flux<Generation> simpleRagChat(@RequestBody @Valid ChatRequestVO chatRequestVO) {
        chatRequestVO.setChatType("simpleRAG");
        List<String> knowledgeBaseIds = List.of(new String[]{"c9b183601b6ea2289a134316c3e70e92"});
        chatRequestVO.setKnowledgeIds(knowledgeBaseIds);
        return chatService.unifyChat(chatRequestVO).map(ChatResponse::getResult).flatMapSequential(Flux::just);
    }
}
