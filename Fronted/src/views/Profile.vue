<template>
  <div class="profile-container">
    <div class="profile-header">
      <div class="user-info-container">
        <div class="user-info">
          <!-- 用户头像 -->
          <div class="avatar">
            <img src="/src/assets/picture/YoyuEN.png" alt="用户头像" />
          </div>
          <!-- 用户信息 -->
          <div class="user-info-content">
            <h3>YoyuEN</h3>
          </div>

          <!-- 邮箱 -->
          <div class="user-info-content">
            <p>15839393171@163.com</p>
          </div>
        </div>

        <!-- 标签 -->
        <div class="tags-container">
          <div v-for="value in tags" :key="value" class="tag-item">
            <span>{{ value }}</span>
          </div>
        </div>
      </div>
      <div class="user-info-content">
        <p>就读于北方民族大学,软件工程专业。 宁鸣而死,不默而生!</p>
      </div>
    </div>
    <div class="profile-content">
      <div class="profile-item">
        <h3>网站数据</h3>
        <!-- 网站数据 -->
        <div class="website-data">
          <!-- 文章数 -->
          <div class="data-item">
            <div class="data-number">
              <n-number-animation :from="0" :to="100" />
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
      <div class="profile-item">
        <h3>活跃度</h3>
        <div class="heatmap-container">
          <Heatmap />
        </div>
      </div>
      
      <!-- 照片墙 -->
      <div class="profile-item">
        <h3>照片墙</h3>
        <div class="photo-wall-container">
          <div
            v-for="(photo, index) in photos"
            :key="photo"
            class="photo-item"
            :style="{ animationDelay: `${index * 0.1}s` }"
          >
            <n-image :src="photo" alt="照片" />
          </div>
        </div>
      </div>
    </div>
  </div>
</template>
<script setup lang="ts">
import { ref } from "vue";
import Heatmap from "../components/Heatmap.vue";

const photos = ref([
  "/src/assets/picture/life1.jpg",
  "/src/assets/picture/life2.jpg",
  "/src/assets/picture/life3.jpg",
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
  width: 100%;
  height: 400px;
  background: url("/src/assets/picture/image.png") no-repeat center center;
  background-size: cover;
  padding: 80px;
}

.avatar {
  width: 100px;
  height: 100px;
  border-radius: 50%;
  margin-top: 50px;
  margin-left: 50px;
  border: 4px solid white;
  position: relative;
  animation: float 3s ease-in-out infinite;
  transition: all 0.4s ease;
  cursor: pointer;
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

.user-info {
  display: grid;
  align-items: center;
  width: 20%;
}

.user-info-content {
  margin-top: 20px;
  margin-left: 50px;
}

.user-info-content h3 {
  font-family: "快看世界体";
  font-size: 12px;
  color: rgba(255, 255, 255, 0.9);
  text-shadow: 0 2px 4px rgba(0, 0, 0, 0.3);
}

.user-info-content p {
  font-size: 12px;
  color: rgba(255, 255, 255, 0.9);
  text-shadow: 0 2px 4px rgba(0, 0, 0, 0.3);
}

.tags-container {
  display: flex;
  gap: 10px;
  margin-top: 20px;
  flex-wrap: wrap; /* 自动换行 */
  margin-left: 50px;
}

.tag-item {
  background-color: rgba(255, 255, 255, 0.2); /* 半透明白色背景 */
  padding: 6px 12px;
  border-radius: 20px; /* 圆角 */
  backdrop-filter: blur(5px); /* 毛玻璃效果,适配背景 */
}

.tag-item span {
  color: white;
  font-size: 14px;
  text-shadow: 0 1px 2px rgba(0, 0, 0, 0.3);
}

.profile-content {
  margin-top: -50px;
  background-color: white;
  border-radius: 25px;
  padding: 20px 80px;
  box-shadow: 0 2px 12px rgba(0, 0, 0, 0.08);
}

.profile-item {
  margin: 0 50px;
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