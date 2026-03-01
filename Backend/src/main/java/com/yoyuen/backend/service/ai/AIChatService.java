package com.yoyuen.backend.service.ai;


//import reactor.core.publisher.Flux;

import com.yoyuen.backend.controller.vo.ChatMessageVO;
import com.yoyuen.backend.controller.vo.ChatRequestVO;
import org.springframework.ai.chat.model.ChatResponse;
import reactor.core.publisher.Flux;

import java.util.List;

/**
 * @Author: YoyuEN
 * @Date: 2026/2/10
 * @Time: 18:42
 * @Description:
 */
public interface AIChatService {

    /**
     * 简单的流式对话
     * @param chatMessageVO
     * @return
     */
    Flux<ChatResponse> simpleChat(ChatMessageVO chatMessageVO);

    /**
     * 多模态对话
     * @param chatMessageVO
     * @return
     */
    Flux<ChatResponse> multimodalChat(ChatMessageVO chatMessageVO);

    /**
     * RAG对话
     * @param chatMessageVO
     * @param baseIds 知识库ID列表
     * @return
     */
    Flux<ChatResponse> simpleRAGChat(ChatMessageVO chatMessageVO, List<String> baseIds);

    /**
     * 多模态的RAG对话
     * @param chatMessageVO
     * @return
     */
    Flux<ChatResponse> multimodalRAGChat(ChatMessageVO chatMessageVO, List<String> baseIds);

    /**
     * 统一接口对话
     * @param chatRequestVO
     * @return
     */
    Flux<ChatResponse> unifyChat(ChatRequestVO chatRequestVO);

}

