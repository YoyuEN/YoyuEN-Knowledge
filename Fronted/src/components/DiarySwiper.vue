<template>
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
            <!-- 页码 -->
            <div class="page-number">{{ index + 1 }}</div>
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
            <!-- 页码 -->
            <div class="page-number">{{ diaryEntries.length + 1 }}</div>
          </div>
        </div>
      </SwiperSlide>
    </Swiper>
  </div>
</template>

<script setup>
import { ref } from 'vue'
import { Swiper, SwiperSlide } from 'swiper/vue'
import { ElEmpty } from 'element-plus'
import 'swiper/css'
import 'swiper/css/navigation'
import 'swiper/css/pagination'

// 定义props
const props = defineProps({
  diaryEntries: {
    type: Array,
    default: () => []
  }
})

// 当前页码
const currentPage = ref(0)
let swiperInstance = null

// 格式化日期
const formatDate = (date) => {
  if (!date) return ''
  const str = String(date)
  // 优先解析 YYYY-MM-DD，避免时区偏差
  const match = str.match(/^(\d{4})-(\d{2})-(\d{2})/)
  if (match) {
    const y = parseInt(match[1], 10)
    const m = parseInt(match[2], 10)
    const day = parseInt(match[3], 10)
    const d = new Date(y, m - 1, day)
    if (isNaN(d.getTime())) return str
    const weekdays = ['周日', '周一', '周二', '周三', '周四', '周五', '周六']
    return `${y}年${m}月${day}日 ${weekdays[d.getDay()]}`
  }
  // 回退到通用解析
  const d = new Date(str.replace(/-/g, '/'))
  if (isNaN(d.getTime())) return str
  const weekdays = ['周日', '周一', '周二', '周三', '周四', '周五', '周六']
  const y = d.getFullYear()
  const m = d.getMonth() + 1
  const day = d.getDate()
  return `${y}年${m}月${day}日 ${weekdays[d.getDay()]}`
}

// swiper实例
const onSwiper = (swiper) => {
  swiperInstance = swiper
}

// 幻灯片切换事件
const onSlideChange = () => {
  if (swiperInstance) {
    currentPage.value = swiperInstance.activeIndex
  }
}
</script>

<style scoped>
.book-container {
  position: relative;
  width: 100%;
  height: 820px;
  display: flex;
  justify-content: center;
  background: #fff;
  border-radius: 12px;
  border: 1px solid var(--dt-hairline, #e6dfd8);
  padding: 10px;
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
  display: flex;
  flex-direction: column;
  cursor: grab;
  transition: all 0.3s ease;
}

.diary-page:active {
  cursor: grabbing;
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

.page-content {
  padding: 28px;
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
  width: 56px;
  height: 56px;
  border-radius: 50%;
  object-fit: cover;
  transition: transform 0.3s ease;
}

.avatar:hover {
  transform: scale(1.05);
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

/* 页码 */
.page-number {
  position: absolute;
  bottom: 0;
  left: 50%;
  transform: translateX(-50%);
  font-size: 12px;
  color: #999;
  font-weight: 500;
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
  .book-container {
    width: 95%;
    height: 420px;
    padding: 8px;
  }

  .page-content {
    padding: 25px;
  }

  .diary-page-slide:nth-child(odd) .diary-page {
    border-top-left-radius: 6px;
    border-bottom-left-radius: 6px;
  }

  .diary-page-slide:nth-child(even) .diary-page {
    border-top-right-radius: 6px;
    border-bottom-right-radius: 6px;
  }

  .page-number {
    bottom: 15px;
    font-size: 11px;
  }
}

@media (max-width: 480px) {
  .book-container {
    height: 340px;
    padding: 5px;
  }

  .page-content {
    padding: 12px;
  }

  .entry-header {
    margin-bottom: 15px;
    padding-bottom: 10px;
    gap: 15px;
  }

  .page-number {
    bottom: 12px;
    font-size: 10px;
  }
}
</style>