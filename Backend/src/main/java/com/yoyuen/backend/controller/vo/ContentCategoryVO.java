package com.yoyuen.backend.controller.vo;

import lombok.AllArgsConstructor;
import lombok.Data;

/**
 * @Author: YoyuEN
 * @Date: 2026/3/5
 * @Description: 内容分类VO
 */
@Data
@AllArgsConstructor
public class ContentCategoryVO {
    private String type;
    private String name;
    private Long count;
}
