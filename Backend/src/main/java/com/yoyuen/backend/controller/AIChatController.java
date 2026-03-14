package com.yoyuen.backend.controller;

import com.yoyuen.backend.controller.vo.ChatMessageVO;
import com.yoyuen.backend.controller.vo.ChatRequestVO;
import com.yoyuen.backend.controller.vo.ChatResponseWithReferencesVO;
import com.yoyuen.backend.controller.vo.KnowledgeBaseVO;
import com.yoyuen.backend.service.ai.AIChatService;
import com.yoyuen.backend.service.ai.KnowledgeBaseService;
import com.yoyuen.backend.service.ai.impl.AIChatServiceImpl;
import lombok.RequiredArgsConstructor;
import org.springframework.ai.chat.model.ChatResponse;
import org.springframework.ai.chat.model.Generation;
import org.springframework.beans.BeanUtils;
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

    private final AIChatServiceImpl chatServiceImpl;

    private final KnowledgeBaseService knowledgeBaseService;

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
        List<KnowledgeBaseVO> knowledgeBaseList = knowledgeBaseService.KnowledgeList();
        List<String> knowledgeBaseIds = knowledgeBaseList.stream().map(KnowledgeBaseVO::getId).toList();
        chatRequestVO.setKnowledgeIds(knowledgeBaseIds);
        return chatService.unifyChat(chatRequestVO).map(ChatResponse::getResult).flatMapSequential(Flux::just);
    }

    @PostMapping(value = "/chat/simpleRAGWithReferences", produces = MediaType.TEXT_EVENT_STREAM_VALUE)
    public Flux<ChatResponseWithReferencesVO> simpleRagChatWithReferences(@RequestBody @Valid ChatRequestVO chatRequestVO) {
        List<String> knowledgeBaseIds;

        // 如果前端指定了知识库ID，只使用该知识库；否则使用所有知识库
        if (chatRequestVO.getKnowledgeBaseId() != null && !chatRequestVO.getKnowledgeBaseId().isEmpty()) {
            knowledgeBaseIds = List.of(chatRequestVO.getKnowledgeBaseId());
        } else {
            List<KnowledgeBaseVO> knowledgeBaseList = knowledgeBaseService.KnowledgeList();
            knowledgeBaseIds = knowledgeBaseList.stream().map(KnowledgeBaseVO::getId).toList();
        }

        ChatMessageVO chatMessageVO = new ChatMessageVO();
        BeanUtils.copyProperties(chatRequestVO, chatMessageVO);

        return chatServiceImpl.simpleRAGChatWithReferences(chatMessageVO, knowledgeBaseIds);
    }
}
