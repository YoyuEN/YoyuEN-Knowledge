package com.yoyuen.backend.service.system;

import com.yoyuen.backend.entity.Murmur;

import java.util.List;

/**
 * @Author: YoyuEN
 * @Date: 2026/2/26
 * @Description: 碎碎念服务接口
 */
public interface MurmurService {

    /**
     * 获取碎碎念列表
     */
    List<Murmur> list();

    /**
     * 获取最新的N条碎碎念
     */
    List<Murmur> listLatest(int limit);

    /**
     * 添加碎碎念
     */
    String addMurmur(Murmur murmur);

    /**
     * 删除碎碎念
     */
    boolean removeMurmur(String id);
}
