<template>
  <div class="home-container">
    <el-card class="welcome-card">
      <div class="welcome-content">
        <el-icon class="welcome-icon"><Document /></el-icon>
        <h1>欢迎回来！</h1>
        <p>这是一个功能完善的知识管理系统，您可以在这里管理文章、分类、标签等信息。</p>
      </div>
    </el-card>

    <el-row :gutter="20" class="stats-row">
      <el-col :span="6">
        <el-card class="stat-card">
          <div class="stat-content">
            <div class="stat-icon blue">
              <el-icon><Document /></el-icon>
            </div>
            <div class="stat-info">
              <div class="stat-value">128</div>
              <div class="stat-label">文章总数</div>
            </div>
          </div>
        </el-card>
      </el-col>
      <el-col :span="6">
        <el-card class="stat-card">
          <div class="stat-content">
            <div class="stat-icon green">
              <el-icon><Folder /></el-icon>
            </div>
            <div class="stat-info">
              <div class="stat-value">24</div>
              <div class="stat-label">分类数量</div>
            </div>
          </div>
        </el-card>
      </el-col>
      <el-col :span="6">
        <el-card class="stat-card">
          <div class="stat-content">
            <div class="stat-icon orange">
              <el-icon><PriceTag /></el-icon>
            </div>
            <div class="stat-info">
              <div class="stat-value">56</div>
              <div class="stat-label">标签数量</div>
            </div>
          </div>
        </el-card>
      </el-col>
      <el-col :span="6">
        <el-card class="stat-card">
          <div class="stat-content">
            <div class="stat-icon purple">
              <el-icon><User /></el-icon>
            </div>
            <div class="stat-info">
              <div class="stat-value">12</div>
              <div class="stat-label">用户数量</div>
            </div>
          </div>
        </el-card>
      </el-col>
    </el-row>
  </div>
</template>

<script setup>
import { ref } from 'vue'
import {
  Document,
  Folder,
  PriceTag,
  User,
  Plus,
  DataAnalysis,
} from '@element-plus/icons-vue'

const recentArticles = ref([
  {
    title: 'Vue 3 新特性详解',
    category: '前端开发',
    date: '2024-01-15',
  },
  {
    title: 'Element Plus 使用指南',
    category: 'UI框架',
    date: '2024-01-14',
  },
  {
    title: 'TypeScript 最佳实践',
    category: '编程语言',
    date: '2024-01-13',
  },
])
</script>

<style scoped>
.home-container {
  padding: 0;
}

.welcome-card {
  margin-bottom: 20px;
  background-color: var(--card-bg);
  border-color: var(--border-color);
  transition: background-color 0.3s, border-color 0.3s;
}

.card-header {
  font-weight: 600;
  font-size: 16px;
  color: var(--text-primary);
}

.welcome-content {
  text-align: center;
  padding: 40px 20px;
}

.welcome-icon {
  font-size: 80px;
  color: var(--icon-primary);
  margin-bottom: 20px;
  transition: color 0.3s;
}

.welcome-content h1 {
  font-size: 32px;
  margin: 20px 0;
  color: var(--text-primary);
  transition: color 0.3s;
}

.welcome-content p {
  font-size: 16px;
  color: var(--text-secondary);
  line-height: 1.6;
  transition: color 0.3s;
}

.stats-row {
  margin-bottom: 20px;
}

.stat-card {
  cursor: pointer;
  transition: transform 0.3s, box-shadow 0.3s;
  background-color: var(--card-bg);
  border-color: var(--border-color);
}

.stat-card:hover {
  transform: translateY(-5px);
  box-shadow: 0 4px 12px var(--shadow-hover);
}

.stat-content {
  display: flex;
  align-items: center;
  gap: 20px;
}

.stat-icon {
  width: 60px;
  height: 60px;
  border-radius: 12px;
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 28px;
  color: white;
}

/* 浅色主题下的图标颜色 */
.light-theme .stat-icon.blue {
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
}

.light-theme .stat-icon.green {
  background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%);
}

.light-theme .stat-icon.orange {
  background: linear-gradient(135deg, #4facfe 0%, #00f2fe 100%);
}

.light-theme .stat-icon.purple {
  background: linear-gradient(135deg, #43e97b 0%, #38f9d7 100%);
}

/* 深色主题下的图标颜色 - 使用黑白灰 */
.dark-theme .stat-icon.blue,
.dark-theme .stat-icon.green,
.dark-theme .stat-icon.orange,
.dark-theme .stat-icon.purple {
  background: #000000;
}

.stat-info {
  flex: 1;
}

.stat-value {
  font-size: 32px;
  font-weight: bold;
  color: var(--text-primary);
  margin-bottom: 5px;
  transition: color 0.3s;
}

.stat-label {
  font-size: 14px;
  color: var(--text-tertiary);
  transition: color 0.3s;
}

.content-row {
  margin-bottom: 20px;
}

.quick-actions {
  display: flex;
  flex-direction: column;
  gap: 15px;
}

.quick-actions .el-button {
  width: 100%;
  height: 50px;
  font-size: 16px;
}
</style>