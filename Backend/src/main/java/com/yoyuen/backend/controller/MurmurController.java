package com.yoyuen.backend.controller;

import com.yoyuen.backend.controller.vo.MurmurVO;
import com.yoyuen.backend.entity.Murmur;
import com.yoyuen.backend.service.system.MurmurService;
import com.yoyuen.backend.utils.BaseResponse;
import com.yoyuen.backend.utils.ResultUtils;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.BeanUtils;
import org.springframework.web.bind.annotation.*;

import java.util.List;

/**
 * @Author: YoyuEN
 * @Date: 2026/2/26
 * @Description: 碎碎念控制器
 */
@RestController
@RequestMapping("/murmur")
@RequiredArgsConstructor
public class MurmurController {

    private final MurmurService murmurService;

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
    public BaseResponse<List<MurmurVO>> listLatest(@RequestParam(defaultValue = "5") int limit) {
        List<Murmur> murmurs = murmurService.listLatest(limit);
        return ResultUtils.success(murmurs.stream().map(this::toVO).toList());
    }

    /**
     * 添加碎碎念
     */
    @PostMapping("/create")
    public BaseResponse<String> create(@Valid @RequestBody MurmurVO murmurVO) {
        Murmur murmur = toEntity(murmurVO);
        return ResultUtils.success(murmurService.addMurmur(murmur));
    }

    /**
     * 删除碎碎念
     */
    @PostMapping("/remove")
    public BaseResponse<Boolean> remove(@RequestBody MurmurVO murmurVO) {
        return ResultUtils.success(murmurService.removeMurmur(murmurVO.getId()));
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
}
