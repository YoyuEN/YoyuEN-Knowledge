package com.yoyuen.backend.controller;

import com.yoyuen.backend.controller.vo.KnowledgeBaseVO;
import com.yoyuen.backend.controller.vo.SimpleBaseVO;
import com.yoyuen.backend.service.ai.KnowledgeBaseService;
import com.yoyuen.backend.utils.BaseResponse;
import com.yoyuen.backend.utils.ResultUtils;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

/**
 * @Author: YoyuEN
 * @Date: 2026/2/13
 * @Time: 13:34
 * @Description:
 */

@RestController
@RequestMapping("/knowledge")
@RequiredArgsConstructor
public class KnowledgeBaseController {

    private final KnowledgeBaseService knowledgeBaseService;

    @PostMapping("/create")
    public BaseResponse<String> createKnowledgeBase(@RequestBody KnowledgeBaseVO knowledgeBaseVO) {
        return ResultUtils.success(knowledgeBaseService.addKnowledgeBase(knowledgeBaseVO));
    }

    @PostMapping("/remove")
    public BaseResponse<Integer> removeKnowledgeBase(@RequestBody KnowledgeBaseVO knowledgeBaseVO) {
        return ResultUtils.success(knowledgeBaseService.removeKnowledgeBase(knowledgeBaseVO));
    }

    @PostMapping("/list")
    public BaseResponse<List<KnowledgeBaseVO>> listKnowledgeBase() {
        return ResultUtils.success(knowledgeBaseService.KnowledgeList());
    }

    @PostMapping("/simple")
    public BaseResponse<List<SimpleBaseVO>> simpleList() {
        return ResultUtils.success(knowledgeBaseService.simpleList());
    }
}
