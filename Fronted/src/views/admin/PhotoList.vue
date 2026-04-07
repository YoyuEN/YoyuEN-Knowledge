<template>
  <section class="list-page-container">
    <el-card class="admin-section-card">
      <div style="margin-bottom: 20px; flex-shrink: 0;">
        <el-upload
          class="photo-uploader"
          drag
          :show-file-list="false"
          :before-upload="beforeUpload"
          :http-request="handleUpload"
          accept="image/*"
        >
          <el-icon class="uploader-icon"><Plus /></el-icon>
          <div class="el-upload__text">
            拖拽图片到此处或 <em>点击上传</em>
          </div>
          <template #tip>
            <div class="el-upload__tip">
              支持 JPG、PNG、GIF 格式，单个文件不超过 5MB
            </div>
          </template>
        </el-upload>
      </div>

      <el-divider style="flex-shrink: 0;" />

      <div class="photo-grid-container">
        <div v-if="rows.length === 0 && !loading" style="text-align: center; padding: 60px 0; color: var(--admin-text-secondary);">
          <el-icon style="font-size: 64px; margin-bottom: 16px;"><Picture /></el-icon>
          <div>暂无图片，请上传</div>
        </div>

        <el-row :gutter="16" v-loading="loading">
          <el-col
            :xs="12"
            :sm="8"
            :md="6"
            :lg="4"
            v-for="item in pagedRows"
            :key="item.id"
            style="margin-bottom: 16px;"
          >
            <div class="photo-card">
              <div
                v-longpress="(e) => showContextMenu(e, item)"
                class="photo-preview"
                @click="previewImage(item.url)"
              >
                <img :src="item.url" alt="photo" />
                <div class="photo-overlay">
                  <el-icon><ZoomIn /></el-icon>
                </div>
              </div>
              <div class="photo-info">
                <div class="photo-actions hide-on-mobile">
                  <el-button link size="small" @click="openEdit(item)" :icon="Edit">编辑</el-button>
                  <el-button link size="small" type="danger" @click="removeRow(item)" :icon="Delete">删除</el-button>
                </div>
              </div>
            </div>
          </el-col>
        </el-row>
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
        <div style="margin-bottom: 12px;">
          <img :src="selectedRow.url" style="max-width: 100%; border-radius: 4px;" />
        </div>
        <div style="margin-bottom: 8px;"><strong>描述：</strong>{{ selectedRow.description || '无描述' }}</div>
        <div style="margin-bottom: 8px;"><strong>URL：</strong><span style="font-size: 12px; word-break: break-all;">{{ selectedRow.url }}</span></div>
      </div>
    </ContextMenu>

    <el-dialog
      v-model="editVisible"
      title="编辑图片信息"
      width="480px"
      :close-on-click-modal="false"
      :lock-scroll="true"
      class="custom-dialog"
    >
      <el-form :model="editForm" label-position="top">
        <el-form-item label="图片预览">
          <img :src="editForm.url" style="max-width: 100%; border-radius: 8px;" />
        </el-form-item>
        <el-form-item label="图片描述">
          <el-input
            v-model="editForm.description"
            type="textarea"
            :rows="3"
            placeholder="请输入图片描述"
          />
        </el-form-item>
      </el-form>
      <template #footer>
        <el-button @click="editVisible = false">取消</el-button>
        <el-button type="primary" @click="saveEdit" :icon="Check">保存</el-button>
      </template>
    </el-dialog>

    <el-image-viewer
      v-if="previewVisible"
      :url-list="[previewUrl]"
      @close="previewVisible = false"
    />
  </section>
</template>

<script setup>
import { onMounted, ref, onUnmounted, computed } from 'vue'
import { ElMessage, ElMessageBox, ElImageViewer } from 'element-plus'
import {
  Picture,
  Plus,
  ZoomIn,
  Edit,
  Delete,
  Check,
} from '@element-plus/icons-vue'
import { fetchPhotoList, removePhoto, uploadPhoto, updatePhoto } from '@/api/photo/photo'
import ContextMenu from '@/components/ContextMenu.vue'
import vLongpress from '@/directives/longpress'

const rows = ref([])
const loading = ref(false)
const contextMenuRef = ref(null)
const selectedRow = ref(null)
const contextMenuTitle = ref('')
const contextMenuActions = ref([])
const editVisible = ref(false)
const editForm = ref({ id: '', url: '', description: '' })
const previewVisible = ref(false)
const previewUrl = ref('')

const currentPage = ref(1)
const pageSize = ref(12)

const pagedRows = computed(() => {
  const start = (currentPage.value - 1) * pageSize.value
  return rows.value.slice(start, start + pageSize.value)
})

const loadData = async () => {
  loading.value = true
  try {
    const res = await fetchPhotoList()
    rows.value = res.data || []
  } catch (error) {
    ElMessage.error(error.message || '加载图片失败')
  } finally {
    loading.value = false
  }
}

const beforeUpload = (file) => {
  const isImage = file.type.startsWith('image/')
  const isLt5M = file.size / 1024 / 1024 < 5
  if (!isImage) {
    ElMessage.error('只能上传图片文件')
    return false
  }
  if (!isLt5M) {
    ElMessage.error('图片大小不能超过 5MB')
    return false
  }
  return true
}

const handleUpload = async ({ file }) => {
  try {
    const form = new FormData()
    form.append('file', file)
    await uploadPhoto(form)
    ElMessage.success('上传成功')
    await loadData()
  } catch (error) {
    ElMessage.error(error.message || '上传失败')
  }
}

const openEdit = (item) => {
  editForm.value = {
    id: item.id,
    url: item.url,
    description: item.description || '',
  }
  editVisible.value = true
}

const saveEdit = async () => {
  try {
    await updatePhoto(editForm.value)
    ElMessage.success('更新成功')
    editVisible.value = false
    await loadData()
  } catch (error) {
    ElMessage.error(error.message || '更新失败')
  }
}

const previewImage = (url) => {
  previewUrl.value = url
  previewVisible.value = true
}

const showContextMenu = (e, item) => {
  selectedRow.value = item
  contextMenuTitle.value = '图片详情'
  contextMenuActions.value = [
    {
      label: '编辑',
      icon: Edit,
      handler: () => openEdit(item)
    },
    {
      label: '删除',
      icon: Delete,
      danger: true,
      handler: () => removeRow(item)
    }
  ]

  const x = e.clientX || e.touches?.[0]?.clientX || 0
  const y = e.clientY || e.touches?.[0]?.clientY || 0
  contextMenuRef.value?.show(x, y)
}

const removeRow = async (row) => {
  try {
    await ElMessageBox.confirm('确认删除该图片吗？', '删除确认', { type: 'warning' })
    await removePhoto(row.id)
    ElMessage.success('图片已删除')
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
@import '@/styles/admin-dialog.css';

.list-page-container {
  height: 100%;
  display: flex;
  flex-direction: column;
}

.photo-grid-container {
  flex: 1;
  overflow-y: auto;
  overflow-x: hidden;
  min-height: 0;
  scrollbar-width: none; /* Firefox */
  -ms-overflow-style: none; /* IE/Edge */
}

.photo-grid-container::-webkit-scrollbar {
  display: none; /* Chrome/Safari */
}

.pagination-container {
  padding: 16px 0;
  display: flex;
  justify-content: flex-end;
  border-top: 1px solid var(--admin-border);
  flex-shrink: 0;
}
</style>

<style scoped>
.photo-uploader {
  width: 100%;
}

.uploader-icon {
  font-size: 48px;
  color: var(--admin-text-secondary);
  margin-bottom: 12px;
}

.photo-card {
  border-radius: 8px;
  overflow: hidden;
  background: white;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.08);
  transition: all 0.3s;
}

.photo-card:hover {
  box-shadow: 0 4px 16px rgba(0, 0, 0, 0.12);
  transform: translateY(-2px);
}

.photo-preview {
  position: relative;
  width: 100%;
  padding-top: 100%;
  overflow: hidden;
  cursor: pointer;
  user-select: none;
}

.photo-preview img {
  position: absolute;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  object-fit: cover;
}

.photo-overlay {
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background: rgba(0, 0, 0, 0.5);
  display: flex;
  align-items: center;
  justify-content: center;
  opacity: 0;
  transition: opacity 0.3s;
  color: white;
  font-size: 32px;
}

.photo-preview:hover .photo-overlay {
  opacity: 1;
}

.photo-info {
  padding: 12px;
}

.photo-actions {
  display: flex;
  gap: 8px;
}

@media (max-width: 768px) {
  .hide-on-mobile {
    display: none !important;
  }
}
</style>
