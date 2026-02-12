package com.yoyuen.backend.service.ai;

import com.baomidou.mybatisplus.extension.service.IService;
import com.yoyuen.backend.model.ai.ChatMessage;
import org.springframework.ai.chat.messages.Message;

import java.util.List;

/**
 * @Author: YoyuEN
 * @Date: 2026/2/12
 * @Time: 11:36
 * @Description:
 */
public interface ChatMessageService extends IService<ChatMessage> {
    /*
    * 将ChatMessage转换为Spring AI的Message
    * @Param:
    * @reture
    * */
    List<Message> toMessage(List<ChatMessage> chatMessages);

    /*
    * 将Spring AI的Message转换为ChatMessage
    * @Param:
    * @reture
    * */
    List<ChatMessage> fromMessage(List<Message> messages);
}
