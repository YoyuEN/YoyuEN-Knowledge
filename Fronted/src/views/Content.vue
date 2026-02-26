<template>
  <div class="page-wrapper">

    <!-- 左侧：可滚动内容区 -->
    <div class="content-main">

      <!-- 推荐内容 -->
      <section class="module">
        <div class="module-header">
          <h2 class="module-title">推荐内容</h2>
          <span class="module-more">查看更多</span>
        </div>
        <div class="recommend-grid">
          <div v-for="item in recommendList" :key="item.id" class="recommend-card" @click="goToDetail(item, categoryTypeMap[item.category] || 'article')">
            <div class="rc-image">
              <img :src="item.cover" :alt="item.title" />
              <div class="rc-overlay"></div>
              <div class="rc-time">{{ item.date }}</div>
              <div class="rc-avatar">
                <img src="/src/assets/picture/YoyuEN.png" alt="Author" />
              </div>
              <div class="rc-comment-count">
                <svg width="12" height="12" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                  <path d="M21 15a2 2 0 0 1-2 2H7l-4 4V5a2 2 0 0 1 2-2h14a2 2 0 0 1 2 2z"></path>
                </svg>
                <span>{{ item.comments }}</span>
              </div>
              <div class="rc-content">
                <h3 class="rc-title">{{ item.title }}</h3>
                <p class="rc-summary">{{ item.desc.length > 40 ? item.desc.slice(0, 40) + '...' : item.desc }}</p>
                <div class="rc-tags">
                  <span class="rc-tag">{{ item.category }}</span>
                </div>
              </div>
            </div>
          </div>
        </div>
      </section>

      <!-- 文章模块 -->
      <section class="module">
        <div class="module-header">
          <h2 class="module-title">文章</h2>
          <span class="module-more">查看更多</span>
        </div>
        <div class="list">
          <div v-for="item in articleList" :key="item.id" class="list-item" @click="goToDetail(item, 'article')">
            <div class="item-thumb">
              <img :src="item.cover" :alt="item.title" />
            </div>
            <div class="item-body">
              <div class="item-title">{{ item.title }}</div>
              <div class="item-desc">{{ item.desc }}</div>
              <div class="item-meta">
                <span class="meta-date">{{ item.date }}</span>
                <span class="meta-divider">·</span>
                <span class="meta-comment">
                  <svg width="13" height="13" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                    <path d="M21 15a2 2 0 0 1-2 2H7l-4 4V5a2 2 0 0 1 2-2h14a2 2 0 0 1 2 2z"></path>
                  </svg>
                  {{ item.comments }}
                </span>
              </div>
            </div>
          </div>
        </div>
      </section>

      <!-- 游戏模块 -->
      <section class="module">
        <div class="module-header">
          <h2 class="module-title">游戏</h2>
          <span class="module-more">查看更多</span>
        </div>
        <div class="list">
          <div v-for="item in gameList" :key="item.id" class="list-item" @click="goToDetail(item, 'game')">
            <div class="item-thumb">
              <img :src="item.cover" :alt="item.title" />
            </div>
            <div class="item-body">
              <div class="item-title">{{ item.title }}</div>
              <div class="item-desc">{{ item.desc }}</div>
              <div class="item-meta">
                <span class="meta-date">{{ item.date }}</span>
                <span class="meta-divider">·</span>
                <span class="meta-comment">
                  <svg width="13" height="13" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                    <path d="M21 15a2 2 0 0 1-2 2H7l-4 4V5a2 2 0 0 1 2-2h14a2 2 0 0 1 2 2z"></path>
                  </svg>
                  {{ item.comments }}
                </span>
              </div>
            </div>
          </div>
        </div>
      </section>

      <!-- 学习模块 -->
      <section class="module">
        <div class="module-header">
          <h2 class="module-title">学习</h2>
          <span class="module-more">查看更多</span>
        </div>
        <div class="list">
          <div v-for="item in studyList" :key="item.id" class="list-item" @click="goToDetail(item, 'study')">
            <div class="item-thumb">
              <img :src="item.cover" :alt="item.title" />
            </div>
            <div class="item-body">
              <div class="item-title">{{ item.title }}</div>
              <div class="item-desc">{{ item.desc }}</div>
              <div class="item-meta">
                <span class="meta-date">{{ item.date }}</span>
                <span class="meta-divider">·</span>
                <span class="meta-comment">
                  <svg width="13" height="13" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                    <path d="M21 15a2 2 0 0 1-2 2H7l-4 4V5a2 2 0 0 1 2-2h14a2 2 0 0 1 2 2z"></path>
                  </svg>
                  {{ item.comments }}
                </span>
              </div>
            </div>
          </div>
        </div>
      </section>

      <!-- 视频模块 -->
      <section class="module">
        <div class="module-header">
          <h2 class="module-title">视频</h2>
          <span class="module-more">查看更多</span>
        </div>
        <div class="list">
          <div v-for="item in videoList" :key="item.id" class="list-item" @click="goToDetail(item, 'video')">
            <div class="item-thumb video-thumb">
              <img :src="item.cover" :alt="item.title" />
              <span class="play-icon">
                <svg width="20" height="20" viewBox="0 0 24 24" fill="currentColor">
                  <polygon points="5 3 19 12 5 21 5 3"></polygon>
                </svg>
              </span>
            </div>
            <div class="item-body">
              <div class="item-title">{{ item.title }}</div>
              <div class="item-desc">{{ item.desc }}</div>
              <div class="item-meta">
                <span class="meta-date">{{ item.date }}</span>
                <span class="meta-divider">·</span>
                <span class="meta-comment">
                  <svg width="13" height="13" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                    <path d="M21 15a2 2 0 0 1-2 2H7l-4 4V5a2 2 0 0 1 2-2h14a2 2 0 0 1 2 2z"></path>
                  </svg>
                  {{ item.comments }}
                </span>
              </div>
            </div>
          </div>
        </div>
      </section>

    </div>

    <!-- 右侧：固定边栏 -->
    <aside class="sidebar">

      <!-- 个人信息卡 -->
      <div class="sidebar-card profile-card">
        <div class="profile-avatar">
          <img src="/src/assets/picture/YoyuEN.png" alt="YoyuEN" />
        </div>
        <div class="profile-name">YoyuEN</div>
        <div class="profile-sign">宁鸣而死，不默而生</div>
        <div class="profile-bio">
          北方民族大学 · 软件工程<br />
          热爱技术、游戏与生活，记录一切值得留下的东西。
        </div>
        <div class="profile-stats">
          <div class="stat-item">
            <span class="stat-num">100</span>
            <span class="stat-label">文章</span>
          </div>
          <div class="stat-divider"></div>
          <div class="stat-item">
            <span class="stat-num">1k</span>
            <span class="stat-label">动态</span>
          </div>
          <div class="stat-divider"></div>
          <div class="stat-item">
            <span class="stat-num">10k</span>
            <span class="stat-label">评论</span>
          </div>
        </div>
      </div>

      <!-- 每日碎碎念 -->
      <div class="sidebar-card">
        <div class="sidebar-card-title">每日碎碎念</div>
        <div class="murmur-list">
          <div v-for="item in murmurList" :key="item.id" class="murmur-item">
            <div class="murmur-text">{{ item.text }}</div>
            <div class="murmur-date">{{ item.date }}</div>
          </div>
        </div>
      </div>

    </aside>

  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { useRouter } from 'vue-router'
import { fetchRecommendContent, fetchContentByCategory } from '@/api/content/content.js'
import { fetchLatestMurmur } from '@/api/murmur/murmur.js'

const router = useRouter()

const categoryTypeMap = { '文章': 'article', '游戏': 'game', '学习': 'study', '视频': 'video' }

const goToDetail = (item, type) => {
  router.push({ name: 'ContentDetail', params: { type, id: item.id } })
}

// 将后端 ContentVO 字段归一化为模板期望的字段
function normalizeContent(item) {
  return {
    ...item,
    desc: item.description ?? item.desc ?? '',
    comments: item.commentCount ?? item.comments ?? 0,
    date: item.createTime ?? item.date ?? '',
  }
}

const recommendList = ref([])
const articleList = ref([])
const gameList = ref([])
const studyList = ref([])
const videoList = ref([])
const murmurList = ref([])

onMounted(async () => {
  const [recommend, articles, games, studies, videos, murmurs] = await Promise.allSettled([
    fetchRecommendContent(),
    fetchContentByCategory('article'),
    fetchContentByCategory('game'),
    fetchContentByCategory('study'),
    fetchContentByCategory('video'),
    fetchLatestMurmur(5),
  ])

  if (recommend.status === 'fulfilled') {
    recommendList.value = (recommend.value.data || []).map(normalizeContent)
  }
  if (articles.status === 'fulfilled') {
    articleList.value = (articles.value.data || []).map(normalizeContent)
  }
  if (games.status === 'fulfilled') {
    gameList.value = (games.value.data || []).map(normalizeContent)
  }
  if (studies.status === 'fulfilled') {
    studyList.value = (studies.value.data || []).map(normalizeContent)
  }
  if (videos.status === 'fulfilled') {
    videoList.value = (videos.value.data || []).map(normalizeContent)
  }
  console.log(videoList.value)
  if (murmurs.status === 'fulfilled') {
    murmurList.value = (murmurs.value.data || []).map(m => ({
      ...m,
      text: m.content ?? m.text ?? '',
      date: m.createTime ?? m.date ?? '',
    }))
  }
})
</script>

<style scoped>
/* ---- 整体布局 ---- */
.page-wrapper {
  display: flex;
  gap: 24px;
  margin: 36px auto;
  padding: 40px 24px 0px;
  align-items: flex-start;
  background: #fff;
  min-height: calc(100vh - 90px);
}

.module {
  margin-bottom: 40px;
  }

/* ---- 左侧内容 ---- */
.content-main {
  flex: 1;
  min-width: 0;
  padding: 20px;
  border: 1px solid #ebebeb;
  border-radius: 10px;
}

/* ---- 模块公共 ---- */

.module-header {
  display: flex;
  align-items: baseline;
  justify-content: space-between;
  padding-bottom: 12px;
  border-bottom: 1px solid #ebebeb;
  margin-bottom: 20px;
}

.module-title {
  font-size: 17px;
  font-weight: 600;
  color: #1a1a1a;
  margin: 0;
}

.module-more {
  font-size: 13px;
  color: #999;
  cursor: pointer;
  transition: color 0.2s;
}

.module-more:hover {
  color: #555;
}

/* ---- 推荐网格 ---- */
.recommend-grid {
  display: grid;
  grid-template-columns: repeat(2, 1fr);
  gap: 16px;
}

.recommend-card {
  border-radius: 8px;
  overflow: hidden;
  cursor: pointer;
  box-shadow: 0 2px 12px rgba(0, 0, 0, 0.1);
  transition: all 0.3s ease;
}

.recommend-card:hover {
  box-shadow: 0 4px 20px rgba(0, 0, 0, 0.15);
  transform: translateY(-2px);
}

.rc-image {
  position: relative;
  width: 100%;
  height: 200px;
  overflow: hidden;
  background: #f0f0f0;
}

.rc-image img {
  width: 100%;
  height: 100%;
  object-fit: cover;
  transition: transform 0.3s ease;
}

.recommend-card:hover .rc-image img {
  transform: scale(1.05);
}

.rc-overlay {
  position: absolute;
  inset: 0;
  background: linear-gradient(to bottom, rgba(0,0,0,0) 0%, rgba(0,0,0,0.2) 50%, rgba(0,0,0,0.7) 100%);
  transition: background 0.3s ease;
}

.recommend-card:hover .rc-overlay {
  background: linear-gradient(to bottom, rgba(0,0,0,0) 0%, rgba(0,0,0,0.3) 50%, rgba(0,0,0,0.8) 100%);
}

.rc-time {
  position: absolute;
  top: 10px;
  right: 10px;
  background: rgba(0,0,0,0.3);
  backdrop-filter: blur(10px);
  color: #fff;
  padding: 4px 10px;
  border-radius: 4px;
  font-size: 12px;
  z-index: 2;
}

.rc-avatar {
  position: absolute;
  top: 10px;
  left: 10px;
  width: 32px;
  height: 32px;
  border-radius: 50%;
  overflow: hidden;
  z-index: 2;
  border: 2px solid rgba(255,255,255,0.8);
  box-shadow: 0 2px 4px rgba(0,0,0,0.2);
}

.rc-avatar img {
  width: 100%;
  height: 100%;
  object-fit: cover;
}

.rc-comment-count {
  position: absolute;
  top: 10px;
  right: 120px;
  display: flex;
  align-items: center;
  gap: 4px;
  color: #fff;
  font-size: 12px;
  background: rgba(0,0,0,0.3);
  backdrop-filter: blur(10px);
  padding: 4px 8px;
  border-radius: 4px;
  z-index: 2;
  opacity: 0;
  transform: translateY(-10px);
  transition: all 0.3s ease;
}

.recommend-card:hover .rc-comment-count {
  opacity: 1;
  transform: translateY(0);
}

.rc-content {
  padding: 16px;
}

.rc-title {
  margin: 0 0 10px;
  font-size: 14px;
  font-weight: 600;
  color: #fff;
  line-height: 1.4;
  display: -webkit-box;
  -webkit-line-clamp: 2;
  line-clamp: 2;
  -webkit-box-orient: vertical;
  overflow: hidden;
  position: absolute;
  bottom: 36px;
  left: 16px;
  right: 16px;
  z-index: 2;
  transition: all 0.3s ease;
}

.rc-summary {
  margin: 0 0 10px;
  font-size: 12px;
  color: #e0e0e0;
  line-height: 1.5;
  position: absolute;
  bottom: 36px;
  left: 16px;
  right: 16px;
  z-index: 2;
  opacity: 0;
  transform: translateY(10px);
  transition: all 0.3s ease;
  pointer-events: none;
  display: -webkit-box;
  -webkit-line-clamp: 3;
  line-clamp: 3;
  -webkit-box-orient: vertical;
  overflow: hidden;
}

.recommend-card:hover .rc-title {
  opacity: 0;
  transform: translateY(-10px);
}

.recommend-card:hover .rc-summary {
  opacity: 1;
  transform: translateY(0);
}

.rc-tags {
  display: flex;
  flex-wrap: wrap;
  gap: 6px;
  position: absolute;
  bottom: 10px;
  left: 16px;
  right: 16px;
  z-index: 2;
}

.rc-tag {
  background: transparent;
  color: #fff;
  font-size: 11px;
  padding: 2px 8px;
}

/* ---- 列表通用 ---- */
.list {
  display: flex;
  flex-direction: column;
}

.list-item {
  display: flex;
  gap: 16px;
  padding: 16px 0;
  border-bottom: 1px solid #f2f2f2;
  cursor: pointer;
  transition: background 0.15s;
}

.list-item:last-child {
  border-bottom: none;
}

.list-item:hover {
  background: #fafafa;
  padding-left: 6px;
  padding-right: 6px;
  border-radius: 6px;
  margin: 0 -6px;
}

.item-thumb {
  flex-shrink: 0;
  width: 110px;
  height: 74px;
  border-radius: 6px;
  overflow: hidden;
  background: #f5f5f5;
  position: relative;
}

.item-thumb img {
  width: 100%;
  height: 100%;
  object-fit: cover;
}

.video-thumb .play-icon {
  position: absolute;
  inset: 0;
  display: flex;
  align-items: center;
  justify-content: center;
  background: rgba(0, 0, 0, 0.3);
  color: #fff;
  opacity: 0;
  transition: opacity 0.2s;
}

.list-item:hover .video-thumb .play-icon {
  opacity: 1;
}

.item-body {
  flex: 1;
  display: flex;
  flex-direction: column;
  justify-content: space-between;
  min-width: 0;
}

.item-title {
  font-size: 14px;
  font-weight: 600;
  color: #1a1a1a;
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
}

.item-desc {
  font-size: 12px;
  color: #888;
  line-height: 1.6;
  display: -webkit-box;
  -webkit-line-clamp: 2;
  line-clamp: 2;
  -webkit-box-orient: vertical;
  overflow: hidden;
  flex: 1;
  margin: 4px 0;
}

.item-meta {
  display: flex;
  align-items: center;
  gap: 6px;
  font-size: 12px;
  color: #bbb;
}

.meta-comment {
  display: flex;
  align-items: center;
  gap: 3px;
}

.meta-date { color: #bbb; }
.meta-divider { color: #ddd; }

/* ---- 右侧固定边栏 ---- */
.sidebar {
  flex-shrink: 0;
  width: 300px;
  position: sticky;
  top: 76px;
  display: flex;
  flex-direction: column;
  gap: 16px;
}

.sidebar-card {
  border: 1px solid #ebebeb;
  border-radius: 10px;
  padding: 20px 16px;
  background: #fff;
}

/* 个人信息卡 */
.profile-card {
  display: flex;
  flex-direction: column;
  align-items: center;
  text-align: center;
  gap: 8px;
}

.profile-avatar {
  width: 72px;
  height: 72px;
  border-radius: 50%;
  overflow: hidden;
  border: 2px solid #ebebeb;
  margin-bottom: 4px;
}

.profile-avatar img {
  width: 100%;
  height: 100%;
  object-fit: cover;
}

.profile-name {
  font-size: 15px;
  font-weight: 600;
  color: #1a1a1a;
}

.profile-sign {
  font-size: 12px;
  color: #999;
  font-style: italic;
}

.profile-bio {
  font-size: 12px;
  color: #888;
  line-height: 1.8;
  padding-top: 8px;
  border-top: 1px solid #f2f2f2;
  width: 100%;
  text-align: left;
}

.profile-stats {
  display: flex;
  align-items: center;
  justify-content: space-between;
  width: 100%;
  padding-top: 12px;
  border-top: 1px solid #f2f2f2;
  margin-top: 4px;
}

.stat-item {
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 2px;
  flex: 1;
}

.stat-num {
  font-size: 15px;
  font-weight: 600;
  color: #1a1a1a;
}

.stat-label {
  font-size: 11px;
  color: #bbb;
}

.stat-divider {
  width: 1px;
  height: 28px;
  background: #ebebeb;
}

/* 碎碎念卡 */
.sidebar-card-title {
  font-size: 14px;
  font-weight: 600;
  color: #1a1a1a;
  margin-bottom: 14px;
  padding-bottom: 10px;
  border-bottom: 1px solid #ebebeb;
}

.murmur-list {
  display: flex;
  flex-direction: column;
  gap: 14px;
}

.murmur-item {
  display: flex;
  flex-direction: column;
  gap: 4px;
}

.murmur-text {
  font-size: 12px;
  color: #555;
  line-height: 1.7;
}

.murmur-date {
  font-size: 11px;
  color: #ccc;
}
</style>
