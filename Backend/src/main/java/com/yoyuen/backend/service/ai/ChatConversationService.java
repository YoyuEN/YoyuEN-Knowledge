package com.yoyuen.backend.service.ai;

import com.baomidou.mybatisplus.extension.service.IService;
import com.yoyuen.backend.controller.vo.ChatConversationVO;
import com.yoyuen.backend.model.entity.ai.ChatConversation;

import java.util.List;

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

    /*
    * 用户的对话列表
    * */
    List<ChatConversationVO> listConversation();

    /*
    * 删除对话记录
    * */
    Boolean removeConversation(String conversationId);
}
