package com.yoyuen.backend.controller.vo;

import lombok.Data;

import javax.validation.constraints.NotNull;
import java.util.List;

/**
 * @Author: YoyuEN
 * @Date: 2026/2/24
 * @Time: 0:22
 * @Description:
 */
@Data
public class ChatRequestVO {

    @NotNull(message = "对话ID不能为空")
    private String conversationId;

    @NotNull(message = "对话内容不能为空")
    private String content;

    private List<String> resourceIds;

    private List<String> knowledgeIds;

    private String knowledgeBaseId;

    @NotNull(message = "对话类型不能为空")
    private String chatType;

}
