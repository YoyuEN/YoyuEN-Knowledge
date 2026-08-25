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

    /**
     * 按知识库ID + 文件名前缀删除文档（含向量数据）
     * 用于更新文章/评论时清理旧的MD文件
     */
    int deleteByBaseIdAndFileNamePrefix(String baseId, String fileNamePrefix);

}
