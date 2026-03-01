<template>
  <div class="menu-container">
    <div class="collapse-button">
      <el-button
        :icon="isCollapse ? Expand : Fold"
        @click="toggleCollapse"
        text
        circle
      />
    </div>
    <el-menu
      :default-active="activeIndex"
      class="el-menu-vertical-demo"
      :collapse="isCollapse"
      router
      @open="handleOpen"
      @close="handleClose"
    >
      <el-menu-item index="/">
        <el-icon><HomeFilled /></el-icon>
        <template #title>首页</template>
      </el-menu-item>
      <el-sub-menu index="knowledge">
        <template #title>
          <el-icon><Document /></el-icon>
          <span>知识管理</span>
        </template>
        <el-menu-item index="/knowledge/articles">文章管理</el-menu-item>
        <el-menu-item index="/knowledge/categories">分类管理</el-menu-item>
        <el-menu-item index="/knowledge/tags">标签管理</el-menu-item>
      </el-sub-menu>
      <el-sub-menu index="system">
        <template #title>
          <el-icon><Setting /></el-icon>
          <span>系统设置</span>
        </template>
        <el-menu-item index="/system/users">用户管理</el-menu-item>
        <el-menu-item index="/system/roles">角色管理</el-menu-item>
        <el-menu-item index="/system/permissions">权限管理</el-menu-item>
      </el-sub-menu>
      <el-menu-item index="/statistics">
        <el-icon><DataAnalysis /></el-icon>
        <template #title>数据统计</template>
      </el-menu-item>
    </el-menu>
  </div>
</template>

<script setup>
import { ref, computed } from 'vue'
import { useRoute } from 'vue-router'
import {
  Document,
  Setting,
  HomeFilled,
  DataAnalysis,
  Expand,
  Fold,
} from '@element-plus/icons-vue'

const props = defineProps({
  isCollapse: {
    type: Boolean,
    default: false
  }
})

const emit = defineEmits(['toggle-collapse'])

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
  