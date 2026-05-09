<template>
  <section class="list-page-container">
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
        <el-button type="warning" @click="query.keyword = ''; loadData()" :icon="RefreshLeft">清空</el-button>
        <el-button type="primary" @click="loadData" :icon="Search">查询</el-button>
      </div>

      <div class="table-container">
        <el-table
          :data="pagedRows"
          v-loading="loading"
          :row-class-name="() => 'table-row-longpress'"
          @row-contextmenu="handleRowContextMenu"
        >
          <el-table-column prop="author" label="作者" width="140">
            <template #default="{ row }">
              <div style="display: flex; align-items: center; gap: 8px;">
                <el-avatar :size="32" :src="row.avatar" style="background: var(--admin-btn-primary);">
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
          <el-table-column prop="contentTitle" label="文章" width="200" show-overflow-tooltip />
          <el-table-column prop="createTime" label="时间" width="170" />
          <el-table-column label="推荐" width="80" align="center" class-name="hide-on-mobile">
            <template #default="{ row }">
              <el-switch
                :model-value="!!row.isRecommend"
                @change="(val) => changeRecommend(row, val)"
                :active-icon="Star"
              />
            </template>
          </el-table-column>
          <el-table-column label="操作" width="100" align="center" class-name="hide-on-mobile">
            <template #default="{ row }">
              <el-button link type="danger" @click="removeRow(row)" :icon="Delete">删除</el-button>
            </template>
          </el-table-column>
        </el-table>
      </div>

      <div class="pagination-container">
        <el-pagination
          background
          layout="total, prev, pager, next, jumper"
          :total="rows.length"
          :page-size="pageSize"
          v-model:current-page="currentPage"
        />
      </div>
    </el-card>

    <ContextMenu ref="contextMenuRef" :title="contextMenuTitle" :actions="contextMenuActions">
      <div v-if="selectedRow">
        <div style="margin-bottom: 8px;"><strong>作者：</strong>{{ selectedRow.author || '匿名' }}</div>
        <div style="margin-bottom: 8px;"><strong>内容：</strong>{{ selectedRow.content }}</div>
        <div style="margin-bottom: 8px;"><strong>文章ID：</strong>{{ selectedRow.contentId }}</div>
        <div style="margin-bottom: 8px;"><strong>创建时间：</strong>{{ selectedRow.createTime }}</div>
        <div style="margin-bottom: 8px;"><strong>推荐状态：</strong>{{ selectedRow.isRecommend ? '已推荐' : '未推荐' }}</div>
      </div>
    </ContextMenu>
  </section>
</template>

<script setup>
import { computed, onMounted, ref, onUnmounted } from 'vue'
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
import ContextMenu from '@/components/ContextMenu.vue'
import { useTableLongpress } from '@/composables/useTableLongpress'

const loading = ref(false)
const rows = ref([])
const query = ref({ keyword: '' })
const contextMenuRef = ref(null)
const selectedRow = ref(null)
const contextMenuTitle = ref('')
const contextMenuActions = ref([])

const showContextMenu = (e, row) => {
  selectedRow.value = row
  contextMenuTitle.value = '评论详情'
  contextMenuActions.value = [
    {
      label: row.isRecommend ? '取消推荐' : '设为推荐',
      icon: Star,
      handler: () => changeRecommend(row, !row.isRecommend)
    },
    {
      label: '删除',
      icon: Delete,
      danger: true,
      handler: () => removeRow(row)
    }
  ]

  const x = e.clientX || e.touches?.[0]?.clientX || 0
  const y = e.clientY || e.touches?.[0]?.clientY || 0
  contextMenuRef.value?.show(x, y)
}

const currentPage = ref(1)
const pageSize = ref(10)

const pagedRows = computed(() => {
  const start = (currentPage.value - 1) * pageSize.value
  return rows.value.slice(start, start + pageSize.value)
})

const { handleRowContextMenu } = useTableLongpress(showContextMenu, pagedRows, { pageSize: pageSize.value })

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
.list-page-container {
  height: 100%;
  display: flex;
  flex-direction: column;
}

.table-container {
  flex: 1;
  overflow-y: auto;
  min-height: 0;
}

.pagination-container {
  padding: 16px 0;
  display: flex;
  justify-content: flex-end;
  border-top: 1px solid var(--admin-border);
  flex-shrink: 0;
}

.table-row-longpress {
  cursor: pointer;
  user-select: none;
}

@media (max-width: 768px) {
  :deep(.hide-on-mobile) {
    display: none !important;
  }
}
</style>
