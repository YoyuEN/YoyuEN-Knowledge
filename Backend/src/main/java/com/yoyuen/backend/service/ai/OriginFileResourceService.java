package com.yoyuen.backend.service.ai;

import com.baomidou.mybatisplus.extension.service.IService;
import com.yoyuen.backend.model.ai.OriginFileResource;
import org.springframework.web.multipart.MultipartFile;

import javax.print.attribute.standard.Media;
import java.util.List;

/**
 * @Author: YoyuEN
 * @Date: 2026/2/5
 * @Time: 19:03
 * @Description:
 */
public interface OriginFileResourceService extends IService<OriginFileResource> {
    List<Media> fromResourceId(List<String> resourceIds);

    String uploadFile(MultipartFile file);

    String uploadFile(MultipartFile file, String knowledgeId);
}
