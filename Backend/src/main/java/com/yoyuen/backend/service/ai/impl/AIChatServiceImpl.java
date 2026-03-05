package com.yoyuen.backend.service.ai.impl;

import com.yoyuen.backend.chat.MessageChatMemoryAdvisor;
import com.yoyuen.backend.controller.vo.ChatMessageVO;
import com.yoyuen.backend.controller.vo.ChatRequestVO;
import com.yoyuen.backend.controller.vo.ChatResponseWithReferencesVO;
import com.yoyuen.backend.exception.BusinessException;
import com.yoyuen.backend.mapper.DocumentEntityMapper;
import com.yoyuen.backend.mapper.KnowledgeBaseMapper;
import com.yoyuen.backend.model.entity.ai.DocumentEntity;
import com.yoyuen.backend.model.entity.ai.KnowledgeBase;
import com.yoyuen.backend.model.enums.ChatType;
import com.yoyuen.backend.service.ai.AIChatService;
import com.yoyuen.backend.service.ai.LLMService;
import com.yoyuen.backend.service.ai.OriginFileResourceService;
import com.yoyuen.backend.service.system.CommentService;
import com.yoyuen.backend.service.system.ContentService;
import com.yoyuen.backend.entity.Comment;
import com.yoyuen.backend.entity.Content;
import com.yoyuen.backend.utils.CoreCode;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.ai.chat.client.ChatClient;
import org.springframework.ai.chat.client.advisor.QuestionAnswerAdvisor;
import org.springframework.ai.chat.client.advisor.SimpleLoggerAdvisor;
import org.springframework.ai.chat.model.ChatModel;
import org.springframework.ai.chat.model.ChatResponse;
import org.springframework.ai.chat.prompt.PromptTemplate;
import org.springframework.ai.document.Document;
import org.springframework.ai.model.Media;
import org.springframework.ai.vectorstore.SearchRequest;
import org.springframework.ai.vectorstore.filter.Filter;
import org.springframework.ai.vectorstore.filter.FilterExpressionBuilder;
import org.springframework.beans.BeanUtils;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.core.io.Resource;
import org.springframework.stereotype.Service;
import reactor.core.publisher.Flux;

import java.util.*;

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

    private final DocumentEntityMapper documentEntityMapper;

    private final KnowledgeBaseMapper knowledgeBaseMapper;

    private final ContentService contentService;

    private final CommentService commentService;

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
    private Filter.Expression buildBaseAccessFilter(List<String> knowledgeBaseIds) {
        FilterExpressionBuilder b = new FilterExpressionBuilder();

        // 如果没有 ID，返回一个不匹配任何内容的表达式
        if (knowledgeBaseIds == null || knowledgeBaseIds.isEmpty()) {
            log.info("Vector Search Filter: knowledge_base_id in [\"___empty___\"]");
            return b.in("knowledge_base_id", "___empty___").build();
        }

        log.info("Vector Search Filter: knowledge_base_id in {}", knowledgeBaseIds);
        return b.in("knowledge_base_id", knowledgeBaseIds.toArray(new String[0])).build();
    }

    /**
     * 从检索到的文档中提取引用信息
     */
    private List<ChatResponseWithReferencesVO.DocumentReferenceVO> extractReferences(List<Document> documents) {
        Set<Long> documentIds = new HashSet<>();
        List<ChatResponseWithReferencesVO.DocumentReferenceVO> references = new ArrayList<>();

        for (Document doc : documents) {
            Map<String, Object> metadata = doc.getMetadata();

            // 过滤低相似度的文档（只保留相关性高的）
            if (metadata.containsKey("distance")) {
                try {
                    double distance = Double.parseDouble(metadata.get("distance").toString());
                    // 距离越小越相似，这里设置阈值为0.5（可根据实际情况调整）
                    if (distance > 0.5) {
                        log.debug("跳过低相似度文档，distance={}", distance);
                        continue;
                    }
                } catch (Exception e) {
                    log.warn("解析distance失败: {}", e.getMessage());
                }
            }

            if (metadata.containsKey("document_id")) {
                try {
                    Long docId = Long.parseLong(metadata.get("document_id").toString());
                    if (!documentIds.contains(docId)) {
                        documentIds.add(docId);

                        DocumentEntity documentEntity = documentEntityMapper.selectById(docId);
                        if (documentEntity != null) {
                            KnowledgeBase knowledgeBase = knowledgeBaseMapper.selectById(documentEntity.getBaseId());

                            ChatResponseWithReferencesVO.DocumentReferenceVO ref = new ChatResponseWithReferencesVO.DocumentReferenceVO();
                            ref.setDocumentId(docId);
                            ref.setDocumentName(documentEntity.getFileName());
                            ref.setKnowledgeBaseId(documentEntity.getBaseId());
                            ref.setKnowledgeBaseName(knowledgeBase != null ? knowledgeBase.getName() : "未知知识库");

                            // 从metadata中提取内容类型和ID
                            if (metadata.containsKey("content_type")) {
                                ref.setContentType(metadata.get("content_type").toString());
                            }
                            if (metadata.containsKey("content_id")) {
                                String contentId = metadata.get("content_id").toString();
                                ref.setContentId(contentId);

                                // 根据内容类型查询详细信息
                                if ("article".equals(ref.getContentType())) {
                                    Content content = contentService.getById(contentId);
                                    if (content != null) {
                                        ref.setTitle(content.getTitle());
                                        ref.setAuthor(content.getCreator());
                                        ref.setPublishTime(content.getCreateTime() != null ?
                                            content.getCreateTime().toString() : null);
                                    }
                                } else if ("comment".equals(ref.getContentType())) {
                                    Comment comment = commentService.getById(contentId);
                                    if (comment != null) {
                                        ref.setTitle(comment.getContent().length() > 30 ?
                                            comment.getContent().substring(0, 30) + "..." :
                                            comment.getContent());
                                        ref.setAuthor(comment.getAuthor());
                                        ref.setPublishTime(comment.getCreateTime() != null ?
                                            comment.getCreateTime().toString() : null);
                                    }
                                }
                            }
                            if (metadata.containsKey("article_id")) {
                                ref.setArticleId(metadata.get("article_id").toString());
                            }

                            references.add(ref);
                        }
                    }
                } catch (Exception e) {
                    log.warn("Failed to extract document reference: {}", e.getMessage());
                }
            }
        }

        return references;
    }

    /**
     * 带引用信息的RAG对话
     */
    public Flux<ChatResponseWithReferencesVO> simpleRAGChatWithReferences(ChatMessageVO chatMessageVO, List<String> baseIds) {
        ChatModel chatModel = llmService.getChatModel();
        ChatClient chatClient = ChatClient.builder(chatModel).build();
        PromptTemplate template = new PromptTemplate(ragPromptResource);
        String ragTemplate = template.getTemplate();

        // 向量查询条件
        SearchRequest searchRequest = SearchRequest.defaults()
                .withTopK(RAG_TOP_K)
                .withQuery(chatMessageVO.getContent())
                .withFilterExpression(buildBaseAccessFilter(baseIds));

        // 先执行向量检索获取引用文档
        List<Document> retrievedDocs = llmService.getVectorStore().similaritySearch(searchRequest);
        List<ChatResponseWithReferencesVO.DocumentReferenceVO> references = extractReferences(retrievedDocs);

        // 执行RAG对话
        Flux<ChatResponse> chatResponseFlux = chatClient.prompt().user(user -> {
                    user.param(CHAT_CONVERSATION_NAME, chatMessageVO.getConversationId());
                    user.text(chatMessageVO.getContent());
                })
                .advisors(new SimpleLoggerAdvisor(),
                        new QuestionAnswerAdvisor(llmService.getVectorStore(), searchRequest, ragTemplate),
                        new MessageChatMemoryAdvisor(databaseChatMemory, chatMessageVO.getConversationId(), CHAT_MAX_LENGTH)
                )
                .stream()
                .chatResponse();

        // 转换为带引用信息的响应
        return chatResponseFlux.map(chatResponse -> {
            ChatResponseWithReferencesVO vo = new ChatResponseWithReferencesVO();
            vo.setContent(chatResponse.getResult().getOutput().getContent());
            vo.setFinishReason(chatResponse.getResult().getMetadata().getFinishReason());
            vo.setReferences(references);
            return vo;
        });
    }
}
