<template>
  <el-container class="admin-shell">
    <el-header class="admin-shell__header">
      <div class="admin-shell__brand">
        <div class="brand-mark">Y</div>
        <div class="brand-text">
          <strong>YoyuEN Console</strong>
          <span>Personal Studio</span>
        </div>
        <span class="brand-chip">my space</span>
      </div>

      <div class="admin-shell__crumb">
        <el-breadcrumb separator="/">
          <el-breadcrumb-item>后台管理</el-breadcrumb-item>
          <el-breadcrumb-item>{{ route.meta.title || '页面' }}</el-breadcrumb-item>
        </el-breadcrumb>
      </div>

      <div class="admin-shell__actions">
        <el-button
          :icon="currentTheme === 'dark' ? Sunny : Moon"
          class="theme-toggle"
          circle
          @click="toggleTheme"
        />
        <el-button
          class="menu-toggle-mobile"
          :icon="isAsideVisible ? Close : Menu"
          circle
          @click="toggleAside"
        />
        <el-dropdown trigger="click" @command="handleCommand">
          <button class="user-trigger" type="button">
            <el-avatar :size="26">A</el-avatar>
            <span class="user-name">管理员</span>
            <el-icon><ArrowDown /></el-icon>
          </button>
          <template #dropdown>
            <el-dropdown-menu class="user-dropdown">
              <el-dropdown-item command="profile">
                <el-icon><User /></el-icon>
                个人中心
              </el-dropdown-item>
              <el-dropdown-item command="logout" divided>
                <el-icon><SwitchButton /></el-icon>
                退出登录
              </el-dropdown-item>
            </el-dropdown-menu>
          </template>
        </el-dropdown>
      </div>
    </el-header>

    <el-container>
      <el-aside
        width="230px"
        class="admin-shell__aside"
        :class="{ 'aside-mobile-visible': isAsideVisible }"
      >
        <div class="menu-toolbar">
          <span>导航</span>
        </div>

        <el-menu
          :default-active="route.path"
          router
          class="console-menu"
          unique-opened
          @select="handleMenuSelect"
        >
          <el-menu-item index="/admin/dashboard">
            <el-icon><House /></el-icon>
            <template #title>仪表盘</template>
          </el-menu-item>
          <el-menu-item index="/admin/articles">
            <el-icon><Document /></el-icon>
            <template #title>文章管理</template>
          </el-menu-item>
          <el-menu-item index="/admin/categories">
            <el-icon><Collection /></el-icon>
            <template #title>分类管理</template>
          </el-menu-item>
          <el-menu-item index="/admin/tags">
            <el-icon><PriceTag /></el-icon>
            <template #title>标签管理</template>
          </el-menu-item>
          <el-menu-item index="/admin/comments">
            <el-icon><ChatDotRound /></el-icon>
            <template #title>评论管理</template>
          </el-menu-item>
          <el-menu-item index="/admin/photos">
            <el-icon><Picture /></el-icon>
            <template #title>图片管理</template>
          </el-menu-item>
          <el-menu-item index="/admin/statistics">
            <el-icon><TrendCharts /></el-icon>
            <template #title>数据统计</template>
          </el-menu-item>
        </el-menu>

        <div class="admin-footer-link">
          <router-link to="/" @click="handleLinkClick">
            <el-icon><HomeFilled /></el-icon>
            <span>返回客户端</span>
          </router-link>
        </div>
      </el-aside>

      <div
        v-if="isAsideVisible && isMobile"
        class="aside-overlay"
        @click="toggleAside"
      />

      <el-main class="admin-shell__main">
        <div class="admin-content">
          <router-view />
        </div>
      </el-main>
    </el-container>
  </el-container>
</template>

<script setup>
import { ref, onMounted, onUnmounted } from 'vue'
import { useRoute } from 'vue-router'
import {
  ArrowDown,
  House,
  Moon,
  Sunny,
  TrendCharts,
  Document,
  Collection,
  PriceTag,
  ChatDotRound,
  Picture,
  User,
  SwitchButton,
  HomeFilled,
  Menu,
  Close,
} from '@element-plus/icons-vue'
import { useTheme } from '../composables/useTheme'
import '../views/admin/admin-theme.css'

const route = useRoute()
const isAsideVisible = ref(false)
const isMobile = ref(false)
const { currentTheme, toggleTheme } = useTheme()

const checkMobile = () => {
  isMobile.value = window.innerWidth < 768
  if (!isMobile.value) {
    isAsideVisible.value = false
  }
}

const toggleAside = () => {
  isAsideVisible.value = !isAsideVisible.value
}

const handleMenuSelect = () => {
  if (isMobile.value) {
    isAsideVisible.value = false
  }
}

const handleLinkClick = () => {
  if (isMobile.value) {
    isAsideVisible.value = false
  }
}

const handleCommand = (command) => {
  if (command === 'logout') {
    console.log('退出登录')
  } else if (command === 'profile') {
    console.log('个人中心')
  }
}

onMounted(() => {
  checkMobile()
  window.addEventListener('resize', checkMobile)
})

onUnmounted(() => {
  window.removeEventListener('resize', checkMobile)
})
</script>
