package com.yoyuen.backend.service.ai.impl;

import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.yoyuen.backend.controller.vo.KnowledgeBaseVO;
import com.yoyuen.backend.controller.vo.SimpleBaseVO;
import com.yoyuen.backend.mapper.KnowledgeBaseMapper;
import com.yoyuen.backend.mapper.SystemUserMapper;
import com.yoyuen.backend.model.ai.KnowledgeBase;
import com.yoyuen.backend.model.user.SystemUser;
import com.yoyuen.backend.service.ai.KnowledgeBaseService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

/**
 * @Author: YoyuEN
 * @Date: 2026/2/12
 * @Time: 13:27
 * @Description:
 */
@Slf4j
@Service
@RequiredArgsConstructor
public class KnowledgeBaseServiceImpl extends ServiceImpl<KnowledgeBaseMapper, KnowledgeBase> implements KnowledgeBaseService {

    private final SystemUserMapper userMapper;
    @Transactional(rollbackFor = Exception.class)
    @Override
    public String addKnowledgeBase(KnowledgeBaseVO knowledgeBaseVO) {
        KnowledgeBase knowledgeBase = new KnowledgeBase();
        knowledgeBase.setName(knowledgeBaseVO.getName());
        knowledgeBase.setDescription(knowledgeBaseVO.getDescription());
        this.save(knowledgeBase);
        return knowledgeBaseVO.getId();
    }

    @Transactional(rollbackFor = Exception.class)
    @Override
    public Integer deleteKnowledgeBase(KnowledgeBaseVO knowledgeBaseVO) {
        String id = knowledgeBaseVO.getId();
        return this.removeById(id) ? 1 : 0;
    }

    @Override
    public List<KnowledgeBaseVO> KnowledgeList() {
        List<KnowledgeBase> knowledgeBaseList = this.list();
        return transfer(knowledgeBaseList);
    }

    @Override
    public List<SimpleBaseVO> simpleList() {
        return List.of();
    }

    private List<KnowledgeBaseVO> transfer(List<KnowledgeBase> knowledgeBaseList) {
        return knowledgeBaseList.stream().map(this::transfer).toList();
    }

    private KnowledgeBaseVO transfer(KnowledgeBase knowledgeBase) {
        KnowledgeBaseVO knowledgeBaseVO = new KnowledgeBaseVO();
        knowledgeBaseVO.setId(knowledgeBase.getId());
        knowledgeBaseVO.setName(knowledgeBase.getName());
        knowledgeBaseVO.setDescription(knowledgeBase.getDescription());
        String creator = knowledgeBase.getCreator();
        if (creator != null) {
            SystemUser user = userMapper.getUserWithRolesAndPermissions(creator);
            knowledgeBaseVO.setAuthor(user.getId());
            knowledgeBaseVO.setAuthorName(user.getUsername());
        }
        return knowledgeBaseVO;
    }

    private List<SimpleBaseVO> transfer2Simple(List<KnowledgeBase> knowledgeBaseList) {
        return knowledgeBaseList.stream().map(item -> {
            SimpleBaseVO simpleBaseVO = new SimpleBaseVO();
            simpleBaseVO.setId(item.getId());
            simpleBaseVO.setName(item.getName());
            return simpleBaseVO;
        }).toList();
    }
}
