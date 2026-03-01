package com.yoyuen.backend.controller;

import com.yoyuen.backend.controller.vo.KnowledgeBaseVO;
import com.yoyuen.backend.controller.vo.MurmurVO;
import com.yoyuen.backend.entity.Murmur;
import com.yoyuen.backend.service.ai.KnowledgeBaseService;
import com.yoyuen.backend.service.ai.OriginFileResourceService;
import com.yoyuen.backend.service.system.MurmurService;
import com.yoyuen.backend.utils.BaseResponse;
import com.yoyuen.backend.utils.ResultUtils;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.BeanUtils;
import org.springframework.web.bind.annotation.*;

import java.nio.charset.StandardCharsets;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.List;

/**
 * @Author: YoyuEN
 * @Date: 2026/2/26
 * @Description: 碎碎念控制器
 */
@Slf4j
@RestController
@RequestMapping("/murmur")
@RequiredArgsConstructor
public class MurmurController {

    private final MurmurService murmurService;
    private final KnowledgeBaseService knowledgeBaseService;
    private final OriginFileResourceService originFileResourceService;

    /**
     * 获取碎碎念列表
     */
    @GetMapping("/list")
    public BaseResponse<List<MurmurVO>> list() {
        List<Murmur> murmurs = murmurService.list();
        return ResultUtils.success(murmurs.stream().map(this::toVO).toList());
    }

    /**
     * 获取最新N条碎碎念
     */
    @GetMapping("/latest")
    public BaseResponse<List<MurmurVO>> listLatest(@RequestParam(defaultValue = "4") int limit) {
        List<Murmur> murmurs = murmurService.listLatest(limit);
        return ResultUtils.success(murmurs.stream().map(this::toVO).toList());
    }

    /**
     * 添加碎碎念
     */
    @PostMapping("/create")
    public BaseResponse<String> create(@Valid @RequestBody MurmurVO murmurVO) {
        Murmur murmur = toEntity(murmurVO);
        String id = murmurService.addMurmur(murmur);
        murmurVO.setId(id);
        syncToKnowledgeBase(murmurVO, "新增");
        return ResultUtils.success(id);
    }

    /**
     * 删除碎碎念（先查询再删除，保留完整信息写入知识库）
     */
    @PostMapping("/remove")
    public BaseResponse<Boolean> remove(@RequestBody MurmurVO murmurVO) {
        Murmur existing = murmurService.getById(murmurVO.getId());
        boolean result = murmurService.removeMurmur(murmurVO.getId());
        if (existing != null) {
            syncToKnowledgeBase(toVO(existing), "删除");
        }
        return ResultUtils.success(result);
    }

    /**
     * Entity 转 VO
     */
    private MurmurVO toVO(Murmur murmur) {
        if (murmur == null) return null;
        MurmurVO vo = new MurmurVO();
        BeanUtils.copyProperties(murmur, vo);
        vo.setCreatorId(murmur.getCreator());
        return vo;
    }

    /**
     * VO 转 Entity
     */
    private Murmur toEntity(MurmurVO vo) {
        Murmur murmur = new Murmur();
        BeanUtils.copyProperties(vo, murmur);
        return murmur;
    }

    /**
     * 将碎碎念同步写入 MD 文件并上传至知识库
     */
    private void syncToKnowledgeBase(MurmurVO murmurVO, String operation) {
        try {
            List<KnowledgeBaseVO> bases = knowledgeBaseService.KnowledgeList();
            if (bases.isEmpty()) {
                log.warn("[知识库同步-碎碎念] 未找到任何知识库，跳过同步");
                return;
            }
            String knowledgeId = bases.get(0).getId();
            LocalDateTime now = LocalDateTime.now();
            String timeStr = now.format(DateTimeFormatter.ofPattern("yyyyMMdd_HHmmss"));
            String fileName = "murmur_" + timeStr + ".md";
            byte[] mdBytes = buildMarkdown(murmurVO, operation, now).getBytes(StandardCharsets.UTF_8);
            originFileResourceService.uploadMarkdown(mdBytes, fileName, knowledgeId);
            log.info("[知识库同步-碎碎念] 成功，operation={}, file={}", operation, fileName);
        } catch (Exception e) {
            log.error("[知识库同步-碎碎念] 失败，operation={}, error={}", operation, e.getMessage(), e);
        }
    }

    /**
     * 根据碎碎念 VO 构建 Markdown 字符串
     */
    private String buildMarkdown(MurmurVO murmurVO, String operation, LocalDateTime now) {
        StringBuilder sb = new StringBuilder();
        sb.append("# 每日碎碎念\n\n");
        sb.append("**时间**: ").append(now.format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss"))).append("  \n");
        sb.append("\n## 内容\n\n").append(murmurVO.getText()).append("\n");
        return sb.toString();
    }
}
