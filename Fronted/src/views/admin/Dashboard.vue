<template>
  <section>
    <div class="admin-page-header">
      <h1 class="admin-page-title">
        <el-icon style="margin-right: 8px; vertical-align: -2px;"><DataAnalysis /></el-icon>
        智能仪表盘
      </h1>
      <el-button @click="refreshAll" :icon="Refresh" :loading="loading">刷新全部</el-button>
    </div>

    <!-- AI智能助手 - 独占一行 -->
    <el-row :gutter="20" style="margin-bottom: 20px;">
      <el-col :span="24">
        <el-card class="ai-assistant-card">
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

    <!-- 访问统计和快捷信息 - 第二行 -->
    <el-row :gutter="20">
      <el-col :xs="24" :sm="24" :md="12" :lg="12" :xl="12">
        <el-card class="stats-card">
          <div v-loading="statsLoading">
            <div class="stats-metrics">
              <div class="stat-item">
                <div class="stat-label">今日访问</div>
                <div class="stat-value">{{ statistics.todayVisits || 0 }}</div>
              </div>
              <div class="stat-item">
                <div class="stat-label">本周访问</div>
                <div class="stat-value">{{ statistics.weekVisits || 0 }}</div>
              </div>
              <div class="stat-item">
                <div class="stat-label">本月访问</div>
                <div class="stat-value">{{ statistics.monthVisits || 0 }}</div>
              </div>
            </div>
            <div class="top-pages">
              <div class="section-title">热门页面</div>
              <div v-for="(page, index) in statistics.topPages" :key="index" class="page-item">
                <span class="page-rank">{{ index + 1 }}</span>
                <span class="page-path">{{ page.path }}</span>
                <span class="page-views">{{ page.views }}</span>
              </div>
            </div>
          </div>
        </el-card>
      </el-col>

      <el-col :xs="24" :sm="24" :md="12" :lg="12" :xl="12">
        <el-card class="quick-info-card">
          <div v-loading="quickLoading">
            <div class="quick-metrics">
              <div class="quick-item" @click="$router.push('/admin/comments')">
                <el-badge :value="quickInfo.pendingComments" :hidden="quickInfo.pendingComments === 0">
                  <el-icon :size="24" color="#409EFF"><ChatDotRound /></el-icon>
                </el-badge>
                <span>待审核评论</span>
              </div>
              <div class="quick-item" @click="$router.push('/admin/content')">
                <el-badge :value="quickInfo.draftArticles" :hidden="quickInfo.draftArticles === 0">
                  <el-icon :size="24" color="#E6A23C"><Document /></el-icon>
                </el-badge>
                <span>草稿箱</span>
              </div>
              <div class="quick-item">
                <el-icon :size="24" color="#67C23A"><ChatLineRound /></el-icon>
                <span>今日评论 {{ quickInfo.todayComments }}</span>
              </div>
            </div>
            <div class="notifications" v-if="quickInfo.notifications && quickInfo.notifications.length > 0">
              <div class="section-title">系统通知</div>
              <div v-for="(notif, index) in quickInfo.notifications" :key="index" class="notif-item">
                <el-icon :color="notif.type === 'comment' ? '#409EFF' : '#909399'">
                  <Bell v-if="notif.type === 'system'" />
                  <ChatDotRound v-else />
                </el-icon>
                <span>{{ notif.message }}</span>
              </div>
            </div>
          </div>
        </el-card>
      </el-col>
    </el-row>
  </section>
</template>

<script setup>
import { onMounted, ref, computed } from 'vue'
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

// 渲染Markdown
const renderedMarkdown = computed(() => {
  if (!assistantReport.value) return ''
  return marked(assistantReport.value)
})

// 刷新AI助手报告（SSE流式）
const refreshAssistant = async () => {
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
  } catch (error) {
    console.error('获取AI报告失败', error)
    ElMessage.error('获取AI报告失败，请稍后重试')
  } finally {
    assistantLoading.value = false
  }
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
const refreshAll = async () => {
  loading.value = true
  await Promise.all([
    refreshAssistant(),
    refreshStats(),
    refreshQuick()
  ])
  loading.value = false
}

onMounted(() => {
  refreshAssistant()
  refreshStats()
  refreshQuick()
})
</script>

<style scoped>
.ai-assistant-card {
  height: 500px;
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
  background: linear-gradient(135deg, #667eea08 0%, #764ba208 100%);
  font-size: 15px;
}

.markdown-body {
  line-height: 1.9;
  color: #2c3e50;
  font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, 'Helvetica Neue', Arial, sans-serif;
}

.markdown-body :deep(h1) {
  margin-top: 20px;
  margin-bottom: 16px;
  font-weight: 700;
  font-size: 24px;
  color: #1a1a1a;
  border-bottom: 2px solid #667eea;
  padding-bottom: 8px;
}

.markdown-body :deep(h2) {
  margin-top: 24px;
  margin-bottom: 16px;
  font-weight: 600;
  font-size: 20px;
  color: #2c3e50;
}

.markdown-body :deep(h3) {
  margin-top: 16px;
  margin-bottom: 12px;
  font-weight: 600;
  font-size: 18px;
  color: #34495e;
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
  color: #667eea;
  font-weight: 600;
}

.markdown-body :deep(code) {
  background: #f5f7fa;
  padding: 2px 6px;
  border-radius: 4px;
  font-family: 'Courier New', monospace;
  color: #e83e8c;
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
