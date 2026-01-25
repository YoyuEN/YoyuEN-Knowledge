<template>
  <div class="home-container">
    <div class="chat-area">
      <!-- 回复区域 -->
      <div class="reply-content">
        <!-- 用户提问内容 - 固定在顶部 -->
        <transition name="question-change" mode="out-in">
          <div class="user-question" v-if="currentQuestion" :key="currentQuestion">
            <div class="question-text">{{ currentQuestion }}</div>
          </div>
        </transition>

        <!-- AI回复列表 -->
        <div class="ai-replies" ref="repliesContainer">
          <div 
            v-for="(reply, index) in aiReplies" 
            :key="index"
            class="reply-item"
          >
            <div class="reply-text">{{ reply.content }}</div>
            <div class="reply-time">{{ reply.time }}</div>
          </div>

          <!-- AI思考中的加载动画 -->
          <div v-if="isThinking" class="reply-item thinking">
            <div class="typing-indicator">
              <span></span>
              <span></span>
              <span></span>
            </div>
            <div class="thinking-text">AI正在思考中...</div>
          </div>
        </div>
      </div>

      <!-- 输入区域 -->
      <div class="send-content">
        <textarea
          v-model="inputMessage"
          placeholder="请输入你的问题..."
          @keydown.enter.exact.prevent="sendMessage"
          class="message-input"
          rows="1"
        ></textarea>
        <button 
          @click="sendMessage" 
          :disabled="!inputMessage.trim() || isThinking"
          class="send-button"
        >
          <span v-if="!isThinking">发送</span>
          <span v-else>思考中...</span>
        </button>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, nextTick } from 'vue'

const currentQuestion = ref('')
const aiReplies = ref([])
const inputMessage = ref('')
const isThinking = ref(false)
const repliesContainer = ref(null)

// 获取当前时间
const getCurrentTime = () => {
  const now = new Date()
  return `${now.getHours().toString().padStart(2, '0')}:${now.getMinutes().toString().padStart(2, '0')}`
}

// 滚动到底部
const scrollToBottom = () => {
  nextTick(() => {
    if (repliesContainer.value) {
      repliesContainer.value.scrollTop = repliesContainer.value.scrollHeight
    }
  })
}

// 发送消息
const sendMessage = async () => {
  if (!inputMessage.value.trim() || isThinking.value) return

  // 设置当前问题（显示在顶部）
  currentQuestion.value = inputMessage.value
  
  // 清空之前的回复
  aiReplies.value = []
  
  const userInput = inputMessage.value
  inputMessage.value = ''

  // 显示AI思考状态
  isThinking.value = true
  scrollToBottom()
  
  // 模拟AI回复延迟（1.5-3秒）
  setTimeout(() => {
    // 添加AI回复
    aiReplies.value.push({
      content: getAIResponse(userInput),
      time: getCurrentTime()
    })
    
    isThinking.value = false
    scrollToBottom()
  }, 1500 + Math.random() * 1500)
}

// 模拟AI回复（实际项目中这里应该调用API）
const getAIResponse = (input) => {
  const responses = [
    `关于"${input}"这个问题，我的理解是：这是一个很有深度的话题。根据相关信息分析，我建议从以下几个方面来考虑...`,
    `针对您提出的"${input}"，我认为可以这样理解：首先需要明确核心概念，然后逐步展开分析...`,
    `感谢您的提问"${input}"。让我为您详细解答：这个问题涉及多个层面，我们可以从实际应用的角度来探讨...`,
    `您问到的"${input}"是个好问题。基于目前的理解，我的看法是：我们需要综合考虑各种因素...`
  ]
  return responses[Math.floor(Math.random() * responses.length)]
}
</script>

<style scoped>
.home-container {
  padding: 20px;
  height: calc(100vh - 80px);
  display: flex;
  gap: 0;
  margin-top: 60px;
}

.chat-area {
  width: 1200px;
  margin: 0 auto;
  display: flex;
  flex-direction: column;
}

.reply-content {
  flex: 1;
  padding: 20px;
  border-radius: 20px;
  border: 1px solid #ddd;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
  overflow: hidden;
  display: flex;
  flex-direction: column;
  background: #fafafa;
}

/* 用户提问区域 - 固定在顶部 */
.user-question {
  padding: 16px 20px;
  margin-bottom: 20px;
  color: white;
  border-bottom: 1px solid #333;
  position: relative;
  overflow: hidden;
}

/* 问题切换动画 */
.question-change-enter-active {
  animation: questionSlideIn 0.5s ease-out;
}

.question-change-leave-active {
  animation: questionSlideOut 0.4s ease-in;
}

@keyframes questionSlideOut {
  0% {
    opacity: 1;
    transform: translateX(0) scale(1);
  }
  100% {
    opacity: 0;
    transform: translateX(-30px) scale(0.95);
  }
}

@keyframes questionSlideIn {
  0% {
    opacity: 0;
    transform: translateX(30px) scale(0.95);
  }
  60% {
    transform: translateX(-5px) scale(1.02);
  }
  100% {
    opacity: 1;
    transform: translateX(0) scale(1);
  }
}

/* 添加背景闪烁效果 */
.user-question::before {
  content: '';
  position: absolute;
  top: 0;
  left: -100%;
  width: 100%;
  height: 100%;
  background: linear-gradient(90deg, 
    transparent, 
    rgba(102, 126, 234, 0.3), 
    transparent
  );
  animation: shimmer 0.8s ease-in-out;
}

@keyframes shimmer {
  0% {
    left: -100%;
  }
  100% {
    left: 100%;
  }
}

.question-label {
  font-size: 12px;
  opacity: 0.9;
  margin-bottom: 8px;
  font-weight: 500;
}

.question-text {
  font-size: 16px;
  color: #333;
  line-height: 1.6;
  font-weight: 500;
  position: relative;
  z-index: 1;
}

/* AI回复列表区域 */
.ai-replies {
  flex: 1;
  overflow-y: auto;
  padding: 10px;
  display: flex;
  flex-direction: column;
  gap: 16px;
}

.ai-replies::-webkit-scrollbar {
  width: 6px;
}

.ai-replies::-webkit-scrollbar-thumb {
  background: #ccc;
  border-radius: 3px;
}

.reply-item {
  padding: 16px 20px;
  border-radius: 12px;
  animation: slideIn 0.4s ease-out;
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

.reply-text {
  font-size: 15px;
  line-height: 1.8;
  color: #333;
  word-wrap: break-word;
}

.reply-time {
  font-size: 12px;
  color: #999;
  margin-top: 10px;
  text-align: right;
}

/* AI思考中样式 */
.reply-item.thinking {
  display: flex;
  align-items: center;
  gap: 12px;
}

.typing-indicator {
  display: flex;
  gap: 4px;
}

.typing-indicator span {
  width: 8px;
  height: 8px;
  border-radius: 50%;
  background: #667eea;
  animation: typing 1.4s infinite;
}

.typing-indicator span:nth-child(2) {
  animation-delay: 0.2s;
}

.typing-indicator span:nth-child(3) {
  animation-delay: 0.4s;
}

@keyframes typing {
  0%, 60%, 100% {
    transform: translateY(0);
    opacity: 0.4;
  }
  30% {
    transform: translateY(-8px);
    opacity: 1;
  }
}

.thinking-text {
  color: #666;
  font-size: 14px;
}

/* 输入区域 */
.send-content {
  margin-top: 20px;
  padding: 15px 20px;
  border-radius: 20px;
  border: 1px solid #ddd;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
  display: flex;
  gap: 12px;
  align-items: flex-end;
  background: white;
}

.message-input {
  flex: 1;
  border: none;
  outline: none;
  resize: none;
  font-size: 15px;
  line-height: 1.5;
  font-family: inherit;
  max-height: 120px;
  min-height: 24px;
}

.message-input::placeholder {
  color: #999;
}

.send-button {
  padding: 10px 24px;
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  color: white;
  border: none;
  border-radius: 10px;
  cursor: pointer;
  font-size: 14px;
  font-weight: 500;
  transition: all 0.3s ease;
  white-space: nowrap;
}

.send-button:hover:not(:disabled) {
  transform: translateY(-2px);
  box-shadow: 0 4px 12px rgba(102, 126, 234, 0.4);
}

.send-button:active:not(:disabled) {
  transform: translateY(0);
}

.send-button:disabled {
  opacity: 0.5;
  cursor: not-allowed;
}
</style>