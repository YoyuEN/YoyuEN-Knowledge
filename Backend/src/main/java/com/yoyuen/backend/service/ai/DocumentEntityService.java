package com.yoyuen.backend.service.ai;

import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.yoyuen.backend.controller.vo.DocumentVO;
import jakarta.servlet.http.HttpServletResponse;

/**
 * @Author: YoyuEN
 * @Date: 2026/2/24
 * @Time: 10:26
 * @Description:
 */
public interface DocumentEntityService {
    Page<DocumentVO> listDocuments(DocumentVO documentVO);

    Boolean deleteKnowledgeFile(DocumentVO documentVO);

    void download(Long fileId, HttpServletResponse  response);

}
