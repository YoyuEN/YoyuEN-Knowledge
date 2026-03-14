package com.yoyuen.backend.controller;

import com.yoyuen.backend.controller.vo.ChatConversationVO;
import com.yoyuen.backend.service.ai.ChatConversationService;
import com.yoyuen.backend.utils.BaseResponse;
import com.yoyuen.backend.utils.ResultUtils;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;

/**
 * @Author: YoyuEN
 * @Date: 2026/2/13
 * @Time: 13:28
 * @Description:
 */
@RestController
@RequestMapping("/conversation")
@RequiredArgsConstructor
public class ChatConversationController {

    private final ChatConversationService conversationService;

    @PostMapping("/create")
    public BaseResponse<ChatConversationVO> createConversation(@RequestBody ChatConversationVO chatConversationVO) {
        return ResultUtils.success(conversationService.createConversation(chatConversationVO));
    }

    @GetMapping("/list")
    public BaseResponse<?> listChatConversation(
            @RequestParam(name = "id", required = false) String id,
            @RequestParam(name = "knowledgeBaseId", required = false) String knowledgeBaseId) {
        if (id != null) {
            return ResultUtils.success(conversationService.getConversation(id));
        }
        // 如果传入了 knowledgeBaseId，按知识库过滤对话列表
        return ResultUtils.success(conversationService.listConversationsByKnowledgeBase(knowledgeBaseId));
    }
}
