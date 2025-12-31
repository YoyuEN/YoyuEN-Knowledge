package com.yoyuen.backend.entity;

import com.baomidou.mybatisplus.annotation.TableName;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;

/**
 * @Author: YoyuEN
 * @Date: 2025/12/28
 * @Time: 11:38
 * @Description:
 */
@Data
@NoArgsConstructor
@AllArgsConstructor
@TableName("kb_client_user")
public class ClientUser {
    private Long id;
    private String displayName;
    private String avatar;
    private String introduction;
    private String profession;
    private Integer status;
    private LocalDateTime createTime;
    private LocalDateTime updateTime;
}

