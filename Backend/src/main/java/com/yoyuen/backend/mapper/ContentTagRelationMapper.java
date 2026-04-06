package com.yoyuen.backend.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.yoyuen.backend.entity.ContentTagRelation;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;

import java.util.List;

/**
 * @Author: YoyuEN
 * @Date: 2026/4/6
 * @Description: 内容标签关联关系Mapper
 */
@Mapper
public interface ContentTagRelationMapper extends BaseMapper<ContentTagRelation> {

    /**
     * 根据内容ID查询标签ID列表
     */
    @Select("SELECT tag_id FROM content_tag_relation WHERE content_id = #{contentId}")
    List<Long> selectTagIdsByContentId(@Param("contentId") String contentId);

    /**
     * 根据标签ID查询内容ID列表
     */
    @Select("SELECT content_id FROM content_tag_relation WHERE tag_id = #{tagId}")
    List<String> selectContentIdsByTagId(@Param("tagId") Long tagId);
}
