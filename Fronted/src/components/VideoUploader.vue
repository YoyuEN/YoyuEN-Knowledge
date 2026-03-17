<template>
  <div class="video-uploader">
    <el-upload
      ref="uploadRef"
      class="upload-area"
      drag
      :action="uploadAction"
      :headers="uploadHeaders"
      :before-upload="beforeUpload"
      :on-progress="handleProgress"
      :on-success="handleSuccess"
      :on-error="handleError"
      :show-file-list="false"
      :disabled="uploading"
      accept="video/mp4,video/avi,video/mov,video/wmv,video/flv,video/webm"
    >
      <div v-if="!videoUrl && !uploading" class="upload-placeholder">
        <el-icon class="upload-icon"><VideoCamera /></el-icon>
        <div class="upload-text">拖拽视频文件到此处或点击上传</div>
        <div class="upload-hint">支持 MP4、AVI、MOV、WMV、FLV、WebM 格式，最大 500MB</div>
      </div>

      <div v-if="uploading" class="upload-progress">
        <el-progress
          type="circle"
          :percentage="uploadPercent"
          :width="80"
        />
        <div class="progress-text">上传中... {{ uploadPercent }}%</div>
      </div>

      <div v-if="videoUrl && !uploading" class="video-preview">
        <video :src="videoUrl" controls class="preview-video"></video>
        <div class="preview-actions">
          <el-button size="small" @click.stop="handleReupload" :icon="RefreshRight">重新上传</el-button>
          <el-button size="small" type="danger" @click.stop="handleRemove" :icon="Delete">删除</el-button>
        </div>
      </div>
    </el-upload>

    <div v-if="videoUrl" class="video-info">
      <el-descriptions :column="2" size="small" border>
        <el-descriptions-item label="视频时长">{{ formatDuration(duration) }}</el-descriptions-item>
        <el-descriptions-item label="文件大小">{{ formatSize(fileSize) }}</el-descriptions-item>
      </el-descriptions>
    </div>
  </div>
</template>

<script setup>
import { ref, computed } from 'vue'
import { ElMessage } from 'element-plus'
import { VideoCamera, RefreshRight, Delete } from '@element-plus/icons-vue'

const props = defineProps({
  modelValue: {
    type: String,
    default: ''
  },
  maxSize: {
    type: Number,
    default: 500 // MB
  }
})

const emit = defineEmits(['update:modelValue', 'upload-success'])

const uploadRef = ref(null)
const uploading = ref(false)
const uploadPercent = ref(0)
const videoUrl = ref(props.modelValue)
const duration = ref(0)
const fileSize = ref(0)

const uploadAction = computed(() => {
  return '/api/content/upload-video'
})

const uploadHeaders = computed(() => {
  const token = localStorage.getItem('token')
  return {
    'Authorization': token ? (token.startsWith('Bearer ') ? token : `Bearer ${token}`) : ''
  }
})

const beforeUpload = (file) => {
  const isVideo = file.type.startsWith('video/')
  const isLt500M = file.size / 1024 / 1024 < props.maxSize

  if (!isVideo) {
    ElMessage.error('只能上传视频文件')
    return false
  }
  if (!isLt500M) {
    ElMessage.error(`视频大小不能超过 ${props.maxSize}MB`)
    return false
  }

  fileSize.value = file.size
  uploading.value = true
  uploadPercent.value = 0

  // 获取视频时长
  getVideoDuration(file)

  return true
}

const getVideoDuration = (file) => {
  const video = document.createElement('video')
  video.preload = 'metadata'
  video.onloadedmetadata = () => {
    window.URL.revokeObjectURL(video.src)
    duration.value = Math.floor(video.duration)
  }
  video.src = URL.createObjectURL(file)
}

const handleProgress = (event) => {
  uploadPercent.value = Math.floor(event.percent)
}

const handleSuccess = (response) => {
  uploading.value = false
  if (response.code === 200) {
    videoUrl.value = response.data.url
    duration.value = response.data.duration || duration.value
    emit('update:modelValue', videoUrl.value)
    emit('upload-success', {
      url: videoUrl.value,
      duration: duration.value,
      size: fileSize.value,
      cover: response.data.cover
    })
    ElMessage.success('视频上传成功')
  } else {
    ElMessage.error(response.message || '上传失败')
  }
}

const handleError = (error) => {
  uploading.value = false
  console.error('上传失败:', error)
  ElMessage.error('视频上传失败，请重试')
}

const handleReupload = () => {
  videoUrl.value = ''
  duration.value = 0
  fileSize.value = 0
  emit('update:modelValue', '')
}

const handleRemove = () => {
  handleReupload()
}

const formatDuration = (seconds) => {
  if (!seconds) return '0秒'
  const h = Math.floor(seconds / 3600)
  const m = Math.floor((seconds % 3600) / 60)
  const s = seconds % 60
  if (h > 0) return `${h}小时${m}分${s}秒`
  if (m > 0) return `${m}分${s}秒`
  return `${s}秒`
}

const formatSize = (bytes) => {
  if (!bytes) return '0 B'
  const k = 1024
  const sizes = ['B', 'KB', 'MB', 'GB']
  const i = Math.floor(Math.log(bytes) / Math.log(k))
  return (bytes / Math.pow(k, i)).toFixed(2) + ' ' + sizes[i]
}
</script>

<style scoped>
.video-uploader {
  width: 100%;
}

.upload-area {
  width: 100%;
}

:deep(.el-upload) {
  width: 100%;
}

:deep(.el-upload-dragger) {
  width: 100%;
  height: auto;
  min-height: 200px;
  display: flex;
  align-items: center;
  justify-content: center;
  border: 2px dashed var(--el-border-color);
  border-radius: 8px;
  background: var(--el-fill-color-blank);
  transition: all 0.3s;
}

:deep(.el-upload-dragger:hover) {
  border-color: var(--el-color-primary);
}

.upload-placeholder {
  text-align: center;
  padding: 40px 20px;
}

.upload-icon {
  font-size: 64px;
  color: var(--el-text-color-secondary);
  margin-bottom: 16px;
}

.upload-text {
  font-size: 16px;
  color: var(--el-text-color-primary);
  margin-bottom: 8px;
}

.upload-hint {
  font-size: 13px;
  color: var(--el-text-color-secondary);
}

.upload-progress {
  display: flex;
  flex-direction: column;
  align-items: center;
  padding: 40px 20px;
}

.progress-text {
  margin-top: 16px;
  font-size: 14px;
  color: var(--el-text-color-regular);
}

.video-preview {
  width: 100%;
  padding: 20px;
}

.preview-video {
  width: 100%;
  max-height: 400px;
  border-radius: 8px;
  background: #000;
}

.preview-actions {
  display: flex;
  justify-content: center;
  gap: 12px;
  margin-top: 16px;
}

.video-info {
  margin-top: 16px;
}
</style>
