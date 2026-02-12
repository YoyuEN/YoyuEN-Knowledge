package com.yoyuen.backend.model.ai;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import com.baomidou.mybatisplus.extension.handlers.JacksonTypeHandler;
import com.yoyuen.backend.pojo.BaseEntity;
import lombok.Data;
import lombok.EqualsAndHashCode;

import java.util.ArrayList;
import java.util.List;

/**
 * @Author: YoyuEN
 * @Date: 2026/2/12
 * @Time: 11:36
 * @Description:
 */
@Data
@EqualsAndHashCode(callSuper = true)
@TableName("chat_message")
public class ChatMessage extends BaseEntity {
    /*
    * 聊天信息
    * */
    @TableId(type = IdType.AUTO)
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
    * 角色
    * */
    private String role;
    /*
    * 对话是否附带资源 资源一般就包含图片、文件、视频等等
    * */
    private Boolean hasMedia;
    /*
    * 附带资源Id，会附带多个
    * */
    @TableField(typeHandler = JacksonTypeHandler.class)
    private List<String> resourceIds = new ArrayList<>();

}

