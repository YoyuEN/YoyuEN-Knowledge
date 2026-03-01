package com.yoyuen.backend.controller.vo;

import com.fasterxml.jackson.annotation.JsonFormat;
import jakarta.validation.constraints.NotBlank;
import lombok.Data;

import java.time.LocalDateTime;

/**
 * @Author: YoyuEN
 * @Date: 2026/2/26
 * @Description: 碎碎念视图对象
 */
@Data
public class MurmurVO {

    private String id;

    @NotBlank(message = "内容不能为空")
    private String text;

    @JsonFormat(pattern = "yyyy-MM-dd")
    private LocalDateTime createTime;

    private String creatorId;

    private String creatorName;
}
