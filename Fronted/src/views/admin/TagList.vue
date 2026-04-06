<template>
  <section class="list-page-container">
    <el-card class="admin-section-card">
      <div class="admin-toolbar">
        <div style="flex: 1;"></div>
        <el-button type="primary" @click="openCreate" :icon="Plus">新增标签</el-button>
      </div>
      <div style="margin-bottom: 16px; display: flex; align-items: center; gap: 12px; flex-shrink: 0;">
        <el-icon style="color: var(--admin-text-secondary);"><InfoFilled /></el-icon>
        <span style="font-size: 13px; color: var(--admin-text-secondary);">
          共 {{ rows.length }} 个标签
        </span>
      </div>

      <div class="table-container">
        <el-table :data="pagedRows" stripe v-loading="loading">
          <el-table-column prop="name" label="标签名" min-width="240">
            <template #default="{ row }">
              <el-tag effect="plain" size="large">{{ row.name }}</el-tag>
            </template>
          </el-table-column>
          <el-table-column prop="count" label="使用文章数" width="140" align="center">
            <template #default="{ row }">
              <el-tag type="info" effect="plain" size="small">
                <el-icon style="vertical-align: -2px; margin-right: 4px;"><Document /></el-icon>
                {{ row.count || 0 }}
              </el-tag>
            </template>
          </el-table-column>
          <el-table-column label="操作" width="180" align="center">
            <template #default="{ row }">
              <el-button link @click="openEdit(row)" :icon="Edit">重命名</el-button>
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

    <el-dialog
      v-model="dialogVisible"
      :title="editing ? '重命名标签' : '新增标签'"
      width="480px"
      :close-on-click-modal="false"
      :lock-scroll="true"
      class="custom-dialog"
    >
      <el-form :model="form" label-width="80px" label-position="top">
        <el-form-item label="标签名">
          <el-input v-model="form.name" placeholder="请输入标签名，例如: Vue3, TypeScript" size="large" />
          <div style="margin-top: 6px; font-size: 12px; color: var(--admin-text-secondary);">
            标签用于文章分类和检索
          </div>
        </el-form-item>
      </el-form>
      <template #footer>
        <el-button @click="dialogVisible = false">取消</el-button>
        <el-button type="primary" :loading="submitting" @click="submitForm" :icon="Check">
          {{ submitting ? '保存中...' : '保存' }}
        </el-button>
      </template>
    </el-dialog>
  </section>
</template>

<script setup>
import { onMounted, ref, computed } from 'vue'
import { ElMessage, ElMessageBox } from 'element-plus'
import {
  Plus,
  PriceTag,
  Edit,
  Delete,
  Check,
  InfoFilled,
  Document,
} from '@element-plus/icons-vue'
import {
  createContentTag,
  fetchContentTags,
  removeContentTag,
  updateContentTag,
} from '@/api/content/content'

const loading = ref(false)
const submitting = ref(false)
const rows = ref([])
const dialogVisible = ref(false)
const editing = ref(false)
const oldName = ref('')
const form = ref({ name: '' })

const currentPage = ref(1)
const pageSize = ref(10)

const pagedRows = computed(() => {
  const start = (currentPage.value - 1) * pageSize.value
  return rows.value.slice(start, start + pageSize.value)
})

const loadData = async () => {
  loading.value = true
  try {
    const res = await fetchContentTags()
    rows.value = res.data || []
  } catch (error) {
    ElMessage.error(error.message || '加载标签失败')
  } finally {
    loading.value = false
  }
}

const openCreate = () => {
  editing.value = false
  oldName.value = ''
  form.value = { name: '' }
  dialogVisible.value = true
}

const openEdit = (row) => {
  editing.value = true
  oldName.value = row.name
  form.value = { name: row.name }
  dialogVisible.value = true
}

const submitForm = async () => {
  if (!form.value.name) {
    ElMessage.warning('标签名不能为空')
    return
  }
  submitting.value = true
  try {
    if (editing.value) {
      await updateContentTag(oldName.value, form.value.name)
      ElMessage.success('标签已更新')
    } else {
      await createContentTag(form.value.name)
      ElMessage.success('标签已创建')
    }
    dialogVisible.value = false
    await loadData()
  } catch (error) {
    ElMessage.error(error.message || '保存失败')
  } finally {
    submitting.value = false
  }
}

const removeRow = async (row) => {
  try {
    await ElMessageBox.confirm(`确认删除标签「${row.name}」吗？`, '删除确认', { type: 'warning' })
    await removeContentTag(row.name)
    ElMessage.success('标签已删除')
    await loadData()
  } catch (error) {
    if (error !== 'cancel') {
      ElMessage.error(error.message || '删除失败')
    }
  }
}

onMounted(loadData)
</script>

<style scoped>
@import '@/styles/admin-dialog.css';

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
</style>
