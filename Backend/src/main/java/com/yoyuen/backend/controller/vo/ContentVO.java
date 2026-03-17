package com.yoyuen.backend.controller.vo;

import com.fasterxml.jackson.annotation.JsonFormat;
import jakarta.validation.constraints.NotBlank;
import lombok.Data;

import java.time.LocalDateTime;
import java.util.List;

@Data
public class ContentVO {

    private String id;

    @NotBlank(message = "标题不能为空")
    private String title;

    private String description;

    @NotBlank(message = "分类不能为空")
    private String category;

    private String categoryName;

    private String cover;

    private String content;

    private Integer commentCount;

    private Integer viewCount;

    private Boolean isRecommend;

    private List<String> tags;

    private String contentType;

    private String videoType;

    private String videoUrl;

    private Integer videoDuration;

    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    private LocalDateTime createTime;

    private String creatorId;

    private String creatorName;
}
