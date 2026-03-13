package com.yoyuen.backend.controller;

import com.yoyuen.backend.utils.BaseResponse;
import com.yoyuen.backend.utils.ResultUtils;
import com.yoyuen.backend.service.ai.DashboardAssistantService;
import com.yoyuen.backend.service.system.CommentService;
import com.yoyuen.backend.service.system.ContentService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.MediaType;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import reactor.core.publisher.Flux;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.HashMap;
import java.util.Map;

/**
 * @Author: YoyuEN
 * @Date: 2026/3/10
 * @Description: 仪表盘控制器
 */
@RestController
@RequestMapping("/dashboard")
@RequiredArgsConstructor
@Slf4j
public class DashboardController {

    private final DashboardAssistantService dashboardAssistantService;
    private final CommentService commentService;
    private final ContentService contentService;

    /**
     * 获取AI助手报告（SSE流式输出）
     */
    @GetMapping(value = "/assistant/report", produces = MediaType.TEXT_EVENT_STREAM_VALUE)
    public Flux<String> getAssistantReport() {
        log.info("开始生成AI助手报告");
        return dashboardAssistantService.generateDashboardReport();
    }

    /**
     * 获取网站访问统计
     * 这里先返回模拟数据，后续对接第三方统计服务
     */
    @GetMapping("/statistics")
    public Object getStatistics() {
        return new Object() {
            public final long todayVisits = 1234;
            public final long weekVisits = 8567;
            public final long monthVisits = 35678;
            public final Object[] trendData = new Object[]{
                new Object() { public final String date = "03-04"; public final int visits = 1200; },
                new Object() { public final String date = "03-05"; public final int visits = 1350; },
                new Object() { public final String date = "03-06"; public final int visits = 980; },
                new Object() { public final String date = "03-07"; public final int visits = 1450; },
                new Object() { public final String date = "03-08"; public final int visits = 1680; },
                new Object() { public final String date = "03-09"; public final int visits = 1520; },
                new Object() { public final String date = "03-10"; public final int visits = 1234; }
            };
            public final Object[] topPages = new Object[]{
                new Object() { public final String path = "/article/vue3-tutorial"; public final int views = 456; },
                new Object() { public final String path = "/article/spring-boot-guide"; public final int views = 389; },
                new Object() { public final String path = "/article/react-hooks"; public final int views = 312; },
                new Object() { public final String path = "/"; public final int views = 278; },
                new Object() { public final String path = "/about"; public final int views = 156; }
            };
        };
    }

    /**
     * 获取快捷信息
     */
    @GetMapping("/quick-info")
    public Object getQuickInfo() {
        // 这里可以调用其他服务获取真实数据
        return new Object() {
            public final int pendingComments = 3;
            public final int draftArticles = 5;
            public final int todayComments = 12;
            public final Object[] notifications = new Object[]{
                new Object() { public final String type = "comment"; public final String message = "文章《Vue3实战》收到新评论"; },
                new Object() { public final String type = "system"; public final String message = "系统将于今晚23:00进行维护"; }
            };
        };
    }
}
