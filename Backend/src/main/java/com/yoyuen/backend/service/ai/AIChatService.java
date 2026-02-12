package com.yoyuen.backend.service.ai;


//import reactor.core.publisher.Flux;

import com.yoyuen.backend.controller.vo.ChatMessageVO;
import org.springframework.ai.chat.model.ChatResponse;
import reactor.core.publisher.Flux;

/**
 * @Author: YoyuEN
 * @Date: 2026/2/10
 * @Time: 18:42
 * @Description:
 */
public interface AIChatService {

    /*
    * 简单的流式对话
    * @Param: chatMessageVO
    * @reture
    * */
    Flux<ChatResponse> simpleChat(String message);

    /*
    * RAG 对话
    * @Param:
    * @reture
    * */
    Flux<ChatResponse> ragChat(ChatMessageVO chatMessageVO, String baseId);

}
