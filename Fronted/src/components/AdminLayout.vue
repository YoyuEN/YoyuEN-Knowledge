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
        <el-dropdown trigger="click">
          <button class="user-trigger" type="button">
            <el-avatar :size="26">A</el-avatar>
            <span>管理员</span>
            <el-icon><ArrowDown /></el-icon>
          </button>
          <template #dropdown>
            <el-dropdown-menu>
              <el-dropdown-item>个人中心</el-dropdown-item>
              <el-dropdown-item divided>退出登录</el-dropdown-item>
            </el-dropdown-menu>
          </template>
        </el-dropdown>
      </div>
    </el-header>

    <el-container>
      <el-aside :width="isCollapse ? '68px' : '230px'" class="admin-shell__aside">
        <div class="menu-toolbar" :class="{ collapsed: isCollapse }">
          <el-button :icon="isCollapse ? Expand : Fold" text circle @click="toggleCollapse" />
          <span v-if="!isCollapse">导航</span>
        </div>

        <el-menu :default-active="route.path" :collapse="isCollapse" router class="console-menu" unique-opened>
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
          <router-link to="/">返回客户端</router-link>
        </div>
      </el-aside>

      <el-main class="admin-shell__main">
        <div class="admin-content">
          <router-view />
        </div>
      </el-main>
    </el-container>
  </el-container>
</template>

<script setup>
import { ref } from 'vue'
import { useRoute } from 'vue-router'
import {
  ArrowDown,
  Expand,
  Fold,
  House,
  Moon,
  Sunny,
  TrendCharts,
  Document,
  Collection,
  PriceTag,
  ChatDotRound,
  Picture,
} from '@element-plus/icons-vue'
import { useTheme } from '../composables/useTheme'
import '../views/admin/admin-theme.css'

const route = useRoute()
const isCollapse = ref(false)
const { currentTheme, toggleTheme } = useTheme()

const toggleCollapse = () => {
  isCollapse.value = !isCollapse.value
}
</script>
