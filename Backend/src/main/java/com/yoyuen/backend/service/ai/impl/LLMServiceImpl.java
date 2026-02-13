package com.yoyuen.backend.service.ai.impl;

import com.yoyuen.backend.service.ai.LLMService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.ai.chat.model.ChatModel;
import org.springframework.ai.openai.OpenAiChatModel;
import org.springframework.ai.openai.OpenAiChatOptions;
import org.springframework.ai.openai.api.OpenAiApi;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

/**
 * @Author: YoyuEN
 * @Date: 2026/2/13
 * @Time: 13:46
 * @Description:
 */
@Service
@Slf4j
@RequiredArgsConstructor
public class LLMServiceImpl implements LLMService {

    /*
    * 简单对话
    * */
    @Value("${chat.simple.base.url}")
    private String simpleBaseUrl;
    @Value("${chat.simple.api.key}")
    private String simpleApiKey;
    @Value("${chat.simple.model}")
    private String simpleModel;

    /*
    * 长文本对话
    * */
    private String longBaseUrl;
    private String longApiKey;
    private String longModel;

    /*
    * 多模态
    * */
    private String multiBaseUrl;
    private String multiApiKey;
    private String multiModel;


    @Override
    public ChatModel getChatModel() {
        OpenAiApi openAiApi = new OpenAiApi(simpleBaseUrl, simpleApiKey);
        return new OpenAiChatModel(openAiApi, OpenAiChatOptions.builder().withModel(simpleModel).build());
    }

    @Override
    public ChatModel getLongContextChatModel() {
        return null;
    }

    @Override
    public ChatModel getMultimodalModel() {
        return null;
    }
}
