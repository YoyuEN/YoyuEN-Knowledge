package com.yoyuen.backend.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.yoyuen.backend.entity.Photo;
import org.apache.ibatis.annotations.Mapper;

/**
 * @Author: YoyuEN
 * @Date: 2026/2/27
 * @Description: 照片Mapper
 */
@Mapper
public interface PhotoMapper extends BaseMapper<Photo> {
}
