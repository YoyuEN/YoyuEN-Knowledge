package com.yoyuen.backend.service.ai;

import com.yoyuen.backend.controller.vo.KnowledgeBaseVO;
import com.yoyuen.backend.controller.vo.SimpleBaseVO;

import java.util.List;

/**
 * @Author: YoyuEN
 * @Date: 2026/2/12
 * @Time: 13:14
 * @Description:
 */
public interface KnowledgeBaseService {
//    添加知识库
    String addKnowledgeBase(KnowledgeBaseVO knowledgeBaseVO);

//    删除知识库
    Integer removeKnowledgeBase(KnowledgeBaseVO knowledgeBaseVO);

//    所有知识库
    List<KnowledgeBaseVO> KnowledgeList();

//    简单的列表
    List<SimpleBaseVO> simpleList();
}