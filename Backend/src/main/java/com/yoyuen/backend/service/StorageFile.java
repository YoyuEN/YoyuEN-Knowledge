package com.yoyuen.backend.service;

/**
 * @Author: YoyuEN
 * @Date: 2026/2/5
 * @Time: 18:28
 * @Description:
 */
public interface StorageFile {

    String getId();

    String getBucketName();

    String getObjectName();

    String getContentType();

    String getFileName();

    String getPath();

    Long getSize();

    String getMd5();
}
