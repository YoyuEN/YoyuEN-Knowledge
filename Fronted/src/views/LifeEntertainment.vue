<template>
  <div class="life-entertainment-container">
    <div class="sub-nav">
      <div class="sub-nav-header">
        <el-icon><Headset /></el-icon>
        <span>生活娱乐</span>
      </div>
      <el-menu
        :default-active="activeCategory"
        class="sub-nav-menu"
        @select="handleCategorySelect"
      >
        <el-menu-item index="music">
          <el-icon><Headset /></el-icon>
          <span>音乐</span>
        </el-menu-item>
        <el-menu-item index="game">
          <el-icon><Trophy /></el-icon>
          <span>游戏</span>
        </el-menu-item>
        <el-menu-item index="video">
          <el-icon><VideoCamera /></el-icon>
          <span>视频</span>
        </el-menu-item>
      </el-menu>
    </div>
    <div class="content-area">
      <div v-if="activeCategory === 'music'" class="category-content">
        <Music />
      </div>
      <div v-else-if="activeCategory === 'game'" class="category-content">
        <Game />
      </div>
      <div v-else-if="activeCategory === 'video'" class="category-content">
        <Video />
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref } from 'vue'
import { Headset, Trophy, VideoCamera } from '@element-plus/icons-vue'
import Music from '../components/Music.vue'
import Game from '../components/Game.vue'
import Video from '../components/Video.vue'

const activeCategory = ref('music')

const handleCategorySelect = (index) => {
  activeCategory.value = index
}
</script>

<style scoped>
.life-entertainment-container {
  display: flex;
  height: calc(100vh - 100px);
  gap: 20px;
  padding: 20px;
}

.sub-nav {
  width: 200px;
  padding: 16px;
  flex-shrink: 0;
}

.sub-nav-header {
  display: flex;
  align-items: center;
  gap: 8px;
  padding: 12px 16px;
  font-size: 16px;
  font-weight: 600;
  color: var(--text-primary);
  border-bottom: 1px solid var(--border-color);
  margin-bottom: 12px;
}

.sub-nav-menu {
  border: none;
  background: transparent;
}

.sub-nav-menu .el-menu-item {
  height: 48px;
  line-height: 48px;
  border-radius: 8px;
  margin-bottom: 4px;
  color: var(--text-primary);
}

.sub-nav-menu .el-menu-item:hover {
  background-color: var(--hover-bg);
}

.sub-nav-menu .el-menu-item.is-active {
  background-color: var(--primary-color);
  color: white;
}

.content-area {
  flex: 1;
  padding: 24px;
  overflow-y: auto;
}

.content-area::-webkit-scrollbar {
  width: 0;
  display: none;
}

.category-content h3 {
  font-size: 24px;
  color: var(--text-primary);
  margin-bottom: 16px;
}

.category-content p {
  color: var(--text-secondary);
}
</style>
