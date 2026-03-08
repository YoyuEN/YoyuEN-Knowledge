<template>
  <section>
    <div class="admin-page-header">
      <div>
        <h1 class="admin-page-title">数据统计</h1>
        <p class="admin-page-desc">展示近 30 天内容发布趋势。</p>
      </div>
      <el-button @click="loadData">刷新</el-button>
    </div>

    <el-card class="admin-section-card" v-loading="loading">
      <template #header>发布统计（近 30 天）</template>
      <el-table :data="tableRows" stripe>
        <el-table-column prop="date" label="日期" width="180" />
        <el-table-column prop="count" label="发布数" width="120" />
      </el-table>
    </el-card>
  </section>
</template>

<script setup>
import { onMounted, ref } from 'vue'
import { ElMessage } from 'element-plus'
import { fetchActivityStats } from '@/api/content/content'

const loading = ref(false)
const tableRows = ref([])

const loadData = async () => {
  loading.value = true
  try {
    const res = await fetchActivityStats(30)
    const map = res.data || {}
    tableRows.value = Object.keys(map)
      .sort((a, b) => (a > b ? -1 : 1))
      .map((date) => ({ date, count: map[date] }))
  } catch (error) {
    ElMessage.error(error.message || '加载统计失败')
  } finally {
    loading.value = false
  }
}

onMounted(loadData)
</script>
