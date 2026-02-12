package com.yoyuen.backend.service.ai;

import com.baomidou.mybatisplus.extension.service.IService;
import com.yoyuen.backend.controller.vo.ChatConversationVO;
import com.yoyuen.backend.model.ai.ChatConversation;

/**
 * @Author: YoyuEN
 * @Date: 2026/2/12
 * @Time: 9:53
 * @Description:
 */
public interface ChatConversationService extends IService<ChatConversation> {
    /*
    * 获取对话记录
    * @Param: conversationId
    * @reture
    * */
    ChatConversationVO getConversation(String conversationId);

    /*
    * 创建对话
    * @Param:
    * @reture
    * */
    ChatConversationVO createConversation(ChatConversationVO chatConversationVO);
}
