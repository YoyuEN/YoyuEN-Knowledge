package com.yoyuen.backend.controller;

import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.yoyuen.backend.controller.vo.DocumentVO;
import com.yoyuen.backend.service.ai.DocumentEntityService;
import com.yoyuen.backend.utils.BaseResponse;
import com.yoyuen.backend.utils.ResultUtils;
import jakarta.servlet.http.HttpServletResponse;
import lombok.RequiredArgsConstructor;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

/**
 * @Author: YoyuEN
 * @Date: 2026/5/9
 * @Description: 知识库文档管理接口
 */
@RestController
@RequiredArgsConstructor
@RequestMapping("/resource")
public class DocumentController {

    private final DocumentEntityService documentEntityService;

    @PreAuthorize("hasRole('ADMIN')")
    @GetMapping("/knowledge/{knowledgeId}/documents")
    public BaseResponse<Page<DocumentVO>> listDocuments(
            @PathVariable String knowledgeId,
            @RequestParam(defaultValue = "1") Integer pageNo,
            @RequestParam(defaultValue = "10") Integer pageSize) {
        DocumentVO query = new DocumentVO();
        query.setKnowledgeBaseId(knowledgeId);
        query.setPageNo(pageNo);
        query.setPageSize(pageSize);
        return ResultUtils.success(documentEntityService.listDocuments(query));
    }

    @PreAuthorize("hasRole('ADMIN')")
    @PostMapping("/document/delete")
    public BaseResponse<Boolean> deleteDocument(@RequestBody DocumentVO documentVO) {
        return ResultUtils.success(documentEntityService.deleteKnowledgeFile(documentVO));
    }

    @GetMapping("/document/download/{fileId}")
    public void downloadDocument(@PathVariable Long fileId, HttpServletResponse response) {
        documentEntityService.download(fileId, response);
    }
}
