package com.yoyuen.backend.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import com.yoyuen.backend.pojo.BaseEntity;
import lombok.Data;
import lombok.EqualsAndHashCode;

/**
 * @Author: YoyuEN
 * @Date: 2026/2/26
 * @Description: 内容实体（文章、游戏、学习、视频）
 */
@Data
@EqualsAndHashCode(callSuper = true)
@TableName("content")
public class Content extends BaseEntity {

    @TableId(value = "id", type = IdType.ASSIGN_UUID)
    private String id;

    /**
     * 标题
     */
    @TableField("title")
    private String title;

    /**
     * 简介/描述
     */
    @TableField("description")
    private String description;

    /**
     * 分类：article-文章, game-游戏, study-学习, video-视频
     */
    @TableField("category")
    private String category;

    /**
     * 封面图片URL
     */
    @TableField("cover")
    private String cover;

    /**
     * 正文内容（HTML格式）
     */
    @TableField("content")
    private String content;

    /**
     * 评论数
     */
    @TableField("comment_count")
    private Integer commentCount;

    /**
     * 浏览量
     */
    @TableField("view_count")
    private Integer viewCount;

    /**
     * 是否推荐
     */
    @TableField("is_recommend")
    private Boolean isRecommend;

    /**
     * 内容类型：article-图文, video-视频
     */
    @TableField("content_type")
    private String contentType;

    /**
     * 视频类型：file-文件上传, link-视频链接
     */
    @TableField("video_type")
    private String videoType;

    /**
     * 视频URL（文件上传后的URL或外部链接）
     */
    @TableField("video_url")
    private String videoUrl;

    /**
     * 视频时长（秒）
     */
    @TableField("video_duration")
    private Integer videoDuration;

    @TableField(exist = false)
    private static final long serialVersionUID = 1L;
}
