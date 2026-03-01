package com.yoyuen.backend.controller.vo;

import com.fasterxml.jackson.annotation.JsonFormat;
import jakarta.validation.constraints.NotBlank;
import lombok.Data;

import java.time.LocalDateTime;

/**
 * @Author: YoyuEN
 * @Date: 2026/2/26
 * @Description: 内容视图对象
 */
@Data
public class ContentVO {

    private String id;

    @NotBlank(message = "标题不能为空")
    private String title;

    private String description;

    @NotBlank(message = "分类不能为空")
    private String category;

    private String cover;

    private String content;

    private Integer commentCount;

    private Integer viewCount;

    private Boolean isRecommend;

    @JsonFormat(pattern = "yyyy-MM-dd")
    private LocalDateTime createTime;

    private String creatorId;

    private String creatorName;
}
