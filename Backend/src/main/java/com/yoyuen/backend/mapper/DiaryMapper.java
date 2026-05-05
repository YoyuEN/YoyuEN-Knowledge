package com.yoyuen.backend.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.yoyuen.backend.entity.Diary;
import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface DiaryMapper extends BaseMapper<Diary> {
}
