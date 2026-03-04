package com.yoyuen.backend.service.ai;

import com.baomidou.mybatisplus.extension.service.IService;
import com.yoyuen.backend.controller.vo.ResourceVO;
import com.yoyuen.backend.model.entity.ai.OriginFileResource;
import org.springframework.ai.model.Media;
import org.springframework.web.multipart.MultipartFile;

import java.util.List;

/**
 * @Author: YoyuEN
 * @Date: 2026/2/5
 * @Time: 19:03
 * @Description:
 */
public interface OriginFileResourceService extends IService<OriginFileResource> {
    /*
    * 根据id转换Media
    * */
    List<Media> fromResourceId(List<String> resourceIds);

    /*
    * 对话附件
    * */
    String uploadFile(MultipartFile file);

    /*
    * 知识库附件
    * */
    Long uploadFile(MultipartFile file, String knowledgeId);

    List<ResourceVO> resourcesFromIds(List<String> resourceIds);

    /**
     * 将程序生成的 Markdown 字节上传到知识库（含向量化）
     * @param content   文件字节内容（UTF-8）
     * @param fileName  文件名，如 "标题_20260227_153000.md"
     * @param knowledgeId 目标知识库 ID
     * @return DocumentEntity ID
     */
    Long uploadMarkdown(byte[] content, String fileName, String knowledgeId);

    /**
     * 将程序生成的 Markdown 字节上传到知识库（含向量化），支持自定义metadata
     * @param content   文件字节内容（UTF-8）
     * @param fileName  文件名，如 "标题_20260227_153000.md"
     * @param knowledgeId 目标知识库 ID
     * @param contentType 内容类型：article, comment
     * @param contentId 内容ID（文章ID或评论ID）
     * @param articleId 如果是评论，需要关联的文章ID
     * @return DocumentEntity ID
     */
    Long uploadMarkdownWithMetadata(byte[] content, String fileName, String knowledgeId,
                                     String contentType, String contentId, String articleId);
}
