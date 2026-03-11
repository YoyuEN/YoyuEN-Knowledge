package com.yoyuen.backend.service.ai.impl;

import com.yoyuen.backend.entity.Comment;
import com.yoyuen.backend.entity.Content;
import com.yoyuen.backend.service.ai.DashboardAssistantService;
import com.yoyuen.backend.service.ai.LLMService;
import com.yoyuen.backend.service.system.CommentService;
import com.yoyuen.backend.service.system.ContentService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.ai.chat.model.ChatModel;
import org.springframework.ai.chat.prompt.Prompt;
import org.springframework.core.io.ClassPathResource;
import org.springframework.stereotype.Service;
import reactor.core.publisher.Flux;

import java.io.IOException;
import java.nio.charset.StandardCharsets;
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
            List<Comment> recentComments = commentService.listAll(null, "approved");
            List<Content> recentArticles = contentService.listRecent(5);
            long contentCount = contentService.countAll();
            long commentCount = commentService.countAll();

            String prompt = buildPrompt(recentComments, recentArticles, contentCount, commentCount);
            ChatModel chatModel = llmService.getChatModel();

            return chatModel.stream(new Prompt(prompt))
                    .map(response -> {
                        if (response.getResult() != null && response.getResult().getOutput() != null) {
                            String content = response.getResult().getOutput().getContent();
                            return content != null ? content : "";
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

    private String buildPrompt(List<Comment> comments, List<Content> articles,
                               long contentCount, long commentCount) throws IOException {
        // 从资源文件读取提示词模板
        ClassPathResource resource = new ClassPathResource("prompt/dashboard-assistant.md");
        String template = resource.getContentAsString(StandardCharsets.UTF_8);

        String today = LocalDate.now().format(DateTimeFormatter.ofPattern("yyyy年MM月dd日"));

        // 格式化评论数据
        String commentsText = comments.stream()
                .limit(15)
                .map(Comment::getContent)
                .collect(Collectors.joining("\n- ", "- ", ""));
        if (commentsText.equals("- ")) {
            commentsText = "暂无评论数据";
        }

        // 格式化文章数据
        String articlesText = articles.stream()
                .map(a -> String.format("- 《%s》（%s）：%s",
                        a.getTitle(),
                        a.getCategory(),
                        a.getDescription() != null ? a.getDescription() : "暂无描述"))
                .collect(Collectors.joining("\n"));
        if (articlesText.isEmpty()) {
            articlesText = "暂无文章数据";
        }

        return template
                .replace("{date}", today)
                .replace("{content_count}", String.valueOf(contentCount))
                .replace("{comment_count}", String.valueOf(commentCount))
                .replace("{comments}", commentsText)
                .replace("{articles}", articlesText);
    }
}
