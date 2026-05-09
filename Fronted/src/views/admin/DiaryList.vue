<template>
  <section class="list-page-container">
    <el-card class="admin-section-card">
      <div class="admin-toolbar">
        <el-input
          v-model="query.keyword"
          placeholder="搜索内容"
          clearable
          @keyup.enter="loadData"
          :prefix-icon="Search"
          style="max-width: 280px;"
        />
        <div style="flex: 1;"></div>
        <el-button type="primary" @click="openCreate" :icon="Plus">新增日记</el-button>
        <el-button type="warning" @click="resetQuery" :icon="RefreshLeft">重置</el-button>
        <el-button type="primary" @click="loadData" :icon="Search">查询</el-button>
      </div>

      <div class="table-container">
        <el-table
          :data="filteredRows"
          v-loading="loading"
        >
          <el-table-column prop="diaryDate" label="日期" width="140" />
          <el-table-column prop="weather" label="天气" width="100" />
          <el-table-column prop="mood" label="心情" width="120" />
          <el-table-column label="内容" min-width="300" show-overflow-tooltip>
            <template #default="{ row }">
              {{ row.content }}
            </template>
          </el-table-column>
          <el-table-column label="操作" width="180" fixed="right">
            <template #default="{ row }">
              <el-button link @click="openEdit(row)" :icon="Edit">编辑</el-button>
              <el-button link type="danger" @click="deleteDiary(row)" :icon="Delete">删除</el-button>
            </template>
          </el-table-column>
        </el-table>
      </div>
    </el-card>

    <el-dialog
      v-model="editorVisible"
      :title="isEdit ? '编辑日记' : '新增日记'"
      width="min(640px, 92vw)"
      :close-on-click-modal="false"
      class="custom-dialog"
    >
      <el-form :model="form" label-width="80px" label-position="top">
        <el-row :gutter="16">
          <el-col :span="12">
            <el-form-item label="日期">
              <el-input v-model="form.diaryDate" placeholder="如 2026-05-07" />
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="天气">
              <el-input v-model="form.weather" placeholder="如 晴" />
            </el-form-item>
          </el-col>
        </el-row>
        <el-form-item label="心情">
          <el-input v-model="form.mood" placeholder="如 开心" />
        </el-form-item>
        <el-form-item label="内容">
          <el-input
            v-model="form.content"
            type="textarea"
            :rows="8"
            placeholder="请输入日记内容"
          />
        </el-form-item>
      </el-form>

      <template #footer>
        <div style="display: flex; justify-content: flex-end; gap: 12px;">
          <el-button @click="editorVisible = false">取消</el-button>
          <el-button type="primary" :loading="submitting" @click="submitForm" :icon="Check">
            {{ submitting ? '保存中...' : '保存' }}
          </el-button>
        </div>
      </template>
    </el-dialog>
  </section>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue'
import { ElMessage, ElMessageBox } from 'element-plus'
import {
  Plus,
  Search,
  RefreshLeft,
  Edit,
  Delete,
  Check,
} from '@element-plus/icons-vue'
import {
  fetchDiaryAdminList,
  createDiary,
  updateDiary,
  removeDiary,
} from '@/api/diary/diary.js'

const loading = ref(false)
const submitting = ref(false)
const rows = ref([])
const query = ref({ keyword: '' })

const editorVisible = ref(false)
const isEdit = ref(false)
const form = ref({
  id: '',
  diaryDate: '',
  weather: '',
  mood: '',
  content: '',
})

const filteredRows = computed(() => {
  if (!query.value.keyword) return rows.value
  const kw = query.value.keyword.toLowerCase()
  return rows.value.filter((item) => {
    return (
      (item.content && item.content.toLowerCase().includes(kw)) ||
      (item.diaryDate && item.diaryDate.toLowerCase().includes(kw)) ||
      (item.mood && item.mood.toLowerCase().includes(kw))
    )
  })
})

const loadData = async () => {
  loading.value = true
  try {
    const res = await fetchDiaryAdminList()
    rows.value = res.data || []
  } catch (error) {
    ElMessage.error(error.message || '加载日记失败')
  } finally {
    loading.value = false
  }
}

const resetQuery = () => {
  query.value = { keyword: '' }
  loadData()
}

const openCreate = () => {
  isEdit.value = false
  form.value = {
    id: '',
    diaryDate: '',
    weather: '',
    mood: '',
    content: '',
  }
  editorVisible.value = true
}

const openEdit = (row) => {
  isEdit.value = true
  form.value = {
    id: row.id,
    diaryDate: row.diaryDate || '',
    weather: row.weather || '',
    mood: row.mood || '',
    content: row.content || '',
  }
  editorVisible.value = true
}

const submitForm = async () => {
  if (!form.value.diaryDate || !form.value.content) {
    ElMessage.warning('请补齐日期和内容')
    return
  }

  submitting.value = true
  try {
    const payload = { ...form.value, type: 'diary' }
    if (isEdit.value) {
      await updateDiary(payload)
      ElMessage.success('日记更新成功')
    } else {
      await createDiary(payload)
      ElMessage.success('日记创建成功')
    }
    editorVisible.value = false
    await loadData()
  } catch (error) {
    ElMessage.error(error.message || '保存失败')
  } finally {
    submitting.value = false
  }
}

const deleteDiary = async (row) => {
  try {
    await ElMessageBox.confirm(`确认删除 ${row.diaryDate} 的日记吗？`, '删除确认', {
      type: 'warning',
      confirmButtonText: '确认删除',
      cancelButtonText: '取消',
    })
    await removeDiary(row.id)
    ElMessage.success('删除成功')
    await loadData()
  } catch (error) {
    if (error !== 'cancel') {
      ElMessage.error(error.message || '删除失败')
    }
  }
}

onMounted(() => {
  loadData()
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
</style>

<style>
.custom-dialog.el-dialog {
  border-radius: 12px;
  box-shadow: 0 1px 3px rgba(20, 20, 19, 0.08);
  background: #faf9f5;
  border: 1px solid #e6dfd8;
}

.custom-dialog .el-dialog__header {
  padding: 16px 24px;
  border-bottom: 1px solid #e6dfd8;
  background: #faf9f5;
  border-radius: 12px 12px 0 0;
  margin: 0;
}

.custom-dialog .el-dialog__title {
  font-size: 18px;
  font-weight: 500;
  color: #141413;
}

.custom-dialog .el-dialog__body {
  padding: 24px;
  background: #faf9f5;
}

.custom-dialog .el-dialog__footer {
  padding: 16px 24px;
  border-top: 1px solid #e6dfd8;
  background: #f5f0e8;
  border-radius: 0 0 12px 12px;
}

.custom-dialog .el-form-item__label {
  font-weight: 500;
  color: #3d3d3a;
  font-size: 13px;
}

.custom-dialog .el-input__wrapper {
  border-radius: 8px;
  border: 1px solid #e6dfd8;
  background: #faf9f5;
  box-shadow: none !important;
}

.custom-dialog .el-input__wrapper.is-focus {
  border-color: #cc785c;
  outline: 3px solid rgba(204, 120, 92, 0.15);
}

.custom-dialog .el-textarea__inner {
  border-radius: 8px;
  border: 1px solid #e6dfd8;
  background: #faf9f5;
  box-shadow: none !important;
}

.custom-dialog .el-textarea__inner:focus {
  border-color: #cc785c;
  outline: 3px solid rgba(204, 120, 92, 0.15);
}

.custom-dialog .el-button--primary {
  background-color: #cc785c;
  border-color: #cc785c;
  color: #ffffff;
}

.custom-dialog .el-button--primary:hover {
  background-color: #a9583e;
  border-color: #a9583e;
}
</style>
