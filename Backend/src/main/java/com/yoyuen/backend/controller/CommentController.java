package com.yoyuen.backend.controller;

import com.yoyuen.backend.controller.vo.CommentVO;
import com.yoyuen.backend.entity.Comment;
import com.yoyuen.backend.service.system.CommentService;
import com.yoyuen.backend.service.system.ContentService;
import com.yoyuen.backend.service.system.ObjectStoreService;
import com.yoyuen.backend.utils.BaseResponse;
import com.yoyuen.backend.utils.ResultUtils;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.BeanUtils;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.util.List;
import java.util.UUID;

/**
 * @Author: YoyuEN
 * @Date: 2026/2/26
 * @Description: 评论控制器
 */
@RestController
@RequestMapping("/comment")
@RequiredArgsConstructor
public class CommentController {

    private final CommentService commentService;
    private final ContentService contentService;
    private final ObjectStoreService objectStoreService;

    private static final String AVATAR_BUCKET = "avatars";

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
            // 获取访问链接并设置到 VO
            String avatarUrl = objectStoreService.getTmpFileUrl(AVATAR_BUCKET, objectName, 7 * 24 * 3600);
            commentVO.setAvatar(avatarUrl);
        }

        Comment comment = toEntity(commentVO);
        String commentId = commentService.addComment(comment);
        // 更新内容的评论数
        contentService.incrementCommentCount(commentVO.getContentId());
        return ResultUtils.success(commentId);
    }

    /**
     * 添加评论（JSON格式，不带头像上传）
     */
    @PostMapping(value = "/create", consumes = "application/json")
    public BaseResponse<String> createJson(@RequestBody @Valid CommentVO commentVO) {
        Comment comment = toEntity(commentVO);
        String commentId = commentService.addComment(comment);
        // 更新内容的评论数
        contentService.incrementCommentCount(commentVO.getContentId());
        return ResultUtils.success(commentId);
    }

    /**
     * 删除评论
     */
    @PostMapping("/remove")
    public BaseResponse<Boolean> remove(@RequestBody CommentVO commentVO) {
        return ResultUtils.success(commentService.removeComment(commentVO.getId()));
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
        if (comment == null) return null;
        CommentVO vo = new CommentVO();
        BeanUtils.copyProperties(comment, vo);
        // 递归转换子评论
        if (comment.getReplies() != null && !comment.getReplies().isEmpty()) {
            vo.setReplies(comment.getReplies().stream().map(this::toVO).toList());
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
}
