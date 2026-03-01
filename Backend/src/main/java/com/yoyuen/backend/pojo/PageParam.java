package com.yoyuen.backend.pojo;

import lombok.Data;

/**
 * @Author: YoyuEN
 * @Date: 2026/2/24
 * @Time: 10:27
 * @Description:
 */
@Data
public class PageParam {

    private static final Integer PAGE_NO = 1;

    private static final Integer PAGE_SIZE = 10;

    public static final Integer PAGE_SIZE_NONE = -1;

    private Integer pageNo = PAGE_NO;

    private Integer pageSize = PAGE_SIZE;

}

