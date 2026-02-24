package com.yoyuen.backend.service.ai.impl;

import com.yoyuen.backend.controller.vo.ChatMessageVO;
import com.yoyuen.backend.controller.vo.ChatRequestVO;
import com.yoyuen.backend.exception.BusinessException;
import com.yoyuen.backend.model.entity.user.SystemUser;
import com.yoyuen.backend.model.enums.ChatType;
import com.yoyuen.backend.service.ai.AIChatService;
import com.yoyuen.backend.service.ai.LLMService;
import com.yoyuen.backend.service.ai.OriginFileResourceService;
import com.yoyuen.backend.utils.CoreCode;
import com.yoyuen.backend.utils.SecurityFrameworkUtil;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.ai.chat.client.ChatClient;
import org.springframework.ai.chat.client.advisor.MessageChatMemoryAdvisor;
import org.springframework.ai.chat.client.advisor.QuestionAnswerAdvisor;
import org.springframework.ai.chat.client.advisor.SimpleLoggerAdvisor;
import org.springframework.ai.chat.model.ChatModel;
import org.springframework.ai.chat.model.ChatResponse;
import org.springframework.ai.chat.prompt.PromptTemplate;
import org.springframework.ai.model.Media;
import org.springframework.ai.vectorstore.SearchRequest;
import org.springframework.beans.BeanUtils;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.core.io.Resource;
import org.springframework.stereotype.Service;
import reactor.core.publisher.Flux;

import java.util.HashMap;
import java.util.List;

import static com.yoyuen.backend.constant.AppConstant.*;

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

    private final LLMService llmService;

    private final OriginFileResourceService originFileResourceService;

    private final DatabaseChatMemory databaseChatMemory;

    @Value("classpath:prompt/RAG.txt")
    private Resource ragPromptResource;

    @Override
    public Flux<ChatResponse> simpleChat(ChatMessageVO chatMessageVO) {
        ChatModel chatModel = llmService.getChatModel();
        // 构建Meta信息
        ChatClient chatClient = ChatClient.builder(chatModel).build();

        return chatClient.prompt().user(user -> {
                    user.param(CHAT_CONVERSATION_NAME, chatMessageVO.getConversationId());
                    user.text(chatMessageVO.getContent());
                })
                .advisors(new MessageChatMemoryAdvisor(databaseChatMemory, chatMessageVO.getConversationId(), CHAT_MAX_LENGTH))
                .stream()
                .chatResponse();
    }

    @Override
    public Flux<ChatResponse> multimodalChat(ChatMessageVO chatMessageVO) {
        ChatModel chatModel = llmService.getMultimodalModel();
        List<String> resourceIds = chatMessageVO.getResourceIds();
        ChatClient chatClient = ChatClient.builder(chatModel).build();
        return chatClient.prompt().user(user -> {
                    HashMap<String, Object> params = new HashMap<>();
                    params.put(CHAT_CONVERSATION_NAME, chatMessageVO.getConversationId());
                    params.put(CHAT_MEDIAS, chatMessageVO.getResourceIds());
                    user.params(params);
                    user.text(chatMessageVO.getContent());
                    log.info("params:{}", params);
                    if (resourceIds != null && !resourceIds.isEmpty()) {
                        List<Media> medias = originFileResourceService.fromResourceId(resourceIds);
                        user.media(medias.toArray(new Media[0]));
                    }
                })
                .advisors(new SimpleLoggerAdvisor(),
                        new MessageChatMemoryAdvisor(databaseChatMemory, chatMessageVO.getConversationId(), CHAT_MAX_LENGTH))
                .stream()
                .chatResponse();
    }

    @Override
    public Flux<ChatResponse> simpleRAGChat(ChatMessageVO chatMessageVO, List<String> baseIds) {
        ChatModel chatModel = llmService.getChatModel();
        // 构建Meta信息
        ChatClient chatClient = ChatClient.builder(chatModel).build();
        PromptTemplate template = new PromptTemplate(ragPromptResource);
        String ragTemplate = template.getTemplate();

        // 向量查询条件
        SearchRequest searchRequest = SearchRequest.defaults()
                .withTopK(RAG_TOP_K)
                .withQuery(chatMessageVO.getContent())
                .withFilterExpression(buildBaseAccessFilter(baseIds));

        return chatClient.prompt().user(user -> {
                    user.param(CHAT_CONVERSATION_NAME, chatMessageVO.getConversationId());
                    user.text(chatMessageVO.getContent());
                })
                .advisors(new SimpleLoggerAdvisor(),
                        new QuestionAnswerAdvisor(llmService.getVectorStore(), searchRequest, ragTemplate),
                        new MessageChatMemoryAdvisor(databaseChatMemory, chatMessageVO.getConversationId(), CHAT_MAX_LENGTH)
                )
                .stream()
                .chatResponse();
    }

    @Override
    public Flux<ChatResponse> multimodalRAGChat(ChatMessageVO chatMessageVO, List<String> baseIds) {
        throw new BusinessException(CoreCode.SYSTEM_ERROR, "多模态RAG对话功能暂未实现");
    }

    @Override
    public Flux<ChatResponse> unifyChat(ChatRequestVO chatRequestVO) {
        String chatType = chatRequestVO.getChatType();
        ChatMessageVO chatMessageVO = new ChatMessageVO();
        BeanUtils.copyProperties(chatRequestVO, chatMessageVO);
        ChatType type = ChatType.parse(chatType);
        return switch (type) {
            case SIMPLE -> this.simpleChat(chatMessageVO);
            case SIMPLE_RAG -> this.simpleRAGChat(chatMessageVO, chatRequestVO.getKnowledgeIds());
            case MULTIMODAL -> this.multimodalChat(chatMessageVO);
            case MULTIMODAL_RAG -> this.multimodalRAGChat(chatMessageVO, chatRequestVO.getKnowledgeIds());
            default -> throw new BusinessException(CoreCode.PARAMS_ERROR, "未知的对话类型");
        };
    }

    // meta ==> { "user_id"、"knowledge_base_id"、"document_id"}
    private String buildBaseAccessFilter(List<String> knowledgeBaseIds) {
//        SystemUser user = SecurityFrameworkUtil.getLoginUser();

        // 如果没有 ID，返回一个 false 的表达式
        if (knowledgeBaseIds == null || knowledgeBaseIds.isEmpty()) {
            return "knowledge_base_id in [\"___empty___\"]"; // 不让查询任何知识库
        }
        StringBuilder sb = new StringBuilder();
        sb.append("knowledge_base_id in [");
        for (int i = 0; i < knowledgeBaseIds.size(); i++) {
            if (i != 0) {
                sb.append(",");
            }
            sb.append("\"").append(knowledgeBaseIds.get(i)).append("\"");
        }
        sb.append("]");
        log.info("Vector Search Filter SQL: {}", sb);
        log.info("Vector Search Filter Parameter: {}", knowledgeBaseIds);
        return sb.toString();
    }

}
