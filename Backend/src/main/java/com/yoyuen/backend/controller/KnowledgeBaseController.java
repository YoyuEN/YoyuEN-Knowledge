package com.yoyuen.backend.controller;

import com.yoyuen.backend.controller.vo.KnowledgeBaseVO;
import com.yoyuen.backend.controller.vo.SimpleBaseVO;
import com.yoyuen.backend.service.ai.KnowledgeBaseService;
import com.yoyuen.backend.utils.BaseResponse;
import com.yoyuen.backend.utils.ResultUtils;
import lombok.RequiredArgsConstructor;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.util.List;

/**
 * @Author: YoyuEN
 * @Date: 2026/2/13
 * @Time: 13:34
 * @Description:
 */

@RestController
@RequestMapping("/knowledge/base")
@RequiredArgsConstructor
public class KnowledgeBaseController {

    private final KnowledgeBaseService knowledgeBaseService;

    @PreAuthorize("hasRole('ADMIN')")
    @PostMapping("/create")
    public BaseResponse<String> createKnowledgeBase(@RequestBody KnowledgeBaseVO knowledgeBaseVO) {
        return ResultUtils.success(knowledgeBaseService.addKnowledgeBase(knowledgeBaseVO));
    }

    @PreAuthorize("hasRole('ADMIN')")
    @PostMapping("/update")
    public BaseResponse<Boolean> updateKnowledgeBase(@RequestBody KnowledgeBaseVO knowledgeBaseVO) {
        return ResultUtils.success(knowledgeBaseService.updateKnowledgeBase(knowledgeBaseVO));
    }

    @PreAuthorize("hasRole('ADMIN')")
    @PostMapping("/remove")
    public BaseResponse<Integer> removeKnowledgeBase(@RequestBody KnowledgeBaseVO knowledgeBaseVO) {
        return ResultUtils.success(knowledgeBaseService.removeKnowledgeBase(knowledgeBaseVO));
    }

    @GetMapping("/list")
    public BaseResponse<List<KnowledgeBaseVO>> listKnowledgeBase(
            @RequestParam(required = false) String keyword,
            @RequestParam(required = false) String category) {
        return ResultUtils.success(knowledgeBaseService.listKnowledge(keyword, category));
    }

    @PostMapping("/list")
    public BaseResponse<List<KnowledgeBaseVO>> listKnowledgeBasePost() {
        return ResultUtils.success(knowledgeBaseService.KnowledgeList());
    }

    @GetMapping("/{id}")
    public BaseResponse<KnowledgeBaseVO> getById(@PathVariable String id) {
        return ResultUtils.success(knowledgeBaseService.getKnowledgeById(id));
    }

    @PostMapping("/simple")
    public BaseResponse<List<SimpleBaseVO>> simpleList() {
        return ResultUtils.success(knowledgeBaseService.simpleList());
    }

    @PreAuthorize("hasRole('ADMIN')")
    @PostMapping("/toggle-status")
    public BaseResponse<Boolean> toggleStatus(@RequestBody KnowledgeBaseVO knowledgeBaseVO) {
        return ResultUtils.success(knowledgeBaseService.updateKnowledgeBase(knowledgeBaseVO));
    }
}
