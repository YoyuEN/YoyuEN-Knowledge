package com.yoyuen.backend.chat;

/**
 * @Author: YoyuEN
 * @Date: 2026/2/2
 * @Time: 18:27
 * @Description:
 */
import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.mongodb.client.MongoClient;
import com.mongodb.client.MongoClients;
import com.mongodb.client.model.CreateCollectionOptions;
import dev.langchain4j.data.document.Document;
import dev.langchain4j.data.document.DocumentSplitter;
import dev.langchain4j.data.document.Metadata;
import dev.langchain4j.data.embedding.Embedding;
import dev.langchain4j.data.segment.TextSegment;
import dev.langchain4j.model.chat.ChatLanguageModel;
import dev.langchain4j.model.openai.OpenAiChatModel;
import dev.langchain4j.model.openai.OpenAiEmbeddingModel;
import dev.langchain4j.model.openai.OpenAiEmbeddingModelName;
import dev.langchain4j.model.openai.OpenAiTokenizer;
import dev.langchain4j.rag.content.retriever.ContentRetriever;
import dev.langchain4j.rag.content.retriever.EmbeddingStoreContentRetriever;
import dev.langchain4j.store.embedding.*;
import dev.langchain4j.store.embedding.inmemory.InMemoryEmbeddingStore;
import dev.langchain4j.store.embedding.mongodb.IndexMapping;
import dev.langchain4j.store.embedding.mongodb.MongoDbEmbeddingStore;
import dev.langchain4j.service.AiServices;
import org.bson.conversions.Bson;
import dev.langchain4j.data.document.splitter.DocumentSplitters;

import java.io.*;
import java.util.*;

public class LangChainRagApp {

    public static void main(String[] args) {
        try {
            // 使用本地 MongoDB 存储
            MongoClient mongoClient = MongoClients.create("mongodb://localhost:27017");
            EmbeddingStore<TextSegment> embeddingStore = createSimpleMongoEmbeddingStore(mongoClient);

            // Embedding Model setup - 使用阿里云 DashScope
            OpenAiEmbeddingModel embeddingModel = OpenAiEmbeddingModel.builder()
                    .apiKey(System.getenv("DASHSCOPE_API_KEY"))
                    .baseUrl("https://dashscope.aliyuncs.com/compatible-mode/v1")
                    .modelName("text-embedding-v1")
                    .build();

            // Chat Model setup - 使用阿里云 DashScope
            ChatLanguageModel chatModel = OpenAiChatModel.builder()
                    .apiKey(System.getenv("DASHSCOPE_API_KEY"))
                    .baseUrl("https://dashscope.aliyuncs.com/compatible-mode/v1")
                    .modelName("qwen-max")
                    .build();

            // Load documents
            String resourcePath = "devcenter-content-snapshot.2024-05-20.json";
            List<TextSegment> documents = loadJsonDocuments(resourcePath, 800, 200);

            System.out.println("Loaded " + documents.size() + " documents");

            for (int i = 0; i < documents.size()/10; i++) {
                TextSegment segment = documents.get(i);
                Embedding embedding = embeddingModel.embed(segment.text()).content();
                embeddingStore.add(embedding, segment);
            }

            System.out.println("Stored embeddings");

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // 创建简单的 MongoDB 存储（不使用 Atlas 向量搜索）
    private static EmbeddingStore<TextSegment> createSimpleMongoEmbeddingStore(MongoClient mongoClient) {
        String databaseName = "rag_app";
        String collectionName = "embeddings";
        String indexName = "embedding_index";

        // 不创建向量搜索索引，使用基本的 MongoDB 存储
        return MongoDbEmbeddingStore.builder()
//                .mongoClient(mongoClient)
                .databaseName(databaseName)
                .collectionName(collectionName)
                .indexName(indexName)
                .createIndex(false)  // 关键：不创建 Atlas 向量搜索索引
                .build();
    }

    private static EmbeddingStore<TextSegment> createEmbeddingStore(MongoClient mongoClient) {
        String databaseName = "rag_app";
        String collectionName = "embeddings";
        String indexName = "embedding";
        Long maxResultRatio = 10L;
        CreateCollectionOptions createCollectionOptions = new CreateCollectionOptions();
        Bson filter = null;
        Set<String> metadataFields = new HashSet<>();
        IndexMapping indexMapping = new IndexMapping(1536, metadataFields);
        Boolean createIndex = true;

        return new MongoDbEmbeddingStore(
                mongoClient,
                databaseName,
                collectionName,
                indexName,
                maxResultRatio,
                createCollectionOptions,
                filter,
                indexMapping,
                createIndex
        );
    }

    private static List<TextSegment> loadJsonDocuments(String resourcePath, int maxTokensPerChunk, int overlapTokens) throws IOException {
        List<TextSegment> textSegments = new ArrayList<>();

        // Load file from resources using the ClassLoader
        InputStream inputStream = LangChainRagApp.class.getClassLoader().getResourceAsStream(resourcePath);

        if (inputStream == null) {
            throw new FileNotFoundException("Resource not found: " + resourcePath);
        }

        // Jackson ObjectMapper
        ObjectMapper objectMapper = new ObjectMapper();
        BufferedReader reader = new BufferedReader(new InputStreamReader(inputStream));

        // Batch size for processing
        int batchSize = 500;  // Adjust batch size as needed
        List<Document> batch = new ArrayList<>();

        String line;
        while ((line = reader.readLine()) != null) {
            JsonNode jsonNode = objectMapper.readTree(line);

            String title = jsonNode.path("title").asText(null);
            String body = jsonNode.path("body").asText(null);
            JsonNode metadataNode = jsonNode.path("metadata");

            if (body != null) {
                String text = (title != null ? title + "\n\n" + body : body);

                Metadata metadata = new Metadata();
                if (metadataNode != null && metadataNode.isObject()) {
                    Iterator<String> fieldNames = metadataNode.fieldNames();
                    while (fieldNames.hasNext()) {
                        String fieldName = fieldNames.next();
                        metadata.put(fieldName, metadataNode.path(fieldName).asText());
                    }
                }

                Document document = Document.from(text, metadata);
                batch.add(document);

                // If batch size is reached, process the batch
                if (batch.size() >= batchSize) {
                    textSegments.addAll(splitIntoChunks(batch, maxTokensPerChunk, overlapTokens));
                    batch.clear();
                }
            }
        }

        // Process remaining documents in the last batch
        if (!batch.isEmpty()) {
            textSegments.addAll(splitIntoChunks(batch, maxTokensPerChunk, overlapTokens));
        }

        return textSegments;
    }

    private static List<TextSegment> splitIntoChunks(List<Document> documents, int maxTokensPerChunk, int overlapTokens) {
        // Create a tokenizer for OpenAI
        OpenAiTokenizer tokenizer = new OpenAiTokenizer(OpenAiEmbeddingModelName.TEXT_EMBEDDING_ADA_002);

        // Create a recursive document splitter with the specified token size and overlap
        DocumentSplitter splitter = DocumentSplitters.recursive(
                maxTokensPerChunk,
                overlapTokens,
                tokenizer
        );

        List<TextSegment> allSegments = new ArrayList<>();
        for (Document document : documents) {
            List<TextSegment> segments = splitter.split(document);
            allSegments.addAll(segments);
        }

        return allSegments;
    }
}
