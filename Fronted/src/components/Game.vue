<template>
  <div class="game-container">
    <div class="game-header">
      <div class="header-icon">
        <el-icon size="24"><Trophy /></el-icon>
      </div>
      <div class="header-content">
        <h3>游戏中心</h3>
        <span class="game-count">{{ gameList.length }}款游戏</span>
      </div>
    </div>
    <div class="game-card-grid">
      <Card16x9
        v-for="game in gameList"
        :key="game.id"
        :background-image="game.cover"
        class="game-card-item"
      >
        <div class="card-info">
          <h4 class="game-name">{{ game.name }}</h4>
          <span class="game-category">{{ game.category }}</span>
        </div>
      </Card16x9>
    </div>
  </div>
</template>

<script setup>
import { ref } from 'vue'
import { Trophy } from '@element-plus/icons-vue'
import Card16x9 from './Card16x9.vue'
import defaultCover from '../assets/picture/YoyuEN.png'

const gameList = ref([
  { id: 1, name: '王者荣耀', category: 'MOBA', cover: defaultCover },
  { id: 2, name: '三角洲行动', category: '射击', cover: defaultCover },
  { id: 3, name: '原神', category: '开放世界', cover: defaultCover },
  { id: 4, name: '和平精英', category: '射击', cover: defaultCover },
  { id: 5, name: '英雄联盟手游', category: 'MOBA', cover: defaultCover },
  { id: 6, name: '崩坏星穹铁道', category: '角色扮演', cover: defaultCover },
  { id: 7, name: '明日方舟', category: '塔防', cover: defaultCover },
  { id: 8, name: '绝区零', category: '动作', cover: defaultCover }
])
</script>

<style scoped>
.game-container {
  padding: 24px;
  height: 100%;
  overflow-y: auto;
}

.game-header {
  display: flex;
  align-items: center;
  gap: 16px;
  margin-bottom: 24px;
  padding-bottom: 16px;
  border-bottom: 1px solid var(--border-color);
}

.header-icon {
  width: 48px;
  height: 48px;
  border-radius: 12px;
  background: linear-gradient(135deg, var(--primary-color), var(--primary-color-light));
  display: flex;
  align-items: center;
  justify-content: center;
  color: white;
}

.header-content h3 {
  margin: 0 0 4px;
  font-size: 20px;
  font-weight: 600;
  color: var(--text-primary);
}

.game-count {
  font-size: 13px;
  color: var(--text-secondary);
}

.game-card-grid {
  display: flex;
  flex-direction: column;
  gap: 16px;
}

.game-card-item {
  width: 100%;
  transition: transform 0.2s ease, box-shadow 0.2s ease;
}

.game-card-item:hover {
  transform: translateX(4px);
  box-shadow: 0 8px 24px rgba(0, 0, 0, 0.15);
}

.card-info {
  width: 100%;
  height: 100%;
  display: flex;
  flex-direction: column;
  justify-content: flex-end;
  padding: 16px;
  background: linear-gradient(to top, rgba(0,0,0,0.7) 0%, transparent 60%);
}

.game-name {
  margin: 0 0 8px;
  font-size: 16px;
  font-weight: 600;
  color: white;
  text-shadow: 0 2px 4px rgba(0,0,0,0.3);
}

.game-category {
  font-size: 12px;
  color: rgba(255,255,255,0.9);
  background: rgba(255,255,255,0.2);
  backdrop-filter: blur(4px);
  padding: 4px 10px;
  border-radius: 4px;
  width: fit-content;
}

.game-container::-webkit-scrollbar {
  width: 6px;
}

.game-container::-webkit-scrollbar-track {
  background: transparent;
}

.game-container::-webkit-scrollbar-thumb {
  background: var(--primary-color);
  border-radius: 3px;
}
</style>
