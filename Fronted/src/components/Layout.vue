<template>
  <el-container class="layout-container">
    <!-- 头部 -->
    <el-header class="layout-header">
      <div class="header-left">
        <h2 class="logo">YoyuEN</h2>
      </div>
      <div class="header-right">
        <el-button
          :icon="currentTheme === 'dark' ? Sunny : Moon"
          @click="toggleTheme"
          circle
          class="theme-toggle"
          :title="currentTheme === 'dark' ? '切换到浅色主题' : '切换到深色主题'"
        />
        <el-dropdown>
          <span class="user-info">
            <el-icon><User /></el-icon>
            <span>管理员</span>
            <el-icon><ArrowDown /></el-icon>
          </span>
          <template #dropdown>
            <el-dropdown-menu>
              <el-dropdown-item>个人中心</el-dropdown-item>
              <el-dropdown-item>设置</el-dropdown-item>
              <el-dropdown-item divided>退出登录</el-dropdown-item>
            </el-dropdown-menu>
          </template>
        </el-dropdown>
      </div>
    </el-header>

    <el-container>
      <!-- 侧边栏 -->
      <el-aside :width="isCollapse ? '64px' : '200px'" class="layout-aside">
        <Menu :isCollapse="isCollapse" @toggle-collapse="toggleCollapse" />
      </el-aside>

      <!-- 主内容区 -->
      <el-main class="layout-main">
        <router-view />
      </el-main>
    </el-container>
  </el-container>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import Menu from './menu.vue'
import { User, ArrowDown, Sunny, Moon } from '@element-plus/icons-vue'
import { useTheme } from '../composables/useTheme'

const { currentTheme, toggleTheme, initTheme } = useTheme()
const isCollapse = ref(false)

const toggleCollapse = (value) => {
  isCollapse.value = value
}

onMounted(() => {
  // 确保主题已初始化
  initTheme()
})
</script>

<style scoped>
.layout-container {
  height: 100vh;
}

.layout-header {
  background-color: var(--bg-header);
  color: var(--text-primary);
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 0 20px;
  box-shadow: 0 2px 4px var(--shadow);
  transition: background-color 0.3s, color 0.3s;
}

.header-left .logo {
  margin: 0;
  font-size: 20px;
  font-weight: 600;
  color: var(--text-primary);
}

.header-right {
  display: flex;
  align-items: center;
  gap: 12px;
}

.theme-toggle {
  background-color: var(--hover-bg);
  border-color: var(--border-color);
  color: var(--text-primary);
}

.theme-toggle:hover {
  background-color: var(--hover-bg);
  border-color: var(--border-color);
  opacity: 0.8;
}

.user-info {
  display: flex;
  align-items: center;
  gap: 8px;
  cursor: pointer;
  padding: 8px 12px;
  border-radius: 4px;
  transition: background-color 0.3s;
  color: var(--text-primary);
}

.user-info:hover {
  background-color: var(--hover-bg);
}

.layout-aside {
  background-color: var(--bg-aside);
  border-right: 1px solid var(--border-color);
  transition: width 0.3s, background-color 0.3s, border-color 0.3s;
}

.layout-main {
  background-color: var(--bg-secondary);
  padding: 20px;
  overflow-y: auto;
  transition: background-color 0.3s;
}
</style>
