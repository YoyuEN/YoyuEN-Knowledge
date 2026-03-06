package com.yoyuen.backend.service.ai;

import java.io.InputStream;

/**
 * @Author: YoyuEN
 * @Date: 2026/3/6
 * @Description: 文生图服务接口
 */
public interface ImageGenerationService {
    /**
     * 根据文本生成图片
     * @param prompt 提示词
     * @return 图片URL
     */
    String generateImage(String prompt);

    /**
     * 根据文章内容生成封面
     * @param title 文章标题
     * @param content 文章内容
     * @return 封面图片URL
     */
    String generateCoverForContent(String title, String content);

    /**
     * 图生图：将图片转换为动漫风格
     * @param imageBytes 原始图片字节数组
     * @return 动漫化后的图片路径
     */
    String convertToAnime(byte[] imageBytes);
}
