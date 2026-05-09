package com.yoyuen.backend.service.system;

import com.yoyuen.backend.entity.Diary;

import java.util.List;

public interface DiaryService {

    List<Diary> listByType(String type);

    List<Diary> listAll(String type);

    Diary getById(String id);

    String addDiary(Diary diary);

    boolean updateDiary(Diary diary);

    boolean removeDiary(String id);
}
