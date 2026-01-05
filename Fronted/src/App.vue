<template>
  <Layout />
</template>

<script setup>
import Layout from './components/Layout.vue'
import { useTheme } from './composables/useTheme'

// 立即初始化主题，避免闪烁
const { initTheme } = useTheme()
initTheme()
</script>

<style>
* {
  margin: 0;
  padding: 0;
  box-sizing: border-box;
}

body {
  margin: 0;
  padding: 0;
}

#app {
  width: 100%;
  height: 100vh;
}

/* 浅色主题 CSS 变量 */
:root {
  --bg-primary: #ffffff;
  --bg-secondary: #f5f5f5;
  --bg-header: #ffffff;
  --bg-aside: #ffffff;
  --text-primary: #303133;
  --text-secondary: #606266;
  --text-tertiary: #909399;
  --text-inverse: #ffffff;
  --border-color: #e4e7ed;
  --shadow: rgba(0, 0, 0, 0.1);
  --shadow-hover: rgba(0, 0, 0, 0.15);
  --icon-primary: #409eff;
  --card-bg: #ffffff;
  --hover-bg: #f5f5f5;
  --menu-panel-bg: rgba(255, 255, 255, 0.85);
  --diary-page-bg: #ffffff;
  --diary-border-color: rgba(0, 0, 0, 0.1);
  --diary-text-color: #333;
  --diary-content-color: #444;
  --panel-section-bg: rgba(255, 255, 255, 0.6);
  --calendar-bg: #ffffff;
  --calendar-text: #333;
  --article-title: #303133;
  --article-date: #909399;
}

/* 深色主题 CSS 变量 */
.dark-theme {
  --bg-primary: #1a1a1a;
  --bg-secondary: #0d0d0d;
  --bg-header: #000000;
  --bg-aside: #1a1a1a;
  --text-primary: #ffffff;
  --text-secondary: #e4e7ed;
  --text-tertiary: #a8abb2;
  --text-inverse: #000000;
  --border-color: #3a3a3a;
  --shadow: rgba(0, 0, 0, 0.5);
  --shadow-hover: rgba(0, 0, 0, 0.7);
  --icon-primary: #ffffff;
  --card-bg: #242424;
  --hover-bg: #2d2d2d;
  --menu-panel-bg: rgba(0, 0, 0, 0.85);
  --diary-page-bg: #2d2d2d;
  --diary-border-color: rgba(255, 255, 255, 0.1);
  --diary-text-color: #ffffff;
  --diary-content-color: #e4e7ed;
  --panel-section-bg: rgba(45, 45, 45, 0.6);
  --calendar-bg: #2d2d2d;
  --calendar-text: #ffffff;
  --article-title: #ffffff;
  --article-date: #a8abb2;
}

/* 确保主题变量应用到整个应用 */
body {
  background-image: url('./assets/pciture/image.png');
  background-size: cover;
  background-position: center;
  background-repeat: no-repeat;
  background-attachment: fixed;
  color: var(--text-primary);
  transition: background-color 0.3s, color 0.3s;
}

/* Element Plus 组件主题适配 */
.el-card {
  background-color: var(--card-bg);
  border-color: var(--border-color);
  color: var(--text-primary);
  transition: background-color 0.3s, border-color 0.3s, color 0.3s;
}

.el-card__header {
  border-bottom-color: var(--border-color);
  color: var(--text-primary);
}

.el-menu {
  background-color: var(--bg-aside);
  border-color: var(--border-color);
  transition: background-color 0.3s, border-color 0.3s;
}

.el-menu-item {
  color: var(--text-primary);
  transition: background-color 0.3s, color 0.3s;
}

.el-menu-item:hover {
  background-color: var(--hover-bg) !important;
  color: var(--text-primary) !important;
}

.el-menu-item.is-active {
  color: var(--text-primary) !important;
  background-color: var(--hover-bg) !important;
}

.el-menu-item.is-active::before {
  background-color: var(--text-primary);
}

.el-menu-item [class^="el-icon"] {
  color: var(--text-primary);
  transition: color 0.3s;
}

.el-sub-menu__title {
  color: var(--text-primary);
  transition: background-color 0.3s, color 0.3s;
}

.el-sub-menu__title:hover {
  background-color: var(--hover-bg) !important;
  color: var(--text-primary) !important;
}

.el-sub-menu__title [class^="el-icon"] {
  color: var(--text-primary);
  transition: color 0.3s;
}

.el-sub-menu .el-menu {
  background-color: var(--bg-aside);
}

.el-sub-menu .el-menu-item {
  color: var(--text-secondary);
  background-color: var(--bg-aside);
}

.el-sub-menu .el-menu-item:hover {
  background-color: var(--hover-bg) !important;
  color: var(--text-primary) !important;
}

.el-sub-menu .el-menu-item.is-active {
  color: var(--text-primary) !important;
  background-color: var(--hover-bg) !important;
}

.el-menu--collapse .el-menu-item,
.el-menu--collapse .el-sub-menu__title {
  color: var(--text-primary);
}

.el-sub-menu__icon-arrow {
  color: var(--text-primary) !important;
  transition: color 0.3s;
}

.el-sub-menu.is-opened > .el-sub-menu__title .el-sub-menu__icon-arrow {
  color: var(--text-primary) !important;
}

.el-table {
  background-color: var(--card-bg);
  color: var(--text-primary);
}

.el-table th {
  background-color: var(--card-bg);
  color: var(--text-primary);
  border-bottom-color: var(--border-color);
}

.el-table td {
  border-bottom-color: var(--border-color);
  color: var(--text-primary);
}

.el-table--border {
  border-color: var(--border-color);
}

.el-table--border th,
.el-table--border td {
  border-right-color: var(--border-color);
}

.el-table tr {
  background-color: var(--card-bg);
}

.el-table tr:hover {
  background-color: var(--hover-bg);
}

.el-dropdown-menu {
  background-color: var(--card-bg);
  border-color: var(--border-color);
}

.el-dropdown-menu__item {
  color: var(--text-primary);
}

.el-dropdown-menu__item:hover {
  background-color: var(--hover-bg);
  color: var(--text-primary);
}
</style>
