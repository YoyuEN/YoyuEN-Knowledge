package com.yoyuen.backend.controller.vo;

import lombok.Data;

/**
 * @Author: YoyuEN
 * @Date: 2026/2/24
 * @Time: 9:05
 * @Description:
 */
@Data
public class ResourceVO {
    /*
    * 资源ID
    * */
    private String resourceId;

    /*
    * 资源文件名
    * */
    private String fileName;

    /*
    * 资源类型
    * */
    private String fileType;

    /*
    * 下载路径
    * */
    private String path;
}
