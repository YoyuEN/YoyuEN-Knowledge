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
import com.yoyuen.backend.utils.CoreCode;
import com.yoyuen.backend.utils.ResultUtils;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.BeanUtils;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.List;
import java.util.UUID;
import java.util.concurrent.TimeUnit;

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

    @GetMapping("/recommend")
    public BaseResponse<List<CommentVO>> listRecommend() {
        String cacheKey = "comment:recommend";
        Object cached = redisService.get(cacheKey);
        if (cached != null) {
            return ResultUtils.success((List<CommentVO>) cached);
        }

        List<Comment> comments = commentService.listRecommend();
        List<CommentVO> voList = comments.stream().map(this::toVO).toList();

        redisService.set(cacheKey, voList, 5, TimeUnit.MINUTES);
        return ResultUtils.success(voList);
    }

    @GetMapping("/all")
    public BaseResponse<List<CommentVO>> listAll(
            @RequestParam(required = false) String keyword,
            @RequestParam(required = false) String status) {
        List<Comment> comments = commentService.listAll(keyword, status);
        List<CommentVO> voList = comments.stream().map(this::toVO).toList();
        return ResultUtils.success(voList);
    }

    @PreAuthorize("hasRole('ADMIN')")
    @PostMapping("/approve")
    public BaseResponse<Boolean> approve(@RequestBody CommentVO commentVO) {
        boolean result = commentService.approveComment(commentVO.getId());
        redisService.delete("comment:recommend");
        return ResultUtils.success(result);
    }

    @PreAuthorize("hasRole('ADMIN')")
    @PostMapping("/recommend")
    public BaseResponse<Boolean> toggleRecommend(@RequestBody CommentVO commentVO) {
        boolean result = commentService.toggleRecommend(commentVO.getId(), commentVO.getIsRecommend());
        redisService.delete("comment:recommend");
        return ResultUtils.success(result);
    }

    @GetMapping("/list")
    public BaseResponse<List<CommentVO>> listByContent(
            @RequestParam String contentId,
            @RequestParam String contentType) {
        List<Comment> comments = commentService.listByContent(contentId, contentType);
        return ResultUtils.success(comments.stream().map(this::toVO).toList());
    }

    @PostMapping(value = "/create", consumes = "multipart/form-data")
    public BaseResponse<String> create(@ModelAttribute @Valid CommentVO commentVO) throws IOException {
        MultipartFile avatarFile = commentVO.getAvatarFile();
        if (avatarFile != null && !avatarFile.isEmpty()) {
            String originalFilename = avatarFile.getOriginalFilename();
            String ext = originalFilename != null && originalFilename.contains(".")
                    ? originalFilename.substring(originalFilename.lastIndexOf("."))
                    : ".png";
            String objectName = "comment/" + UUID.randomUUID() + ext;
            objectStoreService.uploadFile(avatarFile, AVATAR_BUCKET, objectName);
            commentVO.setAvatar(AVATAR_BUCKET + ":" + objectName);
        }

        Comment comment = toEntity(commentVO);
        String commentId = commentService.addComment(comment);
        contentService.incrementCommentCount(commentVO.getContentId());
        commentVO.setId(commentId);
        syncToKnowledgeBase(commentVO, "新增");

        redisService.delete("comment:recommend");
        return ResultUtils.success(commentId);
    }

    @PostMapping(value = "/create", consumes = "application/json")
    public BaseResponse<String> createJson(@RequestBody @Valid CommentVO commentVO) {
        Comment comment = toEntity(commentVO);
        String commentId = commentService.addComment(comment);
        contentService.incrementCommentCount(commentVO.getContentId());
        commentVO.setId(commentId);
        syncToKnowledgeBase(commentVO, "新增");

        redisService.delete("comment:recommend");
        return ResultUtils.success(commentId);
    }

    @PreAuthorize("hasRole('ADMIN')")
    @PostMapping("/remove")
    public BaseResponse<Boolean> remove(@RequestBody CommentVO commentVO) {
        Comment existing = commentService.getById(commentVO.getId());
        boolean result = commentService.removeComment(commentVO.getId());
        if (existing != null && result) {
            contentService.decrementCommentCount(existing.getContentId(), 1);
            syncToKnowledgeBase(toVO(existing), "删除");
            redisService.delete("comment:recommend");
        }
        return ResultUtils.success(result);
    }

    @PreAuthorize("hasRole('ADMIN')")
    @PostMapping("/remove/by-content")
    public BaseResponse<Integer> removeByContent(@RequestBody CommentVO commentVO) {
        if (commentVO == null || commentVO.getContentId() == null || commentVO.getContentId().isBlank()) {
            return ResultUtils.error(CoreCode.PARAMS_ERROR, "内容ID不能为空");
        }

        int removed = commentService.removeByContentId(commentVO.getContentId());
        if (removed > 0) {
            contentService.decrementCommentCount(commentVO.getContentId(), removed);
            redisService.delete("comment:recommend");
        }
        return ResultUtils.success(removed);
    }

    @GetMapping("/count")
    public BaseResponse<Integer> count(
            @RequestParam String contentId,
            @RequestParam(required = false) String contentType) {
        if (contentType == null || contentType.isBlank()) {
            return ResultUtils.success(commentService.countByContentId(contentId));
        }
        return ResultUtils.success(commentService.countByContent(contentId, contentType));
    }

    private CommentVO toVO(Comment comment) {
        return toVO(comment, null);
    }

    private CommentVO toVO(Comment comment, Comment parent) {
        if (comment == null) return null;
        CommentVO vo = new CommentVO();
        BeanUtils.copyProperties(comment, vo);

        if (comment.getAvatar() != null && comment.getAvatar().contains(":")) {
            String[] parts = comment.getAvatar().split(":", 2);
            if (parts.length == 2) {
                String bucket = parts[0];
                String objectName = parts[1];
                String avatarUrl = objectStoreService.getTmpFileUrl(bucket, objectName, 7 * 24 * 3600);
                vo.setAvatar(avatarUrl);
            }
        }

        if (comment.getContentId() != null) {
            Content content = contentService.getById(comment.getContentId());
            if (content != null) {
                vo.setContentTitle(content.getTitle());
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

    private Comment toEntity(CommentVO vo) {
        Comment comment = new Comment();
        BeanUtils.copyProperties(vo, comment);
        return comment;
    }

    private void syncToKnowledgeBase(CommentVO commentVO, String operation) {
        try {
            List<KnowledgeBaseVO> bases = knowledgeBaseService.KnowledgeList();
            if (bases.isEmpty()) {
                log.warn("[知识库同步:评论] no knowledge base, skip, author={}", commentVO.getAuthor());
                return;
            }
            // 查找网站内容知识库（通过名称或描述识别，优先使用第一个）
            String knowledgeId = bases.stream()
                    .filter(base -> "YoyuEN".equals(base.getName()) || "Profile".equals(base.getDescription()))
                    .findFirst()
                    .orElse(bases.get(0))
                    .getId();

            String contentTitle = commentVO.getContentId();
            Content content = contentService.getById(commentVO.getContentId());
            if (content != null) {
                contentTitle = content.getTitle();
            }

            LocalDateTime now = LocalDateTime.now();
            String timeStr = now.format(DateTimeFormatter.ofPattern("yyyyMMdd_HHmmss"));
            String safeAuthor = (commentVO.getAuthor() == null ? "unknown" : commentVO.getAuthor())
                    .replaceAll("[\\\\/:*?\"<>|\\s]", "_");
            String fileName = "comment_" + safeAuthor + "_" + timeStr + ".md";

            byte[] mdBytes = buildMarkdown(commentVO, operation, contentTitle, now).getBytes(StandardCharsets.UTF_8);
            originFileResourceService.uploadMarkdownWithMetadata(
                    mdBytes,
                    fileName,
                    knowledgeId,
                    "comment",
                    commentVO.getId(),
                    commentVO.getContentId()
            );
        } catch (Exception e) {
            log.error("[知识库同步:评论] failed operation={}, author={}, error={}", operation, commentVO.getAuthor(), e.getMessage(), e);
        }
    }

    private String buildMarkdown(CommentVO commentVO, String operation, String contentTitle, LocalDateTime now) {
        StringBuilder sb = new StringBuilder();
        sb.append("# 评论 - ").append(commentVO.getAuthor()).append("\n\n");
        sb.append("**操作**: ").append(operation).append("  \n");
        sb.append("**时间**: ").append(now.format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss"))).append("  \n");
        sb.append("**所属文章**: ").append(contentTitle).append("  \n");
        sb.append("**内容类型**: ").append(commentVO.getContentType()).append("  \n");
        if (commentVO.getReplyTo() != null && !commentVO.getReplyTo().isBlank()) {
            sb.append("**回复对象**: @").append(commentVO.getReplyTo()).append("  \n");
        }
        sb.append("\n## 评论内容\n\n").append(commentVO.getContent()).append("\n");
        return sb.toString();
    }
}
