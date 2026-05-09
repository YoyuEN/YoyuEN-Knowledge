<template>
  <div class="diary-container">
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
  min-height: 100vh;
  background: #fff;
  padding: 100px 24px 60px;
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  gap: 24px;
}

@media (max-width: 768px) {
  .diary-container {
    padding: 80px 16px 40px;
  }
}
</style>
