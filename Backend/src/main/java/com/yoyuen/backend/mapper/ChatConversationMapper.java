package com.yoyuen.backend.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.yoyuen.backend.model.entity.ai.ChatConversation;
import org.apache.ibatis.annotations.Mapper;

/**
 * @Author: YoyuEN
 * @Date: 2026/2/12
 * @Time: 13:12
 * @Description:
 */
@Mapper
public interface ChatConversationMapper extends BaseMapper<ChatConversation> {
}
