package com.yoyuen.backend.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import com.yoyuen.backend.pojo.BaseEntity;
import lombok.Data;
import lombok.EqualsAndHashCode;

import java.util.List;

/**
 * @Author: YoyuEN
 * @Date: 2026/2/26
 * @Description: 评论实体
 */
@Data
@EqualsAndHashCode(callSuper = true)
@TableName("comment")
public class Comment extends BaseEntity {

    @TableId(value = "id", type = IdType.ASSIGN_UUID)
    private String id;

    /**
     * 关联内容ID
     */
    @TableField("content_id")
    private String contentId;

    /**
     * 内容类型：article, game, study, video
     */
    @TableField("content_type")
    private String contentType;

    /**
     * 评论者头像
     */
    @TableField("avatar")
    private String avatar;

    /**
     * 评论者昵称
     */
    @TableField("author")
    private String author;

    /**
     * 评论者用户ID
     */
    @TableField("user_id")
    private String userId;

    /**
     * 评论内容
     */
    @TableField("content")
    private String content;

    /**
     * 父评论ID（用于回复功能，顶级评论为null）
     */
    @TableField("parent_id")
    private String parentId;

    /**
     * 是否推荐（展示在首页）
     */
    @TableField("is_recommend")
    private Boolean isRecommend;

    /**
     * 审核状态：pending-待审核，approved-已通过，rejected-已拒绝
     */
    @TableField("status")
    private String status;

    /**
     * 子评论列表（非数据库字段）
     */
    @TableField(exist = false)
    private List<Comment> replies;

    @TableField(exist = false)
    private static final long serialVersionUID = 1L;
}
