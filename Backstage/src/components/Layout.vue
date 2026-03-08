<template>
  <el-container class="layout-container">
    <el-header class="layout-header">
      <div class="header-left">
        <div class="brand-mark">Y</div>
        <div class="brand-text">
          <strong>YoyuEN Console</strong>
          <span>Knowledge Operations</span>
        </div>
      </div>

      <div class="header-center">
        <el-breadcrumb separator="/">
          <el-breadcrumb-item>后台管理</el-breadcrumb-item>
          <el-breadcrumb-item>{{ route.meta.title || '页面' }}</el-breadcrumb-item>
        </el-breadcrumb>
      </div>

      <div class="header-right">
        <el-button
          :icon="currentTheme === 'dark' ? Sunny : Moon"
          class="theme-toggle"
          circle
          @click="toggleTheme"
        />
        <el-dropdown trigger="click">
          <button class="user-trigger" type="button">
            <el-avatar :size="28">A</el-avatar>
            <span>管理员</span>
            <el-icon><ArrowDown /></el-icon>
          </button>
          <template #dropdown>
            <el-dropdown-menu>
              <el-dropdown-item>个人中心</el-dropdown-item>
              <el-dropdown-item>账号设置</el-dropdown-item>
              <el-dropdown-item divided>退出登录</el-dropdown-item>
            </el-dropdown-menu>
          </template>
        </el-dropdown>
      </div>
    </el-header>

    <el-container>
      <el-aside :width="isCollapse ? '72px' : '248px'" class="layout-aside">
        <Menu :is-collapse="isCollapse" @toggle-collapse="toggleCollapse" />
      </el-aside>
      <el-main class="layout-main">
        <router-view />
      </el-main>
    </el-container>
  </el-container>
</template>

<script setup>
import { ref } from 'vue'
import { useRoute } from 'vue-router'
import { ArrowDown, Moon, Sunny } from '@element-plus/icons-vue'
import Menu from './menu.vue'
import { useTheme } from '../composables/useTheme'

const route = useRoute()
const isCollapse = ref(false)
const { currentTheme, toggleTheme } = useTheme()

const toggleCollapse = (value) => {
  isCollapse.value = value
}
</script>

<style scoped>
.layout-container {
  min-height: 100vh;
  background: var(--bg-page);
}

.layout-header {
  height: 64px;
  padding: 0 20px;
  border-bottom: 1px solid var(--border-base);
  background: linear-gradient(92deg, var(--bg-header) 0%, var(--bg-header-accent) 100%);
  display: grid;
  grid-template-columns: 280px 1fr auto;
  align-items: center;
  gap: 16px;
}

.header-left {
  display: flex;
  align-items: center;
  gap: 10px;
}

.brand-mark {
  width: 32px;
  height: 32px;
  border-radius: 10px;
  background: var(--brand-gradient);
  color: #fff;
  display: flex;
  align-items: center;
  justify-content: center;
  font-weight: 700;
}

.brand-text {
  display: flex;
  flex-direction: column;
  line-height: 1.1;
}

.brand-text strong {
  font-size: 14px;
  color: var(--text-primary);
}

.brand-text span {
  font-size: 12px;
  color: var(--text-secondary);
}

.header-center :deep(.el-breadcrumb__inner) {
  color: var(--text-secondary);
}

.header-right {
  display: flex;
  align-items: center;
  gap: 10px;
}

.theme-toggle {
  background: var(--bg-elevated);
  border-color: var(--border-base);
  color: var(--text-primary);
}

.user-trigger {
  border: 1px solid var(--border-base);
  background: var(--bg-elevated);
  border-radius: 999px;
  height: 38px;
  padding: 4px 10px 4px 4px;
  display: inline-flex;
  align-items: center;
  gap: 8px;
  color: var(--text-primary);
  cursor: pointer;
}

.user-trigger span {
  font-size: 13px;
  font-weight: 600;
}

.layout-aside {
  border-right: 1px solid var(--border-base);
  background: var(--bg-panel);
  transition: width 0.24s ease;
}

.layout-main {
  background: var(--bg-page);
  padding: 20px;
}

@media (max-width: 992px) {
  .layout-header {
    grid-template-columns: 1fr auto;
  }

  .header-center {
    display: none;
  }
}
</style>
