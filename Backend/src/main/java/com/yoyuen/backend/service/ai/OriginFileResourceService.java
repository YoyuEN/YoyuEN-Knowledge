package com.yoyuen.backend.service.ai;

import com.baomidou.mybatisplus.extension.service.IService;
import com.yoyuen.backend.controller.vo.ResourceVO;
import com.yoyuen.backend.model.entity.ai.OriginFileResource;
import org.springframework.ai.model.Media;
import org.springframework.web.multipart.MultipartFile;

import java.util.List;

/**
 * @Author: YoyuEN
 * @Date: 2026/2/5
 * @Time: 19:03
 * @Description:
 */
public interface OriginFileResourceService extends IService<OriginFileResource> {
    /*
    * 根据id转换Media
    * */
    List<Media> fromResourceId(List<String> resourceIds);

    /*
    * 对话附件
    * */
    String uploadFile(MultipartFile file);

    /*
    * 知识库附件
    * */
    Long uploadFile(MultipartFile file, String knowledgeId);

    List<ResourceVO> resourcesFromIds(List<String> resourceIds);
}
