package com.yoyuen.backend.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.yoyuen.backend.model.entity.ai.DocumentEntity;
import org.apache.ibatis.annotations.Mapper;

import java.util.List;

/**
 * @Author: YoyuEN
 * @Date: 2026/2/24
 * @Time: 9:15
 * @Description:
 */
@Mapper
public interface DocumentEntityMapper extends BaseMapper<DocumentEntity> {
    List<DocumentEntity> selectByBaseId(Long knowledgeId);
}
