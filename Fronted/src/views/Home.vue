<template>
  <div class="home-container">
    <!-- 左侧AI对话区域 -->
    <div class="left-section">
      <!-- 对话消息区域 -->
      <div class="chat-messages">
        <div v-if="messages.length === 0" class="empty-state">
          <el-icon class="empty-icon"><ChatDotRound /></el-icon>
          <p>开始与AI对话吧！</p>
        </div>
        <div
          v-for="(message, index) in messages"
          :key="index"
          :class="['message-item', message.role]"
        >
          <div class="message-avatar">
            <el-icon v-if="message.role === 'user'" color="#4f46e5"><User /></el-icon>
            <el-icon v-else color="#6b7280"><Service /></el-icon>
          </div>
          <div class="message-content">
            <div class="message-text">{{ message.content }}</div>
            <div class="message-time">{{ message.time }}</div>
          </div>
        </div>
      </div>
      <!-- 输入区域 -->
      <div class="chat-input-area">
        <el-input
          v-model="inputMessage"
          type="textarea"
          :rows="3"
          placeholder="输入您的问题..."
          @keydown.ctrl.enter="sendMessage"
        />
        <div class="input-actions">
          <span class="input-tip">按 Ctrl + Enter 发送</span>
          <el-button
            type="primary"
            @click="sendMessage"
            :disabled="!inputMessage.trim()"
          >
            发送
          </el-button>
        </div>
      </div>
    </div>
    
    <!-- 分割线 -->
    <div class="divider"></div>
    
    <!-- 右侧列表区域 -->
    <div class="right-section">
      <div class="article-list">
        <div v-for="(article, index) in listData" :key="index" class="article-item">
          <div class="article-cover">
            <img :src="article.cover" :alt="article.title" />
          </div>
          <div class="article-info">
            <div class="article-title">{{ article.title }}</div>
            <div class="article-date">{{ article.date }}</div>
            <div class="article-excerpt">{{ article.content }}</div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, nextTick } from 'vue'
import { ChatDotRound, User, Service } from '@element-plus/icons-vue'

// AI对话相关
const messages = ref([])
const inputMessage = ref('')

const formatTime = () => {
  const now = new Date()
  return now.toLocaleTimeString('zh-CN', { hour: '2-digit', minute: '2-digit' })
}

const sendMessage = async () => {
  if (!inputMessage.value.trim()) return

  const userMessage = {
    role: 'user',
    content: inputMessage.value.trim(),
    time: formatTime()
  }

  messages.value.push(userMessage)
  const question = inputMessage.value.trim()
  inputMessage.value = ''

  // 模拟AI回复
  setTimeout(() => {
    const aiMessage = {
      role: 'assistant',
      content: `这是对"${question}"的回复。`,
      time: formatTime()
    }
    messages.value.push(aiMessage)
  }, 1000)
}

// 列表数据
const listData = ref([
  {
    date: '2023-05-10',
    title: 'Vue 3 Composition API 入门指南',
    content: '本文详细介绍了Vue 3 Composition API的核心概念和使用方法，包括setup函数、响应式API、生命周期钩子等内容，帮助开发者快速上手Vue 3开发。',
    cover: 'https://picsum.photos/id/1/300/200'
  },
  {
    date: '2023-05-11',
    title: 'Element Plus 组件库使用技巧',
    content: 'Element Plus是Vue 3生态中最流行的UI组件库之一，本文分享了一些实用的使用技巧，包括自定义主题、组件扩展、性能优化等内容。',
    cover: 'https://picsum.photos/id/2/300/200'
  },
  {
    date: '2023-05-12',
    title: '前端性能优化实战',
    content: '性能优化是前端开发中的重要课题，本文从网络请求、渲染性能、资源加载等方面，介绍了一些实用的性能优化技巧和工具。',
    cover: 'https://picsum.photos/id/3/300/200'
  },
  {
    date: '2023-05-13',
    title: 'TypeScript 入门教程',
    content: 'TypeScript是JavaScript的超集，提供了静态类型检查等特性，本文介绍了TypeScript的基础语法、类型系统、接口等核心内容。',
    cover: 'https://picsum.photos/id/4/300/200'
  }
])
</script>

<style scoped>
.home-container {
  padding: 20px;
  height: calc(100vh - 80px);
  display: flex;
  gap: 0;
}

/* 左侧AI对话区域 */
.left-section {
  width: 30%;
  height: 100%;
  display: flex;
  flex-direction: column;
  padding-right: 20px;
}

/* 右侧列表区域 */
.right-section {
  width: 70%;
  height: 100%;
  display: flex;
  flex-direction: column;
  padding-left: 20px;
}

/* 分割线 */
.divider {
  width: 1px;
  background-color: #e0e0e0;
  height: 100%;
  margin: 0 20px;
}

/* 区域标题 */
.section-title {
  font-size: 18px;
  font-weight: bold;
  margin-bottom: 20px;
  color: #333;
}

/* AI对话样式 */
.chat-messages {
  flex: 1;
  overflow-y: auto;
  padding: 20px;
  border-radius: 8px;
  margin-bottom: 20px;
}

.empty-state {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  height: 100%;
  color: #9ca3af;
}

.empty-icon {
  font-size: 60px;
  margin-bottom: 16px;
  color: #d1d5db;
}

.message-item {
  display: flex;
  gap: 12px;
  margin-bottom: 20px;
}

.message-avatar {
  width: 40px;
  height: 40px;
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
  flex-shrink: 0;
}

.message-content {
  flex: 1;
}

.message-text {
  padding: 12px 16px;
  border-radius: 16px;
  background-color: #ffffff;
  color: #1f2937;
  word-wrap: break-word;
  line-height: 1.5;
  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.05);
}

.message-item.user .message-text {
  background-color: #4f46e5;
  color: #ffffff;
}

.message-time {
  font-size: 12px;
  color: #9ca3af;
  margin-top: 4px;
  padding-left: 4px;
}

.chat-input-area {
  padding: 20px;
  border-radius: 8px;
}

.input-actions {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-top: 12px;
}

.input-tip {
  font-size: 12px;
  color: #9ca3af;
}

/* 文章列表样式 */
.article-list {
  overflow-y: auto;
  height: calc(100% - 60px);
  padding-right: 10px;
}

.article-item {
  display: flex;
  gap: 20px;
  padding: 20px;
  border-bottom: 1px solid #f0f0f0;
  transition: all 0.3s ease;
}

.article-item:last-child {
  border-bottom: none;
}

.article-item:hover {
  background-color: #fafafa;
}

.article-cover {
  width: 120px;
  height: 80px;
  flex-shrink: 0;
  overflow: hidden;
  border-radius: 8px;
}

.article-cover img {
  width: 100%;
  height: 100%;
  object-fit: cover;
}

.article-info {
  flex: 1;
  min-width: 0;
}

.article-title {
  font-size: 16px;
  font-weight: bold;
  color: #333;
  margin-bottom: 8px;
  line-height: 1.4;
  display: -webkit-box;
  -webkit-line-clamp: 1;
  -webkit-box-orient: vertical;
  overflow: hidden;
  text-overflow: ellipsis;
}

.article-date {
  font-size: 13px;
  color: #999;
  margin-bottom: 8px;
}

.article-excerpt {
  font-size: 13px;
  color: #666;
  line-height: 1.6;
  display: -webkit-box;
  -webkit-line-clamp: 2;
  -webkit-box-orient: vertical;
  overflow: hidden;
  text-overflow: ellipsis;
}
</style>