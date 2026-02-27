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
              <!-- 上方三个区域 -->
              <div class="top-sections">
                <!-- 左侧日历区域 -->
                <div class="calendar-section">
                  <div class="section-card">
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
                </div>

                <!-- 中间最新文章区域 -->
                <div class="latest-articles">
                  <div class="section-card">
                    <div
                      class="timeline-item"
                      v-for="article in latestArticles"
                      :key="article.id"
                      @click="goToArticle(article.id)"
                    >
                      <div class="timeline-dot"></div>
                      <div class="timeline-content">
                        <div class="timeline-date">{{ article.createTime }}</div>
                        <div class="timeline-title">{{ article.title }}</div>
                      </div>
                    </div>
                  </div>
                </div>

                <!-- 右侧界面导航 -->
                <div class="interface-nav">
                  <div class="section-card">
                      <Menu @menu-item-click="handleMenuItemClick" />
                  </div>
                </div>
              </div>

              <!-- 用户评论区域 -->
              <div class="user-comments">
                <div class="comments-grid">
                  <div class="comment-card" v-for="comment in userComments" :key="comment.id">
                    <div class="card-top">
                      <div class="comment-avatar">
                        <img :src="comment.avatar" :alt="comment.nickname" />
                      </div>
                      <div class="comment-info">
                        <div class="comment-nickname">{{ comment.nickname }}</div>
                        <div class="comment-time">{{ comment.time }}</div>
                      </div>
                    </div>
                    <div class="comment-text">{{ comment.content }}</div>
                  </div>
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
import { fetchContentByCategory } from '../api/content/content.js'

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
const latestArticles = ref([])
let timeInterval = null

const userComments = ref([
  {
    id: 1,
    avatar: new URL('../assets/picture/YoyuEN.png', import.meta.url).href,
    nickname: '张三',
    time: '2小时前',
    content: '这个网站设计得真不错，界面很清爽，内容也很有深度！'
  },
  {
    id: 2,
    avatar: new URL('../assets/picture/YoyuEN.png', import.meta.url).href,
    nickname: '李四',
    time: '5小时前',
    content: '学到了很多东西，感谢分享！期待更多优质内容。'
  },
  {
    id: 3,
    avatar: new URL('../assets/picture/YoyuEN.png', import.meta.url).href,
    nickname: '王五',
    time: '1天前',
    content: '文章写得很详细，对我帮助很大，已经收藏了！'
  }
])

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

const goToArticle = (id) => {
  showDrawer.value = false
  router.push(`/content-detail/article/${id}`)
}

const fetchLatestArticles = async () => {
  try {
    const res = await fetchContentByCategory('article')
    latestArticles.value = (res.data || []).slice(0, 5)
  } catch (e) {
    console.error('获取最新文章失败', e)
  }
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
  fetchLatestArticles()
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
  border: 1px solid var(--border-color);
  border-radius: 8px;
  margin: 5px 25px;
  width: calc(100% - 50px);
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
  padding: 0;
  overflow-y: auto;
  transition: background-color 0.3s;
  /* margin-top: 60px; */
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
  flex-direction: column;
  height: calc(100% - 30px);
  overflow: hidden;
  border-radius: 8px;
  margin: 15px 25px;
  backdrop-filter: blur(10px);
  background-color: var(--menu-panel-bg);
}

/* 上方三个区域的容器 */
.top-sections {
  display: flex;
  max-height: 400px;
  overflow: hidden;
  border-bottom: 1px solid var(--border-color);
}

.calendar-section {
  flex: 1;
  border-right: 1px solid var(--border-color);
  padding: 20px;
  overflow: hidden;
}

/* 统一的卡片样式 */
.section-card {
  background-color: var(--panel-section-bg);
  border-radius: 12px;
  padding: 20px;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.05);
  height: 100%;
  overflow-y: auto;
  display: flex;
  flex-direction: column;
}

/* 卡片滚动条样式 */
.section-card::-webkit-scrollbar {
  width: 6px;
}

.section-card::-webkit-scrollbar-track {
  background: transparent;
  border-radius: 3px;
}

.section-card::-webkit-scrollbar-thumb {
  background: var(--border-color);
  border-radius: 3px;
  transition: background 0.3s ease;
}

.section-card::-webkit-scrollbar-thumb:hover {
  background: var(--text-tertiary);
}

.calendar-widget {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  padding: 24px;
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
  overflow: hidden;
}

.timeline-item {
  position: relative;
  padding-left: 30px;
  padding-bottom: 20px;
  border-left: 2px solid var(--border-color);
}

.timeline-item:last-child {
  padding-bottom: 0;
  border-left: 2px solid transparent;
}

.timeline-dot {
  position: absolute;
  left: -6px;
  top: 6px;
  width: 10px;
  height: 10px;
  border-radius: 50%;
  background-color: var(--primary-color);
  border: 2px solid var(--bg-primary);
  transition: all 0.3s ease;
}

.timeline-item:hover .timeline-dot {
  transform: scale(1.3);
  box-shadow: 0 0 0 4px rgba(5, 145, 255, 0.1);
}

.timeline-content {
  display: flex;
  flex-direction: column;
  gap: 6px;
  cursor: pointer;
  transition: all 0.3s ease;
}

.timeline-content:hover {
  transform: translateX(4px);
}

.timeline-date {
  font-size: 11px;
  color: var(--text-tertiary);
  font-weight: 500;
}

.timeline-title {
  font-size: 14px;
  font-weight: 600;
  color: var(--text-primary);
  line-height: 1.4;
  transition: color 0.3s ease;
}

.timeline-content:hover .timeline-title {
  color: var(--primary-color);
}

/* 右侧界面导航样式 */
.interface-nav {
  flex: 1;
  padding: 20px;
  overflow: hidden;
}

.interface-nav .section-card {
  overflow-y: auto;
  display: flex;
  flex-direction: column;
}

.interface-nav .section-card::-webkit-scrollbar {
  width: 6px;
}

.interface-nav .section-card::-webkit-scrollbar-track {
  background: transparent;
  border-radius: 3px;
}

.interface-nav .section-card::-webkit-scrollbar-thumb {
  background: var(--border-color);
  border-radius: 3px;
  transition: background 0.3s ease;
}

.interface-nav .section-card::-webkit-scrollbar-thumb:hover {
  background: var(--text-tertiary);
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

/* 用户留言区域样式 */
.user-comments {
  flex: 1;
  padding: 20px;
  overflow-y: auto;
}

.comments-grid {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(200px, 1fr));
  gap: 16px;
  margin-top: 20px;
}

.comment-card {
  padding: 16px;
  border-radius: 12px;
  background-color: var(--panel-section-bg);
  transition: all 0.3s ease;
  border: 1px solid transparent;
  display: flex;
  flex-direction: column;
  gap: 12px;
}

.comment-card:hover {
  background-color: var(--hover-bg);
  border-color: var(--border-color);
  transform: translateY(-4px);
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
}

.card-top {
  display: flex;
  align-items: center;
  gap: 10px;
}

.comment-avatar {
  width: 36px;
  height: 36px;
  border-radius: 50%;
  overflow: hidden;
  flex-shrink: 0;
  border: 2px solid var(--border-color);
}

.comment-avatar img {
  width: 100%;
  height: 100%;
  object-fit: cover;
}

.comment-info {
  flex: 1;
  display: flex;
  flex-direction: column;
  gap: 4px;
  min-width: 0;
}

.comment-nickname {
  font-size: 13px;
  font-weight: 600;
  color: var(--text-primary);
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
}

.comment-time {
  font-size: 11px;
  color: var(--text-tertiary);
}

.comment-text {
  font-size: 13px;
  color: var(--text-secondary);
  line-height: 1.6;
  overflow: hidden;
  text-overflow: ellipsis;
  display: -webkit-box;
  -webkit-line-clamp: 2;
  line-clamp: 2;
  -webkit-box-orient: vertical;
}
</style>
