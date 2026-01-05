<template>
  <div class="chat-container">
    <el-card class="chat-card">
      
      <!-- 对话消息区域 -->
      <div class="chat-messages" ref="messagesContainer">
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
            <el-icon v-if="message.role === 'user'"><User /></el-icon>
            <el-icon v-else><Service /></el-icon>
          </div>
          <div class="message-content">
            <div class="message-text">{{ message.content }}</div>
            <div class="message-time">{{ message.time }}</div>
          </div>
        </div>
        <div v-if="loading" class="message-item assistant">
          <div class="message-avatar">  
            <el-icon><Service /></el-icon>
          </div>
          <div class="message-content">
            <div class="message-text typing">
              <span></span>
              <span></span>
              <span></span>
            </div>
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
          class="input-textarea"
        />
        <div class="input-actions">
          <span class="input-tip">按 Ctrl + Enter 发送</span>
          <el-button
            type="primary"
            :icon="Promotion"
            @click="sendMessage"
            :loading="loading"
            :disabled="!inputMessage.trim()"
          >
            发送
          </el-button>
        </div>
      </div>
    </el-card>
  </div>
</template>

<script setup>
import { ref, nextTick } from 'vue'
import {
  ChatDotRound,
  User,
  Service,
  Promotion,
} from '@element-plus/icons-vue'

const messages = ref([])
const inputMessage = ref('')
const loading = ref(false)
const messagesContainer = ref(null)

const formatTime = () => {
  const now = new Date()
  return now.toLocaleTimeString('zh-CN', { hour: '2-digit', minute: '2-digit' })
}

const sendMessage = async () => {
  if (!inputMessage.value.trim() || loading.value) return

  const userMessage = {
    role: 'user',
    content: inputMessage.value.trim(),
    time: formatTime()
  }

  messages.value.push(userMessage)
  const question = inputMessage.value.trim()
  inputMessage.value = ''
  loading.value = true

  // 滚动到底部
  await nextTick()
  scrollToBottom()

  // 模拟AI回复（实际应该调用API）
  setTimeout(() => {
    const aiMessage = {
      role: 'assistant',
      content: `这是对"${question}"的回复。AI对话功能正在开发中，敬请期待！`,
      time: formatTime()
    }
    messages.value.push(aiMessage)
    loading.value = false
    nextTick(() => {
      scrollToBottom()
    })
  }, 1000)
}

const scrollToBottom = () => {
  if (messagesContainer.value) {
    messagesContainer.value.scrollTop = messagesContainer.value.scrollHeight
  }
}
</script>

<style scoped>
.chat-container {
  padding: 20px;
  height: calc(100vh - 80px);
  display: flex;
  flex-direction: column;
  max-width: 30%;
  margin: 0;
}

.chat-card {
  height: 100%;
  display: flex;
  flex-direction: column;
  background-color: var(--diary-page-bg);
  border-radius: 16px;
  border: none;
  box-shadow: 0 8px 24px rgba(0, 0, 0, 0.05);
  position: relative;
  overflow: hidden;
  backdrop-filter: blur(10px);
}

.card-header {
  display: flex;
  align-items: center;
  gap: 10px;
  font-weight: 700;
  font-size: 18px;
  color: #333;
  padding: 20px;
  border-bottom: 1px solid rgba(0, 0, 0, 0.05);
  background: rgba(255, 255, 255, 0.8);
}

.chat-messages {
  flex: 1;
  overflow-y: auto;
  padding: 24px;
  display: flex;
  flex-direction: column;
  gap: 24px;
  padding-bottom: 160px;
}

.empty-state {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  height: 100%;
  color: #9ca3af;
  animation: fadeIn 0.5s ease-out;
}

.empty-icon {
  font-size: 80px;
  margin-bottom: 24px;
  color: #d1d5db;
  background: #f3f4f6;
  padding: 30px;
  border-radius: 50%;
}

.empty-state p {
  font-size: 18px;
  font-weight: 500;
  letter-spacing: 0.5px;
}

.message-item {
  display: flex;
  gap: 16px;
  animation: slideIn 0.4s cubic-bezier(0.16, 1, 0.3, 1);
  max-width: 85%;
  align-self: flex-start;
}

.message-item.user {
  flex-direction: row;
  align-self: flex-start;
}

.message-avatar {
  width: 44px;
  height: 44px;
  border-radius: 12px;
  display: flex;
  align-items: center;
  justify-content: center;
  flex-shrink: 0;
  background: linear-gradient(135deg, #e0e7ff 0%, #c7d2fe 100%);
  color: #4f46e5;
  box-shadow: 0 4px 6px -1px rgba(79, 70, 229, 0.1);
  font-size: 20px;
}

.message-item.user .message-avatar {
  background: linear-gradient(135deg, #4f46e5 0%, #4338ca 100%);
  color: #ffffff;
  box-shadow: 0 4px 6px -1px rgba(67, 56, 202, 0.2);
}

.message-content {
  display: flex;
  flex-direction: column;
  gap: 4px;
}

.message-item.user .message-content {
  align-items: flex-start;
}

.message-text {
  padding: 14px 18px;
  border-radius: 0 16px 16px 16px;
  background-color: #ffffff;
  color: #1f2937;
  word-wrap: break-word;
  white-space: pre-wrap;
  line-height: 1.6;
  font-size: 15px;
  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.04), 0 1px 2px rgba(0, 0, 0, 0.02);
  border: 1px solid rgba(0, 0, 0, 0.03);
}

.message-item.user .message-text {
  border-radius: 16px 16px 16px 0;
  background: linear-gradient(135deg, #4f46e5 0%, #4338ca 100%);
  color: #ffffff;
  box-shadow: 0 4px 6px -1px rgba(79, 70, 229, 0.2);
  border: none;
}

.message-time {
  font-size: 12px;
  color: #9ca3af;
  margin-top: 4px;
  padding: 0 4px;
}

.typing {
  display: flex;
  gap: 6px;
  padding: 16px 20px;
  align-items: center;
  min-height: 24px;
}

.typing span {
  width: 8px;
  height: 8px;
  border-radius: 50%;
  background-color: #6b7280;
  animation: typing 1.4s infinite ease-in-out both;
}

@keyframes typing {
  0%, 80%, 100% { transform: scale(0); }
  40% { transform: scale(1); }
}

@keyframes slideIn {
  from {
    opacity: 0;
    transform: translateY(20px);
  }
  to {
    opacity: 1;
    transform: translateY(0);
  }
}

.chat-input-area {
  position: absolute;
  left: 24px;
  right: 24px;
  bottom: 24px;
  z-index: 100;
  padding: 12px;
  border-radius: 16px;
  box-shadow: 0 10px 25px -5px rgba(0, 0, 0, 0.1), 0 8px 10px -6px rgba(0, 0, 0, 0.1);
  border: 1px solid rgba(255, 255, 255, 0.5);
  background: rgba(255, 255, 255, 0.85);
  backdrop-filter: blur(12px);
  display: flex;
  flex-direction: column;
  gap: 12px;
}

.input-textarea {
  margin-bottom: 0;
}

.input-textarea :deep(.el-textarea__inner) {
  background-color: transparent;
  color: #1f2937;
  border: none;
  box-shadow: none;
  padding: 8px 12px;
  font-size: 15px;
  resize: none;
}

.input-textarea :deep(.el-textarea__inner):focus {
  box-shadow: none;
}

.input-actions {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 0 8px;
  border-top: 1px solid rgba(0, 0, 0, 0.05);
  padding-top: 12px;
}

.input-tip {
  font-size: 12px;
  color: #9ca3af;
  background: rgba(0, 0, 0, 0.03);
  padding: 4px 8px;
  border-radius: 4px;
}

/* Custom Scrollbar */
.chat-messages::-webkit-scrollbar {
  width: 6px;
}

.chat-messages::-webkit-scrollbar-track {
  background: transparent;
}

.chat-messages::-webkit-scrollbar-thumb {
  background-color: rgba(156, 163, 175, 0.5);
  border-radius: 20px;
}

.chat-messages::-webkit-scrollbar-thumb:hover {
  background-color: rgba(107, 114, 128, 0.8);
}
</style>