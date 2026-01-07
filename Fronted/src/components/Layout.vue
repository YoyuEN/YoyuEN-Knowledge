<template>
  <el-container class="layout-container">
    <!-- 头部 -->
    <el-header class="layout-header">
      <div class="header-left">
        <h2 class="logo">YoyuEN</h2>
      </div>
      <div class="header-center">
        <el-input
          v-if="showDrawer"
          placeholder="搜索..."
          class="search-input"
          size="small"
          clearable
          v-model="searchQuery"
          @input="handleSearchInput"
          @focus="handleSearchFocus"
          @blur="handleSearchBlur"
        >
          <template #prefix>
            <el-icon class="search-icon"><Search /></el-icon>
          </template>
        </el-input>
      </div>
      <div class="header-right">
        <el-button
          :icon="currentTheme === 'dark' ? Sunny : Moon"
          @click="toggleTheme"
          circle
          class="theme-toggle"
          :title="currentTheme === 'dark' ? '切换到浅色主题' : '切换到深色主题'"
        />
        <el-button
          :icon="showDrawer ? Close : MenuIcon"
          circle
          class="menu-button"
          :title="showDrawer ? '关闭菜单' : '打开菜单'"
          @click="showDrawer = !showDrawer"
        />
      </div>
    </el-header>

    <!-- 主内容区 -->
    <el-main class="layout-main">
      <router-view />
    </el-main>

    <!-- 自定义菜单面板 -->
    <transition name="menu-overlay">
      <div v-show="showDrawer" class="menu-overlay">
        <transition name="menu-panel">
          <div v-show="showDrawer" class="menu-panel">
            <div class="menu-content">
              <!-- 左侧日历区域 -->
              <div class="calendar-section">
                <div class="section-header">
                  <el-icon><Calendar /></el-icon>
                  <h4>日历</h4>
                </div>
                <div class="calendar-widget">
                  <div class="current-date">{{ formatDate(currentTime) }}</div>
                  <div class="current-time">{{ formatTime(currentTime) }}</div>
                  <div class="calendar-decoration">
                    <div class="decoration-line"></div>
                    <div class="decoration-dot"></div>
                  </div>
                  <div class="daily-quote" v-if="dailyQuote">
                    <div class="quote-text">{{ dailyQuote }}</div>
                    <div class="quote-source" v-if="dailyQuoteSource">{{ dailyQuoteSource }}</div>
                  </div>
                </div>
              </div>
              
              <!-- 中间最新文章区域 -->
              <div class="latest-articles">
                <div class="section-header">
                  <el-icon><Document /></el-icon>
                  <h4>最新更新</h4>
                </div>
                <div class="articles-list">
                  <div class="article-item" v-for="i in 5" :key="i">
                    <div class="article-info">
                      <div class="article-title">文章标题 {{ i }}</div>
                      <div class="article-meta">
                        <span class="article-category">分类 {{ i }}</span>
                        <span class="article-date">2026-01-0{{ i }}</span>
                      </div>
                    </div>
                  </div>
                </div>
              </div>
              
              <!-- 右侧界面导航 -->
              <div class="interface-nav">
                <div class="section-header">
                  <el-icon><House /></el-icon>
                  <h4>界面导航</h4>
                </div>
                <div class="nav-menu">
                  <Menu @menu-item-click="handleMenuItemClick" />
                </div>
              </div>
            </div>
          </div>
        </transition>
      </div>
    </transition>
  </el-container>
</template>

<script setup>
import { ref, onMounted, onUnmounted } from 'vue'
import { useRouter, useRoute } from 'vue-router'
import Menu from './menu.vue'
import { Menu as MenuIcon, Sunny, Moon, House, Document, Setting, User, Close, Message, Bell, Search, Calendar, Clock } from '@element-plus/icons-vue'
import { useTheme } from '../composables/useTheme'

const router = useRouter()
const route = useRoute()
const { currentTheme, toggleTheme, initTheme } = useTheme()
const isCollapse = ref(false)
const showDrawer = ref(false)
const searchQuery = ref('')
const searchFocused = ref(false)
const currentTime = ref(new Date())
const dailyQuote = ref('')
const dailyQuoteSource = ref('')
let timeInterval = null

const handleSearchInput = () => {
}

const handleSearchFocus = () => {
  searchFocused.value = true
}

const handleSearchBlur = () => {
  searchFocused.value = false
}

const toggleCollapse = (value) => {
  isCollapse.value = value
}

const handleMenuItemClick = () => {
  showDrawer.value = false
}

const formatTime = (date) => {
  const hours = String(date.getHours()).padStart(2, '0')
  const minutes = String(date.getMinutes()).padStart(2, '0')
  const seconds = String(date.getSeconds()).padStart(2, '0')
  return `${hours}:${minutes}:${seconds}`
}

const formatDate = (date) => {
  const year = date.getFullYear()
  const month = String(date.getMonth() + 1).padStart(2, '0')
  const day = String(date.getDate()).padStart(2, '0')
  const weekDays = ['周日', '周一', '周二', '周三', '周四', '周五', '周六']
  const weekDay = weekDays[date.getDay()]
  return `${year}年${month}月${day}日 ${weekDay}`
}

const fetchDailyQuote = async () => {
  try {
    const response = await fetch('https://api.xygeng.cn/one')
    const data = await response.json()
    if (data.code === 200) {
      dailyQuote.value = data.data.content
      dailyQuoteSource.value = `—— ${data.data.origin}`
    }
  } catch (error) {
    dailyQuote.value = '今天又是美好的一天'
    dailyQuoteSource.value = ''
  }
}

onMounted(() => {
  initTheme()
  timeInterval = setInterval(() => {
    currentTime.value = new Date()
  }, 1000)
  fetchDailyQuote()
})

onUnmounted(() => {
  if (timeInterval) {
    clearInterval(timeInterval)
  }
})
</script>

<style scoped>
.layout-container {
  height: 100vh;
  display: flex;
  flex-direction: column;
  
}

.layout-header {
  position: fixed;
  top: 0;
  left: 0;
  right: 0;
  z-index: 1000;
  color: var(--text-primary);
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 0 20px;
  transition: background-color 0.3s, color 0.3s;
  --el-header-height: 60px;
  height: var(--el-header-height);
  backdrop-filter: blur(20px);
  -webkit-backdrop-filter: blur(20px);
  background-color: rgba(255, 255, 255, 0.75);
  border-bottom: 1px solid var(--border-color);
  border-radius: 8px;
  margin: 5px 16px;
  width: calc(100% - 32px);
}

html.dark .layout-header {
  background-color: rgba(36, 36, 36, 0.75);
}

.header-left {
  flex: 0 0 auto;
}

.header-left .logo {
  margin: 0;
  font-size: 20px;
  font-weight: 600;
}

.header-center {
  flex: 1;
  display: flex;
  justify-content: center;
  align-items: center;
  max-width: 400px;
  margin: 0 20px;
  position: relative;
}

/* 美化搜索框样式 */
.search-input {
  width: 100%;
  max-width: 100%;
  border-radius: 25px !important;
  transition: all 0.3s ease;
  background-color: var(--bg-secondary) !important;
  border: 2px solid transparent !important;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.08) !important;
  font-size: 14px;
  overflow: hidden;
}

/* 覆盖Element Plus默认样式 */
.search-input :deep(.el-input__wrapper) {
  width: 100% !important;
  border-radius: 25px !important;
  background-color: var(--bg-secondary) !important;
  border: 2px solid transparent !important;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.08) !important;
  padding: 8px 16px !important;
  transition: all 0.3s ease !important;
}

/* 搜索框聚焦状态 */
.search-input:focus-within :deep(.el-input__wrapper) {
  background-color: var(--bg-primary) !important;
  border-color: var(--primary-color) !important;
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.12), 0 0 0 3px rgba(5, 145, 255, 0.1) !important;
  transform: translateY(-1px) !important;
}

/* 搜索图标样式 */
.search-icon {
  color: var(--text-tertiary) !important;
  transition: all 0.3s ease !important;
  font-size: 16px !important;
}

.search-input:focus-within .search-icon {
  color: var(--primary-color) !important;
}

/* 搜索框输入文字样式 */
.search-input :deep(.el-input__inner) {
  color: var(--text-primary) !important;
  background-color: transparent !important;
  border: none !important;
  box-shadow: none !important;
  padding: 0 !important;
  margin: 0 !important;
  font-size: 14px !important;
}

.search-input :deep(.el-input__inner::placeholder) {
  color: var(--text-tertiary) !important;
  font-size: 13px !important;
}

/* 搜索框清除按钮样式 */
.search-input :deep(.el-input__clear) {
  color: var(--text-tertiary) !important;
  font-size: 14px !important;
  transition: all 0.3s ease !important;
}

.search-input:focus-within :deep(.el-input__clear) {
  color: var(--text-secondary) !important;
}

/* 搜索框前缀图标样式 */
.search-input :deep(.el-input__prefix) {
  left: 10px !important;
  color: var(--text-tertiary) !important;
}

.search-input:focus-within :deep(.el-input__prefix) {
  color: var(--primary-color) !important;
}

/* 确保搜索框内部元素正确显示 */
.search-input :deep(.el-input__inner-wrapper) {
  background-color: transparent !important;
}

/* 移除Element Plus默认的边框和阴影 */
.search-input :deep(.el-input__wrapper.is-focus) {
  box-shadow: none !important;
}

.search-input :deep(.el-input__wrapper:hover) {
  border-color: var(--border-color) !important;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.08) !important;
}

/* 动画效果 */
.search-input {
  animation: slideIn 0.3s ease-out forwards;
}

@keyframes slideIn {
  from {
    opacity: 0;
    transform: translateY(-10px) scale(0.95);
  }
  to {
    opacity: 1;
    transform: translateY(0) scale(1);
  }
}

/* 响应式设计 */
@media (max-width: 768px) {
  .header-center {
    max-width: 200px;
    margin: 0 10px;
  }
  
  .search-input {
    font-size: 13px;
    padding: 6px 12px;
  }
}

.header-right {
  display: flex;
  align-items: center;
  gap: 12px;
  flex: 0 0 auto;
}

.theme-toggle {
  background-color: var(--el-button-bg-color);
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
  padding: 20px;
  overflow-y: auto;
  transition: background-color 0.3s;
  margin-top: 60px;
}

.layout-main::-webkit-scrollbar {
  width: 0;
  height: 0;
}

.layout-main::-webkit-scrollbar-track {
  background: transparent;
}

.layout-main::-webkit-scrollbar-thumb {
  background: transparent;
}

.layout-main::-webkit-scrollbar-thumb:hover {
  background: transparent;
}

/* 自定义菜单面板样式 */
.menu-overlay {
  position: fixed;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  z-index: 999;
  background-color: rgba(0, 0, 0, 0.5);
}

.menu-overlay-enter-active,
.menu-overlay-leave-active {
  transition: opacity 0.3s ease, visibility 0.3s ease;
}

.menu-overlay-enter-from,
.menu-overlay-leave-to {
  opacity: 0;
  visibility: hidden;
}

.menu-panel {
  position: fixed;
  top: 60px; /* 与顶部导航栏高度一致 */
  right: 0;
  width: 100%;
  height: calc(100vh - 60px); /* 从导航栏下方到页面底部 */
  box-shadow: -2px 0 10px rgba(0, 0, 0, 0.1);
  overflow-y: auto;
  z-index: 999; /* 确保菜单面板在头部下方 */
  backdrop-filter: blur(10px);
}

.menu-panel-enter-active,
.menu-panel-leave-active {
  transition: transform 0.3s ease-out;
}

.menu-panel-enter-from,
.menu-panel-leave-to {
  transform: translateY(-100%);
}

.menu-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 16px 20px;
  border-bottom: 1px solid var(--border-color);
}

.menu-header h3 {
  margin: 0;
  font-size: 18px;
  font-weight: 600;
  color: var(--text-primary);
}

.close-btn {
  color: var(--text-primary);
  font-size: 20px;
}

.menu-content {
  display: flex;
  height: calc(100% - 30px);
  overflow: hidden;
  border-radius: 8px;
  margin: 15px;
  backdrop-filter: blur(10px);
  background-color: var(--menu-panel-bg);
}

.calendar-section {
  flex: 1;
  border-right: 1px solid var(--border-color);
  padding: 20px;
  overflow-y: auto;
}

.section-header {
  display: flex;
  align-items: center;
  gap: 8px;
  margin-bottom: 20px;
  padding-bottom: 12px;
  border-bottom: 1px solid var(--border-color);
}

.section-header h4 {
  margin: 0;
  font-size: 16px;
  font-weight: 600;
  color: var(--text-primary);
}

.calendar-widget {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  padding: 24px;
  background: linear-gradient(135deg, var(--calendar-bg) 0%, var(--panel-section-bg) 100%);
  border-radius: 12px;
  box-shadow: 0 4px 12px var(--shadow);
}

.current-date {
  font-size: 18px;
  color: var(--calendar-text);
  font-weight: 500;
  margin-bottom: 8px;
}

.current-time {
  font-size: 36px;
  font-weight: 700;
  color: var(--calendar-text);
  font-family: 'Courier New', monospace;
  letter-spacing: 2px;
}

.calendar-decoration {
  display: flex;
  align-items: center;
  gap: 8px;
  margin-top: 16px;
  width: 100%;
  max-width: 160px;
}

.decoration-line {
  flex: 1;
  height: 2px;
  background: linear-gradient(90deg, transparent, var(--border-color), transparent);
}

.decoration-dot {
  width: 6px;
  height: 6px;
  border-radius: 50%;
  background-color: var(--icon-primary);
}

.daily-quote {
  margin-top: 20px;
  padding-top: 16px;
  border-top: 1px dashed var(--border-color);
  text-align: center;
  width: 100%;
}

.quote-text {
  font-size: 14px;
  color: var(--calendar-text);
  line-height: 1.6;
  font-style: italic;
  margin-bottom: 6px;
}

.quote-source {
  font-size: 12px;
  color: var(--text-tertiary);
}

.latest-articles {
  flex: 1.2;
  border-right: 1px solid var(--border-color);
  padding: 20px;
  overflow-y: auto;
}

.articles-list {
  display: flex;
  flex-direction: column;
  gap: 12px;
}

.article-item {
  padding: 14px;
  border-radius: 10px;
  background-color: var(--panel-section-bg);
  transition: all 0.3s ease;
  cursor: pointer;
  border: 1px solid transparent;
}

.article-item:hover {
  background-color: var(--hover-bg);
  border-color: var(--border-color);
  transform: translateX(4px);
}

.article-info {
  display: flex;
  flex-direction: column;
  gap: 6px;
}

.article-title {
  font-size: 14px;
  font-weight: 600;
  color: var(--article-title);
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
}

.article-meta {
  display: flex;
  justify-content: space-between;
  align-items: center;
  font-size: 12px;
}

.article-category {
  padding: 3px 8px;
  background-color: var(--primary-color);
  color: var(--text-primary);
  border-radius: 4px;
  font-size: 11px;
}

.article-date {
  color: var(--article-date);
}

/* 右侧界面导航样式 */
.interface-nav {
  flex: 1;
  padding: 20px;
  overflow-y: auto;
}

.nav-menu {
  margin-top: 20px;
}

.menu-list {
  border-right: none;
  background-color: transparent;
}

.menu-list .el-menu-item {
  height: 60px;
  line-height: 60px;
  font-size: 16px;
  color: var(--text-primary);
  transition: background-color 0.3s;
}

.menu-list .el-menu-item:hover {
  background-color: var(--hover-bg);
}

.menu-list .el-menu-item.is-active {
  background-color: var(--primary-color);
  color: white;
}
</style>
