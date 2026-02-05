package com.yoyuen.backend.pojo;

import com.baomidou.mybatisplus.annotation.TableField;
import lombok.Data;

import java.io.Serializable;
import java.util.Date;

/**
 * @Author: YoyuEN
 * @Date: 2026/2/5
 * @Time: 18:49
 * @Description:
 */
@Data
public class BaseEntity implements Serializable {

    /**
     * 创建时间
     */
    @TableField(value = "create_time")
    private Date createTime;

    /**
     * 更新时间
     */
    @TableField(value = "update_time")
    private Date updateTime;

    /**
     * 是否删除
     */
    @TableField(value = "deleted")
    private Boolean deleted;

    /**
     * 创建人
     */
    @TableField(value = "creator")
    private String creator;

    /**
     * 更新人
     */
    @TableField(value = "updater")
    private String updater;

}
