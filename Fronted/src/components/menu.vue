<template>
  <div class="menu-container">
    <!-- <div class="collapse-button">
      <el-button
        :icon="isCollapse ? Expand : Fold"
        @click="toggleCollapse"
        text
        circle
      />
    </div> -->
    <el-menu
      :default-active="activeIndex"
      class="el-menu-vertical-demo"
      :collapse="isCollapse"
      router
      @open="handleOpen"
      @close="handleClose"
      @select="handleSelect"
    >
      <el-menu-item index="/">
        <el-icon><ChatDotRound /></el-icon>
        <template #title>AI对话</template>
      </el-menu-item>
      <el-menu-item index="/knowledge-blog">
        <el-icon><Document /></el-icon>
        <template #title>知识博客</template>
      </el-menu-item>
      <el-menu-item index="/life-entertainment">
        <el-icon><VideoPlay /></el-icon>
        <template #title>生活娱乐</template>
      </el-menu-item>
      <el-menu-item index="/life-experience">
        <el-icon><Reading /></el-icon>
        <template #title>人生经历</template>
      </el-menu-item>
      <el-menu-item index="/work-life">
        <el-icon><Briefcase /></el-icon>
        <template #title>工作生活</template>
      </el-menu-item>
    </el-menu>
  </div>
</template>

<script setup>
import { ref, computed } from 'vue'
import { useRoute } from 'vue-router'
import {
  Document,
  ChatDotRound,
  VideoPlay,
  Reading,
  Briefcase,
  Expand,
  Fold,
} from '@element-plus/icons-vue'

const props = defineProps({
  isCollapse: {
    type: Boolean,
    default: false
  }
})

const emit = defineEmits(['toggle-collapse', 'menu-item-click'])

const route = useRoute()
const activeIndex = computed(() => route.path)

const toggleCollapse = () => {
  emit('toggle-collapse', !props.isCollapse)
}

const handleOpen = (key, keyPath) => {
  console.log(key, keyPath)
}

const handleClose = (key, keyPath) => {
  console.log(key, keyPath)
}

const handleSelect = (key, keyPath) => {
  console.log(key, keyPath)
  emit('menu-item-click')
}
</script>

<style scoped>
.menu-container {
  height: 100%;
  display: flex;
  flex-direction: column;
}

.collapse-button {
  padding: 10px;
  text-align: center;
  border-bottom: 1px solid var(--border-color);
  transition: border-color 0.3s;
  background-color: var(--bg-aside);
}

.collapse-button :deep(.el-button) {
  color: var(--text-primary);
  transition: color 0.3s;
}

.collapse-button :deep(.el-button:hover) {
  color: var(--text-primary);
  background-color: var(--hover-bg);
}

.el-menu-vertical-demo {
  border-right: none;
  flex: 1;
  background-color: var(--bg-aside);
  transition: background-color 0.3s;
  border-radius: 16px;
}

/* 确保菜单图标颜色适配主题 */
.el-menu-vertical-demo :deep(.el-icon) {
  color: var(--text-primary);
  transition: color 0.3s;
}

.el-menu-vertical-demo :deep(.el-menu-item) {
  color: var(--text-primary);
}

.el-menu-vertical-demo :deep(.el-menu-item:hover) {
  background-color: var(--hover-bg);
  color: var(--text-primary);
}

.el-menu-vertical-demo :deep(.el-menu-item.is-active) {
  color: var(--text-primary);
  background-color: var(--hover-bg);
}

.el-menu-vertical-demo :deep(.el-sub-menu__title) {
  color: var(--text-primary);
}

.el-menu-vertical-demo :deep(.el-sub-menu__title:hover) {
  background-color: var(--hover-bg);
  color: var(--text-primary);
}

.el-menu-vertical-demo :deep(.el-sub-menu .el-menu-item) {
  color: var(--text-secondary);
}

.el-menu-vertical-demo :deep(.el-sub-menu .el-menu-item:hover) {
  background-color: var(--hover-bg);
  color: var(--text-primary);
}

.el-menu-vertical-demo :deep(.el-sub-menu .el-menu-item.is-active) {
  color: var(--text-primary);
  background-color: var(--hover-bg);
}
</style>
  