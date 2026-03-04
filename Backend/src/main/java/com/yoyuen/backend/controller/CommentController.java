package com.yoyuen.backend.controller;

import com.yoyuen.backend.controller.vo.CommentVO;
import com.yoyuen.backend.controller.vo.KnowledgeBaseVO;
import com.yoyuen.backend.entity.Comment;
import com.yoyuen.backend.entity.Content;
import com.yoyuen.backend.service.ai.KnowledgeBaseService;
import com.yoyuen.backend.service.ai.OriginFileResourceService;
import com.yoyuen.backend.service.system.CommentService;
import com.yoyuen.backend.service.system.ContentService;
import com.yoyuen.backend.service.system.ObjectStoreService;
import com.yoyuen.backend.service.system.RedisService;
import com.yoyuen.backend.utils.BaseResponse;
import com.yoyuen.backend.utils.ResultUtils;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.BeanUtils;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.List;
import java.util.UUID;
import java.util.concurrent.TimeUnit;

/**
 * @Author: YoyuEN
 * @Date: 2026/2/26
 * @Description: 评论控制器
 */
@Slf4j
@RestController
@RequestMapping("/comment")
@RequiredArgsConstructor
public class CommentController {

    private final CommentService commentService;
    private final ContentService contentService;
    private final ObjectStoreService objectStoreService;
    private final KnowledgeBaseService knowledgeBaseService;
    private final OriginFileResourceService originFileResourceService;
    private final RedisService redisService;

    private static final String AVATAR_BUCKET = "avatars";

    /**
     * 获取推荐评论列表
     */
    @GetMapping("/recommend")
    public BaseResponse<List<CommentVO>> listRecommend() {
        // 尝试从缓存获取
        String cacheKey = "comment:recommend";
        Object cached = redisService.get(cacheKey);
        if (cached != null) {
            log.debug("从缓存获取推荐评论列表");
            return ResultUtils.success((List<CommentVO>) cached);
        }

        // 缓存未命中，查询数据库
        List<Comment> comments = commentService.listRecommend();
        List<CommentVO> voList = comments.stream().map(this::toVO).toList();

        // 写入缓存，5分钟过期
        redisService.set(cacheKey, voList, 5, TimeUnit.MINUTES);
        return ResultUtils.success(voList);
    }

    /**
     * 获取内容的评论列表（树形结构）
     */
    @GetMapping("/list")
    public BaseResponse<List<CommentVO>> listByContent(
            @RequestParam String contentId,
            @RequestParam String contentType) {
        List<Comment> comments = commentService.listByContent(contentId, contentType);
        return ResultUtils.success(comments.stream().map(this::toVO).toList());
    }

    /**
     * 添加评论（支持上传头像）
     */
    @PostMapping(value = "/create", consumes = "multipart/form-data")
    public BaseResponse<String> create(@ModelAttribute @Valid CommentVO commentVO) throws IOException {

        // 如果上传了头像文件，先上传到 MinIO
        MultipartFile avatarFile = commentVO.getAvatarFile();
        if (avatarFile != null && !avatarFile.isEmpty()) {
            String originalFilename = avatarFile.getOriginalFilename();
            String ext = originalFilename != null && originalFilename.contains(".")
                    ? originalFilename.substring(originalFilename.lastIndexOf("."))
                    : ".png";
            String objectName = "comment/" + UUID.randomUUID() + ext;
            objectStoreService.uploadFile(avatarFile, AVATAR_BUCKET, objectName);
            // 存储格式：bucket:objectName，避免预览地址过期
            commentVO.setAvatar(AVATAR_BUCKET + ":" + objectName);
        }

        Comment comment = toEntity(commentVO);
        String commentId = commentService.addComment(comment);
        contentService.incrementCommentCount(commentVO.getContentId());
        commentVO.setId(commentId);
        syncToKnowledgeBase(commentVO, "新增");

        // 清除推荐评论缓存
        redisService.delete("comment:recommend");
        return ResultUtils.success(commentId);
    }

    /**
     * 添加评论（JSON格式，不带头像上传）
     */
    @PostMapping(value = "/create", consumes = "application/json")
    public BaseResponse<String> createJson(@RequestBody @Valid CommentVO commentVO) {
        Comment comment = toEntity(commentVO);
        String commentId = commentService.addComment(comment);
        contentService.incrementCommentCount(commentVO.getContentId());
        commentVO.setId(commentId);
        syncToKnowledgeBase(commentVO, "新增");

        // 清除推荐评论缓存
        redisService.delete("comment:recommend");
        return ResultUtils.success(commentId);
    }

    /**
     * 删除评论
     */
    @PostMapping("/remove")
    public BaseResponse<Boolean> remove(@RequestBody CommentVO commentVO) {
        Comment existing = commentService.getById(commentVO.getId());
        boolean result = commentService.removeComment(commentVO.getId());
        if (existing != null) {
            syncToKnowledgeBase(toVO(existing), "删除");
            // 清除推荐评论缓存
            redisService.delete("comment:recommend");
        }
        return ResultUtils.success(result);
    }

    /**
     * 获取评论数量
     */
    @GetMapping("/count")
    public BaseResponse<Integer> count(
            @RequestParam String contentId,
            @RequestParam String contentType) {
        return ResultUtils.success(commentService.countByContent(contentId, contentType));
    }

    /**
     * Entity 转 VO（递归处理子评论）
     */
    private CommentVO toVO(Comment comment) {
        return toVO(comment, null);
    }

    private CommentVO toVO(Comment comment, Comment parent) {
        if (comment == null) return null;
        CommentVO vo = new CommentVO();
        BeanUtils.copyProperties(comment, vo);

        // 动态生成头像预览地址
        if (comment.getAvatar() != null && comment.getAvatar().contains(":")) {
            String[] parts = comment.getAvatar().split(":", 2);
            if (parts.length == 2) {
                String bucket = parts[0];
                String objectName = parts[1];
                String avatarUrl = objectStoreService.getTmpFileUrl(bucket, objectName, 7 * 24 * 3600);
                vo.setAvatar(avatarUrl);
            }
        }

        if (parent != null) {
            vo.setReplyTo(parent.getAuthor());
        }
        if (comment.getReplies() != null && !comment.getReplies().isEmpty()) {
            vo.setReplies(comment.getReplies().stream().map(reply -> toVO(reply, comment)).toList());
        }
        return vo;
    }

    /**
     * VO 转 Entity
     */
    private Comment toEntity(CommentVO vo) {
        Comment comment = new Comment();
        BeanUtils.copyProperties(vo, comment);
        return comment;
    }

    /**
     * 将评论同步写入 MD 文件并上传至知识库
     */
    private void syncToKnowledgeBase(CommentVO commentVO, String operation) {
        try {
            List<KnowledgeBaseVO> bases = knowledgeBaseService.KnowledgeList();
            if (bases.isEmpty()) {
                log.warn("[知识库同步-评论] 未找到任何知识库，跳过同步，author={}", commentVO.getAuthor());
                return;
            }
            String knowledgeId = bases.get(0).getId();
            // 查询所属内容标题
            String contentTitle = commentVO.getContentId();
            Content content = contentService.getById(commentVO.getContentId());
            if (content != null) {
                contentTitle = content.getTitle();
            }
            LocalDateTime now = LocalDateTime.now();
            String timeStr = now.format(DateTimeFormatter.ofPattern("yyyyMMdd_HHmmss"));
            String safeAuthor = commentVO.getAuthor().replaceAll("[\\\\/:*?\"<>|\\s]", "_");
            String fileName = "comment_" + safeAuthor + "_" + timeStr + ".md";
            byte[] mdBytes = buildMarkdown(commentVO, operation, contentTitle, now).getBytes(StandardCharsets.UTF_8);
            originFileResourceService.uploadMarkdownWithMetadata(
                mdBytes,
                fileName,
                knowledgeId,
                "comment",                  // contentType
                commentVO.getId(),          // contentId (评论ID)
                commentVO.getContentId()    // articleId (所属文章ID)
            );
            log.info("[知识库同步-评论] 成功，operation={}, author={}, file={}", operation, commentVO.getAuthor(), fileName);
        } catch (Exception e) {
            log.error("[知识库同步-评论] 失败，operation={}, author={}, error={}", operation, commentVO.getAuthor(), e.getMessage(), e);
        }
    }

    /**
     * 根据评论 VO 构建 Markdown 字符串
     */
    private String buildMarkdown(CommentVO commentVO, String operation, String contentTitle, LocalDateTime now) {
        StringBuilder sb = new StringBuilder();
        sb.append("# 评论 - ").append(commentVO.getAuthor()).append("\n\n");
        sb.append("**操作**: ").append(operation).append("  \n");
        sb.append("**时间**: ").append(now.format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss"))).append("  \n");
        sb.append("**所属文章**: 《").append(contentTitle).append("》  \n");
        sb.append("**内容类型**: ").append(commentVO.getContentType()).append("  \n");
        if (commentVO.getReplyTo() != null && !commentVO.getReplyTo().isBlank()) {
            sb.append("**回复对象**: @").append(commentVO.getReplyTo()).append("  \n");
        }
        sb.append("\n## 评论内容\n\n").append(commentVO.getContent()).append("\n");
        return sb.toString();
    }
}
