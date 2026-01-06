<template>
  <div class="card-16-9" :style="cardStyle">
    <div class="card-blur-bg">
      <el-image :src="backgroundImage" fit="cover" class="bg-image">
        <template #error>
          <div class="bg-placeholder">
            <el-icon size="48"><Picture /></el-icon>
          </div>
        </template>
      </el-image>
    </div>
    <div class="card-content">
      <slot></slot>
    </div>
  </div>
</template>

<script setup>
import { computed } from 'vue'
import { Picture } from '@element-plus/icons-vue'

const props = defineProps({
  backgroundImage: {
    type: String,
    default: ''
  },
  height: {
    type: String,
    default: '100%'
  }
})

const cardStyle = computed(() => ({
  height: props.height
}))
</script>

<style scoped>
.card-16-9 {
  position: relative;
  width: 100%;
  aspect-ratio: 16 / 9;
  border-radius: 12px;
  overflow: hidden;
}

.card-blur-bg {
  position: absolute;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  z-index: 0;
  filter: blur(40px);
  transform: scale(1.2);
}

.bg-image {
  width: 100%;
  height: 100%;
}

.bg-placeholder {
  width: 100%;
  height: 100%;
  display: flex;
  align-items: center;
  justify-content: center;
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  color: white;
}

.card-content {
  position: relative;
  z-index: 1;
  width: 100%;
  height: 100%;
  display: flex;
  flex-direction: column;
  justify-content: flex-start;
}
</style>
