package com.yoyuen.backend.service.ai;

import org.springframework.ai.chat.model.ChatModel;
import org.springframework.ai.embedding.EmbeddingModel;
import org.springframework.ai.vectorstore.VectorStore;

/**
 * @Author: YoyuEN
 * @Date: 2026/2/12
 * @Time: 17:40
 * @Description:
 */
public interface LLMService {

    /*
    * 获取对话模型
    * */
    ChatModel getChatModel();

    /*
    * 获取超长上下文对话模型
    * */
    ChatModel getLongContextChatModel();

    /*
    * 获取多模态对话模型
    * */
    ChatModel getMultimodalModel();

    /*
    * 向量化模型
    * */
    EmbeddingModel getEmbeddingModel();

    /*
    * 获取向量存储模型
    * */
    VectorStore getVectorStore();
}
