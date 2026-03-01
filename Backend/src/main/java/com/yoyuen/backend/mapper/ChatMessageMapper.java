package com.yoyuen.backend.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.yoyuen.backend.model.entity.ai.ChatMessage;
import org.apache.ibatis.annotations.Mapper;

/**
 * @Author: YoyuEN
 * @Date: 2026/2/12
 * @Time: 13:13
 * @Description:
 */
@Mapper
public interface ChatMessageMapper extends BaseMapper<ChatMessage> {
}
