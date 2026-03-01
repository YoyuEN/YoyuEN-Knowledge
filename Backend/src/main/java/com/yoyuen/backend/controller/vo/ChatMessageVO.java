package com.yoyuen.backend.controller.vo;

import lombok.Data;

import java.util.List;

/**
 * @Author: YoyuEN
 * @Date: 2026/2/12
 * @Time: 9:45
 * @Description:
 */
@Data
public class ChatMessageVO {
    private String id;
    /*
    * 所属对话
    * */
    private String conversationId;
    /*
    * 消息序号
    * */
    private Integer messageNo;
    /*
    * 对话内容
    * */
    private String content;
    /*
    * 角色
    * */
    private String role;

    private List<String> resourceIds;

    /*
    * 资源列表
    * */
    private List<ResourceVO> resources;
}
