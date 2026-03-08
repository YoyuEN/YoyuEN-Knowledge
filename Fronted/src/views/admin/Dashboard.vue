<template>
  <section>
    <div class="admin-page-header">
      <div>
        <h1 class="admin-page-title">
          <el-icon style="margin-right: 8px; vertical-align: -2px;"><DataAnalysis /></el-icon>
          仪表盘
        </h1>
        <p class="admin-page-desc">查看内容、评论和分类的实时概览</p>
      </div>
      <el-button @click="refreshData" :icon="Refresh" :loading="loading">刷新数据</el-button>
    </div>

    <div class="admin-metric-grid">
      <article class="admin-metric-card">
        <div class="metric-icon" style="background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);">
          <el-icon><Document /></el-icon>
        </div>
        <div class="metric-content">
          <p class="admin-metric-label">文章总数</p>
          <p class="admin-metric-value">{{ stats.contentCount }}</p>
          <p class="admin-metric-extra">
            <el-icon style="vertical-align: -2px;"><TrendCharts /></el-icon>
            来自内容服务
          </p>
        </div>
      </article>

      <article class="admin-metric-card">
        <div class="metric-icon" style="background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%);">
          <el-icon><ChatDotRound /></el-icon>
        </div>
        <div class="metric-content">
          <p class="admin-metric-label">评论总数</p>
          <p class="admin-metric-value">{{ stats.commentCount }}</p>
          <p class="admin-metric-extra">
            <el-icon style="vertical-align: -2px;"><Warning /></el-icon>
            删除文章前需清理评论
          </p>
        </div>
      </article>

      <article class="admin-metric-card">
        <div class="metric-icon" style="background: linear-gradient(135deg, #4facfe 0%, #00f2fe 100%);">
          <el-icon><Collection /></el-icon>
        </div>
        <div class="metric-content">
          <p class="admin-metric-label">分类数</p>
          <p class="admin-metric-value">{{ categories.length }}</p>
          <p class="admin-metric-extra">
            <el-icon style="vertical-align: -2px;"><Setting /></el-icon>
            可在分类管理页维护
          </p>
        </div>
      </article>

      <article class="admin-metric-card">
        <div class="metric-icon" style="background: linear-gradient(135deg, #43e97b 0%, #38f9d7 100%);">
          <el-icon><PriceTag /></el-icon>
        </div>
        <div class="metric-content">
          <p class="admin-metric-label">标签数</p>
          <p class="admin-metric-value">{{ tags.length }}</p>
          <p class="admin-metric-extra">
            <el-icon style="vertical-align: -2px;"><Setting /></el-icon>
            可在标签管理页维护
          </p>
        </div>
      </article>
    </div>

    <el-row :gutter="16" style="margin-top: 20px;">
      <el-col :span="16">
        <el-card class="admin-section-card" v-loading="loading">
          <template #header>
            <div style="display: flex; align-items: center; justify-content: space-between;">
              <span style="font-weight: 600;">
                <el-icon style="margin-right: 6px; vertical-align: -2px;"><Histogram /></el-icon>
                分类分布
              </span>
              <el-tag size="small" effect="plain">共 {{ categories.length }} 个分类</el-tag>
            </div>
          </template>
          <el-table :data="categories" stripe>
            <el-table-column prop="name" label="分类名称" min-width="180">
              <template #default="{ row }">
                <el-tag effect="light">{{ row.name }}</el-tag>
              </template>
            </el-table-column>
            <el-table-column prop="type" label="标识" min-width="140" />
            <el-table-column prop="count" label="文章数" width="120" align="center">
              <template #default="{ row }">
                <el-tag type="info" effect="plain" size="small">{{ row.count || 0 }}</el-tag>
              </template>
            </el-table-column>
          </el-table>
        </el-card>
      </el-col>

      <el-col :span="8">
        <el-card class="admin-section-card" v-loading="loading">
          <template #header>
            <span style="font-weight: 600;">
              <el-icon style="margin-right: 6px; vertical-align: -2px;"><PriceTag /></el-icon>
              热门标签
            </span>
          </template>
          <div class="tag-cloud">
            <el-tag
              v-for="tag in tags.slice(0, 20)"
              :key="tag.name"
              effect="plain"
              style="margin: 4px;"
              size="small"
            >
              {{ tag.name }}
            </el-tag>
            <div v-if="tags.length === 0" style="text-align: center; padding: 40px 0; color: var(--admin-text-secondary);">
              暂无标签数据
            </div>
          </div>
        </el-card>
      </el-col>
    </el-row>
  </section>
</template>

<script setup>
import { onMounted, ref } from 'vue'
import { ElMessage } from 'element-plus'
import {
  DataAnalysis,
  Refresh,
  Document,
  ChatDotRound,
  Collection,
  PriceTag,
  TrendCharts,
  Warning,
  Setting,
  Histogram,
} from '@element-plus/icons-vue'
import { fetchContentStats, fetchContentCategories, fetchContentTags } from '@/api/content/content'

const loading = ref(false)
const stats = ref({ contentCount: 0, commentCount: 0 })
const categories = ref([])
const tags = ref([])

const refreshData = async () => {
  loading.value = true
  try {
    const [statsRes, categoryRes, tagRes] = await Promise.all([
      fetchContentStats(),
      fetchContentCategories(),
      fetchContentTags(),
    ])
    stats.value = statsRes.data || { contentCount: 0, commentCount: 0 }
    categories.value = categoryRes.data || []
    tags.value = tagRes.data || []
  } catch (error) {
    ElMessage.error(error.message || '加载仪表盘数据失败')
  } finally {
    loading.value = false
  }
}

onMounted(refreshData)
</script>
