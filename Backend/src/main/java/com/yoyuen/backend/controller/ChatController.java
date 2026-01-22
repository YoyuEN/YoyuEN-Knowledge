package com.yoyuen.backend.controller;

import dev.langchain4j.model.chat.ChatLanguageModel;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

/**
 * @Author: YoyuEN
 * @Date: 2025/12/28
 * @Time: 11:43
 * @Description:
 */
@RestController
@RequestMapping("/api")
public class ChatController {

    ChatLanguageModel chatLanguageModel;

    public ChatController(ChatLanguageModel chatLanguageModel) {
        this.chatLanguageModel = chatLanguageModel;
    }

    @GetMapping("/chat")
    public String model(@RequestParam(value = "message", defaultValue = "Hello") String message) {
        return chatLanguageModel.chat(message);
    }
}

