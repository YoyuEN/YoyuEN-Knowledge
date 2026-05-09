<template>
  <div class="content-container">

    <!-- 左侧：轮播 + 文章内容 -->
    <div class="swiper-col">
      <swiper
        v-if="loaded"
        :modules="modules"
        :slides-per-view="1"
        :space-between="16"
        :navigation="true"
        :pagination="{ clickable: true }"
        :initial-slide="initialSlide"
        :effect="'fade'"
        :speed="600"
        @swiper="onSwiper"
        @slide-change="onSlideChange"
        class="content-swiper"
      >
        <swiper-slide
          v-for="(item, index) in swiperItems"
          :key="item.id"
          class="content-swiper-slide"
        >
          <!-- 视频内容显示视频播放器 -->
          <div v-if="item.contentType === 'video' && item.videoUrl" class="swiper-video-container">
            <!-- 直接视频文件使用 video 标签 -->
            <video
              v-if="item.videoType === 'file' || isDirectVideoUrl(item.videoUrl)"
              :src="item.videoUrl"
              controls
              class="swiper-video-player"
              controlslist="nodownload"
              playsinline
              :poster="item.cover"
              @error="handleVideoError"
            >
              您的浏览器不支持视频播放
            </video>
            <!-- 第三方视频链接使用 iframe，只在当前活动幻灯片中加载 -->
            <iframe
              v-else-if="item.videoType === 'link' && !isDirectVideoUrl(item.videoUrl) && activeSlideIndex === index"
              :src="convertToEmbedUrl(item.videoUrl)"
              frameborder="0"
              allowfullscreen
              allow="accelerometer; clipboard-write; encrypted-media; gyroscope; picture-in-picture"
              class="swiper-video-iframe"
            ></iframe>
            <!-- 非活动幻灯片显示封面 -->
            <div
              v-else-if="item.videoType === 'link' && !isDirectVideoUrl(item.videoUrl) && activeSlideIndex !== index"
              class="video-placeholder"
              :style="{ backgroundImage: `url(${item.cover})` }"
            >
              <div class="play-icon">▶</div>
            </div>
          </div>
          <!-- 图文内容显示封面图 -->
          <Card16x9 v-else :background-image="item.cover" class="content-card-item" @click="viewImage(item.cover)">
          </Card16x9>
        </swiper-slide>
        <!-- 切换提示图标 -->
        <div v-if="swiperItems.length > 1" class="swipe-hint swipe-hint-left" @click="handleSwipeHintClickPrev">
          <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
            <polyline points="15 18 9 12 15 6"></polyline>
          </svg>
        </div>
        <div v-if="swiperItems.length > 1" class="swipe-hint swipe-hint-right" @click="handleSwipeHintClick">
          <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
            <polyline points="9 18 15 12 9 6"></polyline>
          </svg>
        </div>
      </swiper>

      <!-- 文章内容区 -->
      <div v-if="currentItem" class="article-content">
        <div class="article-body markdown-body" v-html="renderMarkdown(currentItem.content)" @click="handleContentClick" ref="articleBodyRef"></div>
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
          <span>{{ currentItem.date }}</span>
          <span>{{ currentItem.comments }} 评论</span>
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

    <!-- 图片预览模态框 -->
    <div v-if="showImagePreview" class="image-preview-modal" @click="closeImagePreview">
      <div class="image-preview-content" @click.stop>
        <img :src="previewImages[currentImageIndex]" alt="预览图片" />
        <button class="close-btn" @click="closeImagePreview">✕</button>

        <!-- 左右切换按钮 -->
        <button v-if="previewImages.length > 1" class="nav-btn nav-btn-prev" @click="prevImage">
          <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
            <polyline points="15 18 9 12 15 6"></polyline>
          </svg>
        </button>
        <button v-if="previewImages.length > 1" class="nav-btn nav-btn-next" @click="nextImage">
          <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
            <polyline points="9 18 15 12 9 6"></polyline>
          </svg>
        </button>

        <!-- 图片计数 -->
        <div v-if="previewImages.length > 1" class="image-counter">
          {{ currentImageIndex + 1 }} / {{ previewImages.length }}
        </div>
      </div>
    </div>

  </div>
</template>

<script setup>
import { ref, onMounted, onBeforeUnmount, watch, computed } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import { Swiper, SwiperSlide } from 'swiper/vue'
import { EffectFade } from 'swiper/modules'
import 'swiper/css'
import 'swiper/css/navigation'
import 'swiper/css/pagination'
import 'swiper/css/effect-fade'
import Card16x9 from '../components/Card16x9.vue'
import CommentSection from '../components/CommentSection.vue'
import { fetchContentByCategory, fetchContentById } from '@/api/content/content.js'
import { fetchCommentList } from '@/api/comment/comment.js'
import { marked } from 'marked'
import { transitionContent } from '@/js/contentTransition'

marked.setOptions({ breaks: true, gfm: true })
const renderMarkdown = (content) => content ? marked(content) : ''

const isDirectVideoUrl = (url) => {
  if (!url) return false
  // 移除查询参数后再检查文件扩展名
  const urlWithoutParams = url.split('?')[0]
  return /\.(mp4|avi|mov|wmv|flv|webm)$/i.test(urlWithoutParams)
}

// 转换第三方视频链接为嵌入式播放器链接
const convertToEmbedUrl = (url) => {
  if (!url) return url

  // Bilibili 视频链接转换
  // 从 https://www.bilibili.com/video/BV... 转换为 https://player.bilibili.com/player.html?bvid=BV...
  if (url.includes('bilibili.com/video/')) {
    const bvMatch = url.match(/\/video\/(BV[\w]+)/)
    if (bvMatch) {
      return `https://player.bilibili.com/player.html?bvid=${bvMatch[1]}&high_quality=1&danmaku=0&autoplay=0`
    }
  }

  // YouTube 视频链接转换
  // 从 https://www.youtube.com/watch?v=... 转换为 https://www.youtube.com/embed/...
  if (url.includes('youtube.com/watch')) {
    const videoId = new URL(url).searchParams.get('v')
    if (videoId) {
      return `https://www.youtube.com/embed/${videoId}?autoplay=0` 
    }
  }

  // YouTube 短链接转换
  if (url.includes('youtu.be/')) {
    const videoId = url.split('youtu.be/')[1]?.split('?')[0]
    if (videoId) {
      return `https://www.youtube.com/embed/${videoId}?autoplay=0`
    }
  }

  return url
}

const modules = [EffectFade]

const route = useRoute()
const router = useRouter()
const type = computed(() => route.params.type)
const itemId = computed(() => route.params.id)

// 将后端 ContentVO 字段归一化为模板期望的字段
function normalizeContent(item) {
  if (!item) return null
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
const showImagePreview = ref(false)
const previewImages = ref([])
const currentImageIndex = ref(0)
const articleBodyRef = ref(null)
const activeSlideIndex = ref(0)

let swiperInstance = null

const onSwiper = (swiper) => {
  swiperInstance = swiper
}

// 暂停所有视频
const pauseAllVideos = () => {
  // 暂停所有 video 标签
  const videos = document.querySelectorAll('.swiper-video-player')
  videos.forEach(video => {
    if (!video.paused) {
      video.pause()
    }
  })
}

const onSlideChange = async () => {
  if (swiperInstance) {
    // 切换前先暂停所有视频
    pauseAllVideos()

    // 更新当前活动幻灯片索引
    activeSlideIndex.value = swiperInstance.activeIndex

    await transitionContent(async () => {
      currentItem.value = swiperItems.value[swiperInstance.activeIndex] || null
      if (currentItem.value) {
        await loadComments(currentItem.value.id)
      }
    })
  }
}

// 递归归一化评论字段（所有层级的回复都处理）
function normalizeComment(c) {
  return {
    ...c,
    time: c.createTime ?? c.time ?? '',
    replies: (c.replies || []).map(normalizeComment),
  }
}

async function loadComments(contentId) {
  try {
    const res = await fetchCommentList(contentId, type.value)
    itemComments.value = (res.data || []).map(normalizeComment)
  } catch {
    itemComments.value = []
  }
}

async function loadData() {
  // 路由参数尚未就绪时直接返回，等待 watch 触发
  if (!type.value || !itemId.value) return

  loaded.value = false
  try {
    // 1. 获取同类型所有内容（用于 swiper 列表）
    const listRes = await fetchContentByCategory(type.value)
    swiperItems.value = (listRes.data || []).map(normalizeContent).filter(Boolean)

    // 2. 确定 initialSlide（数据就绪后才渲染 swiper）
    const idx = swiperItems.value.findIndex(i => String(i.id) === String(itemId.value))
    initialSlide.value = idx >= 0 ? idx : 0

    // 3. 获取当前条目完整详情（同时触发浏览量 +1），失败时降级使用列表数据
    try {
      const detailRes = await fetchContentById(itemId.value)
      currentItem.value = normalizeContent(detailRes.data) ?? swiperItems.value[initialSlide.value] ?? null
    } catch {
      currentItem.value = swiperItems.value[initialSlide.value] ?? null
    }

    // 4. 加载评论
    if (currentItem.value?.id) {
      await loadComments(currentItem.value.id)
    }

    loaded.value = true
    // 加载完成后定位到目标评论
    scrollToHash()
  } catch (e) {
    console.error('加载内容失败', e)
    // 即使出错也尝试用列表中已有的数据展示
    if (!currentItem.value && swiperItems.value.length > 0) {
      currentItem.value = swiperItems.value[initialSlide.value] ?? null
    }
    loaded.value = true
  }
}

// 拦截文章正文中的链接和图片点击
function handleContentClick(e) {
  // 处理图片点击
  const img = e.target.closest('img')
  if (img && img.src) {
    e.preventDefault()
    openImagePreview(img.src)
    return
  }

  // 处理链接点击
  const link = e.target.closest('a')
  if (!link) return
  const href = link.getAttribute('href')
  if (!href || href.startsWith('http') || href.startsWith('//') || href.startsWith('mailto:')) return
  e.preventDefault()
  router.push(href)
}

// 提取文章中所有图片
function extractImagesFromContent() {
  if (!articleBodyRef.value) return []
  const images = articleBodyRef.value.querySelectorAll('img')
  return Array.from(images).map(img => img.src).filter(Boolean)
}

// 打开图片预览
function openImagePreview(imageSrc) {
  previewImages.value = extractImagesFromContent()
  currentImageIndex.value = previewImages.value.indexOf(imageSrc)
  if (currentImageIndex.value === -1) {
    currentImageIndex.value = 0
    previewImages.value = [imageSrc]
  }
  showImagePreview.value = true
}

// 上一张图片
function prevImage() {
  if (currentImageIndex.value > 0) {
    currentImageIndex.value--
  } else {
    currentImageIndex.value = previewImages.value.length - 1
  }
}

// 下一张图片
function nextImage() {
  if (currentImageIndex.value < previewImages.value.length - 1) {
    currentImageIndex.value++
  } else {
    currentImageIndex.value = 0
  }
}

function viewImage(coverPath) {
  if (!coverPath) return
  // 构建完整图片URL
  const imageUrl = coverPath.startsWith('http')
    ? coverPath
    : `${import.meta.env.VITE_API_BASE_URL || ''}/api/file/view/${coverPath}`
  openImagePreview(imageUrl)
}

function closeImagePreview() {
  showImagePreview.value = false
  previewImages.value = []
  currentImageIndex.value = 0
}

function scrollToHash() {
  const hash = route.hash
  if (!hash) return
  setTimeout(() => {
    const el = document.querySelector(hash)
    if (el) {
      el.scrollIntoView({ behavior: 'smooth', block: 'center' })
      el.style.outline = '2px solid #4096ff'
      setTimeout(() => { el.style.outline = '' }, 2000)
    }
  }, 300)
}

function handleSwipeHintClick() {
  if (swiperInstance) {
    swiperInstance.slideNext()
  }
}

function handleSwipeHintClickPrev() {
  if (swiperInstance) {
    swiperInstance.slidePrev()
  }
}

function handleVideoError(e) {
  console.error('视频加载失败:', e.target.src)
}

onMounted(loadData)

// 组件卸载时暂停所有视频
onBeforeUnmount(() => {
  pauseAllVideos()
})

// 监听路由参数变化（直接监听 computed ref，比 getter 更可靠）
watch([type, itemId], ([newType, newId]) => {
  if (newType && newId) {
    // 切换文章前先暂停所有视频
    pauseAllVideos()
    loadData()
  }
})

// hash 单独变化时（同文章不同评论锚点）只滚动，不重新请求数据
watch(() => route.hash, (hash) => {
  if (hash) scrollToHash()
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
  cursor: pointer;
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

.article-body {
  font-size: 16px;
  color: #333;
  line-height: 2;
}

.article-body :deep(p) {
  margin: 0 0 16px;
  text-indent: 2em;
}

.article-body :deep(h1) {
  font-size: 22px;
  font-weight: 700;
  color: #1a1a1a;
  margin: 28px 0 12px;
  padding-bottom: 8px;
  border-bottom: 1px solid #eee;
}

.article-body :deep(h2) {
  font-size: 18px;
  font-weight: 600;
  color: #1a1a1a;
  margin: 24px 0 10px;
  padding-left: 10px;
  border-left: 3px solid #888;
}

.article-body :deep(h3) {
  font-size: 16px;
  font-weight: 600;
  color: #1a1a1a;
  margin: 20px 0 8px;
  padding-left: 10px;
  border-left: 3px solid #d0d0d0;
}


.article-body :deep(ul), .article-body :deep(ol) {
  padding-left: 20px;
  margin: 0 0 14px;
  color: #555;
}

.article-body :deep(li) {
  margin-bottom: 4px;
}

.article-body :deep(code) {
  background: #f2f2f2;
  padding: 1px 5px;
  border-radius: 3px;
  font-size: 13px;
  font-family: 'Consolas', monospace;
}

.article-body :deep(pre) {
  background: #1e1e1e;
  border-radius: 6px;
  padding: 16px;
  overflow-x: auto;
  margin: 0 0 16px;
}

.article-body :deep(pre code) {
  background: none;
  color: #d4d4d4;
  padding: 0;
  font-size: 13px;
}

.article-body :deep(blockquote) {
  margin: 0 0 14px;
  padding: 10px 16px;
  border-left: 3px solid #ddd;
  background: #f9f9f9;
  color: #777;
}

.article-body :deep(a) {
  color: #667eea;
  text-decoration: none;
}

.article-body :deep(a:hover) {
  text-decoration: underline;
}

.article-body :deep(img) {
  max-width: 100%;
  height: auto;
  border-radius: 8px;
  margin: 16px auto;
  display: block;
  cursor: pointer;
  transition: all 0.3s ease;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
}

.article-body :deep(img:hover) {
  transform: translateY(-2px);
  box-shadow: 0 8px 16px rgba(0, 0, 0, 0.15);
}

/* 小图片居中显示 */
.article-body :deep(p img) {
  margin: 20px auto;
}

/* 大图片占满宽度 */
.article-body :deep(img[src*="large"]),
.article-body :deep(img[width]),
.article-body :deep(img[height]) {
  max-width: 100%;
  margin: 24px 0;
}

.article-body :deep(hr) {
  border: none;
  border-top: 1px solid #eee;
  margin: 20px 0;
}

.article-body :deep(table) {
  width: 100%;
  border-collapse: collapse;
  margin: 0 0 14px;
  font-size: 13px;
}

.article-body :deep(th), .article-body :deep(td) {
  border: 1px solid #e0e0e0;
  padding: 8px 12px;
  text-align: left;
}

.article-body :deep(th) {
  background: #f5f5f5;
  font-weight: 600;
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

/* 切换提示图标 */
.swipe-hint {
  position: absolute;
  top: 50%;
  transform: translateY(-50%);
  width: 48px;
  height: 48px;
  background: rgba(255, 255, 255, 0.9);
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
  box-shadow: 0 2px 12px rgba(0, 0, 0, 0.15);
  z-index: 10;
  animation: breathe 2s ease-in-out infinite;
  cursor: pointer;
  transition: all 0.3s ease;
}

.swipe-hint-left {
  left: 20px;
}

.swipe-hint-right {
  right: 20px;
}

.swipe-hint:hover {
  background: rgba(255, 255, 255, 1);
  box-shadow: 0 4px 16px rgba(0, 0, 0, 0.2);
}

.swipe-hint svg {
  color: #666;
}

@keyframes breathe {
  0%, 100% {
    opacity: 0.6;
    transform: translateY(-50%) scale(1);
  }
  50% {
    opacity: 1;
    transform: translateY(-50%) scale(1.1);
  }
}

/* 图片预览模态框 */
.image-preview-modal {
  position: fixed;
  top: 0;
  left: 0;
  width: 100vw;
  height: 100vh;
  background: rgba(0, 0, 0, 0.9);
  display: flex;
  align-items: center;
  justify-content: center;
  z-index: 9999;
  animation: fadeIn 0.2s ease;
}

.image-preview-content {
  position: relative;
  max-width: 90vw;
  max-height: 90vh;
  display: flex;
  align-items: center;
  justify-content: center;
}

.image-preview-content img {
  max-width: 100%;
  max-height: 90vh;
  object-fit: contain;
  border-radius: 8px;
  box-shadow: 0 8px 32px rgba(0, 0, 0, 0.5);
}

.close-btn {
  position: absolute;
  top: -40px;
  right: 0;
  width: 36px;
  height: 36px;
  background: rgba(255, 255, 255, 0.9);
  border: none;
  border-radius: 50%;
  font-size: 20px;
  color: #333;
  cursor: pointer;
  display: flex;
  align-items: center;
  justify-content: center;
  transition: all 0.2s ease;
}

.close-btn:hover {
  background: #fff;
  transform: scale(1.1);
}

/* 图片预览导航按钮 */
.nav-btn {
  position: absolute;
  top: 50%;
  transform: translateY(-50%);
  width: 48px;
  height: 48px;
  background: rgba(255, 255, 255, 0.9);
  border: none;
  border-radius: 50%;
  cursor: pointer;
  display: flex;
  align-items: center;
  justify-content: center;
  transition: all 0.3s ease;
  z-index: 10;
}

.nav-btn:hover {
  background: #fff;
  transform: translateY(-50%) scale(1.1);
}

.nav-btn-prev {
  left: 20px;
}

.nav-btn-next {
  right: 20px;
}

.nav-btn svg {
  color: #333;
}

/* 图片计数器 */
.image-counter {
  position: absolute;
  bottom: -50px;
  left: 50%;
  transform: translateX(-50%);
  background: rgba(255, 255, 255, 0.9);
  color: #333;
  padding: 8px 16px;
  border-radius: 20px;
  font-size: 14px;
  font-weight: 500;
}

@keyframes fadeIn {
  from {
    opacity: 0;
  }
  to {
    opacity: 1;
  }
}

/* Swiper 视频容器 */
.swiper-video-container {
  width: 100%;
  height: 100%;
  position: relative;
  background: #000;
  border-radius: 12px;
  overflow: hidden;
}

.swiper-video-player {
  width: 100%;
  height: 100%;
  object-fit: contain;
  background: #000;
}

.swiper-video-iframe {
  width: 100%;
  height: 100%;
  border: none;
}

/* 视频占位符 */
.video-placeholder {
  width: 100%;
  height: 100%;
  background-size: cover;
  background-position: center;
  display: flex;
  align-items: center;
  justify-content: center;
  position: relative;
}

.video-placeholder::before {
  content: '';
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background: rgba(0, 0, 0, 0.3);
}

.play-icon {
  position: relative;
  z-index: 1;
  width: 80px;
  height: 80px;
  background: rgba(255, 255, 255, 0.9);
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 32px;
  color: #333;
  padding-left: 6px;
}

.video-overlay {
  position: absolute;
  bottom: 0;
  left: 0;
  right: 0;
  padding: 16px;
  background: linear-gradient(to top, rgba(0,0,0,0.7) 0%, transparent 100%);
  display: flex;
  flex-direction: column;
  gap: 8px;
  pointer-events: none;
}
</style>
