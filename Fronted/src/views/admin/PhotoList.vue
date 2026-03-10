<template>
  <section>
    <div class="admin-page-header">
      <h1 class="admin-page-title">
        <el-icon style="margin-right: 8px; vertical-align: -2px;"><Picture /></el-icon>
        图片管理
      </h1>
      <el-button type="primary" @click="loadData" :icon="Refresh" :loading="loading">刷新</el-button>
    </div>

    <el-card class="admin-section-card">
      <div style="margin-bottom: 20px;">
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

      <el-divider />

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
          v-for="item in rows"
          :key="item.id"
          style="margin-bottom: 16px;"
        >
          <div class="photo-card">
            <div class="photo-preview" @click="previewImage(item.url)">
              <img :src="item.url" alt="photo" />
              <div class="photo-overlay">
                <el-icon><ZoomIn /></el-icon>
              </div>
            </div>
            <div class="photo-info">
              <div class="photo-desc">{{ item.description || '无描述' }}</div>
              <div class="photo-actions">
                <el-button link size="small" @click="openEdit(item)" :icon="Edit">编辑</el-button>
                <el-button link size="small" type="danger" @click="removeRow(item)" :icon="Delete">删除</el-button>
              </div>
            </div>
          </div>
        </el-col>
      </el-row>
    </el-card>

    <el-dialog v-model="editVisible" title="编辑图片信息" width="480px" :close-on-click-modal="false">
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
import { onMounted, ref } from 'vue'
import { ElMessage, ElMessageBox, ElImageViewer } from 'element-plus'
import {
  Picture,
  Refresh,
  Plus,
  ZoomIn,
  Edit,
  Delete,
  Check,
} from '@element-plus/icons-vue'
import { fetchPhotoList, removePhoto, uploadPhoto, updatePhoto } from '@/api/photo/photo'

const rows = ref([])
const loading = ref(false)
const editVisible = ref(false)
const editForm = ref({ id: '', url: '', description: '' })
const previewVisible = ref(false)
const previewUrl = ref('')

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

onMounted(loadData)
</script>
