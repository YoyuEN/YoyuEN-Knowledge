package com.yoyuen.backend.service.ai;

import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.web.reactive.function.client.WebClient;
import org.w3c.dom.Document;
import org.w3c.dom.NodeList;

import javax.xml.parsers.DocumentBuilderFactory;
import java.io.ByteArrayInputStream;
import java.nio.charset.StandardCharsets;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

/**
 * @Author: YoyuEN
 * @Date: 2026/3/19
 * @Description: 抓取 AI 热点新闻（多源降级）
 */
@Service
@Slf4j
public class NewsService {

    // 按优先级排列，逐个尝试直到成功
    private static final List<String> RSS_SOURCES = List.of(
            "https://rsshub.app/36kr/news/technology",   // 36kr 科技
            "https://rsshub.app/sspai/matrix",            // 少数派
            "https://rss.sina.com.cn/news/tech/index.xml" // 新浪科技
    );
    private static final int MAX_NEWS = 5;

    private final WebClient webClient = WebClient.builder()
            .codecs(c -> c.defaultCodecs().maxInMemorySize(2 * 1024 * 1024))
            .build();

    public List<String> fetchHotNews() {
        for (String url : RSS_SOURCES) {
            try {
                String xml = webClient.get()
                        .uri(url)
                        .retrieve()
                        .bodyToMono(String.class)
                        .block();

                if (xml == null || xml.isBlank()) continue;

                Document doc = DocumentBuilderFactory.newInstance()
                        .newDocumentBuilder()
                        .parse(new ByteArrayInputStream(xml.getBytes(StandardCharsets.UTF_8)));

                NodeList titles = doc.getElementsByTagName("title");
                List<String> news = new ArrayList<>();
                for (int i = 1; i < titles.getLength() && news.size() < MAX_NEWS; i++) {
                    String title = titles.item(i).getTextContent().trim();
                    if (!title.isBlank()) news.add(title);
                }
                if (!news.isEmpty()) return news;
            } catch (Exception e) {
                log.warn("新闻源 {} 获取失败，尝试下一个: {}", url, e.getMessage());
            }
        }
        log.warn("所有新闻源均不可用，跳过热点模块");
        return Collections.emptyList();
    }
}
