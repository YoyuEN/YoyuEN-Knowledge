package com.yoyuen.backend.chat;

import org.jetbrains.annotations.NotNull;
import org.springframework.ai.chat.client.advisor.AbstractChatMemoryAdvisor;
import org.springframework.ai.chat.client.advisor.api.*;
import org.springframework.ai.chat.memory.ChatMemory;
import org.springframework.ai.chat.messages.Message;
import org.springframework.ai.chat.messages.UserMessage;
import org.springframework.ai.chat.model.MessageAggregator;
import reactor.core.publisher.Flux;

import java.util.ArrayList;
import java.util.List;

/**
 * @Author: YoyuEN
 * @Date: 2026/2/25
 * @Time: 10:55
 * @Description:
 */
public class MessageChatMemoryAdvisor extends AbstractChatMemoryAdvisor<ChatMemory> {

    public MessageChatMemoryAdvisor(ChatMemory chatMemory) {
        super(chatMemory);
    }

    public MessageChatMemoryAdvisor(ChatMemory chatMemory, String defaultConversationId, int chatHistoryWindowSize) {
        this(chatMemory, defaultConversationId, chatHistoryWindowSize, Advisor.DEFAULT_CHAT_MEMORY_PRECEDENCE_ORDER);
    }

    public MessageChatMemoryAdvisor(ChatMemory chatMemory, String defaultConversationId, int chatHistoryWindowSize,
                                    int order) {
        super(chatMemory, defaultConversationId, chatHistoryWindowSize, true, order);
    }

    public static Builder builder(ChatMemory chatMemory) {
        return new Builder(chatMemory);
    }

    @NotNull
    @Override
    public AdvisedResponse aroundCall(AdvisedRequest advisedRequest, CallAroundAdvisorChain chain) {

        advisedRequest = this.before(advisedRequest);

        AdvisedResponse advisedResponse = chain.nextAroundCall(advisedRequest);

        this.observeAfter(advisedResponse);

        return advisedResponse;
    }

    @NotNull
    @Override
    public Flux<AdvisedResponse> aroundStream(AdvisedRequest advisedRequest, StreamAroundAdvisorChain chain) {

        Flux<AdvisedResponse> advisedResponses = this.doNextWithProtectFromBlockingBefore(advisedRequest, chain,
                this::before);

        return new MessageAggregator().aggregateAdvisedResponse(advisedResponses, this::observeAfter);
    }

    private AdvisedRequest before(AdvisedRequest request) {

        String conversationId = this.doGetConversationId(request.adviseContext());

        int chatMemoryRetrieveSize = this.doGetChatMemoryRetrieveSize(request.adviseContext());

        // 1. Retrieve the chat memory for the current conversation.
        List<Message> memoryMessages = this.getChatMemoryStore().get(conversationId, chatMemoryRetrieveSize);

        // 2. Advise the request messages list.
        List<Message> advisedMessages = new ArrayList<>(request.messages());
        advisedMessages.addAll(memoryMessages);

        // 3. Create a new request with the advised messages.
        AdvisedRequest advisedRequest = AdvisedRequest.from(request).withMessages(advisedMessages).build();

        // 4. Add the new user input to the conversation memory., request.userParams()
        // UserMessage userMessage = new UserMessage(request.userText(), request.media());
        UserMessage userMessage = new UserMessage(request.userText(), request.media(), request.userParams());

        this.getChatMemoryStore().add(this.doGetConversationId(request.adviseContext()), userMessage);

        return advisedRequest;
    }

    private void observeAfter(AdvisedResponse advisedResponse) {

        assert advisedResponse.response() != null;
        List<Message> assistantMessages = advisedResponse.response()
                .getResults()
                .stream()
                .map(g -> (Message) g.getOutput())
                .toList();

        this.getChatMemoryStore().add(this.doGetConversationId(advisedResponse.adviseContext()), assistantMessages);
    }

    public static class Builder extends AbstractBuilder<ChatMemory> {

        protected Builder(ChatMemory chatMemory) {
            super(chatMemory);
        }

        @NotNull
        public MessageChatMemoryAdvisor build() {
            return new MessageChatMemoryAdvisor(this.chatMemory, this.conversationId, this.chatMemoryRetrieveSize,
                    this.order);
        }

    }

}
