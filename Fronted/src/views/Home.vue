<template>
  <div class="home-container">
    <div class="message-list">
      <!-- 知识库选择 -->
      <div class="nav-section">
        <div class="nav-header" @click="toggleKnowledgeExpand">
          <span class="nav-title">知识库</span>
          <svg
            class="nav-arrow"
            :class="{ 'expanded': isKnowledgeExpanded }"
            width="16"
            height="16"
            viewBox="0 0 24 24"
            fill="none"
            stroke="currentColor"
            stroke-width="2"
          >
            <polyline points="6 9 12 15 18 9"></polyline>
          </svg>
        </div>
        <transition name="slide-fade">
          <div v-show="isKnowledgeExpanded" class="nav-list">
            <div
              v-for="(kb, index) in knowledgeList"
              :key="kb.id"
              class="nav-item"
              :class="{ 'active': selectedKnowledge === kb.id }"
              :style="{ transitionDelay: `${index * 30}ms` }"
              @click="selectKnowledge(kb.id)"
            >
              {{ kb.name }}
            </div>
          </div>
        </transition>
      </div>

    </div>
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
          <h2 class="standby-title">{{ standbyConfig.title }}</h2>
          <p class="standby-subtitle">{{ standbyConfig.subtitle }}</p>
          <div class="standby-suggestions">
            <div
              v-for="(suggestion, index) in standbyConfig.suggestions"
              :key="index"
              class="suggestion-item"
            >
              {{ suggestion }}
            </div>
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

                <!-- 引用文档链接 -->
                <div v-if="getValidReferences(reply.references).length > 0" class="references-section">
                  <div class="references-title">引用来源</div>
                  <div class="references-list">
                    <a
                      v-for="ref in getValidReferences(reply.references)"
                      :key="ref.documentId"
                      :href="getContentUrl(ref)"
                      class="reference-link"
                      target="_blank"
                    >
                      <span class="reference-icon">{{ ref.contentType === 'comment' ? '💬' : '📄' }}</span>
                      <div class="reference-content">
                        <div class="reference-title">{{ ref.title || ref.documentName }}</div>
                        <div class="reference-meta">
                          <span v-if="ref.author" class="reference-author">{{ ref.author }}</span>
                          <span v-if="ref.publishTime" class="reference-time">{{ formatTime(ref.publishTime) }}</span>
                        </div>
                      </div>
                    </a>
                  </div>
                </div>

                <div class="reply-time">{{ reply.time }}</div>
              </div>
            </div>

            <!-- AI思考中的加载动画 -->
            <div v-if="isThinking" class="reply-item thinking">
              <div class="thinking-wrapper">
                <div class="thinking-text">
                  <span class="thinking-dot">.</span>
                  <span class="thinking-dot">.</span>
                  <span class="thinking-dot">.</span>
                </div>
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
    <div class="message-list">
    </div>
  </div>
</template>

<script setup>
import { ref, nextTick, computed, onUnmounted, onMounted } from 'vue'
import { marked } from 'marked'
import { chatStreamRAGWithReferences, createConversation } from '@/api/chat/chat.js'
import { fetchKnowledgeBaseList } from '@/api/knowledge/knowledge.js'

const currentQuestion = ref('')
const aiReplies = ref([])
const conversationId = ref(null)
const inputMessage = ref('')
const isThinking = ref(false)
const repliesContainer = ref(null)
const fileInput = ref(null)
const uploadedFiles = ref([])

// 下拉框数据
const knowledgeList = ref([])
const selectedKnowledge = ref('')
const isKnowledgeExpanded = ref(false)

// 当前知识库内容
const currentKnowledgeItems = ref([])
const selectedKnowledgeTitle = computed(() => {
  if (!selectedKnowledge.value) return '请选择知识库'
  const kb = knowledgeList.value.find(k => k.id === selectedKnowledge.value)
  return kb ? (kb.name || kb.title) : '知识库内容'
})

// 待机画面配置 - 根据知识库动态变化
const standbyConfig = computed(() => {
  const kb = knowledgeList.value.find(k => k.id === selectedKnowledge.value)
  const kbName = kb?.name || ''

  if (kbName === 'YoyuEN' || kbName.includes('内容') || kbName.includes('创作')) {
    return {
      title: '内容创作助手',
      subtitle: '基于网站文章和评论内容，为您提供专业的问答服务',
      suggestions: [
        '📝 询问网站已发布的文章内容',
        '💬 查询用户评论和反馈',
        '🔍 搜索特定主题的相关内容'
      ]
    }
  } else if (kbName.includes('个人') || kbName.includes('知识库')) {
    return {
      title: '个人知识库助手',
      subtitle: '了解个人信息、经历和专业知识',
      suggestions: [
        '👤 询问个人背景和经历',
        '💼 了解专业技能和项目经验',
        '📚 探索个人知识和见解'
      ]
    }
  } else {
    return {
      title: '欢迎使用 AI 助手',
      subtitle: '请在下方输入您的问题，我将为您提供帮助',
      suggestions: [
        '💡 支持 Markdown 格式回复',
        '📎 可以上传文件进行分析',
        '⚡ 快速响应您的问题'
      ]
    }
  }
})

// 当前流式请求控制器，可用于中断
let currentAbortController = null

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
  event.target.value = ''
}

// 移除文件
const removeFile = (index) => {
  uploadedFiles.value.splice(index, 1)
}

// 过滤有效的引用（只显示有contentType和contentId的）
const getValidReferences = (references) => {
  if (!references) return []
  return references.filter(ref => ref.contentType && ref.contentId)
}

// 根据引用类型生成跳转URL
const getContentUrl = (ref) => {
  if (!ref.contentType || !ref.contentId) {
    // 如果没有内容类型信息，回退到文档详情页
    return `/document/${ref.documentId}`
  }

  if (ref.contentType === 'article') {
    // 文章详情页
    return `/content-detail/article/${ref.contentId}`
  } else if (ref.contentType === 'comment') {
    // 评论：跳转到文章详情页并定位到评论
    if (ref.articleId) {
      return `/content-detail/article/${ref.articleId}#comment-${ref.contentId}`
    } else {
      return `/document/${ref.documentId}`
    }
  }

  // 其他类型，回退到文档详情页
  return `/document/${ref.documentId}`
}

// 格式化时间
const formatTime = (timeStr) => {
  if (!timeStr) return ''
  try {
    const date = new Date(timeStr)
    const year = date.getFullYear()
    const month = String(date.getMonth() + 1).padStart(2, '0')
    const day = String(date.getDate()).padStart(2, '0')
    return `${year}-${month}-${day}`
  } catch (e) {
    return timeStr
  }
}

// 发送消息
const sendMessage = async () => {
  if (!canSend.value) return

  // 中断上一次未完成的请求
  currentAbortController?.abort()

  // 设置当前问题
  let questionText = inputMessage.value
  if (uploadedFiles.value.length > 0) {
    questionText += ` [附件: ${uploadedFiles.value.map(f => f.name).join(', ')}]`
  }
  currentQuestion.value = questionText

  // 清空之前的回复
  aiReplies.value = []

  const userInput = inputMessage.value
  inputMessage.value = ''
  uploadedFiles.value = []

  // 首次发送时创建对话
  if (!conversationId.value) {
    try {
      const conversation = await createConversation({
        title: userInput.slice(0, 50),
        knowledgeBaseId: selectedKnowledge.value
      })
      conversationId.value = conversation?.id ?? null
    } catch (err) {
      console.error('创建对话失败:', err)
    }
  }

  // 显示 AI 思考状态，并创建空回复占位
  isThinking.value = true
  scrollToBottom()

  // 添加空的回复条目，流式内容追加到这里
  const replyIndex = aiReplies.value.length
  aiReplies.value.push({ content: '', time: getCurrentTime(), references: [] })

  currentAbortController = chatStreamRAGWithReferences(
    userInput,
    conversationId.value,
    selectedKnowledge.value, // 传递选中的知识库 ID
    // onChunk：每次收到新内容片段时追加
    (chunk) => {
      if (isThinking.value) isThinking.value = false
      aiReplies.value[replyIndex].content += chunk
      scrollToBottom()
    },
    // onReferences：收到引用信息
    (references) => {
      aiReplies.value[replyIndex].references = references
      scrollToBottom()
    },
    // onDone：流结束
    () => {
      isThinking.value = false
      currentAbortController = null
      scrollToBottom()
    },
    // onError：请求出错
    (err) => {
      isThinking.value = false
      currentAbortController = null
      if (aiReplies.value[replyIndex].content === '') {
        aiReplies.value[replyIndex].content = `请求出错：${err.message}`
      }
      scrollToBottom()
    }
  )
}

// 加载知识库列表
const loadKnowledgeList = async () => {
  try {
    const result = await fetchKnowledgeBaseList()
    knowledgeList.value = result.data || []
  } catch (err) {
    console.error('加载知识库列表失败:', err)
  }
}

// 知识库切换处理
const toggleKnowledgeExpand = () => {
  isKnowledgeExpanded.value = !isKnowledgeExpanded.value
}

const selectKnowledge = (id) => {
  selectedKnowledge.value = id
  console.log('选择的知识库:', id)
  loadKnowledgeContent(id)
  // 切换知识库时重置对话状态
  conversationId.value = null
  currentQuestion.value = ''
  aiReplies.value = []
}

// 加载知识库内容
const loadKnowledgeContent = async (knowledgeId) => {
  try {
    const params = knowledgeId ? { category: knowledgeId } : {}
    const result = await fetchKnowledgeBaseList(params)
    currentKnowledgeItems.value = result.data || []
  } catch (err) {
    console.error('加载知识库内容失败:', err)
    currentKnowledgeItems.value = []
  }
}

// 查看知识详情
const viewKnowledgeDetail = (item) => {
  console.log('查看知识详情:', item)
  // TODO: 跳转到详情页或打开弹窗
}

// 格式化日期
const formatDate = (dateStr) => {
  if (!dateStr) return ''
  try {
    const date = new Date(dateStr)
    const month = String(date.getMonth() + 1).padStart(2, '0')
    const day = String(date.getDate()).padStart(2, '0')
    return `${month}-${day}`
  } catch (e) {
    return dateStr
  }
}

// 组件挂载时加载数据
onMounted(async () => {
  await loadKnowledgeList()
  // 默认选择第一个知识库
  if (knowledgeList.value.length > 0) {
    selectKnowledge(knowledgeList.value[0].id)
  }
})

// 组件卸载时中断未完成的请求
onUnmounted(() => {
  currentAbortController?.abort()
})
</script>

<style scoped>
.home-container {
  padding: 25px;
  height: calc(100vh - 80px);
  display: flex;
  gap: 20px;
  margin-top: 60px;
}

.chat-area {
  flex: 1;
  display: flex;
  flex-direction: column;
  max-width: 1200px;
  margin: 0 auto;
}

.nav-arrow {
  transition: transform 0.3s cubic-bezier(0.4, 0, 0.2, 1);
  transform-origin: center;
}

.nav-arrow.expanded {
  transform: rotate(180deg);
}

/* 折叠展开动画 */
.slide-fade-enter-active {
  transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
  overflow: hidden;
}

.slide-fade-leave-active {
  transition: all 0.25s cubic-bezier(0.4, 0, 0.2, 1);
  overflow: hidden;
}

.slide-fade-enter-from {
  opacity: 0;
  max-height: 0;
  transform: translateY(-10px);
}

.slide-fade-enter-to {
  opacity: 1;
  max-height: 500px;
  transform: translateY(0);
}

.slide-fade-leave-from {
  opacity: 1;
  max-height: 500px;
  transform: translateY(0);
}

.slide-fade-leave-to {
  opacity: 0;
  max-height: 0;
  transform: translateY(-10px);
}

.nav-list {
  overflow: hidden;
}

.nav-item {
  transition: all 0.2s cubic-bezier(0.4, 0, 0.2, 1);
  transform-origin: left center;
}

.slide-fade-enter-active .nav-item {
  transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
}

.nav-header {
  cursor: pointer;
  user-select: none;
  transition: background-color 0.2s ease;
}

.nav-header:hover {
  background-color: rgba(0, 0, 0, 0.02);
  border-radius: 8px;
}

.nav-header:active {
  transform: scale(0.98);
}

.message-list {
  width: 280px;
  flex-shrink: 0;
  border: 1px solid #e8e8e8;
  padding: 16px;
  border-radius: 8px;
  box-shadow: 0 2px 12px rgba(0, 0, 0, 0.08);
  display: flex;
  flex-direction: column;
  gap: 12px;
  background: white;
}

/* 导航区块 */
.nav-section {
  border-bottom: 1px solid #f0f0f0;
  padding-bottom: 12px;
}

.nav-section:last-child {
  border-bottom: none;
  padding-bottom: 0;
}

.nav-header {
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 10px 12px;
  cursor: pointer;
  border-radius: 6px;
  transition: all 0.2s ease;
  user-select: none;
  background: white;
}

.nav-header:hover {
  background: white;
}

.nav-title {
  font-size: 14px;
  font-weight: 600;
  color: #333;
}

.nav-arrow {
  transition: transform 0.3s ease;
  color: #999;
}

.nav-arrow.expanded {
  transform: rotate(180deg);
}

.nav-list {
  margin-top: 4px;
  overflow: hidden;
}

.nav-item {
  padding: 10px 12px;
  font-size: 13px;
  color: #666;
  cursor: pointer;
  border-radius: 6px;
  transition: all 0.2s ease;
  margin-bottom: 2px;
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
  background: white;
}

.nav-item:hover {
  background: #f5f5f5;
  color: #333;
}

.nav-item.active {
  background: #f5f5f5;
  color: #333;
  font-weight: 500;
}

/* 展开动画 */
.expand-enter-active {
  transition: all 0.25s ease-out;
  overflow: hidden;
}

.expand-leave-active {
  transition: all 0.2s ease-in;
  overflow: hidden;
}

.expand-enter-from {
  max-height: 0;
  opacity: 0;
}

.expand-enter-to {
  max-height: 500px;
  opacity: 1;
}

.expand-leave-from {
  max-height: 500px;
  opacity: 1;
}

.expand-leave-to {
  max-height: 0;
  opacity: 0;
}

/* 知识库内容区域 */
.knowledge-content {
  display: flex;
  flex-direction: column;
  height: 100%;
}

.content-header {
  padding: 12px;
  border-bottom: 1px solid #f0f0f0;
  margin-bottom: 8px;
}

.content-title {
  font-size: 14px;
  font-weight: 600;
  color: #333;
}

.content-list {
  flex: 1;
  overflow-y: auto;
}

.content-item {
  padding: 12px;
  border-radius: 6px;
  cursor: pointer;
  transition: all 0.2s;
  margin-bottom: 8px;
}

.content-item:hover {
  background: #f8f9fa;
}

.item-title {
  font-size: 13px;
  color: #333;
  margin-bottom: 6px;
  font-weight: 500;
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
}

.item-meta {
  display: flex;
  align-items: center;
  gap: 8px;
}

.item-date {
  font-size: 11px;
  color: #999;
}

.empty-state {
  padding: 40px 20px;
  text-align: center;
  color: #999;
  font-size: 13px;
}

.reply-content {
  flex: 1;
  padding: 20px;
  border-radius: 8px;
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

/* 引用文档样式 */
.references-section {
  margin-top: 20px;
  padding: 0;
}

.references-title {
  font-size: 12px;
  font-weight: 500;
  color: #999;
  margin-bottom: 10px;
  letter-spacing: 0.5px;
}

.references-list {
  display: flex;
  flex-direction: column;
  gap: 8px;
}

.reference-link {
  display: flex;
  align-items: flex-start;
  gap: 10px;
  padding: 10px 0;
  text-decoration: none;
  transition: all 0.2s ease;
  border-bottom: 1px solid #f5f5f5;
}

.reference-link:last-child {
  border-bottom: none;
}

.reference-link:hover {
  transform: translateX(2px);
}

.reference-link:hover .reference-title {
  color: #667eea;
}

.reference-icon {
  font-size: 16px;
  flex-shrink: 0;
  opacity: 0.6;
  margin-top: 2px;
}

.reference-content {
  flex: 1;
  display: flex;
  flex-direction: column;
  gap: 4px;
  min-width: 0;
}

.reference-title {
  font-size: 13px;
  color: #333;
  font-weight: 500;
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
  transition: color 0.2s ease;
}

.reference-meta {
  display: flex;
  align-items: center;
  gap: 12px;
  font-size: 11px;
  color: #999;
}

.reference-author {
  display: flex;
  align-items: center;
}

.reference-time {
  display: flex;
  align-items: center;
}

/* AI思考中样式 */
.reply-item.thinking {
  display: block;
}

.thinking-wrapper {
  display: flex;
  align-items: center;
  padding: 0;
}

.thinking-text {
  color: #667eea;
  font-size: 15px;
  font-weight: 500;
  letter-spacing: 2px;
  display: flex;
  align-items: baseline;
}

.thinking-dot {
  animation: blink 1.4s infinite;
  opacity: 0;
}

.thinking-dot:nth-child(1) {
  animation-delay: 0s;
}

.thinking-dot:nth-child(2) {
  animation-delay: 0.2s;
}

.thinking-dot:nth-child(3) {
  animation-delay: 0.4s;
}

@keyframes blink {
  0%, 20% {
    opacity: 0;
  }
  40% {
    opacity: 1;
  }
  100% {
    opacity: 0;
  }
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