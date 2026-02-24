package com.yoyuen.backend.controller.vo;

import jakarta.validation.constraints.NotBlank;
import lombok.Data;

/**
 * @Author: YoyuEN
 * @Date: 2026/2/12
 * @Time: 13:15
 * @Description:
 */
@Data
public class KnowledgeBaseVO {

    private String id;

    @NotBlank(message = "知识库名称不能为空")
    private String name;

    private String description;

//    创建人
    private Long author;

    private String authorName;
}
