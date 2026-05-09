package com.yoyuen.backend.controller;

import com.yoyuen.backend.entity.Diary;
import com.yoyuen.backend.service.system.DiaryService;
import com.yoyuen.backend.utils.BaseResponse;
import com.yoyuen.backend.utils.ResultUtils;
import lombok.RequiredArgsConstructor;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/diary")
@RequiredArgsConstructor
public class DiaryController {

    private final DiaryService diaryService;

    @GetMapping("/list")
    public BaseResponse<List<Diary>> list(@RequestParam(required = false) String type) {
        return ResultUtils.success(diaryService.listAll(type));
    }

    @PreAuthorize("hasRole('ADMIN')")
    @GetMapping("/admin-list")
    public BaseResponse<List<Diary>> adminList() {
        return ResultUtils.success(diaryService.listAll(null));
    }

    @PreAuthorize("hasRole('ADMIN')")
    @PostMapping("/create")
    public BaseResponse<String> create(@RequestBody Diary diary) {
        return ResultUtils.success(diaryService.addDiary(diary));
    }

    @PreAuthorize("hasRole('ADMIN')")
    @PostMapping("/update")
    public BaseResponse<Boolean> update(@RequestBody Diary diary) {
        return ResultUtils.success(diaryService.updateDiary(diary));
    }

    @PreAuthorize("hasRole('ADMIN')")
    @PostMapping("/remove/{id}")
    public BaseResponse<Boolean> remove(@PathVariable String id) {
        return ResultUtils.success(diaryService.removeDiary(id));
    }
}
