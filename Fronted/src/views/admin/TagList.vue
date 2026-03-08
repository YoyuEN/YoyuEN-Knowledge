<template>
  <section>
    <div class="admin-page-header">
      <div>
        <h1 class="admin-page-title">
          <el-icon style="margin-right: 8px; vertical-align: -2px;"><PriceTag /></el-icon>
          标签管理
        </h1>
        <p class="admin-page-desc">维护文章标签，删除前会检查是否仍被文章使用</p>
      </div>
      <el-button type="primary" @click="openCreate" :icon="Plus">新增标签</el-button>
    </div>

    <el-card class="admin-section-card">
      <div style="margin-bottom: 16px; display: flex; align-items: center; gap: 12px;">
        <el-icon style="color: var(--admin-text-secondary);"><InfoFilled /></el-icon>
        <span style="font-size: 13px; color: var(--admin-text-secondary);">
          共 {{ rows.length }} 个标签
        </span>
      </div>
      <el-table :data="rows" stripe v-loading="loading">
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
    </el-card>

    <el-dialog
      v-model="dialogVisible"
      :title="editing ? '重命名标签' : '新增标签'"
      width="480px"
      :close-on-click-modal="false"
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
import { onMounted, ref } from 'vue'
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
