package com.yoyuen.backend.service.system.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.yoyuen.backend.entity.Diary;
import com.yoyuen.backend.mapper.DiaryMapper;
import com.yoyuen.backend.service.system.DiaryService;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
public class DiaryServiceImpl extends ServiceImpl<DiaryMapper, Diary> implements DiaryService {

    @Override
    public List<Diary> listByType(String type) {
        LambdaQueryWrapper<Diary> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(Diary::getType, type)
                .orderByDesc(Diary::getDiaryDate);
        return this.list(wrapper);
    }

    @Override
    public List<Diary> listAll(String type) {
        LambdaQueryWrapper<Diary> wrapper = new LambdaQueryWrapper<>();
        if (type != null && !type.isEmpty()) {
            wrapper.eq(Diary::getType, type);
        }
        wrapper.orderByDesc(Diary::getDiaryDate);
        return this.list(wrapper);
    }

    @Override
    public Diary getById(String id) {
        return super.getById(id);
    }

    @Transactional(rollbackFor = Exception.class)
    @Override
    public String addDiary(Diary diary) {
        this.save(diary);
        return diary.getId();
    }

    @Transactional(rollbackFor = Exception.class)
    @Override
    public boolean updateDiary(Diary diary) {
        return this.updateById(diary);
    }

    @Transactional(rollbackFor = Exception.class)
    @Override
    public boolean removeDiary(String id) {
        return this.removeById(id);
    }
}
