<template>
  <section>
    <div class="admin-page-header">
      <h1 class="admin-page-title">
        <el-icon style="margin-right: 8px; vertical-align: -2px;"><Collection /></el-icon>
        分类管理
      </h1>
      <el-button type="primary" @click="openCreate" :icon="Plus">新增分类</el-button>
    </div>

    <el-card class="admin-section-card">
      <el-table :data="rows" stripe v-loading="loading">
        <el-table-column prop="name" label="分类名称" min-width="200">
          <template #default="{ row }">
            <el-tag effect="light" size="large">{{ row.name }}</el-tag>
          </template>
        </el-table-column>
        <el-table-column prop="type" label="分类标识" min-width="180">
          <template #default="{ row }">
            <code style="padding: 4px 8px; background: var(--admin-bg-panel-muted); border-radius: 4px; font-size: 13px;">
              {{ row.type }}
            </code>
          </template>
        </el-table-column>
        <el-table-column prop="count" label="文章数" width="120" align="center">
          <template #default="{ row }">
            <el-tag type="info" effect="plain" size="small">{{ row.count || 0 }}</el-tag>
          </template>
        </el-table-column>
        <el-table-column label="操作" width="180" align="center">
          <template #default="{ row }">
            <el-button link @click="openEdit(row)" :icon="Edit">编辑</el-button>
            <el-button link type="danger" @click="removeRow(row)" :icon="Delete">删除</el-button>
          </template>
        </el-table-column>
      </el-table>
    </el-card>

    <el-dialog
      v-model="dialogVisible"
      :title="editing ? '编辑分类' : '新增分类'"
      width="480px"
      :close-on-click-modal="false"
    >
      <el-form :model="form" label-width="90px" label-position="top">
        <el-form-item label="分类标识">
          <el-input v-model="form.type" placeholder="例如: tech, life, tutorial" />
          <div style="margin-top: 6px; font-size: 12px; color: var(--admin-text-secondary);">
            用于URL和API，建议使用英文小写
          </div>
        </el-form-item>
        <el-form-item label="分类名称">
          <el-input v-model="form.name" placeholder="例如: 技术文章、生活随笔" />
          <div style="margin-top: 6px; font-size: 12px; color: var(--admin-text-secondary);">
            显示在前端的分类名称
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
  Collection,
  Edit,
  Delete,
  Check,
} from '@element-plus/icons-vue'
import {
  createContentCategory,
  fetchContentCategories,
  removeContentCategory,
  updateContentCategory,
} from '@/api/content/content'

const loading = ref(false)
const submitting = ref(false)
const rows = ref([])
const dialogVisible = ref(false)
const editing = ref(false)
const oldType = ref('')
const form = ref({ type: '', name: '' })

const loadData = async () => {
  loading.value = true
  try {
    const res = await fetchContentCategories()
    rows.value = res.data || []
  } catch (error) {
    ElMessage.error(error.message || '加载分类失败')
  } finally {
    loading.value = false
  }
}

const openCreate = () => {
  editing.value = false
  oldType.value = ''
  form.value = { type: '', name: '' }
  dialogVisible.value = true
}

const openEdit = (row) => {
  editing.value = true
  oldType.value = row.type
  form.value = { type: row.type, name: row.name }
  dialogVisible.value = true
}

const submitForm = async () => {
  if (!form.value.type || !form.value.name) {
    ElMessage.warning('请填写完整分类信息')
    return
  }
  submitting.value = true
  try {
    if (editing.value) {
      await updateContentCategory({ oldType: oldType.value, newType: form.value.type, name: form.value.name })
      ElMessage.success('分类已更新')
    } else {
      await createContentCategory({ type: form.value.type, name: form.value.name })
      ElMessage.success('分类已创建')
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
    await ElMessageBox.confirm(`确认删除分类「${row.name}」吗？`, '删除确认', {
      type: 'warning',
    })
    await removeContentCategory(row.type)
    ElMessage.success('分类已删除')
    await loadData()
  } catch (error) {
    if (error !== 'cancel') {
      ElMessage.error(error.message || '删除失败')
    }
  }
}

onMounted(loadData)
</script>
