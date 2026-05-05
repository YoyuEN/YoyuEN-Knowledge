<template>
  <div class="life-experience-container">
    <DiarySwiper :diary-entries="diaryEntries" />
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { ElMessage } from 'element-plus'
import DiarySwiper from '../components/DiarySwiper.vue'
import { fetchDiaryList } from '@/api/diary/diary.js'

const diaryEntries = ref([])
const loading = ref(false)

const loadLifeExperienceData = async () => {
  loading.value = true
  try {
    const res = await fetchDiaryList('life_experience')
    diaryEntries.value = (res.data || []).map(item => ({
      date: item.diaryDate || '',
      weather: item.weather || '',
      mood: item.mood || '',
      avatar: item.avatar || '/src/assets/picture/YoyuEN.png',
      content: item.content || ''
    }))
  } catch (e) {
    console.error('获取生活经历数据失败', e)
    ElMessage.error('获取生活经历数据失败')
  } finally {
    loading.value = false
  }
}

onMounted(() => {
  loadLifeExperienceData()
})
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
  margin-top: 60px;
}
</style>
