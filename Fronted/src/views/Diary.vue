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
import { ElMessage } from 'element-plus'
import DiarySwiper from '@/components/DiarySwiper.vue'
import { fetchDiaryList } from '@/api/diary/diary.js'

const diaryEntries = ref([])
const loading = ref(false)

const loadDiaryData = async () => {
  loading.value = true
  try {
    const res = await fetchDiaryList('diary')
    diaryEntries.value = (res.data || []).map(item => ({
      date: item.diaryDate || '',
      weather: item.weather || '',
      mood: item.mood || '',
      avatar: item.avatar || '/src/assets/picture/YoyuEN.png',
      content: item.content || ''
    }))
  } catch (e) {
    console.error('获取日记数据失败', e)
    ElMessage.error('获取日记数据失败')
  } finally {
    loading.value = false
  }
}

onMounted(() => {
  loadDiaryData()
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
