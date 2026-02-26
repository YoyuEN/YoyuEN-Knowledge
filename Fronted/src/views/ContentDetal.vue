<template>
  <div class="content-container">

    <!-- 左侧：轮播 + 文章内容 -->
    <div class="swiper-col">
      <swiper
        v-if="loaded"
        :slides-per-view="1"
        :space-between="16"
        :navigation="true"
        :pagination="{ clickable: true }"
        :initial-slide="initialSlide"
        @swiper="onSwiper"
        @slide-change="onSlideChange"
        class="content-swiper"
      >
        <swiper-slide
          v-for="item in swiperItems"
          :key="item.id"
          class="content-swiper-slide"
        >
          <Card16x9 :background-image="item.cover" class="content-card-item">
            <div class="card-overlay">
              <h4 class="card-name">{{ item.title }}</h4>
              <span class="card-badge">{{ item.category }}</span>
            </div>
          </Card16x9>
        </swiper-slide>
      </swiper>

      <!-- 文章内容区 -->
      <div v-if="currentItem" class="article-content">
        <div class="article-meta">
          <span class="article-tag">{{ currentItem.category }}</span>
          <span class="article-date">{{ currentItem.date }}</span>
        </div>
        <h2 class="article-title">{{ currentItem.title }}</h2>
        <div class="article-ai-summary">
          <div class="ai-label">AI 总结</div>
          <p>{{ currentItem.desc }}</p>
        </div>
        <div class="article-body" v-html="currentItem.content"></div>
      </div>
    </div>

    <!-- 右侧：详情 + 评论 -->
    <div v-if="currentItem" class="detail-col">
      <div class="detail-card">
        <div class="detail-header">
          <h3>{{ currentItem.title }}</h3>
          <span class="detail-badge">{{ currentItem.category }}</span>
        </div>
        <p class="detail-desc">{{ currentItem.desc }}</p>
        <div class="detail-stats">
          <span>📅 {{ currentItem.date }}</span>
          <span>💬 {{ currentItem.comments }} 评论</span>
        </div>
      </div>
      <div class="comment-wrap">
        <CommentSection
          :data="currentItem"
          :comments="itemComments"
          :content-type="type"
          @comment-added="loadComments(currentItem.id)"
        />
      </div>
    </div>

  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { useRoute } from 'vue-router'
import { Swiper, SwiperSlide } from 'swiper/vue'
import 'swiper/css'
import 'swiper/css/navigation'
import 'swiper/css/pagination'
import Card16x9 from '../components/Card16x9.vue'
import CommentSection from '../components/CommentSection.vue'
import { fetchContentByCategory, fetchContentById } from '@/api/content/content.js'
import { fetchCommentList } from '@/api/comment/comment.js'

const route = useRoute()
const type = route.params.type
const itemId = route.params.id

// 将后端 ContentVO 字段归一化为模板期望的字段
function normalizeContent(item) {
  return {
    ...item,
    desc: item.description ?? item.desc ?? '',
    comments: item.commentCount ?? item.comments ?? 0,
    date: item.createTime ?? item.date ?? '',
  }
}

const swiperItems = ref([])
const initialSlide = ref(0)
const currentItem = ref(null)
const itemComments = ref([])
const loaded = ref(false)

let swiperInstance = null

const onSwiper = (swiper) => {
  swiperInstance = swiper
}

const onSlideChange = async () => {
  if (swiperInstance) {
    currentItem.value = swiperItems.value[swiperInstance.activeIndex] || null
    if (currentItem.value) {
      await loadComments(currentItem.value.id)
    }
  }
}

async function loadComments(contentId) {
  try {
    const res = await fetchCommentList(contentId, type)
    itemComments.value = (res.data || []).map(c => ({
      ...c,
      time: c.createTime ?? c.time ?? '',
      replies: (c.replies || []).map(r => ({ ...r, time: r.createTime ?? r.time ?? '' })),
    }))
  } catch {
    itemComments.value = []
  }
}

onMounted(async () => {
  try {
    // 1. 获取同类型所有内容（用于 swiper 列表）
    const listRes = await fetchContentByCategory(type)
    swiperItems.value = (listRes.data || []).map(normalizeContent)

    // 2. 确定 initialSlide（数据就绪后才渲染 swiper）
    const idx = swiperItems.value.findIndex(i => String(i.id) === String(itemId))
    initialSlide.value = idx >= 0 ? idx : 0

    // 3. 获取当前条目完整详情（同时触发浏览量 +1）
    const detailRes = await fetchContentById(itemId)
    currentItem.value = normalizeContent(detailRes.data || swiperItems.value[initialSlide.value] || {})

    // 4. 加载评论
    if (currentItem.value?.id) {
      await loadComments(currentItem.value.id)
    }

    loaded.value = true
  } catch (e) {
    console.error('加载内容失败', e)
    loaded.value = true
  }
})
</script>

<style scoped>
@font-face {
  font-family: '快看世界体';
  src: url('../assets/fonts/kuaikanshijieti.ttf') format('truetype');
}

.content-container {
  margin-top: 70px;
  margin-bottom: 20px;
  padding: 0 24px;
  height: calc(100vh - 90px);
  display: flex;
  gap: 24px;
  overflow: hidden;
}

/* ---- 左侧 ---- */
.swiper-col {
  width: 55%;
  height: 100%;
  overflow-y: auto;
  scrollbar-width: none;
}

.swiper-col::-webkit-scrollbar {
  display: none;
}

.content-swiper {
  width: 100%;
  height: 420px;
  margin-top: 20px;
  flex-shrink: 0;
}

.content-swiper-slide {
  width: 100%;
  height: 100%;
  display: flex;
  justify-content: center;
  align-items: center;
}

.content-card-item {
  width: 100%;
  height: 70%;
  cursor: pointer;
}

.card-overlay {
  width: 100%;
  height: 100%;
  display: flex;
  flex-direction: column;
  justify-content: flex-end;
  padding: 16px;
  background: linear-gradient(to top, rgba(0,0,0,0.7) 0%, transparent 60%);
}

.card-name {
  margin: 0 0 8px;
  font-size: 16px;
  font-weight: 600;
  color: #fff;
  text-shadow: 0 2px 4px rgba(0,0,0,0.3);
  font-family: '快看世界体', system-ui, sans-serif;
}

.card-badge {
  font-size: 12px;
  color: rgba(255,255,255,0.9);
  background: rgba(255,255,255,0.2);
  backdrop-filter: blur(4px);
  padding: 3px 10px;
  border-radius: 4px;
  width: fit-content;
}

/* 文章内容区 */
.article-content {
  margin-top: 24px;
  background: #fff;
  border-radius: 12px;
  border: 1px solid #ebebeb;
  padding: 28px 32px 32px;
}

.article-meta {
  display: flex;
  align-items: center;
  gap: 10px;
  margin-bottom: 12px;
}

.article-tag {
  font-size: 11px;
  color: #666;
  background: #f2f2f2;
  padding: 2px 10px;
  border-radius: 20px;
}

.article-date {
  font-size: 12px;
  color: #bbb;
}

.article-title {
  font-size: 20px;
  font-weight: 700;
  color: #1a1a1a;
  margin: 0 0 20px;
  line-height: 1.4;
}

.article-ai-summary {
  background: #f8f8f8;
  border-radius: 8px;
  padding: 16px 20px;
  margin-bottom: 24px;
}

.ai-label {
  font-size: 12px;
  font-weight: 600;
  color: #888;
  margin-bottom: 8px;
  letter-spacing: 0.5px;
}

.article-ai-summary p {
  margin: 0;
  font-size: 13px;
  color: #666;
  line-height: 1.8;
}

.article-body {
  font-size: 14px;
  color: #333;
  line-height: 1.9;
}

.article-body :deep(h3) {
  font-size: 16px;
  font-weight: 600;
  color: #1a1a1a;
  margin: 24px 0 10px;
  padding-left: 10px;
  border-left: 3px solid #d0d0d0;
}

.article-body :deep(p) {
  margin: 0 0 14px;
  color: #555;
}

.article-body :deep(code) {
  background: #f2f2f2;
  padding: 1px 5px;
  border-radius: 3px;
  font-size: 13px;
  font-family: 'Consolas', monospace;
}

/* ---- 右侧 ---- */
.detail-col {
  width: 45%;
  height: 100%;
  overflow-y: auto;
  padding-top: 20px;
  scrollbar-width: none;
}

.detail-col::-webkit-scrollbar {
  display: none;
}

.detail-card {
  background: #fff;
  border: 1px solid #ebebeb;
  border-radius: 10px;
  padding: 20px;
  margin-bottom: 20px;
}

.detail-header {
  display: flex;
  justify-content: space-between;
  align-items: flex-start;
  gap: 12px;
  margin-bottom: 12px;
}

.detail-header h3 {
  margin: 0;
  font-size: 18px;
  font-weight: 700;
  color: #1a1a1a;
  line-height: 1.4;
  font-family: '快看世界体', system-ui, sans-serif;
}

.detail-badge {
  flex-shrink: 0;
  font-size: 11px;
  color: #666;
  background: #f2f2f2;
  padding: 3px 10px;
  border-radius: 20px;
}

.detail-desc {
  font-size: 13px;
  color: #666;
  line-height: 1.8;
  margin: 0 0 14px;
}

.detail-stats {
  display: flex;
  gap: 16px;
  font-size: 12px;
  color: #bbb;
}

.comment-wrap {
  background: #fff;
  border: 1px solid #ebebeb;
  border-radius: 10px;
  overflow: hidden;
}
</style>
