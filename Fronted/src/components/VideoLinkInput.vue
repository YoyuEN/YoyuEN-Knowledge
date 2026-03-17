<template>
  <div class="video-link-input">
    <el-input
      v-model="linkUrl"
      placeholder="请输入视频链接（支持 B站、YouTube、腾讯视频等）"
      clearable
      @input="handleInput"
      @blur="handleBlur"
    >
      <template #prepend>
        <el-icon><Link /></el-icon>
      </template>
    </el-input>

    <div v-if="linkUrl" class="link-preview">
      <div class="preview-header">
        <span class="preview-title">视频预览</span>
        <el-tag v-if="videoType" size="small" type="success">{{ videoType }}</el-tag>
      </div>

      <div class="preview-content">
        <div v-if="embedUrl" class="embed-container">
          <iframe
            :src="embedUrl"
            frameborder="0"
            allowfullscreen
            class="video-iframe"
          ></iframe>
        </div>
        <div v-else class="link-display">
          <el-icon class="link-icon"><VideoPlay /></el-icon>
          <div class="link-text">{{ linkUrl }}</div>
        </div>
      </div>

      <div class="link-tips">
        <el-alert
          v-if="!isValidLink"
          title="链接格式可能不正确"
          type="warning"
          :closable="false"
          show-icon
        />
        <el-alert
          v-else
          title="链接已识别，保存后将在前台展示"
          type="success"
          :closable="false"
          show-icon
        />
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, computed, watch } from 'vue'
import { Link, VideoPlay } from '@element-plus/icons-vue'

const props = defineProps({
  modelValue: {
    type: String,
    default: ''
  }
})

const emit = defineEmits(['update:modelValue', 'link-change'])

const linkUrl = ref(props.modelValue)
const videoType = ref('')
const embedUrl = ref('')
const isValidLink = ref(false)

watch(() => props.modelValue, (newVal) => {
  linkUrl.value = newVal
  parseVideoLink(newVal)
})

const handleInput = () => {
  emit('update:modelValue', linkUrl.value)
  parseVideoLink(linkUrl.value)
}

const handleBlur = () => {
  emit('link-change', {
    url: linkUrl.value,
    type: videoType.value,
    embedUrl: embedUrl.value,
    isValid: isValidLink.value
  })
}

const parseVideoLink = (url) => {
  if (!url) {
    videoType.value = ''
    embedUrl.value = ''
    isValidLink.value = false
    return
  }

  // B站视频
  if (url.includes('bilibili.com')) {
    videoType.value = 'B站'
    const bvMatch = url.match(/BV[\w]+/)
    const avMatch = url.match(/av(\d+)/)
    if (bvMatch) {
      embedUrl.value = `//player.bilibili.com/player.html?bvid=${bvMatch[0]}&high_quality=1`
      isValidLink.value = true
    } else if (avMatch) {
      embedUrl.value = `//player.bilibili.com/player.html?aid=${avMatch[1]}&high_quality=1`
      isValidLink.value = true
    } else {
      isValidLink.value = false
    }
  }
  // YouTube
  else if (url.includes('youtube.com') || url.includes('youtu.be')) {
    videoType.value = 'YouTube'
    let videoId = ''
    if (url.includes('youtube.com/watch')) {
      const match = url.match(/[?&]v=([^&]+)/)
      videoId = match ? match[1] : ''
    } else if (url.includes('youtu.be/')) {
      const match = url.match(/youtu\.be\/([^?]+)/)
      videoId = match ? match[1] : ''
    }
    if (videoId) {
      embedUrl.value = `https://www.youtube.com/embed/${videoId}`
      isValidLink.value = true
    } else {
      isValidLink.value = false
    }
  }
  // 腾讯视频
  else if (url.includes('v.qq.com')) {
    videoType.value = '腾讯视频'
    const match = url.match(/\/([a-z0-9]+)\.html/)
    if (match) {
      embedUrl.value = `https://v.qq.com/txp/iframe/player.html?vid=${match[1]}`
      isValidLink.value = true
    } else {
      isValidLink.value = false
    }
  }
  // 优酷
  else if (url.includes('youku.com')) {
    videoType.value = '优酷'
    const match = url.match(/id_([^=]+)/)
    if (match) {
      embedUrl.value = `https://player.youku.com/embed/${match[1]}`
      isValidLink.value = true
    } else {
      isValidLink.value = false
    }
  }
  // 其他链接（直接视频文件）
  else if (url.match(/\.(mp4|avi|mov|wmv|flv|webm)$/i)) {
    videoType.value = '直链'
    embedUrl.value = ''
    isValidLink.value = true
  }
  // 未识别的链接
  else {
    videoType.value = '其他'
    embedUrl.value = ''
    isValidLink.value = true // 允许其他链接，由后端处理
  }
}

// 初始化解析
if (props.modelValue) {
  parseVideoLink(props.modelValue)
}
</script>

<style scoped>
.video-link-input {
  width: 100%;
}

.link-preview {
  margin-top: 16px;
  border: 1px solid var(--el-border-color);
  border-radius: 8px;
  padding: 16px;
  background: var(--el-fill-color-blank);
}

.preview-header {
  display: flex;
  align-items: center;
  justify-content: space-between;
  margin-bottom: 12px;
  padding-bottom: 12px;
  border-bottom: 1px solid var(--el-border-color-lighter);
}

.preview-title {
  font-size: 14px;
  font-weight: 600;
  color: var(--el-text-color-primary);
}

.preview-content {
  margin-bottom: 12px;
}

.embed-container {
  position: relative;
  width: 100%;
  padding-bottom: 56.25%; /* 16:9 比例 */
  background: #000;
  border-radius: 8px;
  overflow: hidden;
}

.video-iframe {
  position: absolute;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
}

.link-display {
  display: flex;
  align-items: center;
  gap: 12px;
  padding: 20px;
  background: var(--el-fill-color-light);
  border-radius: 8px;
}

.link-icon {
  font-size: 32px;
  color: var(--el-color-primary);
  flex-shrink: 0;
}

.link-text {
  flex: 1;
  font-size: 13px;
  color: var(--el-text-color-regular);
  word-break: break-all;
  line-height: 1.6;
}

.link-tips {
  margin-top: 12px;
}

:deep(.el-alert) {
  padding: 8px 12px;
}

:deep(.el-alert__title) {
  font-size: 13px;
}
</style>
