<template>
  <div class="life-experience-container">
    <DiarySwiper :diary-entries="diaryEntries" />
  </div>
</template>

<script setup>
import { ref } from 'vue'

// 导入本地头像图片
import avatarImage from '../assets/picture/YoyuEN.png'
import DiarySwiper from '../components/DiarySwiper.vue'

const diaryEntries = ref([
  { 
    date: '2025-01-01',
    weather: '☀️ 晴天',
    mood: '😊 开心',
    avatar: avatarImage,
    content: '新的一年开始了！今天和家人一起度过了美好的时光，感觉很幸福。希望新的一年能够充满希望和机遇。'
  },
  { 
    date: '2025-01-02',
    weather: '⛅ 多云',
    mood: '🤔 思考',
    avatar: avatarImage,
    content: '今天思考了很多关于未来的事情。生活就像一本书，每一天都是新的一页。我需要更加珍惜当下的时光。'
  },
  { 
    date: '2025-01-02',
    weather: '⛅ 多云',
    mood: '🤔 思考',
    avatar: avatarImage,
    content: '今天思考了很多关于未来的事情。生活就像一本书，每一天都是新的一页。我需要更加珍惜当下的时光。'
  }
])
</script>

<style scoped>
.life-experience-container {
  position: relative;
  height: calc(100vh - 120px);
  display: flex;
  justify-content: center;
  align-items: center;
  width: 100%;
  overflow: hidden;
}


</style>
