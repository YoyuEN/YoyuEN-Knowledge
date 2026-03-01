package com.yoyuen.backend.service.ai.impl;

import com.yoyuen.backend.service.ai.LLMService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.ai.autoconfigure.vectorstore.pgvector.PgVectorStoreProperties;
import org.springframework.ai.chat.model.ChatModel;
import org.springframework.ai.document.MetadataMode;
import org.springframework.ai.embedding.EmbeddingModel;
import org.springframework.ai.openai.OpenAiChatModel;
import org.springframework.ai.openai.OpenAiChatOptions;
import org.springframework.ai.openai.OpenAiEmbeddingModel;
import org.springframework.ai.openai.OpenAiEmbeddingOptions;
import org.springframework.ai.openai.api.OpenAiApi;
import org.springframework.ai.vectorstore.PgVectorStore;
import org.springframework.ai.vectorstore.VectorStore;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Service;

/**
 * @Author: YoyuEN
 * @Date: 2026/2/13
 * @Time: 13:46
 * @Description:
 */
@Service
@Slf4j
@RequiredArgsConstructor
public class LLMServiceImpl implements LLMService {

    @Value("${chat.simple.base-url}")
    private String simpleBaseUrl;

    @Value("${chat.simple.api-key}")
    private String simpleApiKey;

    @Value("${chat.simple.model}")
    private String simpleModel;

    @Value("${chat.long.base-url}")
    private String longBaseUrl;

    @Value("${chat.long.api-key}")
    private String longApiKey;

    @Value("${chat.long.model}")
    private String longModel;

    @Value("${chat.multimodal.base-url}")
    private String multimodalBaseUrl;

    @Value("${chat.multimodal.api-key}")
    private String multimodalApiKey;

    @Value("${chat.multimodal.model}")
    private String multimodalModel;

    @Value("${embedding.base-url}")
    private String embeddingBaseUrl;

    @Value("${embedding.api-key}")
    private String embeddingApiKey;

    @Value("${embedding.model}")
    private String embeddingModel;

    private final JdbcTemplate jdbcTemplate;

    private final PgVectorStoreProperties pgVectorStoreProperties;

    @Override
    public ChatModel getChatModel() {
        OpenAiApi openAiApi = new OpenAiApi(simpleBaseUrl, simpleApiKey);
        return new OpenAiChatModel(openAiApi, OpenAiChatOptions.builder()
                .withModel(simpleModel)
                .build());
    }

    @Override
    public ChatModel getLongContextChatModel() {
        OpenAiApi openAiApi = new OpenAiApi(longBaseUrl, longApiKey);
        return new OpenAiChatModel(openAiApi, OpenAiChatOptions.builder()
                .withModel(longModel)
                .build());
    }

    @Override
    public ChatModel getMultimodalModel() {
        OpenAiApi openAiApi = new OpenAiApi(multimodalBaseUrl, multimodalApiKey);
        return new OpenAiChatModel(openAiApi, OpenAiChatOptions.builder()
                .withModel(multimodalModel)
                .build());
    }

    @Override
    public EmbeddingModel getEmbeddingModel() {
        OpenAiApi openAiApi = new OpenAiApi(embeddingBaseUrl, embeddingApiKey);
        return new OpenAiEmbeddingModel(openAiApi, MetadataMode.EMBED,
                OpenAiEmbeddingOptions.builder()
                        .withModel(embeddingModel)
                        .build());
    }

    @Override
    public VectorStore getVectorStore() {
        return new PgVectorStore(
                jdbcTemplate,
                this.getEmbeddingModel(),
                pgVectorStoreProperties.getDimensions(),
                pgVectorStoreProperties.getDistanceType(),
                pgVectorStoreProperties.isRemoveExistingVectorStoreTable(),
                pgVectorStoreProperties.getIndexType(),
                pgVectorStoreProperties.isInitializeSchema()
        );
    }
}

