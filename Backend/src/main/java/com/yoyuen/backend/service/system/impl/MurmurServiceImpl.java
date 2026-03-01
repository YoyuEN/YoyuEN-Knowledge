package com.yoyuen.backend.service.system.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.yoyuen.backend.mapper.MurmurMapper;
import com.yoyuen.backend.entity.Murmur;
import com.yoyuen.backend.service.system.MurmurService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

/**
 * @Author: YoyuEN
 * @Date: 2026/2/26
 * @Description: 碎碎念服务实现类
 */
@Slf4j
@Service
@RequiredArgsConstructor
public class MurmurServiceImpl extends ServiceImpl<MurmurMapper, Murmur> implements MurmurService {

    @Override
    public List<Murmur> list() {
        LambdaQueryWrapper<Murmur> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(Murmur::getDeleted, false)
                .orderByDesc(Murmur::getCreateTime);
        return this.list(wrapper);
    }

    @Override
    public List<Murmur> listLatest(int limit) {
        LambdaQueryWrapper<Murmur> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(Murmur::getDeleted, false)
                .orderByDesc(Murmur::getCreateTime)
                .last("LIMIT " + limit);
        return this.list(wrapper);
    }

    @Override
    public Murmur getById(String id) {
        return this.baseMapper.selectById(id);
    }

    @Transactional(rollbackFor = Exception.class)
    @Override
    public String addMurmur(Murmur murmur) {
        this.save(murmur);
        return murmur.getId();
    }

    @Transactional(rollbackFor = Exception.class)
    @Override
    public boolean removeMurmur(String id) {
        return this.removeById(id);
    }
}
