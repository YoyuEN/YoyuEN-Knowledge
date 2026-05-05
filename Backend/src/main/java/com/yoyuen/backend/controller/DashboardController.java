package com.yoyuen.backend.controller;

import com.yoyuen.backend.entity.Comment;
import com.yoyuen.backend.entity.Content;
import com.yoyuen.backend.service.ai.DashboardAssistantService;
import com.yoyuen.backend.service.system.CommentService;
import com.yoyuen.backend.service.system.ContentService;
import com.yoyuen.backend.utils.BaseResponse;
import com.yoyuen.backend.utils.ResultUtils;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.MediaType;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import reactor.core.publisher.Flux;

import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
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
@PreAuthorize("hasRole('ADMIN')")
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
     */
    @GetMapping("/statistics")
    public BaseResponse<Map<String, Object>> getStatistics() {
        long todayContent = contentService.countToday();
        long todayComment = commentService.countToday();
        long weekContent = contentService.countRecentDays(7);
        long weekComment = commentService.countRecentDays(7);
        long monthContent = contentService.countRecentDays(30);
        long monthComment = commentService.countRecentDays(30);

        Map<String, Object> result = new LinkedHashMap<>();
        result.put("todayVisits", todayContent + todayComment);
        result.put("weekVisits", weekContent + weekComment);
        result.put("monthVisits", monthContent + monthComment);

        // 近7天内容发布趋势
        Map<String, Integer> contentStats = contentService.getActivityStats(7);
        List<Map<String, Object>> trendData = new ArrayList<>();
        DateTimeFormatter fmt = DateTimeFormatter.ofPattern("MM-dd");
        for (int i = 6; i >= 0; i--) {
            String date = LocalDate.now().minusDays(i).format(fmt);
            int count = contentStats.getOrDefault(date, 0);
            Map<String, Object> item = new LinkedHashMap<>();
            item.put("date", date);
            item.put("visits", count);
            trendData.add(item);
        }
        result.put("trendData", trendData);

        // 浏览量最高的内容
        List<Content> topContents = contentService.listTopByViews(5);
        List<Map<String, Object>> topPages = new ArrayList<>();
        for (Content content : topContents) {
            Map<String, Object> item = new LinkedHashMap<>();
            item.put("path", "/article/" + content.getId());
            item.put("views", content.getViewCount() != null ? content.getViewCount() : 0);
            topPages.add(item);
        }
        result.put("topPages", topPages);

        return ResultUtils.success(result);
    }

    /**
     * 获取快捷信息
     */
    @GetMapping("/quick-info")
    public BaseResponse<Map<String, Object>> getQuickInfo() {
        List<Comment> pendingList = commentService.listAll(null, "pending");
        long pendingComments = pendingList.size();
        long todayComments = commentService.countToday();

        List<Map<String, Object>> notifications = new ArrayList<>();
        for (Comment comment : pendingList.stream().limit(2).toList()) {
            Map<String, Object> notification = new LinkedHashMap<>();
            notification.put("type", "comment");
            notification.put("message", String.format("%s 评论了《%s》待审核",
                    comment.getAuthor() != null ? comment.getAuthor() : "匿名",
                    comment.getContentId() != null ? comment.getContentId() : "未知内容"));
            notifications.add(notification);
        }
        if (notifications.isEmpty()) {
            Map<String, Object> notification = new LinkedHashMap<>();
            notification.put("type", "system");
            notification.put("message", "暂无待处理事项");
            notifications.add(notification);
        }

        Map<String, Object> result = new LinkedHashMap<>();
        result.put("pendingComments", pendingComments);
        result.put("draftArticles", 0);
        result.put("todayComments", todayComments);
        result.put("notifications", notifications);

        return ResultUtils.success(result);
    }
}
