package com.yoyuen.backend.service.ai.impl;

import com.yoyuen.backend.entity.Comment;
import com.yoyuen.backend.service.ai.DashboardAssistantService;
import com.yoyuen.backend.service.ai.LLMService;
import com.yoyuen.backend.service.system.CommentService;
import com.yoyuen.backend.service.system.ContentService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.ai.chat.model.ChatModel;
import org.springframework.ai.chat.prompt.Prompt;
import org.springframework.stereotype.Service;
import reactor.core.publisher.Flux;

import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.List;
import java.util.stream.Collectors;

/**
 * @Author: YoyuEN
 * @Date: 2026/3/10
 * @Description: 仪表盘AI助手服务实现
 */
@Service
@Slf4j
@RequiredArgsConstructor
public class DashboardAssistantServiceImpl implements DashboardAssistantService {

    private final LLMService llmService;
    private final CommentService commentService;
    private final ContentService contentService;

    @Override
    public Flux<String> generateDashboardReport() {
        try {
            // 获取最近的评论数据
            List<Comment> recentComments = commentService.listAll(null, "approved");

            // 获取内容统计
            long contentCount = contentService.countAll();
            long commentCount = commentService.countAll();

            // 构建提示词
            String prompt = buildPrompt(recentComments, contentCount, commentCount);

            // 使用千问模型进行流式生成
            ChatModel chatModel = llmService.getChatModel();

            return chatModel.stream(new Prompt(prompt))
                    .map(response -> {
                        if (response.getResult() != null && response.getResult().getOutput() != null) {
                            return response.getResult().getOutput().getContent();
                        }
                        return "";
                    })
                    .onErrorResume(e -> {
                        log.error("AI生成报告失败", e);
                        return Flux.just("抱歉，AI助手暂时无法生成报告，请稍后再试。");
                    });

        } catch (Exception e) {
            log.error("生成仪表盘报告失败", e);
            return Flux.just("系统错误，无法生成报告。");
        }
    }

    private String buildPrompt(List<Comment> comments, long contentCount, long commentCount) {
        // 获取当前日期和天气（这里先用模拟数据，后续可接入真实天气API）
        String today = LocalDate.now().format(DateTimeFormatter.ofPattern("yyyy年MM月dd日"));

        // 提取评论内容用于情感分析
        String commentsText = comments.stream()
                .limit(20) // 只取最近20条
                .map(Comment::getContent)
                .collect(Collectors.joining("\n- "));

        return String.format("""
                你是一个友好的AI助手，负责为网站管理员生成每日仪表盘报告。

                今天是%s。网站目前共有 %d 篇内容，%d 条评论。

                最近的评论内容：
                %s

                请严格按照以下格式生成报告：

                ## 🌤️ 早安问候
                用1-2句话打招呼，提及日期和天气（可适当发挥）

                ## 📊 评论分析
                分析最近评论的：
                - **情感倾向**：整体是积极/中性/消极
                - **热门话题**：用户主要讨论什么
                - **关注重点**：用户最关心的问题

                ## 💡 运营建议
                给出1-2条具体的运营建议

                ## ✨ 今日寄语
                用一句鼓励的话结束

                要求：
                - 每个章节之间必须空一行
                - 使用markdown格式（##标题、**加粗**、- 列表）
                - 语气轻松友好，适当使用emoji
                - 总字数300字左右
                """,
                today,
                contentCount,
                commentCount,
                commentsText.isEmpty() ? "暂无评论数据" : commentsText
        );
    }
}
