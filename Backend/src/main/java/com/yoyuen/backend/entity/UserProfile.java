package com.yoyuen.backend.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import com.yoyuen.backend.pojo.BaseEntity;
import lombok.Data;
import lombok.EqualsAndHashCode;

/**
 * 用户个人资料/博主信息
 */
@Data
@EqualsAndHashCode(callSuper = true)
@TableName("user_profile")
public class UserProfile extends BaseEntity {

    @TableId(value = "id", type = IdType.ASSIGN_UUID)
    private String id;

    /**
     * 昵称
     */
    @TableField("nickname")
    private String nickname;

    /**
     * 头像URL
     */
    @TableField("avatar")
    private String avatar;

    /**
     * 个性签名
     */
    @TableField("signature")
    private String signature;

    /**
     * 欢迎语/自我介绍
     */
    @TableField("welcome_text")
    private String welcomeText;

    /**
     * 学校/公司
     */
    @TableField("school")
    private String school;

    /**
     * 邮箱
     */
    @TableField("email")
    private String email;

    /**
     * 所在地
     */
    @TableField("location")
    private String location;

    /**
     * 技术栈（JSON数组字符串）
     */
    @TableField("tech_stack")
    private String techStack;

    /**
     * 个人标签（JSON数组字符串）
     */
    @TableField("tags")
    private String tags;

    @TableField(exist = false)
    private static final long serialVersionUID = 1L;
}
