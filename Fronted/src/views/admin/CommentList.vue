<template>
  <section>
    <div class="admin-page-header">
      <h1 class="admin-page-title">
        <el-icon style="margin-right: 8px; vertical-align: -2px;"><ChatDotRound /></el-icon>
        评论管理
      </h1>
      <el-button @click="loadData" :icon="Refresh" :loading="loading">刷新数据</el-button>
    </div>

    <el-card class="admin-section-card">
      <div class="admin-toolbar">
        <el-input
          v-model="query.keyword"
          placeholder="搜索评论内容或作者"
          clearable
          @keyup.enter="loadData"
          :prefix-icon="Search"
          style="max-width: 300px;"
        />
        <div style="flex: 1;"></div>
        <el-button @click="query.keyword = ''; loadData()" :icon="RefreshLeft">清空</el-button>
        <el-button type="primary" @click="loadData" :icon="Search">查询</el-button>
      </div>

      <el-table :data="pagedRows" stripe v-loading="loading" style="margin-top: 16px;">
        <el-table-column prop="author" label="作者" width="140">
          <template #default="{ row }">
            <div style="display: flex; align-items: center; gap: 8px;">
              <el-avatar :size="32" style="background: var(--admin-btn-primary);">
                {{ row.author?.charAt(0) || 'U' }}
              </el-avatar>
              <span>{{ row.author || '匿名' }}</span>
            </div>
          </template>
        </el-table-column>
        <el-table-column prop="content" label="评论内容" min-width="320" show-overflow-tooltip>
          <template #default="{ row }">
            <div style="display: flex; align-items: center; gap: 8px;">
              <el-tag v-if="row.isRecommend" type="warning" size="small" effect="plain">推荐</el-tag>
              <span>{{ row.content }}</span>
            </div>
          </template>
        </el-table-column>
        <el-table-column prop="contentId" label="文章ID" width="200" show-overflow-tooltip />
        <el-table-column prop="createTime" label="时间" width="170" />
        <el-table-column label="推荐" width="80" align="center">
          <template #default="{ row }">
            <el-switch
              :model-value="!!row.isRecommend"
              @change="(val) => changeRecommend(row, val)"
              :active-icon="Star"
            />
          </template>
        </el-table-column>
        <el-table-column label="操作" width="100" align="center">
          <template #default="{ row }">
            <el-button link type="danger" @click="removeRow(row)" :icon="Delete">删除</el-button>
          </template>
        </el-table-column>
      </el-table>

      <div style="margin-top: 20px; display: flex; justify-content: flex-end;">
        <el-pagination
          background
          layout="total, prev, pager, next, jumper"
          :total="rows.length"
          :page-size="pageSize"
          v-model:current-page="currentPage"
        />
      </div>
    </el-card>
  </section>
</template>

<script setup>
import { computed, onMounted, ref } from 'vue'
import { ElMessage, ElMessageBox } from 'element-plus'
import {
  ChatDotRound,
  Refresh,
  Search,
  RefreshLeft,
  Star,
  Delete,
} from '@element-plus/icons-vue'
import { fetchAllComments, removeComment, toggleCommentRecommend } from '@/api/comment/comment'

const loading = ref(false)
const rows = ref([])
const query = ref({ keyword: '' })
const currentPage = ref(1)
const pageSize = 10

const pagedRows = computed(() => {
  const start = (currentPage.value - 1) * pageSize
  return rows.value.slice(start, start + pageSize)
})

const loadData = async () => {
  loading.value = true
  try {
    const res = await fetchAllComments({ keyword: query.value.keyword })
    rows.value = res.data || []
    currentPage.value = 1
  } catch (error) {
    ElMessage.error(error.message || '加载评论失败')
  } finally {
    loading.value = false
  }
}

const changeRecommend = async (row, val) => {
  try {
    await toggleCommentRecommend(row.id, val)
    row.isRecommend = val
    ElMessage.success('推荐状态已更新')
  } catch (error) {
    ElMessage.error(error.message || '更新失败')
  }
}

const removeRow = async (row) => {
  try {
    await ElMessageBox.confirm('确认删除该评论吗？', '删除确认', { type: 'warning' })
    await removeComment(row.id)
    ElMessage.success('评论已删除')
    await loadData()
  } catch (error) {
    if (error !== 'cancel') {
      ElMessage.error(error.message || '删除失败')
    }
  }
}

onMounted(loadData)
</script>
