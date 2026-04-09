<template>
  <div class="diary-container">
    <div class="diary-header">
      <h1 class="diary-title">时光手札</h1>
      <p class="diary-subtitle">记录生活的点点滴滴</p>
    </div>

    <DiarySwiper :diary-entries="diaryEntries" />
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import DiarySwiper from '@/components/DiarySwiper.vue'

const diaryEntries = ref([
  {
    date: '2026年4月9日',
    weather: '☀️ 晴',
    mood: '心情愉悦',
    avatar: '/src/assets/picture/YoyuEN.png',
    content: '今天完成了登录认证功能的开发，前后端联调顺利。看着自己一行行代码变成可用的功能，内心充满成就感。技术的魅力就在于此，将想法变为现实。'
  },
  {
    date: '2026年4月8日',
    weather: '🌤️ 多云',
    mood: '专注思考',
    avatar: '/src/assets/picture/YoyuEN.png',
    content: '开始设计登录界面，使用了 Pencil 工具绘制原型。简洁的3:2布局，左侧介绍右侧登录，淡色系的配色让整个界面看起来很舒服。设计不仅是美观，更是用户体验的体现。'
  },
  {
    date: '2026年4月7日',
    weather: '🌧️ 雨',
    mood: '平静安宁',
    avatar: '/src/assets/picture/YoyuEN.png',
    content: '雨天适合读书和思考。翻阅了几篇关于 JWT 认证的文章，对安全性有了更深的理解。技术的学习永无止境，每一次深入都能发现新的世界。'
  },
  {
    date: '2026年4月6日',
    weather: '☁️ 阴',
    mood: '充实满足',
    avatar: '/src/assets/picture/YoyuEN.png',
    content: '优化了项目的路由守卫逻辑，添加了更完善的权限控制。代码重构虽然耗时，但看到更清晰的结构和更好的可维护性，一切都值得。'
  },
  {
    date: '2026年4月5日',
    weather: '🌤️ 晴转多云',
    mood: '轻松愉快',
    avatar: '/src/assets/picture/YoyuEN.png',
    content: '周末去了图书馆，找到几本不错的技术书籍。在安静的环境中学习，效率格外高。生活需要这样的节奏，工作与学习的平衡。'
  },
  {
    date: '2026年4月4日',
    weather: '☀️ 晴',
    mood: '充满动力',
    avatar: '/src/assets/picture/YoyuEN.png',
    content: '新的一周开始了，制定了本周的开发计划。目标明确，步骤清晰，相信这周会有不错的进展。每一个小目标的达成，都是向大目标迈进的一步。'
  }
])

onMounted(() => {
  // 可以在这里从后端获取日记数据
  // const res = await fetchDiaryList()
  // diaryEntries.value = res.data || []
})
</script>

<style scoped>
.diary-container {
  height: 100vh;
  background: linear-gradient(135deg, #f5f7fa 0%, #c3cfe2 100%);
  padding: 100px 20px 40px;
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 30px;
  overflow: hidden;
}

.diary-header {
  text-align: center;
  animation: fadeInDown 0.8s ease-out;
  flex-shrink: 0;
}

.diary-title {
  font-size: 36px;
  font-weight: 700;
  color: #2c3e50;
  margin: 0 0 8px 0;
  text-shadow: 2px 2px 4px rgba(0, 0, 0, 0.1);
  font-family: "快看世界体", -apple-system, BlinkMacSystemFont, "Segoe UI", sans-serif;
}

.diary-subtitle {
  font-size: 14px;
  color: #7f8c8d;
  margin: 0;
  font-style: italic;
}

@keyframes fadeInDown {
  from {
    opacity: 0;
    transform: translateY(-30px);
  }
  to {
    opacity: 1;
    transform: translateY(0);
  }
}

@media (max-width: 768px) {
  .diary-container {
    padding: 80px 15px 30px;
    gap: 20px;
  }

  .diary-title {
    font-size: 28px;
  }

  .diary-subtitle {
    font-size: 12px;
  }
}
</style>
