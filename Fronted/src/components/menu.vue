<template>
  <div class="menu-container">
    <el-menu
      :default-active="activeIndex"
      class="el-menu-vertical-demo"
      :collapse="isCollapse"
      router
      @select="handleSelect"
    >
      <el-menu-item index="/">
        <el-icon><ChatDotRound /></el-icon>
        <template #title>问道阁</template>
      </el-menu-item>
      <el-menu-item index="/content">
        <el-icon><Briefcase /></el-icon>
        <template #title>墨香苑</template>
      </el-menu-item>
      <el-menu-item index="/diary">
        <el-icon><Reading /></el-icon>
        <template #title>时光手札</template>
      </el-menu-item>
      <el-menu-item index="/life-experience">
        <el-icon><Compass /></el-icon>
        <template #title>生活经历</template>
      </el-menu-item>
      <el-menu-item index="/profile">
        <el-icon><User /></el-icon>
        <template #title>归心居</template>
      </el-menu-item>
      <el-menu-item index="/admin">
        <el-icon><Grid /></el-icon>
        <template #title>匠心坊</template>
      </el-menu-item>
    </el-menu>
  </div>
</template>

<script setup>
import { computed } from 'vue'
import { useRoute } from 'vue-router'
import {
  ChatDotRound,
  Reading,
  Briefcase,
  User,
  Grid,
  Compass,
} from '@element-plus/icons-vue'

const props = defineProps({
  isCollapse: {
    type: Boolean,
    default: false
  }
})

const emit = defineEmits(['menu-item-click'])

const route = useRoute()
const activeIndex = computed(() => route.path)

const handleSelect = () => {
  emit('menu-item-click')
}
</script>

<style scoped>
.menu-container {
  height: 100%;
  display: flex;
  flex-direction: column;
  overflow: hidden;
}

.el-menu-vertical-demo {
  border-right: none;
  flex: 1;
  background-color: transparent;
  border-radius: 12px;
  overflow-y: auto;
  overflow-x: hidden;
}

/* 美化菜单滚动条 */
.el-menu-vertical-demo::-webkit-scrollbar {
  width: 6px;
}

.el-menu-vertical-demo::-webkit-scrollbar-track {
  background: transparent;
  border-radius: 3px;
}

.el-menu-vertical-demo::-webkit-scrollbar-thumb {
  background: var(--border-color);
  border-radius: 3px;
  transition: background 0.3s ease;
}

.el-menu-vertical-demo::-webkit-scrollbar-thumb:hover {
  background: var(--text-tertiary);
}

/* 菜单项基础样式 */
.el-menu-vertical-demo :deep(.el-menu-item),
.el-menu-vertical-demo :deep(.el-sub-menu__title) {
  color: var(--text-primary);
  transition: all 0.3s ease;
  border-radius: 8px;
  margin: 4px 8px;
  height: 48px;
  line-height: 48px;
}

/* 菜单图标样式 */
.el-menu-vertical-demo :deep(.el-icon) {
  color: var(--text-primary);
  transition: all 0.3s ease;
  font-size: 18px;
}

/* 悬停效果 */
.el-menu-vertical-demo :deep(.el-menu-item:hover),
.el-menu-vertical-demo :deep(.el-sub-menu__title:hover) {
  background-color: var(--hover-bg);
  color: var(--text-primary);
}

.el-menu-vertical-demo :deep(.el-menu-item:hover .el-icon),
.el-menu-vertical-demo :deep(.el-sub-menu__title:hover .el-icon) {
  color: var(--primary-color);
}

/* 激活状态 */
.el-menu-vertical-demo :deep(.el-menu-item.is-active) {
  color: var(--primary-color);
  background-color: var(--hover-bg);
  font-weight: 600;
}

.el-menu-vertical-demo :deep(.el-menu-item.is-active .el-icon) {
  color: var(--primary-color);
}

/* 子菜单样式 */
.el-menu-vertical-demo :deep(.el-sub-menu .el-menu-item) {
  color: var(--text-secondary);
  height: 44px;
  line-height: 44px;
  padding-left: 48px !important;
}

.el-menu-vertical-demo :deep(.el-sub-menu .el-menu-item:hover) {
  background-color: var(--hover-bg);
  color: var(--text-primary);
}

.el-menu-vertical-demo :deep(.el-sub-menu .el-menu-item.is-active) {
  color: var(--primary-color);
  background-color: var(--hover-bg);
  font-weight: 500;
}

/* 子菜单展开动画 */
.el-menu-vertical-demo :deep(.el-menu--inline) {
  background-color: transparent;
}
</style>
  