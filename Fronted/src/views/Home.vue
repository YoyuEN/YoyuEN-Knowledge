<template>
  <div class="home-container">
    <!-- 左侧双栏 -->
    <aside class="sidebar">
      <!-- 知识库面板 -->
      <div class="sidebar-panel">
        <div class="panel-header">
          <span class="panel-title">知识库</span>
        </div>
        <div class="panel-body">
          <div
            v-for="kb in knowledgeList"
            :key="kb.id"
            class="kb-item"
            :class="{ active: selectedKnowledge === kb.id }"
            @click="selectKnowledge(kb.id)"
          >
            <div class="kb-info">
              <div class="kb-name">{{ kb.name }}</div>
              <div v-if="kb.description" class="kb-desc">{{ kb.description }}</div>
            </div>
          </div>
        </div>
      </div>

      <!-- 最近对话面板 -->
      <div class="sidebar-panel conversation-panel">
        <div class="panel-header">
          <span class="panel-title">最近对话</span>
          <button class="new-chat-btn" @click="createNewConversation">
            <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5">
              <line x1="12" y1="5" x2="12" y2="19"></line>
              <line x1="5" y1="12" x2="19" y2="12"></line>
            </svg>
            新建
          </button>
        </div>
        <div class="panel-body">
          <div v-if="conversationHistory.length === 0" class="empty-hint">
            暂无对话
          </div>
          <div
            v-for="conv in conversationHistory"
            :key="conv.id"
            class="conv-item"
            :class="{ active: activeConversationId === conv.id }"
            @click="loadConversation(conv.id)"
          >
            <div class="conv-title">{{ conv.title || '新对话' }}</div>
            <div class="conv-meta">{{ formatDateTime(conv.updateTime) }}</div>
          </div>
        </div>
      </div>
    </aside>

    <!-- 主聊天区 -->
    <main class="chat-main">
      <!-- 顶部标题栏 -->
      <header class="chat-header">
        <div class="header-info">
          <span class="header-kb" v-if="selectedKnowledgeName">{{ selectedKnowledgeName }}</span>
          <h2 class="header-title" :title="currentQuestion">{{ isInProgress ? currentQuestion : (activeConversationTitle || '新对话') }}</h2>
        </div>
        <button v-if="messages.length > 0" class="header-btn" @click="clearConversation">
          <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
            <polyline points="3 6 5 6 21 6"></polyline>
            <path d="M19 6v14a2 2 0 0 1-2 2H7a2 2 0 0 1-2-2V6m3 0V4a2 2 0 0 1 2-2h4a2 2 0 0 1 2 2v2"提问的问题></path>
          </svg>
          清空
        </button>
      </header>

      <!-- 消息区 -->
      <div class="messages-area" ref="messagesContainer">
        <!-- 待机画面 -->
        <div v-if="showStandby" class="standby-screen">
          <div class="standby-card">
            <h2 class="standby-title">{{ selectedKnowledgeName }}</h2>
            <p class="standby-desc">{{ standbyConfig.subtitle }}</p>
            <div class="standby-suggestions">
              <div
                v-for="(s, i) in standbyConfig.suggestions"
                :key="i"
                class="suggestion-chip"
                @click="quickAsk(s)"
              >
                {{ s }}
              </div>
            </div>
          </div>
        </div>

        <!-- 对话内容 -->
        <template v-else>
          <div
            v-for="(turn, index) in messageTurns"
            :key="turn.user.id"
            class="message-turn"
          >
            <!-- 用户问题 -->
            <div class="user-question">
              <div class="question-text">{{ turn.user.content }}</div>
            </div>

            <!-- AI 回答 -->
            <template v-if="turn.assistant">
              <div class="reply-item">
                <div class="reply-text markdown-body" v-html="renderMarkdown(turn.assistant.content)"></div>

                <!-- 引用来源 -->
                <div v-if="getValidReferences(turn.assistant.references).length > 0" class="references-section">
                  <div class="references-title">引用来源</div>
                  <div class="references-list">
                    <a
                      v-for="ref in getValidReferences(turn.assistant.references)"
                      :key="ref.documentId"
                      :href="getContentUrl(ref)"
                      class="reference-link"
                      target="_blank"
                    >
                      <span class="reference-icon">{{ ref.contentType === 'comment' ? '💬' : '📄' }}</span>
                      <div class="reference-info">
                        <div class="reference-name">{{ ref.title || ref.documentName }}</div>
                        <div class="reference-meta">
                          <span v-if="ref.author">{{ ref.author }}</span>
                          <span v-if="ref.publishTime">{{ formatTime(ref.publishTime) }}</span>
                        </div>
                      </div>
                    </a>
                  </div>
                </div>

                <!-- AI 工具栏 -->
                <div v-if="turn.assistant.status === 'done'" class="message-toolbar">
                  <button class="tool-btn" @click="copyMessage(turn.assistant.content)">
                    <svg width="13" height="13" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                      <rect x="9" y="9" width="13" height="13" rx="2" ry="2"></rect>
                      <path d="M5 15H4a2 2 0 0 1-2-2V4a2 2 0 0 1 2-2h9a2 2 0 0 1 2 2v1"></path>
                    </svg>
                    复制
                  </button>
                  <button v-if="turn.assistant.id === lastAssistantMessage?.id" class="tool-btn" @click="regenerateLast">
                    <svg width="13" height="13" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                      <polyline points="23 4 23 10 17 10"></polyline>
                      <path d="M20.49 15a9 9 0 1 1-2.12-9.36L23 10"></path>
                    </svg>
                    重新生成
                  </button>
                  <span class="reply-time">{{ turn.assistant.time }}</span>
                </div>

                <!-- 错误状态 - 仅最后一条 assistant -->
                <div v-if="turn.assistant.id === lastAssistantMessage?.id && turn.assistant.status === 'error'" class="message-error">
                  <span class="error-icon">⚠️</span>
                  <span class="error-text">{{ turn.assistant.errorMsg || '请求失败' }}</span>
                  <button class="retry-btn" @click="retryLast">重试</button>
                </div>

                <div v-if="turn.assistant.status !== 'done'" class="reply-time">{{ turn.assistant.time }}</div>
              </div>

              <!-- 流式生成中 -->
              <div v-if="turn.assistant.status === 'streaming'" class="thinking-wrapper">
                <div class="streaming-indicator">
                  <span class="streaming-dot"></span>
                  <span class="streaming-dot"></span>
                  <span class="streaming-dot"></span>
                </div>
                <button class="stop-btn" @click="stopStreaming">
                  <svg width="12" height="12" viewBox="0 0 24 24" fill="currentColor">
                    <rect x="6" y="6" width="12" height="12" rx="2"></rect>
                  </svg>
                  停止生成
                </button>
              </div>
            </template>

            <!-- 当前轮次还没有回复 -->
            <div v-else-if="isStreaming && index === messageTurns.length - 1" class="thinking-wrapper">
              <div class="streaming-indicator">
                <span class="streaming-dot"></span>
                <span class="streaming-dot"></span>
                <span class="streaming-dot"></span>
              </div>
              <button class="stop-btn" @click="stopStreaming">
                <svg width="12" height="12" viewBox="0 0 24 24" fill="currentColor">
                  <rect x="6" y="6" width="12" height="12" rx="2"></rect>
                </svg>
                停止生成
              </button>
            </div>
          </div>
        </template>
      </div>

      <!-- 输入区 -->
      <div class="input-area" :class="{ focused: isInputFocused }">
        <div class="input-row">
          <textarea
            ref="textareaRef"
            v-model="inputMessage"
            placeholder="请输入你的问题..."
            @keydown.enter.exact.prevent="sendMessage"
            @input="autoResize"
            @focus="isInputFocused = true"
            @blur="isInputFocused = false"
            class="message-input"
            rows="1"
          ></textarea>
          <button class="send-btn" @click="sendMessage" :disabled="!canSend">
            <span v-if="!isStreaming">
              <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5">
                <line x1="22" y1="2" x2="11" y2="13"></line>
                <polygon points="22 2 15 22 11 13 2 9 22 2"></polygon>
              </svg>
            </span>
            <span v-else class="send-spinner"></span>
          </button>
        </div>
      </div>
    </main>
  </div>
</template>

<script setup>
import { ref, computed, nextTick, onMounted, onUnmounted } from 'vue'
import { marked } from 'marked'
import {
  chatStreamRAGWithReferences,
  createConversation,
  fetchConversationList,
} from '@/api/chat/chat.js'
import { fetchKnowledgeBaseList } from '@/api/knowledge/knowledge.js'

// ================================
// 状态
// ================================
const knowledgeList = ref([])
const selectedKnowledge = ref('')
const conversationHistory = ref([])
const activeConversationId = ref(null)
const messages = ref([])
const inputMessage = ref('')
const isStreaming = ref(false)
const isInputFocused = ref(false)

// Refs
const messagesContainer = ref(null)
const textareaRef = ref(null)
let currentAbortController = null

// 常量
const LS_KEY = 'chat_conversations'
marked.setOptions({ breaks: true, gfm: true, headerIds: false, mangle: false })
const renderMarkdown = (content) => marked(content || '')

// ================================
// 计算属性
// ================================
const selectedKnowledgeName = computed(() => {
  const kb = knowledgeList.value.find((k) => k.id === selectedKnowledge.value)
  return kb ? kb.name : ''
})

const activeConversationTitle = computed(() => {
  if (!activeConversationId.value) return ''
  const conv = conversationHistory.value.find((c) => c.id === activeConversationId.value)
  return conv?.title || '新对话'
})

const showStandby = computed(() => messages.value.length === 0 && !isStreaming.value)

const currentQuestion = computed(() => {
  for (let i = messages.value.length - 1; i >= 0; i--) {
    if (messages.value[i].role === 'user') {
      return messages.value[i].content.replace(/ \[附件: .*\]$/, '')
    }
  }
  return ''
})

const isInProgress = computed(() => {
  if (messages.value.length === 0) return false
  const last = messages.value[messages.value.length - 1]
  return last.role === 'user' || (last.role === 'assistant' && last.status === 'streaming')
})

const messageTurns = computed(() => {
  const turns = []
  for (let i = 0; i < messages.value.length; i++) {
    if (messages.value[i].role === 'user') {
      const userMsg = messages.value[i]
      const assistantMsg = messages.value[i + 1]?.role === 'assistant' ? messages.value[i + 1] : null
      turns.push({ user: userMsg, assistant: assistantMsg })
    }
  }
  return turns
})

const lastAssistantMessage = computed(() => {
  for (let i = messages.value.length - 1; i >= 0; i--) {
    if (messages.value[i].role === 'assistant') return messages.value[i]
  }
  return null
})

const canSend = computed(() => {
  return inputMessage.value.trim() && !isStreaming.value
})

const standbyConfig = computed(() => {
  const kb = knowledgeList.value.find((k) => k.id === selectedKnowledge.value)
  const kbName = kb?.name || ''
  if (kbName === 'YoyuEN' || kbName.includes('内容') || kbName.includes('创作')) {
    return {
      title: '内容创作助手',
      subtitle: '基于网站文章和评论内容，为您提供专业的问答服务',
      suggestions: ['询问网站已发布的文章内容', '查询用户评论和反馈', '搜索特定主题的相关内容'],
    }
  }
  if (kbName.includes('个人') || kbName.includes('知识库')) {
    return {
      title: '个人知识库助手',
      subtitle: '了解个人信息、经历和专业知识',
      suggestions: ['询问个人背景和经历', '了解专业技能和项目经验', '探索个人知识和见解'],
    }
  }
  return {
    title: '欢迎使用 AI 助手',
    subtitle: '请在下方输入您的问题，我将为您提供帮助',
    suggestions: ['支持 Markdown 格式回复', '可以上传文件进行分析', '快速响应您的问题'],
  }
})

// ================================
// 工具函数
// ================================
const getCurrentTime = () => {
  const now = new Date()
  return `${now.getHours().toString().padStart(2, '0')}:${now.getMinutes().toString().padStart(2, '0')}`
}

const scrollToBottom = () => {
  nextTick(() => {
    if (messagesContainer.value) {
      messagesContainer.value.scrollTop = messagesContainer.value.scrollHeight
    }
  })
}

const autoResize = () => {
  const el = textareaRef.value
  if (!el) return
  el.style.height = 'auto'
  el.style.height = Math.min(el.scrollHeight, 120) + 'px'
}

// ================================
// 知识库
// ================================
const loadKnowledgeList = async () => {
  try {
    const result = await fetchKnowledgeBaseList()
    knowledgeList.value = result.data || []
  } catch (err) {
    console.error('加载知识库列表失败:', err)
  }
}

const selectKnowledge = async (id) => {
  selectedKnowledge.value = id
  activeConversationId.value = null
  messages.value = []
  await loadConversationHistory(id)
  saveToLocalStorage()
}

// ================================
// 对话历史
// ================================
const loadConversationHistory = async (knowledgeBaseId) => {
  try {
    const list = await fetchConversationList(knowledgeBaseId)
    conversationHistory.value = list || []
  } catch (err) {
    console.error('加载对话历史失败:', err)
    conversationHistory.value = []
  }
}

const createNewConversation = () => {
  activeConversationId.value = null
  messages.value = []
  inputMessage.value = ''
  if (textareaRef.value) textareaRef.value.style.height = 'auto'
}

const loadConversation = async (id) => {
  activeConversationId.value = id
  const all = JSON.parse(localStorage.getItem(LS_KEY) || '{}')
  const cached = all[id]
  messages.value = cached?.messages || []
  await nextTick()
  scrollToBottom()
}

const clearConversation = () => {
  if (activeConversationId.value) {
    const all = JSON.parse(localStorage.getItem(LS_KEY) || '{}')
    delete all[activeConversationId.value]
    localStorage.setItem(LS_KEY, JSON.stringify(all))
  }
  messages.value = []
  activeConversationId.value = null
}

// ================================
// 发送消息
// ================================
const sendMessage = async () => {
  if (!canSend.value) return
  stopStreaming()

  const fullQuestion = inputMessage.value.trim()

  // 用户消息
  messages.value.push({
    id: Date.now(),
    role: 'user',
    content: fullQuestion,
    time: getCurrentTime(),
    status: 'done',
  })

  const userInput = inputMessage.value
  inputMessage.value = ''
  if (textareaRef.value) textareaRef.value.style.height = 'auto'

  // 首次发送创建对话
  if (!activeConversationId.value) {
    try {
      const conv = await createConversation({
        title: userInput.slice(0, 50),
        knowledgeBaseId: selectedKnowledge.value,
      })
      activeConversationId.value = conv?.id || null
      if (activeConversationId.value) {
        await loadConversationHistory(selectedKnowledge.value)
      }
    } catch (err) {
      console.error('创建对话失败:', err)
    }
  }

  // AI 占位
  const assistantIndex = messages.value.length
  messages.value.push({
    id: Date.now() + 1,
    role: 'assistant',
    content: '',
    time: getCurrentTime(),
    references: [],
    status: 'streaming',
  })

  isStreaming.value = true
  scrollToBottom()

  currentAbortController = chatStreamRAGWithReferences(
    userInput,
    activeConversationId.value,
    selectedKnowledge.value,
    (chunk) => {
      messages.value[assistantIndex].content += chunk
      scrollToBottom()
    },
    (references) => {
      messages.value[assistantIndex].references = references
    },
    () => {
      messages.value[assistantIndex].status = 'done'
      isStreaming.value = false
      currentAbortController = null
      saveToLocalStorage()
      scrollToBottom()
    },
    (err) => {
      messages.value[assistantIndex].status = 'error'
      messages.value[assistantIndex].errorMsg = err.message || '请求失败'
      isStreaming.value = false
      currentAbortController = null
      saveToLocalStorage()
      scrollToBottom()
    }
  )
}

const stopStreaming = () => {
  if (currentAbortController) {
    currentAbortController.abort()
    currentAbortController = null
    isStreaming.value = false
    const last = messages.value[messages.value.length - 1]
    if (last && last.role === 'assistant' && last.status === 'streaming') {
      last.status = 'done'
      saveToLocalStorage()
    }
  }
}

const regenerateLast = () => {
  let userIndex = messages.value.length - 1
  while (userIndex >= 0 && messages.value[userIndex].role !== 'user') userIndex--
  if (userIndex < 0) return
  messages.value = messages.value.slice(0, userIndex + 1)
  const userMsg = messages.value[userIndex]
  inputMessage.value = userMsg.content.replace(/ \[附件: .*\]$/, '')
  sendMessage()
}

const retryLast = () => {
  let assistantIndex = messages.value.length - 1
  while (assistantIndex >= 0 && messages.value[assistantIndex].role !== 'assistant') assistantIndex--
  if (assistantIndex < 0) return
  messages.value.splice(assistantIndex, 1)
  let userIndex = assistantIndex - 1
  while (userIndex >= 0 && messages.value[userIndex].role !== 'user') userIndex--
  if (userIndex < 0) return
  const userMsg = messages.value[userIndex]
  inputMessage.value = userMsg.content.replace(/ \[附件: .*\]$/, '')
  sendMessage()
}

const copyMessage = async (content) => {
  try {
    await navigator.clipboard.writeText(content)
  } catch (err) {
    console.error('复制失败:', err)
  }
}

const quickAsk = (text) => {
  inputMessage.value = text
  nextTick(() => {
    autoResize()
    sendMessage()
  })
}

// ================================
// 引用处理
// ================================
const getValidReferences = (references) => {
  if (!references) return []
  return references.filter((ref) => ref.contentType && ref.contentId)
}

const getContentUrl = (ref) => {
  if (!ref.contentType || !ref.contentId) return `/document/${ref.documentId}`
  if (ref.contentType === 'article') return `/content-detail/article/${ref.contentId}`
  if (ref.contentType === 'comment' && ref.articleId) {
    return `/content-detail/article/${ref.articleId}#comment-${ref.contentId}`
  }
  return `/document/${ref.documentId}`
}

// ================================
// 格式化
// ================================
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

const formatDateTime = (timeStr) => {
  if (!timeStr) return ''
  try {
    const date = new Date(timeStr)
    const now = new Date()
    if (date.toDateString() === now.toDateString()) {
      return `${date.getHours().toString().padStart(2, '0')}:${date.getMinutes().toString().padStart(2, '0')}`
    }
    return `${date.getMonth() + 1}/${date.getDate()}`
  } catch (e) {
    return timeStr
  }
}

// ================================
// 本地持久化
// ================================
const saveToLocalStorage = () => {
  if (!activeConversationId.value) return
  const all = JSON.parse(localStorage.getItem(LS_KEY) || '{}')
  all[activeConversationId.value] = {
    knowledgeBaseId: selectedKnowledge.value,
    messages: messages.value,
    updatedAt: Date.now(),
  }
  localStorage.setItem(LS_KEY, JSON.stringify(all))
  // 清理 30 天前的缓存
  const thirtyDays = 30 * 24 * 60 * 60 * 1000
  Object.keys(all).forEach((key) => {
    if (all[key].updatedAt && Date.now() - all[key].updatedAt > thirtyDays) delete all[key]
  })
  localStorage.setItem(LS_KEY, JSON.stringify(all))
}

// ================================
// 生命周期
// ================================
onMounted(async () => {
  await loadKnowledgeList()
  if (knowledgeList.value.length > 0) {
    const firstId = knowledgeList.value[0].id
    selectedKnowledge.value = firstId
    await loadConversationHistory(firstId)
  }
})

onUnmounted(() => {
  stopStreaming()
})
</script>

<style scoped>
.home-container {
  display: flex;
  height: calc(100vh - 97px);
  margin-top: 81px;
  padding: 0 25px;
  gap: 16px;
  background: var(--dt-canvas);
  color: var(--dt-ink);
  font-family: var(--dt-font-body);
  overflow: hidden;
}

/* ================================
   左侧栏
   ================================ */
.sidebar {
  width: 280px;
  flex-shrink: 0;
  display: flex;
  flex-direction: column;
  background: #fff;
  border: 1px solid var(--dt-hairline);
  border-radius: var(--dt-radius-lg);
  overflow: hidden;
}

.sidebar-panel {
  display: flex;
  flex-direction: column;
}

.sidebar-panel + .sidebar-panel {
  border-top: 1px solid var(--dt-hairline);
}

.conversation-panel {
  flex: 1;
  min-height: 0;
  overflow: hidden;
}

.panel-header {
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 14px 16px;
  font-size: var(--dt-text-caption);
  font-weight: 600;
  color: var(--dt-muted);
  text-transform: uppercase;
  letter-spacing: 1px;
}

.panel-body {
  padding: 0 12px 12px;
  overflow-y: auto;
}

.new-chat-btn {
  display: flex;
  align-items: center;
  gap: 4px;
  padding: 4px 10px;
  border-radius: var(--dt-radius-sm);
  border: 1px solid var(--dt-hairline);
  background: #fff;
  color: var(--dt-muted);
  font-size: 12px;
  cursor: pointer;
  transition: var(--dt-transition-fast);
}

.new-chat-btn:hover {
  background: var(--dt-primary);
  color: var(--dt-on-primary);
  border-color: var(--dt-primary);
}

/* 知识库项 */
.kb-item {
  padding: 10px 12px;
  border-radius: var(--dt-radius-md);
  cursor: pointer;
  transition: var(--dt-transition-fast);
  margin-bottom: 4px;
}

.kb-item:hover {
  background: #f5f5f5;
}

.kb-item.active {
  background: #f5f5f5;
}

.kb-item.active .kb-name {
  color: var(--dt-primary);
}

.kb-info {
  min-width: 0;
  flex: 1;
}

.kb-name {
  font-size: 14px;
  font-weight: 500;
  color: var(--dt-ink);
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
}

.kb-desc {
  font-size: 12px;
  color: var(--dt-muted);
  margin-top: 2px;
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
}

/* 对话项 */
.conv-item {
  padding: 10px 12px;
  border-radius: var(--dt-radius-md);
  cursor: pointer;
  transition: var(--dt-transition-fast);
  margin-bottom: 4px;
}

.conv-item:hover {
  background: #f5f5f5;
}

.conv-item.active {
  background: #f5f5f5;
}

.conv-title {
  font-size: 13px;
  font-weight: 500;
  color: var(--dt-ink);
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
}

.conv-meta {
  font-size: 11px;
  color: var(--dt-muted-soft);
  margin-top: 2px;
}

.empty-hint {
  padding: 20px;
  text-align: center;
  font-size: 13px;
  color: var(--dt-muted-soft);
}

/* ================================
   主聊天区
   ================================ */
.chat-main {
  flex: 1;
  display: flex;
  flex-direction: column;
  min-width: 0;
  background: #fff;
  border: 1px solid var(--dt-hairline);
  border-radius: var(--dt-radius-lg);
  overflow: hidden;
}

/* 顶部标题栏 */
.chat-header {
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 14px 24px;
  border-bottom: 1px solid var(--dt-hairline);
  background: #fff;
  flex-shrink: 0;
}

.header-info {
  display: flex;
  align-items: baseline;
  gap: 12px;
}

.header-title {
  font-family: var(--dt-font-display);
  font-size: 18px;
  font-weight: 400;
  color: var(--dt-ink);
  margin: 0;
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
  max-width: 480px;
}

.header-kb {
  font-size: 13px;
  color: var(--dt-muted);
  background: var(--dt-surface-soft);
  padding: 2px 10px;
  border-radius: var(--dt-radius-pill);
}

.header-btn {
  display: flex;
  align-items: center;
  gap: 6px;
  padding: 6px 12px;
  border-radius: var(--dt-radius-sm);
  border: 1px solid var(--dt-hairline);
  background: #fff;
  color: var(--dt-muted);
  font-size: 13px;
  cursor: pointer;
  transition: var(--dt-transition-fast);
}

.header-btn:hover {
  background: var(--dt-error);
  color: var(--dt-on-primary);
  border-color: var(--dt-error);
}

/* ================================
   消息区域
   ================================ */
.messages-area {
  flex: 1;
  overflow-y: auto;
  padding: 20px 24px;
  display: flex;
  flex-direction: column;
}

/* 待机画面 */
.standby-screen {
  display: flex;
  align-items: center;
  justify-content: center;
  flex: 1;
  animation: fadeIn 0.6s ease-out;
}

.standby-card {
  text-align: center;
  max-width: 480px;
  padding: 24px;
}

.standby-title {
  font-family: "快看世界体", var(--dt-font-display);
  font-size: 32px;
  font-weight: 400;
  color: var(--dt-ink);
  margin: 0 0 10px;
  letter-spacing: -0.3px;
}

.standby-desc {
  font-size: 15px;
  color: var(--dt-muted);
  margin-bottom: 28px;
  line-height: 1.6;
}

.standby-suggestions {
  display: flex;
  flex-direction: column;
  gap: 10px;
}

.suggestion-chip {
  background: var(--dt-canvas);
  border: 1px solid var(--dt-hairline);
  padding: 12px 20px;
  border-radius: var(--dt-radius-lg);
  font-size: 14px;
  color: var(--dt-body);
  cursor: pointer;
  transition: var(--dt-transition-base);
}

.suggestion-chip:hover {
  border-color: var(--dt-primary);
  background: linear-gradient(135deg, rgba(204, 120, 92, 0.08) 0%, rgba(232, 165, 90, 0.04) 100%);
  transform: translateY(-1px);
}

/* 对话轮次 */
.message-turn {
  padding: 16px 20px;
  background: #fff;
  border-radius: var(--dt-radius-lg);
  border: 1px solid var(--dt-hairline);
  box-shadow: 0 2px 12px rgba(0, 0, 0, 0.06);
  margin-bottom: 16px;
}
.message-turn:last-child {
  margin-bottom: 0;
}

/* 用户问题 */
.user-question {
  padding: 0 0 8px;
  border-bottom: 1px solid var(--dt-hairline);
  animation: fadeIn 0.4s ease-out;
}

.question-text {
  font-size: 15px;
  font-weight: 500;
  color: var(--dt-ink);
  line-height: 1.6;
}

.reply-item {
  padding: 12px 0 0;
  animation: slideInUp 0.35s ease-out;
}

.reply-text {
  font-size: 15px;
  line-height: 1.8;
  color: var(--dt-body);
}

.reply-text :deep(p) {
  margin: 8px 0;
}

.reply-text :deep(h2),
.reply-text :deep(h3) {
  margin: 14px 0 8px;
  font-weight: 600;
  color: var(--dt-ink);
}

.reply-text :deep(code) {
  background: var(--dt-surface-soft);
  padding: 2px 6px;
  border-radius: var(--dt-radius-xs);
  font-family: var(--dt-font-mono);
  font-size: 13px;
}

.reply-text :deep(pre) {
  background: var(--dt-surface-dark);
  color: var(--dt-on-dark);
  padding: 14px;
  border-radius: var(--dt-radius-md);
  overflow-x: auto;
  margin: 10px 0;
}

.reply-text :deep(pre code) {
  background: none;
  color: inherit;
  padding: 0;
}

.reply-text :deep(blockquote) {
  border-left: 3px solid var(--dt-primary);
  padding-left: 14px;
  margin: 10px 0;
  color: var(--dt-muted);
}

.reply-text :deep(ul),
.reply-text :deep(ol) {
  padding-left: 22px;
  margin: 8px 0;
}

.reply-text :deep(li) {
  margin: 4px 0;
}

.reply-time {
  font-size: 12px;
  color: var(--dt-muted-soft);
}

.message-toolbar .reply-time {
  margin-left: auto;
}

.reply-item > .reply-time {
  margin-top: 10px;
  text-align: right;
}

/* 引用来源 */
.references-section {
  margin-top: 16px;
  padding-top: 12px;
  border-top: 1px solid var(--dt-hairline-soft);
}

.references-title {
  font-size: 11px;
  font-weight: 600;
  color: var(--dt-muted-soft);
  text-transform: uppercase;
  letter-spacing: 0.5px;
  margin-bottom: 8px;
}

.references-list {
  display: flex;
  flex-wrap: wrap;
  gap: 8px;
}

.reference-link {
  display: inline-flex;
  align-items: center;
  gap: 6px;
  padding: 6px 12px;
  text-decoration: none;
  border: 1px solid var(--dt-hairline);
  border-radius: var(--dt-radius-pill);
  background: var(--dt-canvas);
  transition: var(--dt-transition-fast);
}

.reference-link:hover {
  border-color: var(--dt-primary);
  background: linear-gradient(135deg, rgba(204, 120, 92, 0.08) 0%, rgba(232, 165, 90, 0.04) 100%);
}

.reference-link:hover .reference-name {
  color: var(--dt-primary);
}

.reference-icon {
  font-size: 14px;
  flex-shrink: 0;
}

.reference-info {
  display: flex;
  align-items: center;
  gap: 6px;
  min-width: 0;
}

.reference-name {
  font-size: 12px;
  color: var(--dt-ink);
  font-weight: 500;
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
  transition: color 0.2s;
}

.reference-meta {
  font-size: 11px;
  color: var(--dt-muted-soft);
}

/* 工具栏 */
.message-toolbar {
  display: flex;
  gap: 8px;
  margin-top: 12px;
  padding-top: 10px;
}

.tool-btn {
  display: flex;
  align-items: center;
  gap: 4px;
  padding: 4px 10px;
  border-radius: var(--dt-radius-sm);
  border: 1px solid var(--dt-hairline);
  background: #fff;
  color: var(--dt-muted);
  font-size: 12px;
  cursor: pointer;
  transition: var(--dt-transition-fast);
}

.tool-btn:hover {
  background: var(--dt-primary);
  color: var(--dt-on-primary);
  border-color: var(--dt-primary);
}

/* 错误状态 */
.message-error {
  display: flex;
  align-items: center;
  gap: 8px;
  margin-top: 10px;
  padding: 10px 14px;
  background: rgba(198, 69, 69, 0.08);
  border-radius: var(--dt-radius-md);
  font-size: 13px;
  color: var(--dt-error);
}

.error-icon {
  font-size: 15px;
}

.retry-btn {
  margin-left: auto;
  padding: 4px 12px;
  border-radius: var(--dt-radius-sm);
  border: 1px solid var(--dt-error);
  background: var(--dt-error);
  color: var(--dt-on-primary);
  font-size: 12px;
  cursor: pointer;
  transition: var(--dt-transition-fast);
}

.retry-btn:hover {
  background: #a83a3a;
}

/* 流式指示器 */
.thinking-wrapper {
  padding: 16px 0;
}

.streaming-indicator {
  display: flex;
  gap: 4px;
  padding: 8px 0;
}

.streaming-dot {
  width: 6px;
  height: 6px;
  border-radius: 50%;
  background: var(--dt-primary);
  animation: blink 1.4s infinite;
  opacity: 0;
}

.streaming-dot:nth-child(1) {
  animation-delay: 0s;
}
.streaming-dot:nth-child(2) {
  animation-delay: 0.2s;
}
.streaming-dot:nth-child(3) {
  animation-delay: 0.4s;
}

.stop-btn {
  display: flex;
  align-items: center;
  gap: 4px;
  margin-top: 8px;
  padding: 4px 10px;
  border-radius: var(--dt-radius-sm);
  border: 1px solid var(--dt-hairline);
  background: #fff;
  color: var(--dt-muted);
  font-size: 12px;
  cursor: pointer;
  transition: var(--dt-transition-fast);
}

.stop-btn:hover {
  background: var(--dt-error);
  color: var(--dt-on-primary);
  border-color: var(--dt-error);
}

/* ================================
   输入区域
   ================================ */
.input-area {
  margin: 0 24px 24px;
  padding: 12px 16px;
  border-radius: var(--dt-radius-xl);
  border: 1px solid var(--dt-hairline);
  background: #fff;
  box-shadow: 0 2px 12px rgba(0, 0, 0, 0.06);
  display: flex;
  flex-direction: column;
  gap: 8px;
  transition: var(--dt-transition-base);
  flex-shrink: 0;
}

.input-area.focused {
  border-color: var(--dt-primary);
  box-shadow: 0 0 0 3px rgba(204, 120, 92, 0.12);
}

.input-row {
  display: flex;
  align-items: flex-end;
  gap: 10px;
}

.message-input {
  flex: 1;
  border: none;
  outline: none;
  resize: none;
  font-size: 15px;
  line-height: 1.5;
  font-family: inherit;
  min-height: 36px;
  max-height: 120px;
  padding: 8px 0;
  background: transparent;
  color: var(--dt-ink);
}

.message-input::placeholder {
  color: var(--dt-muted-soft);
}

.send-btn {
  width: 36px;
  height: 36px;
  background: var(--dt-primary);
  color: var(--dt-on-primary);
  border: none;
  border-radius: var(--dt-radius-md);
  cursor: pointer;
  display: flex;
  align-items: center;
  justify-content: center;
  transition: var(--dt-transition-fast);
  flex-shrink: 0;
}

.send-btn:hover:not(:disabled) {
  background: var(--dt-primary-active);
  transform: translateY(-1px);
  box-shadow: 0 4px 12px rgba(204, 120, 92, 0.3);
}

.send-btn:disabled {
  opacity: 0.4;
  cursor: not-allowed;
}

.send-spinner {
  width: 16px;
  height: 16px;
  border: 2px solid rgba(255, 255, 255, 0.3);
  border-top-color: white;
  border-radius: 50%;
  animation: spin 0.8s linear infinite;
}

/* ================================
   滚动条
   ================================ */
.messages-area::-webkit-scrollbar,
.panel-body::-webkit-scrollbar {
  width: 5px;
}

.messages-area::-webkit-scrollbar-track,
.panel-body::-webkit-scrollbar-track {
  background: transparent;
}

.messages-area::-webkit-scrollbar-thumb,
.panel-body::-webkit-scrollbar-thumb {
  background: var(--dt-hairline);
  border-radius: var(--dt-radius-pill);
}

.messages-area::-webkit-scrollbar-thumb:hover,
.panel-body::-webkit-scrollbar-thumb:hover {
  background: var(--dt-hairline-soft);
}

/* ================================
   动画
   ================================ */
@keyframes fadeIn {
  from {
    opacity: 0;
    transform: translateY(10px);
  }
  to {
    opacity: 1;
    transform: translateY(0);
  }
}

@keyframes float {
  0%,
  100% {
    transform: translateY(0);
  }
  50% {
    transform: translateY(-8px);
  }
}

@keyframes slideInUp {
  from {
    opacity: 0;
    transform: translateY(12px);
  }
  to {
    opacity: 1;
    transform: translateY(0);
  }
}

@keyframes blink {
  0%,
  20% {
    opacity: 0;
  }
  40% {
    opacity: 1;
  }
  100% {
    opacity: 0;
  }
}

@keyframes spin {
  to {
    transform: rotate(360deg);
  }
}

/* ================================
   响应式
   ================================ */
@media (max-width: 768px) {
  .sidebar {
    display: none;
  }

  .messages-area {
    padding: 0 16px;
  }

  .input-area {
    margin: 0 12px 12px;
  }

  .chat-header {
    padding: 12px 16px;
  }

  .header-title {
    font-size: 18px;
  }

  .question-text {
    font-size: 16px;
  }
}
</style>
