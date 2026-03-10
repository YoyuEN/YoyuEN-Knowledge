package com.yoyuen.backend.service.ai;

import reactor.core.publisher.Flux;

/**
 * @Author: YoyuEN
 * @Date: 2026/3/10
 * @Description: 仪表盘AI助手服务
 */
public interface DashboardAssistantService {

    /**
     * 生成仪表盘AI助手报告（流式输出）
     * @return 流式文本
     */
    Flux<String> generateDashboardReport();
}
