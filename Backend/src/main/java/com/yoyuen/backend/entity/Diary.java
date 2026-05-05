package com.yoyuen.backend.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import com.yoyuen.backend.pojo.BaseEntity;
import lombok.Data;
import lombok.EqualsAndHashCode;

/**
 * 日记/生活经历实体
 */
@Data
@EqualsAndHashCode(callSuper = true)
@TableName("diary")
public class Diary extends BaseEntity {

    @TableId(value = "id", type = IdType.ASSIGN_UUID)
    private String id;

    /**
     * 类型：diary-日记，life_experience-生活经历
     */
    @TableField("type")
    private String type;

    /**
     * 日期（前端展示用，如 2026年4月9日）
     */
    @TableField("diary_date")
    private String diaryDate;

    /**
     * 天气
     */
    @TableField("weather")
    private String weather;

    /**
     * 心情
     */
    @TableField("mood")
    private String mood;

    /**
     * 头像URL
     */
    @TableField("avatar")
    private String avatar;

    /**
     * 内容
     */
    @TableField("content")
    private String content;

    @TableField(exist = false)
    private static final long serialVersionUID = 1L;
}
