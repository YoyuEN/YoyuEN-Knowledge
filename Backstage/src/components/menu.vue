<template>
  <div class="menu-container">
    <div class="menu-toolbar" :class="{ collapsed: isCollapse }">
      <el-tooltip content="折叠菜单" placement="right">
        <el-button
          :icon="isCollapse ? Expand : Fold"
          text
          circle
          @click="toggleCollapse"
        />
      </el-tooltip>
      <span v-if="!isCollapse">导航</span>
    </div>

    <el-menu
      :default-active="activeIndex"
      :collapse="isCollapse"
      router
      class="console-menu"
      unique-opened
    >
      <el-menu-item index="/dashboard">
        <el-icon><House /></el-icon>
        <template #title>仪表盘</template>
      </el-menu-item>

      <el-sub-menu index="knowledge">
        <template #title>
          <el-icon><Reading /></el-icon>
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
        <el-icon><TrendCharts /></el-icon>
        <template #title>数据统计</template>
      </el-menu-item>
    </el-menu>
  </div>
</template>

<script setup>
import { computed } from 'vue'
import { useRoute } from 'vue-router'
import {
  Expand,
  Fold,
  House,
  Reading,
  Setting,
  TrendCharts,
} from '@element-plus/icons-vue'

const props = defineProps({
  isCollapse: {
    type: Boolean,
    default: false,
  },
})

const emit = defineEmits(['toggle-collapse'])

const route = useRoute()
const activeIndex = computed(() => route.path)

const toggleCollapse = () => {
  emit('toggle-collapse', !props.isCollapse)
}
</script>

<style scoped>
.menu-container {
  height: 100%;
  display: flex;
  flex-direction: column;
}

.menu-toolbar {
  height: 50px;
  display: flex;
  align-items: center;
  gap: 8px;
  padding: 0 14px;
  border-bottom: 1px solid var(--border-base);
  color: var(--text-secondary);
  font-weight: 600;
}

.menu-toolbar.collapsed {
  justify-content: center;
  padding: 0;
}

.console-menu {
  border-right: none;
  background: transparent;
  flex: 1;
}

.console-menu :deep(.el-menu-item),
.console-menu :deep(.el-sub-menu__title) {
  margin: 4px 8px;
  border-radius: 10px;
  color: var(--text-secondary);
}

.console-menu :deep(.el-menu-item.is-active) {
  color: var(--brand-strong);
  background: var(--brand-soft);
  font-weight: 600;
}

.console-menu :deep(.el-menu-item:hover),
.console-menu :deep(.el-sub-menu__title:hover) {
  background: var(--bg-hover);
  color: var(--text-primary);
}
</style>
