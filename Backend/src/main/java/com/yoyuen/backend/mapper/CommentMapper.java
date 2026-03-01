package com.yoyuen.backend.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.yoyuen.backend.entity.Comment;
import org.apache.ibatis.annotations.Mapper;

import java.util.List;

/**
 * @Author: YoyuEN
 * @Date: 2026/2/26
 * @Description: 评论Mapper
 */
@Mapper
public interface CommentMapper extends BaseMapper<Comment> {

    /**
     * 根据内容ID和类型获取评论列表（包含子评论）
     */
    List<Comment> selectCommentsWithReplies(String contentId, String contentType);
}
