<template>
  <div class="content-type-selector">
    <el-radio-group v-model="selectedType" @change="handleChange" size="large">
      <el-radio-button value="article">
        <el-icon style="margin-right: 6px; vertical-align: -2px;"><Document /></el-icon>
        图文内容
      </el-radio-button>
      <el-radio-button value="video">
        <el-icon style="margin-right: 6px; vertical-align: -2px;"><VideoCamera /></el-icon>
        视频内容
      </el-radio-button>
    </el-radio-group>

    <div v-if="showDescription" class="type-description">
      <el-alert
        :title="currentDescription"
        :type="selectedType === 'article' ? 'info' : 'success'"
        :closable="false"
        show-icon
      />
    </div>
  </div>
</template>

<script setup>
import { ref, computed, watch } from 'vue'
import { Document, VideoCamera } from '@element-plus/icons-vue'

const props = defineProps({
  modelValue: {
    type: String,
    default: 'article'
  },
  showDescription: {
    type: Boolean,
    default: true
  }
})

const emit = defineEmits(['update:modelValue', 'change'])

const selectedType = ref(props.modelValue)

const currentDescription = computed(() => {
  return selectedType.value === 'article'
    ? '图文内容：支持富文本编辑，适合文章、教程、笔记等'
    : '视频内容：支持上传视频文件或填写视频链接，适合视频教程、录屏、Vlog等'
})

watch(() => props.modelValue, (newVal) => {
  selectedType.value = newVal
})

const handleChange = (value) => {
  emit('update:modelValue', value)
  emit('change', value)
}
</script>

<style scoped>
.content-type-selector {
  width: 100%;
}

:deep(.el-radio-group) {
  display: flex;
  width: 100%;
}

:deep(.el-radio-button) {
  flex: 1;
}

:deep(.el-radio-button__inner) {
  width: 100%;
  display: flex;
  align-items: center;
  justify-content: center;
  padding: 12px 20px;
  font-size: 14px;
}

.type-description {
  margin-top: 16px;
}

:deep(.el-alert) {
  padding: 10px 12px;
}

:deep(.el-alert__title) {
  font-size: 13px;
  line-height: 1.6;
}
</style>
