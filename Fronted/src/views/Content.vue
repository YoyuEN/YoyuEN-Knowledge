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
            <div class="card-thumb">
              <img :src="item.cover" :alt="item.title" />
              <span class="card-badge">{{ item.category }}</span>
            </div>
            <div class="card-info">
              <div class="card-title">{{ item.title }}</div>
              <div class="card-desc">{{ item.desc }}</div>
              <div class="card-meta">
                <span class="meta-date">{{ item.date }}</span>
                <span class="meta-divider">·</span>
                <span class="meta-comment">{{ item.comments }} 评论</span>
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
import { ref } from 'vue'
import { useRouter } from 'vue-router'

const router = useRouter()
const placeholder = 'https://picsum.photos/seed/'

const categoryTypeMap = { '文章': 'article', '游戏': 'game', '学习': 'study', '视频': 'video' }

const goToDetail = (item, type) => {
  router.push({ name: 'ContentDetail', params: { type, id: item.id } })
}

const recommendList = ref([
  { id: 1, title: 'Vue 3 全面升级指南', desc: '从 Vue 2 迁移到 Vue 3 的完整方案与最佳实践', date: '2026-02-20', comments: 38, category: '文章', cover: placeholder + 'vue/400/220' },
  { id: 2, title: '原神新版本攻略', desc: '4.5 版本全新角色技能机制与队伍搭配思路', date: '2026-02-18', comments: 62, category: '游戏', cover: placeholder + 'game/400/220' },
  { id: 3, title: 'Spring Boot 微服务实战', desc: '从零搭建企业级微服务架构，覆盖网关、注册中心等', date: '2026-02-15', comments: 24, category: '学习', cover: placeholder + 'java/400/220' },
  { id: 4, title: '摄影后期调色技巧', desc: '5 分钟学会 Lightroom 高级调色，让照片更有质感', date: '2026-02-12', comments: 17, category: '视频', cover: placeholder + 'photo/400/220' },
])

const articleList = ref([
  { id: 1, title: 'TypeScript 高级类型体操入门', desc: '通过实际案例理解条件类型、映射类型与模板字面量类型，提升代码可维护性。', date: '2026-02-22', comments: 45, cover: placeholder + 'ts/120/80' },
  { id: 2, title: 'Docker + Nginx 前端部署最佳实践', desc: '一文搞定容器化部署流程，涵盖多阶段构建、反向代理与 HTTPS 配置。', date: '2026-02-19', comments: 31, cover: placeholder + 'docker/120/80' },
  { id: 3, title: '算法每日一题：动态规划系列', desc: '整理了 LeetCode 上经典 DP 题型，附详细解题思路与复杂度分析。', date: '2026-02-16', comments: 19, cover: placeholder + 'algo/120/80' },
])

const gameList = ref([
  { id: 1, title: '艾尔登法环 DLC 全 Boss 攻略', desc: '影之地全 BOSS 详细打法、武器推荐与伤害机制解析，新手必看。', date: '2026-02-21', comments: 87, cover: placeholder + 'elden/120/80' },
  { id: 2, title: '黑神话：悟空 性能优化设置', desc: '高帧率与高画质如何兼得？提供各显卡档次的推荐配置方案。', date: '2026-02-17', comments: 53, cover: placeholder + 'wukong/120/80' },
  { id: 3, title: '星穹铁道 2.3 版本角色强度榜', desc: '最新版本各角色 T 档评级，附组队思路与遗器推荐。', date: '2026-02-13', comments: 42, cover: placeholder + 'hsr/120/80' },
])

const studyList = ref([
  { id: 1, title: 'Redis 缓存穿透、击穿与雪崩详解', desc: '深入理解三大缓存问题的触发场景与对应解决方案，面试高频题。', date: '2026-02-23', comments: 28, cover: placeholder + 'redis/120/80' },
  { id: 2, title: 'MySQL 索引失效的 10 个场景', desc: '结合 EXPLAIN 执行计划，逐一分析索引失效原因及优化建议。', date: '2026-02-20', comments: 36, cover: placeholder + 'mysql/120/80' },
  { id: 3, title: 'React Hooks 深度解析', desc: 'useState、useEffect、useCallback、useMemo 原理与最佳实践。', date: '2026-02-14', comments: 22, cover: placeholder + 'react/120/80' },
])

const videoList = ref([
  { id: 1, title: '手撕 LRU 缓存算法', desc: '用 Map + 双向链表实现 O(1) 操作的 LRU，配合动画演示讲解。', date: '2026-02-24', comments: 15, cover: placeholder + 'lru/120/80' },
  { id: 2, title: '我的 2025 年度总结', desc: '记录这一年的技术成长、生活感悟与新年计划，欢迎一起交流。', date: '2026-02-11', comments: 33, cover: placeholder + 'vlog/120/80' },
  { id: 3, title: 'Gym 健身入门：如何制定训练计划', desc: '从零开始的健身指南，动作讲解 + 饮食建议，适合健身新手。', date: '2026-02-08', comments: 20, cover: placeholder + 'gym/120/80' },
])

const murmurList = ref([
  { id: 1, text: '今天终于把 Redis 哨兵模式搞明白了，感觉打通了任督二脉 🎉', date: '02-26' },
  { id: 2, text: '健身第 30 天，发现坚持比方法更重要，先动起来再说。', date: '02-25' },
  { id: 3, text: '翻了翻以前写的代码，真的有种想删库跑路的冲动……', date: '02-24' },
  { id: 4, text: '春天来了，适合出去拍照，准备周末去公园走走。', date: '02-23' },
  { id: 5, text: '推荐一首歌：Nuvole Bianche，写代码听这个太合适了。', date: '02-22' },
])
</script>

<style scoped>
/* ---- 整体布局 ---- */
.page-wrapper {
  display: flex;
  gap: 24px;
  margin: 0 auto;
  padding: 80px 24px 48px;
  align-items: flex-start;
  background: #fff;
  min-height: 100vh;
}

/* ---- 左侧内容 ---- */
.content-main {
  flex: 1;
  min-width: 0;
}

/* ---- 模块公共 ---- */
.module {
  margin-bottom: 48px;
}

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
  border: 1px solid #ebebeb;
  border-radius: 8px;
  overflow: hidden;
  cursor: pointer;
  transition: box-shadow 0.2s;
}

.recommend-card:hover {
  box-shadow: 0 4px 16px rgba(0, 0, 0, 0.08);
}

.card-thumb {
  position: relative;
  width: 100%;
  height: 140px;
  overflow: hidden;
  background: #f5f5f5;
}

.card-thumb img {
  width: 100%;
  height: 100%;
  object-fit: cover;
}

.card-badge {
  position: absolute;
  top: 10px;
  left: 10px;
  background: rgba(0, 0, 0, 0.55);
  color: #fff;
  font-size: 11px;
  padding: 2px 8px;
  border-radius: 20px;
}

.card-info {
  padding: 12px 14px;
}

.card-title {
  font-size: 14px;
  font-weight: 600;
  color: #1a1a1a;
  margin-bottom: 6px;
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
}

.card-desc {
  font-size: 12px;
  color: #888;
  line-height: 1.6;
  display: -webkit-box;
  -webkit-line-clamp: 2;
  line-clamp: 2;
  -webkit-box-orient: vertical;
  overflow: hidden;
  margin-bottom: 8px;
}

.card-meta {
  display: flex;
  align-items: center;
  gap: 6px;
  font-size: 12px;
  color: #bbb;
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
