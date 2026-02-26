package com.yoyuen.backend.controller.vo;

import jakarta.validation.constraints.NotBlank;
import lombok.Data;

import java.time.LocalDateTime;
import java.util.List;

/**
 * @Author: YoyuEN
 * @Date: 2026/2/26
 * @Description: 评论视图对象
 */
@Data
public class CommentVO {

    private String id;

    @NotBlank(message = "内容ID不能为空")
    private String contentId;

    @NotBlank(message = "内容类型不能为空")
    private String contentType;

    private String avatar;

    private String author;

    private String userId;

    @NotBlank(message = "评论内容不能为空")
    private String content;

    private String parentId;

    private LocalDateTime createTime;

    private List<CommentVO> replies;
}
