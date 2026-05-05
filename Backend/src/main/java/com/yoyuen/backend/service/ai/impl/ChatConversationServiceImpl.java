package com.yoyuen.backend.service.ai.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.yoyuen.backend.controller.vo.ChatConversationVO;
import com.yoyuen.backend.controller.vo.ChatMessageVO;
import com.yoyuen.backend.controller.vo.ResourceVO;
import com.yoyuen.backend.mapper.ChatConversationMapper;
import com.yoyuen.backend.mapper.ChatMessageMapper;
import com.yoyuen.backend.model.entity.ai.ChatConversation;
import com.yoyuen.backend.model.entity.ai.ChatMessage;
import com.yoyuen.backend.service.ai.ChatConversationService;
import com.yoyuen.backend.service.ai.OriginFileResourceService;
import com.yoyuen.backend.utils.SecurityFrameworkUtil;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.BeanUtils;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.ArrayList;
import java.util.List;

/**
 * @Author: YoyuEN
 * @Date: 2026/2/12
 * @Time: 13:09
 * @Description:
 */
@Slf4j
@Service
@RequiredArgsConstructor
public class ChatConversationServiceImpl extends ServiceImpl<ChatConversationMapper, ChatConversation>
        implements ChatConversationService {

    private final ChatMessageMapper chatMessageMapper;

    private final OriginFileResourceService originFileResourceService;

    @Override
    public ChatConversationVO getConversation(String conversationId) {
        ChatConversation chatConversation = this.getById(conversationId);
        return transferChatConversation(List.of(chatConversation)).get(0);
    }

    @Transactional(rollbackFor = Exception.class)
    @Override
    public ChatConversationVO createConversation(ChatConversationVO conversation) {
        String title = conversation.getTitle();
        if (title.length() > 16) {
            title = title.substring(0, 16);
        }
        ChatConversation chatConversation = new ChatConversation();
        chatConversation.setTitle(title);
        chatConversation.setKnowledgeBaseId(conversation.getKnowledgeBaseId());
        chatConversation.setUserId(SecurityFrameworkUtil.getCurrUserIdOrNull());
        this.saveOrUpdate(chatConversation);
        ChatConversationVO chatConversationVO = new ChatConversationVO();
        chatConversationVO.setId(chatConversation.getId());
        chatConversationVO.setCreateTime(chatConversation.getCreateTime());
        chatConversationVO.setTitle(title);
        chatConversationVO.setKnowledgeBaseId(chatConversation.getKnowledgeBaseId());
        chatConversationVO.setMessages(new ArrayList<>());
        return chatConversationVO;
    }

    @Override
    public List<ChatConversationVO> listConversation() {
        Long userId = SecurityFrameworkUtil.getCurrUserIdOrNull();
        if (userId == null) {
            return new ArrayList<>();
        }
        LambdaQueryWrapper<ChatConversation> qw = new LambdaQueryWrapper<>();
        qw.orderByDesc(ChatConversation::getCreateTime);
        qw.eq(ChatConversation::getUserId, userId);
        qw.last(" LIMIT 30");
        List<ChatConversation> list = this.list(qw);
        return transferChatConversation(list);
    }

    @Override
    public List<ChatConversationVO> listConversationsByKnowledgeBase(String knowledgeBaseId) {
        Long userId = SecurityFrameworkUtil.getCurrUserIdOrNull();
        if (userId == null) {
            return new ArrayList<>();
        }
        LambdaQueryWrapper<ChatConversation> qw = new LambdaQueryWrapper<>();
        qw.orderByDesc(ChatConversation::getCreateTime);
        qw.eq(ChatConversation::getUserId, userId);
        if (knowledgeBaseId != null && !knowledgeBaseId.isEmpty()) {
            qw.eq(ChatConversation::getKnowledgeBaseId, knowledgeBaseId);
        }
        qw.last(" LIMIT 30");
        List<ChatConversation> list = this.list(qw);
        return transferChatConversation(list);
    }

    @Transactional(rollbackFor = Exception.class)
    @Override
    public Boolean removeConversation(String conversationId) {
        return this.removeById(conversationId);
    }

    public List<ChatConversationVO> transferChatConversation(List<ChatConversation> chatConversations) {
        return chatConversations.stream().map(item -> {
            LambdaQueryWrapper<ChatMessage> qw = new LambdaQueryWrapper<>();
            qw.eq(ChatMessage::getConversationId, item.getId());
            qw.orderByAsc(ChatMessage::getCreateTime);
            List<ChatMessage> chatMessages = chatMessageMapper.selectList(qw);
            List<ChatMessageVO> chatMessageVOS = this.transferChatMessage(chatMessages);

            ChatConversationVO chatConversationVO = new ChatConversationVO();
            chatConversationVO.setId(item.getId());
            chatConversationVO.setTitle(item.getTitle());
            chatConversationVO.setKnowledgeBaseId(item.getKnowledgeBaseId());
            chatConversationVO.setCreateTime(item.getCreateTime());
            chatConversationVO.setMessages(chatMessageVOS);
            return chatConversationVO;
        }).toList();
    }

    public List<ChatMessageVO> transferChatMessage(List<ChatMessage> chatMessages) {
        return chatMessages.stream().map(item -> {
            ChatMessageVO chatMessageVO = new ChatMessageVO();
            BeanUtils.copyProperties(item, chatMessageVO);
            List<String> resourceIds = item.getResourceIds();
            List<ResourceVO> resourceVOS = originFileResourceService.resourcesFromIds(resourceIds);
            chatMessageVO.setResources(resourceVOS);
            return chatMessageVO;
        }).toList();
    }

}
