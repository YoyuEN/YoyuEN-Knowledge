<template>
  <section>
    <!-- 汇总卡片 -->
    <el-row :gutter="16" style="margin-bottom: 20px;">
      <el-col :xs="12" :sm="6" v-for="card in summaryCards" :key="card.label">
        <div class="summary-card">
          <el-icon :size="22" class="summary-icon">
            <component :is="card.icon" />
          </el-icon>
          <div class="summary-value">{{ card.value }}</div>
          <div class="summary-label">{{ card.label }}</div>
        </div>
      </el-col>
    </el-row>

    <!-- 活动热力图 + 分类分布 -->
    <el-row :gutter="16">
      <el-col :xs="24" :md="16">
        <el-card class="chart-card" v-loading="heatmapLoading">
          <div class="card-title">内容发布热力图（近一年）</div>
          <div class="heatmap-wrap">
            <CalendarHeatmap
              v-if="heatmapValues.length"
              :values="heatmapValues"
              :end-date="today"
              :max="heatmapMax"
              :round="3"
              tooltip-unit="篇"
              :color="{ empty: '#ebedf0', colors: ['#c6e8a6', '#8cc665', '#44a340', '#1e6823'] }"
            />
            <div v-else class="empty-chart">暂无数据</div>
          </div>
        </el-card>
      </el-col>

      <el-col :xs="24" :md="8">
        <el-card class="chart-card" v-loading="categoryLoading">
          <div class="card-title">内容分类分布</div>
          <div class="donut-wrap">
            <svg v-if="categoryData.length" class="donut-svg" viewBox="0 0 120 120">
              <circle
                v-for="(seg, i) in donutSegments"
                :key="i"
                cx="60" cy="60" r="40"
                fill="none"
                :stroke="seg.color"
                stroke-width="20"
                :stroke-dasharray="`${seg.dash} ${seg.gap}`"
                :stroke-dashoffset="seg.offset"
              />
              <text x="60" y="56" text-anchor="middle" font-size="11" fill="#606266" font-weight="500">总计</text>
              <text x="60" y="70" text-anchor="middle" font-size="14" fill="#303133" font-weight="700">{{ totalContent }}</text>
            </svg>
            <div v-else class="empty-chart">暂无数据</div>
          </div>
          <div class="legend-list">
            <div v-for="(item, i) in categoryData" :key="i" class="legend-item">
              <span class="legend-dot" :style="{ background: categoryColors[i % categoryColors.length] }"></span>
              <span class="legend-name">{{ categoryLabel(item.name) }}</span>
              <span class="legend-value">{{ item.count }}</span>
            </div>
          </div>
        </el-card>
      </el-col>
    </el-row>
  </section>
</template>

<script setup>
import { onMounted, ref, computed, onUnmounted } from 'vue'
import { ElMessage } from 'element-plus'
import { TrendCharts, Refresh, Document, ChatDotRound, View, Star } from '@element-plus/icons-vue'
import { CalendarHeatmap } from 'vue3-calendar-heatmap'
import 'vue3-calendar-heatmap/dist/style.css'
import { fetchActivityStats, fetchContentStats, fetchAllContent } from '@/api/content/content'

const loading = ref(false)
const heatmapLoading = ref(false)
const categoryLoading = ref(false)

const today = new Date().toISOString().slice(0, 10)

// 汇总数据
const totalContent = ref(0)
const totalComment = ref(0)
const totalViews = ref(0)
const totalRecommend = ref(0)

const summaryCards = computed(() => [
  { label: '内容总数', value: totalContent.value, icon: Document },
  { label: '评论总数', value: totalComment.value, icon: ChatDotRound },
  { label: '总浏览量', value: totalViews.value, icon: View },
  { label: '推荐内容', value: totalRecommend.value, icon: Star },
])

// 热力图
const heatmapValues = ref([])
const heatmapMax = ref(5)

// 分类分布
const categoryColors = ['#667eea', '#f5576c', '#4facfe', '#43e97b', '#f093fb', '#f6d365']
const categoryData = ref([])

const categoryLabel = (name) => {
  const map = { article: '文章', game: '游戏', study: '学习', video: '视频' }
  return map[name] || name
}

const donutSegments = computed(() => {
  const total = categoryData.value.reduce((s, c) => s + c.count, 0)
  if (!total) return []
  const circumference = 2 * Math.PI * 40 // r=40
  let offset = 0
  return categoryData.value.map((item, i) => {
    const ratio = item.count / total
    const dash = ratio * circumference
    const seg = {
      color: categoryColors[i % categoryColors.length],
      dash,
      gap: circumference - dash,
      offset: circumference * 0.25 - offset, // 从顶部开始
    }
    offset += dash
    return seg
  })
})

// 加载汇总 + 浏览量/推荐数（从 allContent 聚合）
const loadSummary = async () => {
  const [statsRes, allRes] = await Promise.all([
    fetchContentStats(),
    fetchAllContent({}),
  ])
  const stats = statsRes.data || {}
  totalContent.value = stats.contentCount || 0
  totalComment.value = stats.commentCount || 0

  const allList = allRes.data || []
  totalViews.value = allList.reduce((s, c) => s + (c.viewCount || 0), 0)
  totalRecommend.value = allList.filter(c => c.isRecommend).length

  // 分类统计
  const catMap = {}
  allList.forEach(c => {
    catMap[c.category] = (catMap[c.category] || 0) + 1
  })
  categoryData.value = Object.entries(catMap)
    .map(([name, count]) => ({ name, count }))
    .sort((a, b) => b.count - a.count)
}

// 加载热力图（近一年）
const loadHeatmap = async () => {
  heatmapLoading.value = true
  try {
    const res = await fetchActivityStats(365)
    const map = res.data || {}
    heatmapValues.value = Object.entries(map).map(([date, count]) => ({ date, count }))
    heatmapMax.value = Math.max(...Object.values(map), 1)
  } finally {
    heatmapLoading.value = false
  }
}

const loadData = async () => {
  loading.value = true
  categoryLoading.value = true
  try {
    await Promise.all([loadSummary(), loadHeatmap()])
  } catch (e) {
    ElMessage.error(e.message || '加载失败')
  } finally {
    loading.value = false
    categoryLoading.value = false
  }
}

const handleAdminRefresh = () => {
  loadData()
}

onMounted(() => {
  loadData()
  window.addEventListener('admin-refresh', handleAdminRefresh)
})

onUnmounted(() => {
  window.removeEventListener('admin-refresh', handleAdminRefresh)
})
</script>

<style scoped>
.summary-card {
  border-radius: 8px;
  padding: 20px 16px;
  display: flex;
  flex-direction: column;
  gap: 8px;
  margin-bottom: 16px;
  background: #fff;
  border: 1px solid #ebeef5;
  box-shadow: 0 1px 4px rgba(0, 0, 0, 0.06);
  transition: box-shadow 0.2s;
}
.summary-card:hover {
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
}
.summary-icon {
  color: #909399;
}
.summary-value {
  font-size: 28px;
  font-weight: 700;
  letter-spacing: -0.5px;
  line-height: 1;
  color: #303133;
}
.summary-label {
  font-size: 13px;
  color: #909399;
}

.chart-card {
  border-radius: 12px;
  box-shadow: 0 2px 12px rgba(0, 0, 0, 0.08);
}
.chart-card :deep(.el-card__body) {
  padding: 20px;
}
.card-title {
  font-size: 14px;
  font-weight: 600;
  color: #303133;
  margin-bottom: 16px;
}

/* 热力图 */
.heatmap-wrap {
  overflow-x: auto;
  padding-bottom: 4px;
}
.heatmap-wrap :deep(.vch__container) {
  width: 100%;
}

/* 甜甜圈图 */
.donut-wrap {
  display: flex;
  justify-content: center;
  margin-bottom: 12px;
}
.donut-svg {
  width: 120px;
  height: 120px;
}
.legend-list {
  display: flex;
  flex-direction: column;
  gap: 8px;
}
.legend-item {
  display: flex;
  align-items: center;
  font-size: 13px;
  color: #606266;
}
.legend-dot {
  width: 10px;
  height: 10px;
  border-radius: 50%;
  margin-right: 8px;
  flex-shrink: 0;
}
.legend-name {
  flex: 1;
}
.legend-value {
  font-weight: 600;
  color: #303133;
}

.empty-chart {
  height: 100px;
  display: flex;
  align-items: center;
  justify-content: center;
  color: #c0c4cc;
  font-size: 13px;
}
</style>
