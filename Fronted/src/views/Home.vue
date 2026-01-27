<template>
  <div class="home-container">
    <div class="chat-area">
      <!-- 回复区域 -->
      <div class="reply-content">
        <!-- 待机画面 - 在用户提问之前显示 -->
        <div v-if="!currentQuestion" class="standby-screen">
          <div class="standby-icon">
            <svg width="80" height="80" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5">
              <path d="M21 15a2 2 0 0 1-2 2H7l-4 4V5a2 2 0 0 1 2-2h14a2 2 0 0 1 2 2z"></path>
            </svg>
          </div>
          <h2 class="standby-title">欢迎使用 AI 助手</h2>
          <p class="standby-subtitle">请在下方输入您的问题，我将为您提供帮助</p>
          <div class="standby-suggestions">
            <div class="suggestion-item">💡 支持 Markdown 格式回复</div>
            <div class="suggestion-item">📎 可以上传文件进行分析</div>
            <div class="suggestion-item">⚡ 快速响应您的问题</div>
          </div>
        </div>

        <!-- 用户提问内容 - 固定在顶部 -->
        <transition name="question-change" mode="out-in">
          <div class="user-question" v-if="currentQuestion" :key="currentQuestion">
            <div class="question-text">{{ currentQuestion }}</div>
          </div>
        </transition>

        <!-- AI回复列表 -->
        <transition name="replies-fade">
          <div class="ai-replies" ref="repliesContainer" v-if="currentQuestion">
            <div v-for="(reply, index) in aiReplies" :key="index" class="reply-item">
              <div class="reply-content-wrapper">
                <div class="reply-text markdown-body" v-html="renderMarkdown(reply.content)"></div>
                <div class="reply-time">{{ reply.time }}</div>
              </div>
            </div>

            <!-- AI思考中的加载动画 -->
            <div v-if="isThinking" class="reply-item thinking">
              <div class="thinking-wrapper">
                <div class="typing-indicator">
                  <span></span>
                  <span></span>
                  <span></span>
                </div>
                <div class="thinking-text">AI正在思考中...</div>
              </div>
            </div>
          </div>
        </transition>
      </div>

      <!-- 输入区域 -->
      <div class="send-content">
        <!-- 文件上传按钮 -->
        <label class="upload-button" title="上传文件">
          <input
            type="file"
            ref="fileInput"
            @change="handleFileUpload"
            multiple
            accept="image/*,.pdf,.doc,.docx,.txt"
            style="display: none;"
          />
          <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
            <path d="M21.44 11.05l-9.19 9.19a6 6 0 0 1-8.49-8.49l9.19-9.19a4 4 0 0 1 5.66 5.66l-9.2 9.19a2 2 0 0 1-2.83-2.83l8.49-8.48"/>
          </svg>
        </label>

        <!-- 已上传文件列表 -->
        <div v-if="uploadedFiles.length > 0" class="uploaded-files">
          <div v-for="(file, index) in uploadedFiles" :key="index" class="file-tag">
            <span class="file-name">{{ file.name }}</span>
            <button @click="removeFile(index)" class="remove-file">×</button>
          </div>
        </div>

        <textarea
          v-model="inputMessage"
          placeholder="请输入你的问题..."
          @keydown.enter.exact.prevent="sendMessage"
          class="message-input"
          rows="1"
        ></textarea>

        <button @click="sendMessage" :disabled="!canSend" class="send-button">
          <span v-if="!isThinking">
            <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
              <line x1="22" y1="2" x2="11" y2="13"></line>
              <polygon points="22 2 15 22 11 13 2 9 22 2"></polygon>
            </svg>
          </span>
          <span v-else>
            <div class="button-spinner"></div>
          </span>
        </button>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, nextTick, computed } from 'vue'
import { marked } from 'marked'

const currentQuestion = ref('')
const aiReplies = ref([])
const inputMessage = ref('')
const isThinking = ref(false)
const repliesContainer = ref(null)
const fileInput = ref(null)
const uploadedFiles = ref([])

// 配置 marked
marked.setOptions({
  breaks: true,
  gfm: true,
  headerIds: false,
  mangle: false
})

// 渲染 Markdown
const renderMarkdown = (content) => {
  return marked(content)
}

// 是否可以发送
const canSend = computed(() => {
  return (inputMessage.value.trim() || uploadedFiles.value.length > 0) && !isThinking.value
})

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

// 处理文件上传
const handleFileUpload = (event) => {
  const files = Array.from(event.target.files)
  uploadedFiles.value.push(...files)
  // 清空 input，允许重复上传同一文件
  event.target.value = ''
}

// 移除文件
const removeFile = (index) => {
  uploadedFiles.value.splice(index, 1)
}

// 发送消息
const sendMessage = async () => {
  if (!canSend.value) return

  // 设置当前问题（显示在顶部）
  let questionText = inputMessage.value
  if (uploadedFiles.value.length > 0) {
    questionText += ` [附件: ${uploadedFiles.value.map(f => f.name).join(', ')}]`
  }
  currentQuestion.value = questionText

  // 清空之前的回复
  aiReplies.value = []

  const userInput = inputMessage.value
  const files = [...uploadedFiles.value]

  inputMessage.value = ''
  uploadedFiles.value = []

  // 显示AI思考状态
  isThinking.value = true
  scrollToBottom()

  // 模拟AI回复延迟（1.5-3秒）
  setTimeout(() => {
    // 添加AI回复
    aiReplies.value.push({
      content: getAIResponse(userInput, files),
      time: getCurrentTime()
    })

    isThinking.value = false
    scrollToBottom()
  }, 1500 + Math.random() * 1500)
}

// 模拟AI回复（实际项目中这里应该调用API）
const getAIResponse = (input, files) => {
  const fileInfo = files.length > 0 ? `\n\n**已接收文件：** ${files.map(f => f.name).join(', ')}` : ''

  const responses = [
    `## 关于"${input}"的回答\n\n这是一个很有深度的话题。根据相关信息分析，我建议从以下几个方面来考虑：\n\n### 主要观点\n\n1. **第一点**：需要明确核心概念\n2. **第二点**：逐步展开分析\n3. **第三点**：综合考虑各种因素\n\n\`\`\`javascript\n// 示例代码\nconst example = "这是一个示例";\nconsole.log(example);\n\`\`\`\n\n希望这个回答对您有帮助！${fileInfo}`,

    `## 针对您的问题\n\n感谢您提出"${input}"这个问题。让我为您详细解答：\n\n### 分析要点\n\n- 首先，我们需要理解问题的本质\n- 其次，要考虑实际应用场景\n- 最后，提供可行的解决方案\n\n> 💡 **提示**：这个问题涉及多个层面，建议从实际应用的角度来探讨。\n\n${fileInfo}`,

    `## 详细解答\n\n您问到的"${input}"是个好问题。基于目前的理解，我的看法是：\n\n### 核心内容\n\n1. **背景分析**\n   - 相关概念说明\n   - 历史发展脉络\n\n2. **具体建议**\n   - 实践方法\n   - 注意事项\n\n3. **总结**\n   - 关键要点回顾\n   - 后续行动建议\n\n---\n\n如有其他问题，欢迎继续提问！${fileInfo}`
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
  border: 1px solid #f0f0f0;
  overflow: hidden;
  display: flex;
  flex-direction: column;
  background: white;
  box-shadow: 0 2px 12px rgba(0, 0, 0, 0.08);
}

/* 待机画面样式 */
.standby-screen {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  height: 100%;
  padding: 40px;
  animation: fadeIn 0.6s ease-out;
}

.standby-icon {
  color: #667eea;
  margin-bottom: 24px;
  animation: float 3s ease-in-out infinite;
}

@keyframes float {
  0%, 100% {
    transform: translateY(0);
  }
  50% {
    transform: translateY(-10px);
  }
}

.standby-title {
  font-size: 28px;
  font-weight: 600;
  color: #333;
  margin-bottom: 12px;
  text-align: center;
}

.standby-subtitle {
  font-size: 16px;
  color: #666;
  margin-bottom: 32px;
  text-align: center;
}

.standby-suggestions {
  display: flex;
  flex-direction: column;
  gap: 12px;
  width: 100%;
  max-width: 400px;
}

.suggestion-item {
  background: linear-gradient(135deg, #f5f7fa 0%, #f0f2f5 100%);
  padding: 12px 20px;
  border-radius: 12px;
  font-size: 14px;
  color: #555;
  text-align: center;
  transition: all 0.3s ease;
  animation: slideInUp 0.5s ease-out backwards;
}

.suggestion-item:nth-child(1) {
  animation-delay: 0.1s;
}

.suggestion-item:nth-child(2) {
  animation-delay: 0.2s;
}

.suggestion-item:nth-child(3) {
  animation-delay: 0.3s;
}

@keyframes slideInUp {
  from {
    opacity: 0;
    transform: translateY(20px);
  }
  to {
    opacity: 1;
    transform: translateY(0);
  }
}

.suggestion-item:hover {
  background: linear-gradient(135deg, #667eea15 0%, #764ba215 100%);
  transform: translateY(-2px);
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.08);
}

/* 用户提问区域 - 固定在顶部 */
.user-question {
  padding-bottom: 10px;
  border-bottom: 1px solid #e8e8e8;
  position: relative;
}

@keyframes fadeIn {
  from {
    opacity: 0;
    transform: translateY(-10px);
  }
  to {
    opacity: 1;
    transform: translateY(0);
  }
}

/* 问题切换动画 */
.question-change-enter-active {
  animation: questionSlideIn 0.4s ease-out;
}

.question-change-leave-active {
  animation: questionSlideOut 0.3s ease-in;
}

@keyframes questionSlideOut {
  0% {
    opacity: 1;
    transform: translateY(0);
  }
  100% {
    opacity: 0;
    transform: translateY(-20px);
  }
}

@keyframes questionSlideIn {
  0% {
    opacity: 0;
    transform: translateY(20px);
  }
  100% {
    opacity: 1;
    transform: translateY(0);
  }
}

.question-text {
  font-size: 17px;
  color: #1a1a1a;
  line-height: 1.7;
  font-weight: 600;
  letter-spacing: 0.3px;
  text-align: center;
  transition: all 0.3s ease;
  cursor: default;
}

.question-text:hover {
  color: #667eea;
  transform: translateY(-2px);
}

/* 回复区域过渡动画 */
.replies-fade-enter-active {
  transition: all 0.4s ease-out;
}

.replies-fade-leave-active {
  transition: all 0.3s ease-in;
}

.replies-fade-enter-from {
  opacity: 0;
  transform: translateY(20px);
}

.replies-fade-leave-to {
  opacity: 0;
  transform: translateY(-20px);
}

/* AI回复列表区域 */
.ai-replies {
  flex: 1;
  overflow-y: auto;
  padding: 10px;
  display: flex;
  flex-direction: column;
  gap: 20px;
  position: relative;
}

/* 顶部和底部渐变遮罩 */
.ai-replies::before,
.ai-replies::after {
  content: '';
  position: sticky;
  left: 0;
  right: 0;
  height: 60px;
  pointer-events: none;
  z-index: 1;
}

.ai-replies::before {
  top: 0;
  background: linear-gradient(to bottom, rgba(255, 255, 255, 1), rgba(255, 255, 255, 0));
}

.ai-replies::after {
  bottom: 0;
  background: linear-gradient(to top, rgba(255, 255, 255, 1), rgba(255, 255, 255, 0));
  margin-top: -60px;
}

.ai-replies::-webkit-scrollbar {
  width: 8px;
}

.ai-replies::-webkit-scrollbar-track {
  background: #f1f1f1;
  border-radius: 4px;
}

.ai-replies::-webkit-scrollbar-thumb {
  background: #ccc;
  border-radius: 4px;
}

.ai-replies::-webkit-scrollbar-thumb:hover {
  background: #999;
}

.reply-item {
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

.reply-content-wrapper {
  padding: 0;
}

.reply-text {
  font-size: 15px;
  line-height: 1.8;
  color: #333;
  word-wrap: break-word;
}

/* Markdown 样式 */
.markdown-body :deep(h2) {
  font-size: 20px;
  font-weight: 600;
  margin: 16px 0 12px 0;
  color: #333;
  border-bottom: 2px solid #e0e0e0;
  padding-bottom: 8px;
}

.markdown-body :deep(h3) {
  font-size: 18px;
  font-weight: 600;
  margin: 14px 0 10px 0;
  color: #333;
}

.markdown-body :deep(p) {
  margin: 8px 0;
}

.markdown-body :deep(ul), .markdown-body :deep(ol) {
  margin: 8px 0;
  padding-left: 24px;
}

.markdown-body :deep(li) {
  margin: 4px 0;
}

.markdown-body :deep(code) {
  background: #f5f5f5;
  padding: 2px 6px;
  border-radius: 4px;
  font-family: 'Consolas', 'Monaco', monospace;
  font-size: 14px;
  color: #333;
}

.markdown-body :deep(pre) {
  background: #2d2d2d;
  color: #f8f8f2;
  padding: 16px;
  border-radius: 8px;
  overflow-x: auto;
  margin: 12px 0;
}

.markdown-body :deep(pre code) {
  background: none;
  color: inherit;
  padding: 0;
}

.markdown-body :deep(blockquote) {
  border-left: 4px solid #ccc;
  padding-left: 16px;
  margin: 12px 0;
  color: #666;
  background: #f9f9f9;
  padding: 12px 16px;
  border-radius: 4px;
}

.markdown-body :deep(strong) {
  color: #333;
  font-weight: 600;
}

.markdown-body :deep(hr) {
  border: none;
  border-top: 2px solid #e0e0e0;
  margin: 20px 0;
}

.reply-time {
  font-size: 12px;
  color: #999;
  margin-top: 10px;
  text-align: right;
}

/* AI思考中样式 */
.reply-item.thinking {
  display: block;
}

.thinking-wrapper {
  display: flex;
  align-items: center;
  gap: 12px;
  padding: 0;
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
  color: #999;
  font-size: 14px;
  font-weight: 400;
}

/* 输入区域 */
.send-content {
  margin-top: 20px;
  padding: 16px 20px;
  border-radius: 20px;
  border: 1px solid #f0f0f0;
  box-shadow: 0 2px 12px rgba(0, 0, 0, 0.08);
  display: flex;
  gap: 12px;
  align-items: flex-end;
  background: white;
  flex-wrap: wrap;
  transition: all 0.3s ease;
}

.send-content:focus-within {
  border-color: #667eea;
}

.upload-button {
  width: 40px;
  height: 40px;
  border-radius: 10px;
  background: #f5f5f5;
  display: flex;
  align-items: center;
  justify-content: center;
  cursor: pointer;
  transition: all 0.3s ease;
  color: #666;
  flex-shrink: 0;
}

.upload-button:hover {
  background: #e0e0e0;
  transform: translateY(-2px);
}

.upload-button:active {
  transform: translateY(0);
}

.uploaded-files {
  width: 100%;
  display: flex;
  flex-wrap: wrap;
  gap: 8px;
  margin-bottom: 8px;
}

.file-tag {
  display: flex;
  align-items: center;
  gap: 8px;
  background: linear-gradient(135deg, #667eea15 0%, #764ba215 100%);
  padding: 6px 12px;
  border-radius: 20px;
  font-size: 13px;
  color: #667eea;
  animation: fileTagIn 0.3s ease-out;
}

@keyframes fileTagIn {
  from {
    opacity: 0;
    transform: scale(0.8);
  }
  to {
    opacity: 1;
    transform: scale(1);
  }
}

.file-name {
  max-width: 150px;
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
}

.remove-file {
  background: none;
  border: none;
  color: #f5576c;
  font-size: 18px;
  cursor: pointer;
  padding: 0;
  width: 20px;
  height: 20px;
  display: flex;
  align-items: center;
  justify-content: center;
  border-radius: 50%;
  transition: all 0.2s ease;
}

.remove-file:hover {
  background: #f5576c;
  color: white;
  transform: rotate(90deg);
}

.message-input {
  flex: 1;
  border: none;
  outline: none;
  resize: none;
  font-size: 15px;
  line-height: 1.5;
  font-family: inherit;
  min-height: 40px;
  max-height: 120px;
  padding: 10px 0;
}

.message-input::placeholder {
  color: #999;
}

.send-button {
  width: 40px;
  height: 40px;
  background: #fff9c4;
  color: #666;
  border: none;
  border-radius: 10px;
  cursor: pointer;
  display: flex;
  align-items: center;
  justify-content: center;
  transition: all 0.3s ease;
  flex-shrink: 0;
}

.send-button:hover:not(:disabled) {
  transform: translateY(-2px);
  box-shadow: 0 4px 12px rgba(102, 126, 234, 0.3);
}

.send-button:active:not(:disabled) {
  transform: translateY(0);
}

.send-button:disabled {
  opacity: 0.5;
  cursor: not-allowed;
}

.button-spinner {
  width: 16px;
  height: 16px;
  border: 2px solid rgba(255, 255, 255, 0.3);
  border-top-color: white;
  border-radius: 50%;
  animation: spin 0.8s linear infinite;
}

@keyframes spin {
  to {
    transform: rotate(360deg);
  }
}
</style>