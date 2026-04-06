<template>
  <section class="list-page-container">
    <el-card class="admin-section-card">
      <div class="admin-toolbar">
        <el-input
          v-model="query.keyword"
          placeholder="搜索知识库名称"
          clearable
          @keyup.enter="loadData"
          :prefix-icon="Search"
          style="max-width: 280px;"
        />
        <div style="flex: 1;"></div>
        <el-button type="primary" @click="openCreate" :icon="Plus">新增知识库</el-button>
        <el-button type="warning" @click="resetQuery" :icon="RefreshLeft">重置</el-button>
        <el-button type="primary" @click="loadData" :icon="Search">查询</el-button>
      </div>

      <div class="table-container">
        <el-table
          :data="pagedRows"
          stripe
          v-loading="loading"
          :row-class-name="() => 'table-row-longpress'"
          @row-contextmenu="handleRowContextMenu"
        >
          <el-table-column prop="name" label="知识库名称" min-width="200" show-overflow-tooltip />
          <el-table-column prop="description" label="描述" min-width="240" show-overflow-tooltip>
            <template #default="{ row }">
              <span style="color: var(--admin-text-secondary);">{{ row.description || '-' }}</span>
            </template>
          </el-table-column>
          <el-table-column label="文档数量" width="120" align="center">
            <template #default="{ row }">
              <el-tag size="small" effect="plain">{{ row.documentCount || 0 }}</el-tag>
            </template>
          </el-table-column>
          <el-table-column label="状态" width="100" align="center">
            <template #default="{ row }">
              <el-tag :type="row.status === 'active' ? 'success' : 'info'" size="small">
                {{ row.status === 'active' ? '启用' : '禁用' }}
              </el-tag>
            </template>
          </el-table-column>
          <el-table-column prop="createTime" label="创建时间" width="170" />
          <el-table-column label="操作" width="320" fixed="right" class-name="hide-on-mobile">
            <template #default="{ row }">
              <el-button link type="warning" @click="openUpload(row)" :icon="Upload">上传数据</el-button>
              <el-button link @click="openEdit(row)" :icon="Edit">编辑</el-button>
              <el-button link type="success" @click="toggleStatus(row)" :icon="Switch">
                {{ row.status === 'active' ? '禁用' : '启用' }}
              </el-button>
              <el-button link type="danger" @click="deleteKnowledge(row)" :icon="Delete">删除</el-button>
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
        <div style="margin-bottom: 8px;"><strong>名称：</strong>{{ selectedRow.name }}</div>
        <div style="margin-bottom: 8px;"><strong>描述：</strong>{{ selectedRow.description || '-' }}</div>
        <div style="margin-bottom: 8px;"><strong>文档数量：</strong>{{ selectedRow.documentCount || 0 }}</div>
        <div style="margin-bottom: 8px;"><strong>状态：</strong>{{ selectedRow.status === 'active' ? '启用' : '禁用' }}</div>
        <div style="margin-bottom: 8px;"><strong>创建时间：</strong>{{ selectedRow.createTime }}</div>
      </div>
    </ContextMenu>

    <!-- 新增/编辑对话框 -->
    <el-dialog
      v-model="editorVisible"
      :title="isEdit ? '编辑知识库' : '新增知识库'"
      width="600px"
      :close-on-click-modal="false"
      :lock-scroll="true"
      class="custom-dialog"
    >
      <el-form :model="form" label-width="100px">
        <el-form-item label="知识库名称" required>
          <el-input v-model="form.name" placeholder="请输入知识库名称" />
        </el-form-item>
        <el-form-item label="描述">
          <el-input v-model="form.description" type="textarea" :rows="3" placeholder="请输入知识库描述" />
        </el-form-item>
        <el-form-item label="状态">
          <el-radio-group v-model="form.status">
            <el-radio value="active">启用</el-radio>
            <el-radio value="inactive">禁用</el-radio>
          </el-radio-group>
        </el-form-item>
      </el-form>
      <template #footer>
        <el-button @click="editorVisible = false">取消</el-button>
        <el-button type="primary" @click="saveKnowledge" :loading="saving">保存</el-button>
      </template>
    </el-dialog>

    <!-- 上传数据对话框 -->
    <el-dialog
      v-model="uploadVisible"
      title="上传知识库数据"
      width="700px"
      :close-on-click-modal="false"
      :lock-scroll="true"
      class="custom-dialog"
    >
      <div style="margin-bottom: 16px;">
        <el-alert type="info" :closable="false" show-icon>
          <template #title>
            <div style="font-size: 14px;">支持上传文本文件、PDF、Word文档等格式</div>
          </template>
        </el-alert>
      </div>

      <el-upload
        ref="uploadRef"
        class="upload-area"
        drag
        :action="uploadAction"
        :headers="uploadHeaders"
        name="file"
        :on-success="handleUploadSuccess"
        :on-error="handleUploadError"
        :before-upload="beforeUpload"
        :file-list="fileList"
        multiple
        accept=".txt,.pdf,.doc,.docx,.md"
      >
        <el-icon class="el-icon--upload"><UploadFilled /></el-icon>
        <div class="el-upload__text">
          将文件拖到此处，或<em>点击上传</em>
        </div>
        <template #tip>
          <div class="el-upload__tip">
            支持 txt、pdf、doc、docx、md 格式，单个文件不超过 10MB
          </div>
        </template>
      </el-upload>

      <template #footer>
        <el-button @click="uploadVisible = false">关闭</el-button>
      </template>
    </el-dialog>
  </section>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue'
import { ElMessage, ElMessageBox } from 'element-plus'
import {
  Plus, Edit, Delete, Search, RefreshLeft, Upload, Switch,
  Folder, UploadFilled
} from '@element-plus/icons-vue'
import {
  fetchKnowledgeBaseList,
  createKnowledgeBase,
  updateKnowledgeBase,
  removeKnowledgeBase,
  toggleKnowledgeBaseStatus
} from '@/api/knowledge/knowledge'
import ContextMenu from '@/components/ContextMenu.vue'
import { useTableLongpress } from '@/composables/useTableLongpress'

const loading = ref(false)
const saving = ref(false)
const rows = ref([])
const query = ref({ keyword: '' })

const editorVisible = ref(false)
const uploadVisible = ref(false)
const isEdit = ref(false)
const currentKnowledgeId = ref(null)
const fileList = ref([])
const uploadRef = ref(null)
const contextMenuRef = ref(null)
const selectedRow = ref(null)
const contextMenuTitle = ref('')
const contextMenuActions = ref([])

const showContextMenu = (e, row) => {
  selectedRow.value = row
  contextMenuTitle.value = '知识库详情'
  contextMenuActions.value = [
    {
      label: '上传数据',
      icon: Upload,
      handler: () => openUpload(row)
    },
    {
      label: '编辑',
      icon: Edit,
      handler: () => openEdit(row)
    },
    {
      label: row.status === 'active' ? '禁用' : '启用',
      icon: Switch,
      handler: () => toggleStatus(row)
    },
    {
      label: '删除',
      icon: Delete,
      danger: true,
      handler: () => deleteKnowledge(row)
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

const form = ref({
  name: '',
  description: '',
  status: 'active'
})

const uploadAction = computed(() => {
  return `/api/resource/knowledge/${currentKnowledgeId.value}`
})

const uploadHeaders = computed(() => {
  const token = localStorage.getItem('token')
  return {
    'Authorization': `Bearer ${token}`
  }
})

const loadData = async () => {
  loading.value = true
  try {
    const res = await fetchKnowledgeBaseList(query.value)
    rows.value = res.data || []
  } catch (error) {
    ElMessage.error('加载失败')
    rows.value = []
  } finally {
    loading.value = false
  }
}

const resetQuery = () => {
  query.value = { keyword: '' }
  currentPage.value = 1
  loadData()
}

const openCreate = () => {
  isEdit.value = false
  form.value = {
    name: '',
    description: '',
    status: 'active'
  }
  editorVisible.value = true
}

const openEdit = (row) => {
  isEdit.value = true
  form.value = { ...row }
  editorVisible.value = true
}

const saveKnowledge = async () => {
  if (!form.value.name) {
    ElMessage.warning('请输入知识库名称')
    return
  }

  saving.value = true
  try {
    if (isEdit.value) {
      await updateKnowledgeBase(form.value)
      ElMessage.success('更新成功')
    } else {
      await createKnowledgeBase(form.value)
      ElMessage.success('创建成功')
    }
    editorVisible.value = false
    await loadData()
  } catch (error) {
    ElMessage.error(error.message || '保存失败')
  } finally {
    saving.value = false
  }
}

const openUpload = (row) => {
  currentKnowledgeId.value = row.id
  fileList.value = []
  uploadVisible.value = true
}

const beforeUpload = (file) => {
  const isLt10M = file.size / 1024 / 1024 < 10
  if (!isLt10M) {
    ElMessage.error('文件大小不能超过 10MB')
    return false
  }
  return true
}

const handleUploadSuccess = (response, file) => {
  ElMessage.success(`${file.name} 上传成功`)
  loadData()
}

const handleUploadError = (error, file) => {
  ElMessage.error(`${file.name} 上传失败`)
}

const toggleStatus = async (row) => {
  try {
    const action = row.status === 'active' ? '禁用' : '启用'
    await ElMessageBox.confirm(`确定要${action}知识库「${row.name}」吗？`, '状态切换', {
      type: 'warning',
      confirmButtonText: '确认',
      cancelButtonText: '取消'
    })

    const newStatus = row.status === 'active' ? 'inactive' : 'active'
    await toggleKnowledgeBaseStatus({ id: row.id, status: newStatus })
    ElMessage.success(`${action}成功`)
    await loadData()
  } catch (error) {
    if (error !== 'cancel') {
      ElMessage.error(error.message || '操作失败')
    }
  }
}

const deleteKnowledge = async (row) => {
  try {
    await ElMessageBox.confirm(`确定要删除知识库「${row.name}」吗？此操作将同时删除该知识库下的所有文档数据。`, '删除确认', {
      type: 'warning',
      confirmButtonText: '确认删除',
      cancelButtonText: '取消'
    })

    await removeKnowledgeBase(row.id)
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

.table-row-longpress {
  cursor: pointer;
  user-select: none;
}

.upload-area {
  width: 100%;
}

.upload-area :deep(.el-upload-dragger) {
  padding: 40px 20px;
}

@media (max-width: 768px) {
  :deep(.hide-on-mobile) {
    display: none !important;
  }
}
</style>
