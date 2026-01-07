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
      <div class="section-title">列表</div>
      <el-table :data="listData" style="width: 100%">
        <el-table-column prop="date" label="日期" width="180" />
        <el-table-column prop="name" label="名称" width="180" />
        <el-table-column prop="address" label="地址" />
      </el-table>
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
    name: '张三',
    address: '北京市朝阳区'
  },
  {
    date: '2023-05-11',
    name: '李四',
    address: '上海市浦东新区'
  },
  {
    date: '2023-05-12',
    name: '王五',
    address: '广州市天河区'
  },
  {
    date: '2023-05-13',
    name: '赵六',
    address: '深圳市南山区'
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

/* 列表样式 */
:deep(.el-table) {
  border-radius: 8px;
  overflow: hidden;
}
</style>