<template>
  <div class="life-experience-container">
    <div class="book-container">
      <Swiper 
        :slides-per-view="2"
        :space-between="0"
        :initial-slide="0"
        @swiper="onSwiper"
        @slideChange="onSlideChange"
        class="swiper-container"
      >
        <SwiperSlide v-for="(entry, index) in diaryEntries" :key="index" class="diary-page-slide">
          <div class="diary-page">
            <div class="page-content">
              <div class="diary-entry">
                <div class="entry-header">
                  <div class="avatar-container">
                    <img class="avatar" :src="entry.avatar" alt="头像">
                  </div>
                  <div class="header-info">
                    <div class="date-weather">
                      <div class="date">{{ formatDate(entry.date) }}</div>
                      <div class="weather">{{ entry.weather }}</div>
                    </div>
                    <div class="mood">{{ entry.mood }}</div>
                  </div>
                </div>
                <div class="entry-content">{{ entry.content }}</div>
              </div>
            </div>
          </div>
        </SwiperSlide>
        
        <!-- 如果日记条目数量为奇数，添加一个空幻灯片 -->
        <SwiperSlide v-if="diaryEntries.length % 2 !== 0" class="diary-page-slide">
          <div class="diary-page">
            <div class="page-content">
              <div class="empty-entry">
                <el-empty description="这一页还没有日记" :image-size="60" />
              </div>
            </div>
          </div>
        </SwiperSlide>
      </Swiper>
    </div>

    <!-- 左下角页码指示器 -->
    <div class="page-nav-indicator page-nav-left">
      <span class="page-indicator">{{ currentPage + 1 }}</span>
    </div>
    
    <!-- 右下角页码指示器 -->
    <div class="page-nav-indicator page-nav-right">
      <span class="page-indicator">{{ currentPage + 2 }}</span>
    </div>
  </div>
</template>

<script setup>
import { ref, computed } from 'vue'
import { Swiper, SwiperSlide } from 'swiper/vue'
import 'swiper/css'
import 'swiper/css/navigation'
import 'swiper/css/pagination'

// 导入本地头像图片
import avatarImage from '../assets/pciture/YoyuEN.png'

const currentPage = ref(0)
let swiperInstance = null

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

const totalPages = computed(() => {
  return Math.ceil(diaryEntries.value.length / 2) || 1
})

const formatDate = (dateStr) => {
  const date = new Date(dateStr)
  const year = date.getFullYear()
  const month = String(date.getMonth() + 1).padStart(2, '0')
  const day = String(date.getDate()).padStart(2, '0')
  return `${year}年${month}月${day}日`
}

const onSwiper = (swiper) => {
  swiperInstance = swiper
}

const onSlideChange = () => {
  if (swiperInstance) {
    // 计算当前页码，每2个幻灯片为一页
    currentPage.value = Math.floor(swiperInstance.activeIndex)
  }
}
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

.book-container {
  position: relative;
  width: 90%;
  height: 700px;
  display: flex;
  justify-content: center;
  background: var(--diary-page-bg);
  border-radius: 8px;
  padding: 10px;
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
}



.swiper-container {
  width: 100%;
  height: 100%;
  position: relative;
}

.diary-page-slide {
  width: 100%;
  height: 100%;
  display: flex;
  justify-content: center;
  align-items: center;
  transition: transform 0.3s ease;
}

.diary-page {
  width: 100%;
  height: 100%;
  border-radius: 4px;
  box-shadow: 0 2px 8px var(--shadow);
  display: flex;
  flex-direction: column;
  cursor: grab;
  transition: all 0.3s ease;
}

.diary-page:active {
  cursor: grabbing;
  transform: scale(0.98);
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.15);
}

/* 左侧页面样式 */
.diary-page-slide:nth-child(odd) .diary-page {
  border-top-left-radius: 8px;
  border-bottom-left-radius: 8px;
  border-right: 1px solid var(--diary-border-color);
}

/* 右侧页面样式 */
.diary-page-slide:nth-child(even) .diary-page {
  border-top-right-radius: 8px;
  border-bottom-right-radius: 8px;
  border-left: 1px solid var(--diary-border-color);
}

.diary-page:hover {
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
  transform: translateY(-2px);
}

.page-content {
  padding: 40px;
  height: 100%;
  position: relative;
  flex: 1;
  display: flex;
  flex-direction: column;
}

.diary-entry {
  height: 100%;
  display: flex;
  flex-direction: column;
  flex: 1;
}

.entry-header {
  margin-bottom: 20px;
  padding-bottom: 15px;
  border-bottom: 1px solid var(--border-color);
  display: flex;
  align-items: center;
  gap: 20px;
}

.avatar-container {
  flex-shrink: 0;
}

.avatar {
  width: 60px;
  height: 60px;
  border-radius: 50%;
  object-fit: cover;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
  transition: transform 0.3s ease;
}

.avatar:hover {
  transform: scale(1.05);
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
}

.header-info {
  flex: 1;
  display: flex;
  flex-direction: column;
  justify-content: center;
}

.date-weather {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 8px;
}

.date {
  font-size: 16px;
  font-weight: 600;
  color: var(--diary-text-color);
}

.weather {
  font-size: 14px;
  color: var(--text-secondary);
}

.mood {
  font-size: 14px;
  color: var(--text-tertiary);
  text-align: right;
}

.entry-content {
  flex: 1;
  line-height: 1.6;
  color: var(--diary-content-color);
  font-size: 14px;
  overflow-y: auto;
  white-space: pre-wrap;
  background-image: linear-gradient(transparent 95%, var(--diary-border-color) 95%);
  background-size: 100% 28px;
  padding-top: 5px;
}

.empty-entry {
  height: 100%;
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  gap: 20px;
}

/* 页码指示器 */
.page-nav-indicator {
  position: fixed;
  bottom: 40px;
  z-index: 10;
  animation: fadeInUp 0.5s ease-out;
}

.page-nav-left {
  left: 40px;
}

.page-nav-right {
  right: 40px;
}

.page-indicator {
  background: rgba(255, 255, 255, 0.95);
  padding: 8px 16px;
  border-radius: 20px;
  font-size: 14px;
  color: #555;
  box-shadow: 
    0 3px 12px rgba(0, 0, 0, 0.15),
    inset 0 1px 0 rgba(255, 255, 255, 0.8);
  font-weight: 500;
  transition: all 0.3s ease;
  border: 1px solid rgba(0, 0, 0, 0.1);
}

.page-indicator:hover {
  background: rgba(255, 255, 255, 1);
  box-shadow: 
    0 4px 16px rgba(0, 0, 0, 0.2),
    inset 0 1px 0 rgba(255, 255, 255, 0.9);
  transform: translateY(-2px);
}

/* 动画效果 */
@keyframes fadeInUp {
  from {
    opacity: 0;
    transform: translateY(30px);
  }
  to {
    opacity: 1;
    transform: translateY(0);
  }
}

@media (max-width: 768px) {
  .life-experience-container {
    height: calc(100vh - 140px);
    padding: 10px;
  }
  
  .book-container {
    width: 95%;
    height: 550px;
    padding: 8px;
  }
  
  .page-content {
    padding: 25px;
  }

  .page-nav-left {
    left: 20px;
    bottom: 30px;
  }
  
  .page-nav-right {
    right: 20px;
    bottom: 30px;
  }
  
  .diary-page-slide:nth-child(odd) .diary-page {
    border-top-left-radius: 6px;
    border-bottom-left-radius: 6px;
  }
  
  .diary-page-slide:nth-child(even) .diary-page {
    border-top-right-radius: 6px;
    border-bottom-right-radius: 6px;
  }
  
  .page-indicator {
    padding: 10px 20px;
    font-size: 14px;
  }
}

@media (max-width: 480px) {
  .life-experience-container {
    height: calc(100vh - 120px);
    padding: 5px;
  }
  
  .book-container {
    height: 450px;
    padding: 5px;
  }
  
  .page-content {
    padding: 15px;
  }
  
  .entry-header {
    margin-bottom: 15px;
    padding-bottom: 10px;
    gap: 15px;
  }
  
  .avatar {
    width: 45px;
    height: 45px;
  }
  
  .date {
    font-size: 14px;
  }
  
  .weather,
  .mood {
    font-size: 12px;
  }
  
  .entry-content {
    font-size: 13px;
    line-height: 1.5;
  }
  
  .page-indicator {
    padding: 8px 16px;
    font-size: 13px;
  }
  
  .page-nav-left {
    left: 15px;
    bottom: 20px;
  }
  
  .page-nav-right {
    right: 15px;
    bottom: 20px;
  }
}
</style>
