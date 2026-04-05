<template>
  <section>
    <!-- AI智能助手 - 独占一行 -->
    <el-row :gutter="20" style="margin-bottom: 20px;">
      <el-col :span="24">
        <el-card class="ai-assistant-card">
          <template #header>
            <div class="card-header">
              <el-button
                :icon="Refresh"
                :loading="assistantLoading"
                @click="handleManualRefresh"
                size="small"
                circle
              />
            </div>
          </template>
          <div class="assistant-content">
            <div v-if="assistantReport" class="markdown-body" v-html="renderedMarkdown"></div>
            <div v-else-if="assistantLoading" class="loading-state">
              <el-icon class="rotating" :size="32" color="#667eea"><Loading /></el-icon>
              <p>AI助手正在思考中...</p>
            </div>
            <div v-else class="empty-state">
              <el-icon :size="48" color="#909399"><ChatDotRound /></el-icon>
              <p>AI助手正在准备中...</p>
            </div>
          </div>
        </el-card>
      </el-col>
    </el-row>
  </section>
</template>

<script setup>
import { onMounted, ref, computed, onUnmounted } from 'vue'
import { useRouter } from 'vue-router'
import { ElMessage } from 'element-plus'
import {
  DataAnalysis,
  Refresh,
  Document,
  ChatDotRound,
  TrendCharts,
  Bell,
  ChatLineRound,
  Loading,
} from '@element-plus/icons-vue'
import { fetchAssistantReport, fetchStatistics, fetchQuickInfo } from '@/api/dashboard/dashboard'
import { marked } from 'marked'

// 配置 marked：保留换行符，支持 GFM 语法
marked.use({
  gfm: true,
  breaks: true,
})

const router = useRouter()
const loading = ref(false)
const assistantLoading = ref(false)
const statsLoading = ref(false)
const quickLoading = ref(false)

const assistantReport = ref('')
const statistics = ref({
  todayVisits: 0,
  weekVisits: 0,
  monthVisits: 0,
  topPages: []
})
const quickInfo = ref({
  pendingComments: 0,
  draftArticles: 0,
  todayComments: 0,
  notifications: []
})

// 渲染Markdown：先补全标题前的空格，再渲染
const renderedMarkdown = computed(() => {
  if (!assistantReport.value) return ''
  // 修复 ##标题 缺少空格（如 ##问候 → ## 问候）
  const fixed = assistantReport.value
    .replace(/^(#{1,6})([^\s#])/gm, '$1 $2')
    // 修复 -列表项 缺少空格（如 -读者关注 → - 读者关注）
    .replace(/^(-|\*|\+)([^\s])/gm, '$1 $2')
  return marked(fixed)
})

// 缓存键名
const CACHE_KEY = 'dashboard_assistant_report'
const CACHE_TIMESTAMP_KEY = 'dashboard_assistant_timestamp'

// 检查缓存是否有效（24小时内）
const isCacheValid = () => {
  const timestamp = localStorage.getItem(CACHE_TIMESTAMP_KEY)
  if (!timestamp) return false

  const cacheTime = parseInt(timestamp)
  const now = Date.now()
  const oneDayInMs = 24 * 60 * 60 * 1000

  return (now - cacheTime) < oneDayInMs
}

// 从缓存加载数据
const loadFromCache = () => {
  const cached = localStorage.getItem(CACHE_KEY)
  if (cached) {
    assistantReport.value = cached
    return true
  }
  return false
}

// 保存到缓存
const saveToCache = (data) => {
  localStorage.setItem(CACHE_KEY, data)
  localStorage.setItem(CACHE_TIMESTAMP_KEY, Date.now().toString())
}

// 刷新AI助手报告（SSE流式）
const refreshAssistant = async (forceRefresh = false) => {
  // 如果不是强制刷新，且缓存有效，则使用缓存
  if (!forceRefresh && isCacheValid() && loadFromCache()) {
    return
  }

  assistantLoading.value = true
  assistantReport.value = ''

  try {
    const response = await fetchAssistantReport()
    const reader = response.body.getReader()
    const decoder = new TextDecoder()
    let buffer = ''

    while (true) {
      const { done, value } = await reader.read()
      if (done) break

      buffer += decoder.decode(value, { stream: true })

      // 以 \n\n 为分隔符提取完整 SSE 事件
      let delimiterIndex
      while ((delimiterIndex = buffer.indexOf('\n\n')) !== -1) {
        const event = buffer.substring(0, delimiterIndex)
        buffer = buffer.substring(delimiterIndex + 2)

        if (!event.trim()) continue

        // 提取所有 data: 字段（多行 data 按 SSE 规范用 \n 拼接）
        const dataLines = event.split('\n').filter(l => l.startsWith('data:'))
        if (dataLines.length === 0) continue

        const dataValue = dataLines
          .map(l => l.startsWith('data: ') ? l.substring(6) : l.substring(5))
          .join('\n')

        // 空 data 值代表 AI 输出的换行符，非空则直接追加
        assistantReport.value += dataValue === '' ? '\n' : dataValue
      }
    }

    // 保存到缓存
    saveToCache(assistantReport.value)
  } catch (error) {
    console.error('获取AI报告失败', error)
    ElMessage.error('获取AI报告失败，请稍后重试')
  } finally {
    assistantLoading.value = false
  }
}

// 手动刷新按钮处理
const handleManualRefresh = () => {
  refreshAssistant(true)
}

// 刷新访问统计
const refreshStats = async () => {
  statsLoading.value = true
  try {
    const res = await fetchStatistics()
    statistics.value = res.data || statistics.value
  } catch (error) {
    console.error('获取访问统计失败', error)
  } finally {
    statsLoading.value = false
  }
}

// 刷新快捷信息
const refreshQuick = async () => {
  quickLoading.value = true
  try {
    const res = await fetchQuickInfo()
    quickInfo.value = res.data || quickInfo.value
  } catch (error) {
    console.error('获取快捷信息失败', error)
  } finally {
    quickLoading.value = false
  }
}

// 刷新全部
const refreshAll = async (forceRefresh = false) => {
  loading.value = true
  await Promise.all([
    refreshAssistant(forceRefresh),
    refreshStats(),
    refreshQuick()
  ])
  loading.value = false
}

const handleAdminRefresh = () => {
  refreshAll(true)
}

onMounted(() => {
  refreshAssistant()
  refreshStats()
  refreshQuick()
  window.addEventListener('admin-refresh', handleAdminRefresh)
})

onUnmounted(() => {
  window.removeEventListener('admin-refresh', handleAdminRefresh)
})
</script>

<style scoped>
.card-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  font-weight: 600;
  color: #303133;
}

.ai-assistant-card {
  box-shadow: 0 2px 12px 0 rgba(0, 0, 0, 0.1);
  border-radius: 12px;
  overflow: hidden;
}

.ai-assistant-card :deep(.el-card__body) {
  padding: 0;
  height: 100%;
}

.assistant-content {
  height: 100%;
  overflow-y: auto;
  padding: 24px;
  scrollbar-width: none;
}

.assistant-content::-webkit-scrollbar {
  display: none;
}

.assistant-content {
  background: transparent;
  font-size: 15px;
}

.markdown-body {
  line-height: 1.9;
  color: #1a1a1a;
  font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, 'Helvetica Neue', Arial, sans-serif;
}

.markdown-body :deep(h1) {
  margin-bottom: 16px;
  font-weight: 700;
  font-size: 24px;
  color: #1a1a1a;
  border-bottom: 1px solid #ebebeb;
  padding-bottom: 8px;
}

.markdown-body :deep(h2) {
  margin-bottom: 16px;
  font-weight: 600;
  font-size: 20px;
  color: #1a1a1a;
}

.markdown-body :deep(h3) {
  margin-bottom: 12px;
  font-weight: 600;
  font-size: 18px;
  color: #1a1a1a;
}

.markdown-body :deep(p) {
  margin-bottom: 16px;
  text-align: justify;
  line-height: 1.8;
}

.markdown-body :deep(ul),
.markdown-body :deep(ol) {
  padding-left: 28px;
  margin-bottom: 14px;
}

.markdown-body :deep(li) {
  margin-bottom: 8px;
}

.markdown-body :deep(strong) {
  color: #1a1a1a;
  font-weight: 600;
}

.markdown-body :deep(code) {
  background: #f5f5f5;
  padding: 2px 6px;
  border-radius: 4px;
  font-family: 'Courier New', monospace;
  color: #333;
}

.empty-state {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  height: 100%;
  color: #909399;
}

.empty-state p {
  margin-top: 16px;
  font-size: 14px;
}

.loading-state {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  height: 100%;
  color: #667eea;
}

.loading-state p {
  margin-top: 16px;
  font-size: 14px;
  font-weight: 500;
}

.rotating {
  animation: rotate 1.5s linear infinite;
}

@keyframes rotate {
  from {
    transform: rotate(0deg);
  }
  to {
    transform: rotate(360deg);
  }
}

.stats-card {
  height: 380px;
  box-shadow: 0 2px 12px 0 rgba(0, 0, 0, 0.1);
  border-radius: 12px;
}

.stats-card :deep(.el-card__body) {
  padding: 20px;
}

.stats-metrics {
  display: grid;
  grid-template-columns: repeat(3, 1fr);
  gap: 12px;
  margin-bottom: 20px;
}

.stat-item {
  text-align: center;
  padding: 20px 16px;
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  border-radius: 12px;
  color: white;
  box-shadow: 0 4px 12px rgba(102, 126, 234, 0.3);
  transition: transform 0.3s;
}

.stat-item:hover {
  transform: translateY(-4px);
}

.stat-item:nth-child(2) {
  background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%);
  box-shadow: 0 4px 12px rgba(240, 147, 251, 0.3);
}

.stat-item:nth-child(3) {
  background: linear-gradient(135deg, #4facfe 0%, #00f2fe 100%);
  box-shadow: 0 4px 12px rgba(79, 172, 254, 0.3);
}

.stat-label {
  font-size: 13px;
  opacity: 0.95;
  margin-bottom: 10px;
  font-weight: 500;
}

.stat-value {
  font-size: 32px;
  font-weight: 700;
  letter-spacing: -1px;
}

.section-title {
  font-size: 13px;
  font-weight: 600;
  color: #606266;
  margin-bottom: 12px;
  padding-bottom: 8px;
  border-bottom: 2px solid #ebeef5;
}

.top-pages {
  max-height: 180px;
  overflow-y: auto;
}

.page-item {
  display: flex;
  align-items: center;
  padding: 10px 0;
  font-size: 13px;
  border-bottom: 1px solid #f0f0f0;
  transition: background 0.2s;
}

.page-item:hover {
  background: #f9fafb;
}

.page-item:last-child {
  border-bottom: none;
}

.page-rank {
  width: 26px;
  height: 26px;
  display: flex;
  align-items: center;
  justify-content: center;
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  color: white;
  border-radius: 6px;
  font-size: 13px;
  font-weight: 700;
  margin-right: 12px;
  flex-shrink: 0;
}

.page-path {
  flex: 1;
  color: #606266;
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
  font-weight: 500;
}

.page-views {
  color: #909399;
  font-weight: 600;
  margin-left: 12px;
  font-size: 14px;
}

.quick-info-card {
  height: 380px;
  box-shadow: 0 2px 12px 0 rgba(0, 0, 0, 0.1);
  border-radius: 12px;
}

.quick-info-card :deep(.el-card__body) {
  padding: 20px;
}

.quick-metrics {
  display: grid;
  grid-template-columns: repeat(3, 1fr);
  gap: 10px;
  margin-bottom: 20px;
}

.quick-item {
  display: flex;
  flex-direction: column;
  align-items: center;
  padding: 16px 8px;
  background: linear-gradient(135deg, #f5f7fa 0%, #e8eaf0 100%);
  border-radius: 10px;
  cursor: pointer;
  transition: all 0.3s;
  border: 2px solid transparent;
}

.quick-item:hover {
  background: linear-gradient(135deg, #e8eaf0 0%, #dfe1e8 100%);
  transform: translateY(-3px);
  border-color: #667eea;
  box-shadow: 0 4px 12px rgba(102, 126, 234, 0.2);
}

.quick-item span {
  margin-top: 10px;
  font-size: 12px;
  color: #606266;
  font-weight: 500;
}

.notifications {
  max-height: 180px;
  overflow-y: auto;
}

.notif-item {
  display: flex;
  align-items: center;
  padding: 10px 0;
  font-size: 13px;
  color: #606266;
  transition: background 0.2s;
}

.notif-item:hover {
  background: #f9fafb;
}

.notif-item .el-icon {
  margin-right: 10px;
  flex-shrink: 0;
}

.notif-item span {
  flex: 1;
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
}

/* 滚动条美化 */
.assistant-content::-webkit-scrollbar,
.top-pages::-webkit-scrollbar,
.notifications::-webkit-scrollbar {
  width: 6px;
}

.assistant-content::-webkit-scrollbar-thumb,
.top-pages::-webkit-scrollbar-thumb,
.notifications::-webkit-scrollbar-thumb {
  background: #c0c4cc;
  border-radius: 3px;
}

.assistant-content::-webkit-scrollbar-thumb:hover,
.top-pages::-webkit-scrollbar-thumb:hover,
.notifications::-webkit-scrollbar-thumb:hover {
  background: #909399;
}
</style>
