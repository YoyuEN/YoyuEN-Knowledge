<template>
  <div class="dashboard">
    <h1 class="page-title">仪表盘</h1>

    <div class="stats-grid">
      <div class="stat-card">
        <div class="stat-icon">📝</div>
        <div class="stat-info">
          <div class="stat-value">{{ stats.articles }}</div>
          <div class="stat-label">文章总数</div>
        </div>
      </div>

      <div class="stat-card">
        <div class="stat-icon">🖼️</div>
        <div class="stat-info">
          <div class="stat-value">{{ stats.photos }}</div>
          <div class="stat-label">照片总数</div>
        </div>
      </div>

      <div class="stat-card">
        <div class="stat-icon">💬</div>
        <div class="stat-info">
          <div class="stat-value">{{ stats.comments }}</div>
          <div class="stat-label">评论总数</div>
        </div>
      </div>

      <div class="stat-card">
        <div class="stat-icon">👁️</div>
        <div class="stat-info">
          <div class="stat-value">{{ stats.views }}</div>
          <div class="stat-label">总访问量</div>
        </div>
      </div>
    </div>

    <div class="recent-section">
      <h2 class="section-title">最近活动</h2>
      <div class="activity-list">
        <div v-for="activity in recentActivities" :key="activity.id" class="activity-item">
          <div class="activity-icon">{{ activity.icon }}</div>
          <div class="activity-content">
            <div class="activity-text">{{ activity.text }}</div>
            <div class="activity-time">{{ activity.time }}</div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue';

const stats = ref({
  articles: 0,
  photos: 0,
  comments: 0,
  views: 0
});

const recentActivities = ref([
  { id: 1, icon: '📝', text: '发布了新文章《Vue 3 实战指南》', time: '2小时前' },
  { id: 2, icon: '🖼️', text: '上传了3张新照片', time: '5小时前' },
  { id: 3, icon: '💬', text: '收到了新评论', time: '1天前' },
  { id: 4, icon: '✏️', text: '编辑了文章《TypeScript 入门》', time: '2天前' }
]);

onMounted(async () => {
  // TODO: 从API获取统计数据
  stats.value = {
    articles: 42,
    photos: 128,
    comments: 256,
    views: 8964
  };
});
</script>

<style scoped>
.dashboard {
  max-width: 1200px;
}

.page-title {
  font-size: 28px;
  font-weight: 600;
  margin: 0 0 30px 0;
  color: #000;
}

.stats-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(240px, 1fr));
  gap: 20px;
  margin-bottom: 40px;
}

.stat-card {
  background: #fff;
  border: 1px solid #000;
  border-radius: 8px;
  padding: 24px;
  display: flex;
  align-items: center;
  gap: 16px;
  transition: all 0.2s;
}

.stat-card:hover {
  box-shadow: 4px 4px 0 #000;
  transform: translate(-2px, -2px);
}

.stat-icon {
  font-size: 36px;
  line-height: 1;
}

.stat-info {
  flex: 1;
}

.stat-value {
  font-size: 32px;
  font-weight: 700;
  color: #000;
  line-height: 1.2;
}

.stat-label {
  font-size: 14px;
  color: #666;
  margin-top: 4px;
}

.recent-section {
  background: #fff;
  border: 1px solid #000;
  border-radius: 8px;
  padding: 24px;
}

.section-title {
  font-size: 20px;
  font-weight: 600;
  margin: 0 0 20px 0;
  color: #000;
}

.activity-list {
  display: flex;
  flex-direction: column;
  gap: 16px;
}

.activity-item {
  display: flex;
  align-items: flex-start;
  gap: 12px;
  padding: 12px;
  border: 1px solid #e0e0e0;
  border-radius: 6px;
  transition: all 0.2s;
}

.activity-item:hover {
  background: #f9f9f9;
  border-color: #000;
}

.activity-icon {
  font-size: 24px;
  line-height: 1;
}

.activity-content {
  flex: 1;
}

.activity-text {
  font-size: 14px;
  color: #000;
  margin-bottom: 4px;
}

.activity-time {
  font-size: 12px;
  color: #999;
}

/* 移动端适配 */
@media (max-width: 768px) {
  .page-title {
    font-size: 24px;
    margin-bottom: 20px;
  }

  .stats-grid {
    grid-template-columns: repeat(2, 1fr);
    gap: 12px;
  }

  .stat-card {
    padding: 16px;
    flex-direction: column;
    text-align: center;
  }

  .stat-icon {
    font-size: 28px;
  }

  .stat-value {
    font-size: 24px;
  }

  .recent-section {
    padding: 16px;
  }

  .section-title {
    font-size: 18px;
  }
}
</style>
