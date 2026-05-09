<template>
  <el-container class="admin-shell">
    <el-header class="admin-shell__header">
      <div class="admin-shell__brand">
        <div class="brand-avatar">
          <img src="/src/assets/picture/YoyuEN.png" alt="YoyuEN" />
        </div>
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
          :icon="Refresh"
          circle
          @click="handleRefresh"
          title="刷新当前页面"
        />
        <el-button
          class="menu-toggle-mobile"
          :icon="isAsideVisible ? Close : Menu"
          circle
          @click="toggleAside"
        />
        <el-dropdown trigger="click" @command="handleCommand">
          <button class="user-trigger" type="button">
            <img
              :src="userInfo.avatar || '/src/assets/picture/YoyuEN.png'"
              alt="avatar"
              class="user-avatar"
            />
            <span class="user-name">{{ userInfo.username || '管理员' }}</span>
            <el-icon><ArrowDown /></el-icon>
          </button>
          <template #dropdown>
            <el-dropdown-menu class="user-dropdown">
              <el-dropdown-item command="logout">
                <el-icon><SwitchButton /></el-icon>
                退出登录
              </el-dropdown-item>
            </el-dropdown-menu>
          </template>
        </el-dropdown>
      </div>
    </el-header>

    <el-container class="admin-shell__body">
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
          <el-menu-item index="/admin/knowledge">
            <el-icon><Folder /></el-icon>
            <template #title>知识库管理</template>
          </el-menu-item>
          <el-menu-item index="/admin/diary">
            <el-icon><Notebook /></el-icon>
            <template #title>日记管理</template>
          </el-menu-item>
          <el-menu-item index="/admin/profile">
            <el-icon><UserFilled /></el-icon>
            <template #title>个人信息</template>
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
import { useRoute, useRouter } from 'vue-router'
import { ElMessage, ElMessageBox } from 'element-plus'
import { storeToRefs } from 'pinia'
import { useUserStore } from '@/stores/user'
import { isAuthenticated } from '@/utils/auth.js'
import {
  ArrowDown,
  House,
  TrendCharts,
  Document,
  Collection,
  PriceTag,
  ChatDotRound,
  Picture,
  SwitchButton,
  HomeFilled,
  Menu,
  Close,
  Folder,
  Refresh,
  Notebook,
  UserFilled,
} from '@element-plus/icons-vue'
import '../views/admin/admin-theme.css'

const route = useRoute()
const router = useRouter()
const userStore = useUserStore()
const { userInfo, isLoggedIn } = storeToRefs(userStore)

const isAsideVisible = ref(false)
const isMobile = ref(false)

// 获取当前用户信息（优先使用 store 缓存，无缓存则请求）
const fetchUserInfo = async () => {
  // 检查是否已登录
  if (!isAuthenticated()) {
    router.push('/login')
    return
  }

  // 若 store 中已有用户信息，不再重复请求
  if (userInfo.value.username) {
    return
  }

  try {
    await userStore.fetchUserInfo()
  } catch (error) {
    console.error('获取用户信息失败:', error)
  }
}

const handleRefresh = () => {
  // 强制刷新当前路由组件
  const currentPath = route.path
  router.replace({ path: '/admin/refresh' }).then(() => {
    router.replace({ path: currentPath })
  })
}

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
    ElMessageBox.confirm(
      '确定要退出登录吗？',
      '提示',
      {
        confirmButtonText: '确定',
        cancelButtonText: '取消',
        type: 'warning',
      }
    ).then(() => {
      // 通过 Pinia store 清除登录状态
      userStore.logout()
      // 显示提示
      ElMessage.success('已退出登录')
      // 跳转到登录页
      router.push('/login')
    }).catch(() => {
      // 用户取消退出
    })
  }
}

onMounted(() => {
  checkMobile()
  window.addEventListener('resize', checkMobile)
  // 获取用户信息
  fetchUserInfo()
})

onUnmounted(() => {
  window.removeEventListener('resize', checkMobile)
})
</script>
