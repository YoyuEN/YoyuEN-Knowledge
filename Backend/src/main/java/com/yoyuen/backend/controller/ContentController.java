package com.yoyuen.backend.controller;

import com.yoyuen.backend.controller.vo.ContentVO;
import com.yoyuen.backend.entity.Content;
import com.yoyuen.backend.service.system.ContentService;
import com.yoyuen.backend.utils.BaseResponse;
import com.yoyuen.backend.utils.ResultUtils;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.BeanUtils;
import org.springframework.web.bind.annotation.*;

import java.util.List;

/**
 * @Author: YoyuEN
 * @Date: 2026/2/26
 * @Description: 内容控制器
 */
@RestController
@RequestMapping("/content")
@RequiredArgsConstructor
public class ContentController {

    private final ContentService contentService;

    /**
     * 根据ID获取内容详情
     */
    @GetMapping("/{id}")
    public BaseResponse<ContentVO> getById(@PathVariable String id) {
        Content content = contentService.getById(id);
        contentService.incrementViewCount(id);
        return ResultUtils.success(toVO(content));
    }

    /**
     * 根据分类获取内容列表
     */
    @GetMapping("/list/{category}")
    public BaseResponse<List<ContentVO>> listByCategory(@PathVariable String category) {
        List<Content> contents = contentService.listByCategory(category);
        return ResultUtils.success(contents.stream().map(this::toVO).toList());
    }

    /**
     * 获取推荐内容列表
     */
    @GetMapping("/recommend")
    public BaseResponse<List<ContentVO>> listRecommend() {
        List<Content> contents = contentService.listRecommend();
        return ResultUtils.success(contents.stream().map(this::toVO).toList());
    }

    /**
     * 添加内容
     */
    @PostMapping("/create")
    public BaseResponse<String> create(@Valid @RequestBody ContentVO contentVO) {
        Content content = toEntity(contentVO);
        return ResultUtils.success(contentService.addContent(content));
    }

    /**
     * 更新内容
     */
    @PostMapping("/update")
    public BaseResponse<Boolean> update(@Valid @RequestBody ContentVO contentVO) {
        Content content = toEntity(contentVO);
        return ResultUtils.success(contentService.updateContent(content));
    }

    /**
     * 删除内容
     */
    @PostMapping("/remove")
    public BaseResponse<Boolean> remove(@RequestBody ContentVO contentVO) {
        return ResultUtils.success(contentService.removeContent(contentVO.getId()));
    }

    /**
     * Entity 转 VO
     */
    private ContentVO toVO(Content content) {
        if (content == null) return null;
        ContentVO vo = new ContentVO();
        BeanUtils.copyProperties(content, vo);
        vo.setCreatorId(content.getCreator());
        return vo;
    }

    /**
     * VO 转 Entity
     */
    private Content toEntity(ContentVO vo) {
        Content content = new Content();
        BeanUtils.copyProperties(vo, content);
        return content;
    }
}
