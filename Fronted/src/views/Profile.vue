<template>
  <div class="profile-container">
    <div class="profile-header">
      <div class="user-info-container">
        <!-- 头像和基本信息 -->
        <div class="user-header">
          <div class="avatar">
            <img src="/src/assets/picture/YoyuEN.png" alt="用户头像" />
          </div>
          <div class="user-basic">
            <h3>YoyuEN</h3>
            <p class="user-signature">宁鸣而死，不默而生！</p>           
          </div>
        </div>
        <div class="welcome-container">
           <p class="user-welcome">欢迎来到我的知识空间！这里记录着我的学习历程、技术探索和生活感悟。希望我的分享能给你带来一些启发和帮助。</p>
        </div>
        <!-- 详细信息卡片 -->
        <div class="info-cards">
          <div class="info-card">
            <h4>个人信息</h4>
            <div class="card-content">
              <div class="info-row">
                <span>北方民族大学 · 软件工程</span>
              </div>
              <div class="info-row">
                <span>15839393171@163.com</span>
              </div>
              <div class="info-row">
                <span>北京 · 昌平</span>
              </div>
            </div>
          </div>

          <div class="info-card">
            <h4>技术栈</h4>
            <div class="card-content">
              <div class="tags-wrapper">
                <span v-for="tech in techStack" :key="tech" class="tech-tag">{{ tech }}</span>
              </div>
            </div>
          </div>

          <div class="info-card">
            <h4>个人标签</h4>
            <div class="card-content">
              <div class="tags-wrapper">
                <span v-for="tag in tags" :key="tag" class="tech-tag">{{ tag }}</span>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
    <div class="profile-content">
      <div class="profile-row">
        <div class="profile-item profile-item--data">
          <h3>网站数据</h3>
          <!-- 网站数据 -->
          <div class="website-data">
            <!-- 文章数 -->
            <div class="data-item">
              <div class="data-number">
                <n-number-animation :from="0" :to="100"/>
              </div>
              <div class="data-label">文章</div>
            </div>
            <!-- 动态数 -->
            <div class="data-item">
              <div class="data-number">
                <n-number-animation :from="0" :to="1000" />
              </div>
              <div class="data-label">动态</div>
            </div>
            <!-- 评论数 -->
            <div class="data-item">
              <div class="data-number">
                <n-number-animation :from="0" :to="10000" />
              </div>
              <div class="data-label">评论</div>
            </div>
          </div>
        </div>
        <!-- 活跃度 -->
        <div class="profile-item profile-item--heatmap">
          <h3>活跃度</h3>
          <div class="heatmap-container">
            <Heatmap />
          </div>
        </div>
      </div>
      
      <!-- 照片墙 -->
      <div class="profile-item">
        <h3>照片墙</h3>
        <div class="photo-wall-container">
          <div
            v-for="(photo, index) in photos"
            :key="photo.id"
            class="photo-item"
            :style="{ animationDelay: `${index * 0.1}s` }"
          >
            <n-image :src="photo.url" :alt="photo.description || '照片'" />
          </div>
        </div>
      </div>
    </div>
  </div>
</template>
<script setup lang="ts">
import { ref, onMounted } from "vue";
import Heatmap from "../components/Heatmap.vue";
import { fetchPhotoList } from "../api/photo/photo.js";

const photos = ref([]);

onMounted(async () => {
  try {
    const res = await fetchPhotoList();
    photos.value = res.data || [];
  } catch (e) {
    console.error("获取照片列表失败", e);
  }
});

// 技术栈
const techStack = ref([
  "Vue.js",
  "React",
  "TypeScript",
  "Node.js",
  "Python",
  "Java",
  "MySQL",
  "Git"
]);

// 标签
const tags = ref([
  "玄不救非,氪不改命",
  "男神",
  "手工",
  "天然呆",
  "篮球",
  "Running",
  "Gym",
]);
</script>
<style scoped>
/* 头像浮动动画 */
@keyframes float {
  0%, 100% {
    transform: translateY(0px);
  }
  50% {
    transform: translateY(-10px);
  }
}

/* 光环流动动画 */
@keyframes shimmer {
  0% {
    background-position: -200% center;
  }
  100% {
    background-position: 200% center;
  }
}

/* 照片墙淡入动画 */
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

.profile-container {
  width: 100%;
}

.profile-header {
  display: flex;
  align-items: center;
  justify-content: center;
  width: 100%;
  height: 700px;
  background: url("/src/assets/picture/image.png") no-repeat center center;
  background-size: cover;
  padding: 80px;
}

.user-info-container {
  max-width: 1200px;
  width: 100%;
  display: flex;
  flex-direction: column;
  gap: 30px;
  position: relative;
  z-index: 1;
}

.user-header {
  display: flex;
  align-items: flex-start;
  gap: 40px;
  margin-bottom: 30px;
}

.user-basic {
  flex: 1;
  display: flex;
  flex-direction: column;
  gap: 16px;
}

.user-basic h3 {
  font-family: "快看世界体";
  font-size: 36px;
  color: rgba(255, 255, 255, 0.98);
  text-shadow: 0 3px 12px rgba(0, 0, 0, 0.4);
  margin: 0;
  letter-spacing: 1px;
}

.user-signature {
  font-size: 18px;
  color: rgba(255, 255, 255, 0.92);
  text-shadow: 0 2px 6px rgba(0, 0, 0, 0.4);
  font-style: italic;
  margin: 0;
  font-weight: 500;
}

.welcome-container {
  width: 100%;
  animation: fadeInUp 0.8s ease-out 0.3s backwards;
}

@keyframes fadeInUp {
  from {
    opacity: 0;
    transform: translateY(20px);
  }
  to {
    opacity: 1;
    transform: translateY(0);
  }
}

.user-welcome {
  font-size: 15px;
  color: rgba(255, 255, 255, 0.9);
  text-shadow: 0 2px 6px rgba(0, 0, 0, 0.4);
  line-height: 2;
  margin: 0;
  padding: 20px 24px;
  background: rgba(255, 255, 255, 0.12);
  backdrop-filter: blur(15px);
  border-radius: 16px;
  border: 1px solid rgba(255, 255, 255, 0.25);
  box-shadow: 0 4px 16px rgba(0, 0, 0, 0.15);
  transition: all 0.3s ease;
  position: relative;
  overflow: hidden;
}

.user-welcome::before {
  content: '';
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  height: 1px;
  background: linear-gradient(90deg, transparent, rgba(255, 255, 255, 0.3), transparent);
}

.user-welcome:hover {
  background: rgba(255, 255, 255, 0.15);
  transform: translateY(-2px);
  box-shadow: 0 6px 20px rgba(0, 0, 0, 0.2);
}

.info-cards {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(320px, 1fr));
  gap: 24px;
}

.info-card {
  background: rgba(255, 255, 255, 0.15);
  backdrop-filter: blur(20px);
  border-radius: 16px;
  padding: 20px;
  border: 1px solid rgba(255, 255, 255, 0.2);
  transition: all 0.3s ease;
}

.info-card:hover {
  background: rgba(255, 255, 255, 0.2);
  transform: translateY(-4px);
  box-shadow: 0 8px 24px rgba(0, 0, 0, 0.2);
}

.info-card h4 {
  font-size: 16px;
  color: rgba(255, 255, 255, 0.95);
  text-shadow: 0 2px 4px rgba(0, 0, 0, 0.3);
  margin: 0 0 16px 0;
  font-weight: 600;
}

.card-content {
  display: flex;
  flex-direction: column;
  gap: 12px;
}

.info-row {
  display: flex;
  align-items: center;
  gap: 10px;
  font-size: 14px;
  color: rgba(255, 255, 255, 0.9);
  text-shadow: 0 2px 4px rgba(0, 0, 0, 0.3);
}

.tags-wrapper {
  display: flex;
  flex-wrap: wrap;
  gap: 8px;
}

.avatar {
  width: 120px;
  height: 120px;
  border-radius: 50%;
  border: 4px solid white;
  position: relative;
  animation: float 3s ease-in-out infinite;
  transition: all 0.4s ease;
  cursor: pointer;
  flex-shrink: 0;
}

/* 头像光环效果 */
.avatar::before {
  content: "";
  position: absolute;
  inset: -8px;
  border-radius: 50%;
  background: linear-gradient(45deg, #667eea, #764ba2, #f093fb, #4facfe, #667eea);
  background-size: 300% 300%;
  opacity: 0;
  z-index: -1;
  transition: opacity 0.4s ease;
  animation: shimmer 3s linear infinite;
  filter: blur(10px);
}

.avatar:hover::before {
  opacity: 0.8;
}

.avatar:hover {
  transform: scale(1.1) rotate(5deg);
  box-shadow: 0 10px 30px rgba(0, 0, 0, 0.3);
}

.avatar img {
  width: 100%;
  height: 100%;
  border-radius: 50%;
  transition: all 0.4s ease;
}

.avatar:hover img {
  filter: brightness(1.1);
}

.tech-tag {
  background: rgba(255, 255, 255, 0.25);
  backdrop-filter: blur(10px);
  padding: 6px 14px;
  border-radius: 20px;
  font-size: 13px;
  color: white;
  text-shadow: 0 1px 2px rgba(0, 0, 0, 0.3);
  transition: all 0.3s ease;
  cursor: pointer;
}

.tech-tag:hover {
  background: rgba(255, 255, 255, 0.35);
  transform: translateY(-2px);
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.2);
}

.profile-content {
  margin-top: -50px;
  background-color: white;
  border-radius: 25px;
  padding: 20px 80px;
  box-shadow: 0 2px 12px rgba(0, 0, 0, 0.08);
}

.profile-row {
  display: flex;
  gap: 40px;
  align-items: flex-start;
  margin: 0 50px;
}

.profile-item {
  margin: 0 50px;
}

.profile-item--data {
  flex-shrink: 0;
  margin: 0;
  width: 1000px;
}

.profile-item--heatmap {
  flex: 1;
  margin: 0;
  min-width: 0;
}

.profile-item h3 {
  color: #333;
  padding: 20px 0;
  border-bottom: 1px solid #e0e0e0;
  margin-bottom: 20px;
}

.heatmap-container {
  width: 100%;
}

.website-data {
  display: flex;
  justify-content: space-around;
  gap: 40px;
  padding: 20px 0;
}

.data-item {
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 10px;
}

.data-number {
  font-size: 32px;
  font-weight: bold;
  color: #333;
}

.data-label {
  font-size: 14px;
  color: #666;
}

.photo-wall-container {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
  gap: 20px;
  padding: 10px 0;
}

.photo-item {
  position: relative;
  overflow: hidden;
  border-radius: 12px;
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
  transition: all 0.3s ease;
  animation: fadeInUp 0.6s ease-out backwards;
  cursor: pointer;
}

.photo-item:hover {
  transform: translateY(-8px) scale(1.02);
  box-shadow: 0 12px 24px rgba(0, 0, 0, 0.15);
}

.photo-item::before {
  content: "";
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background: linear-gradient(135deg, rgba(102, 126, 234, 0.1), rgba(118, 75, 162, 0.1));
  opacity: 0;
  transition: opacity 0.3s ease;
  z-index: 1;
  pointer-events: none;
}

.photo-item:hover::before {
  opacity: 1;
}

.photo-item :deep(.n-image) {
  width: 100%;
  height: 100%;
  display: block;
}

.photo-item :deep(.n-image img) {
  width: 100%;
  height: 100%;
  object-fit: cover;
  transition: transform 0.3s ease;
}

.photo-item:hover :deep(.n-image img) {
  transform: scale(1.05);
}

.photo-items {
  width: 100%;
  display: flex;
  flex-wrap: wrap;
  justify-content: flex-start;
  gap: 20px;
}

.n-image {
  width: 100%;
  height: 100%;
  border-radius: 10px;
}
</style>