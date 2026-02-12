package com.yoyuen.backend.model.ai;

import com.baomidou.mybatisplus.annotation.TableName;
import com.yoyuen.backend.pojo.BaseEntity;
import lombok.Data;
import lombok.EqualsAndHashCode;

/**
 * @Author: YoyuEN
 * @Date: 2026/2/12
 * @Time: 9:54
 * @Description:
 */
@Data
@EqualsAndHashCode(callSuper = true)
@TableName("chat_conversation")
public class ChatConversation extends BaseEntity {
    private String id;
    /*
    * 系统提示词 标题
    * */
    private String title;
    /*
    * 对话人
    * */
    private Long userId;
}
