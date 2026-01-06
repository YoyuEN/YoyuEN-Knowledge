<template>
  <div class="knowledge-blog-container">
    <div class="blog-grid">
      <div v-for="blog in blogList" :key="blog.id" class="blog-card">
        <div class="card-image">
          <img :src="blog.image" :alt="blog.title" />
          <div class="card-overlay"></div>
          <div class="time-badge">{{ blog.time }}</div>
          <div class="author-avatar" v-if="blog.avater">
            <img :src="blog.avater" alt="Author" />
          </div>
          <div class="comment-count" v-if="blog.comments">
            <el-icon><ChatLineRound /></el-icon>
            <span>{{ blog.comments }}</span>
          </div>
          <div class="card-content">
            <h3 class="card-title">{{ blog.title }}</h3>
            <p class="card-summary" v-if="blog.summary">{{ blog.summary.length > 40 ? blog.summary.slice(0, 40) + '...' : blog.summary }}</p>
            <div class="card-tags">
              <el-tag v-for="tag in blog.tags" :key="tag" type="info" size="small" effect="plain">
                {{ tag }}
              </el-tag>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref } from 'vue'
import { ChatLineRound } from '@element-plus/icons-vue'

const blogList = ref([
  {
    id: 1,
    image: new URL('../assets/picture/微信图片_20240504221829.jpg', import.meta.url).href,
    avater: new URL('../assets/picture/YoyuEN.png', import.meta.url).href,
    title: '圣人之道 "为而不争"，基础教育就该守好这份纯种',
    summary: '圣人之道，为而不争。夫唯不争，故天下莫能与之争。基础教育应坚守初心，培养纯粹的求知精神。',
    time: '3周前',
    comments: 12,
    tags: ['学习', '教师生活', '思考', '悟悟']
  },
  {
    id: 2,
    image: new URL('../assets/picture/微信图片_20240504222510.jpg', import.meta.url).href,
    avater: new URL('../assets/picture/YoyuEN.png', import.meta.url).href,
    title: '物质的变化和性质 第一课时',
    summary: '本节课主要介绍物质的变化和性质，包括物理变化、化学变化、物理性质和化学性质的概念及区别。',
    time: '9月前',
    comments: 8,
    tags: ['学习', '知识点', '化学', '初中']
  },
  {
    id: 3,
    image: new URL('../assets/picture/微信图片_20240504222657.jpg', import.meta.url).href,
    avater: new URL('../assets/picture/YoyuEN.png', import.meta.url).href,
    title: '绪论：化学使世界变得更加绚丽多彩',
    summary: '化学是一门神奇的学科，它不仅改变了我们的生活，也让世界变得更加五彩斑斓。让我们一起走进化学的世界。',
    time: '9月前',
    comments: 5,
    tags: ['学习', '化学', '初中', '知识点']
  },
  {
    id: 4,
    image: new URL('..//assets/picture/微信图片_20240504222750.jpg', import.meta.url).href,
    avater: new URL('../assets/picture/YoyuEN.png', import.meta.url).href,
    title: '学习方法探讨',
    summary: '探讨高效的学习方法，帮助学生提高学习效率，掌握科学的学习技巧，从容应对各种考试和挑战。',
    time: '1个月前',
    comments: 7,
    tags: ['学习', '方法', '效率']
  },
  {
    id: 5,
    image: new URL('../assets/picture/微信图片_20240504221829.jpg', import.meta.url).href,
    avater: new URL('../assets/picture/YoyuEN.png', import.meta.url).href,
    title: '教师职业发展路径',
    summary: '分析教师职业发展的不同阶段和路径，为青年教师提供职业规划建议，助力教师成长与发展。',
    time: '2个月前',
    comments: 10,
    tags: ['教育', '职业', '发展']
  },
  {
    id: 6,
    image: new URL('../assets/picture/微信图片_20240504221829.jpg', import.meta.url).href,
    avater: new URL('../assets/picture/YoyuEN.png', import.meta.url).href,
    title: '知识体系构建指南',
    summary: '如何构建系统的知识体系？本文将从知识获取、整理、内化等方面为您提供详细的指导和建议。',
    time: '3个月前',
    comments: 42,
    tags: ['学习', '知识', '系统']
  },
  {
    id: 7,
    image: new URL('../assets/picture/微信图片_20240504222510.jpg', import.meta.url).href,
    avater: new URL('../assets/picture/YoyuEN.png', import.meta.url).href,
    title: '高效时间管理技巧',
    time: '4个月前',
    comments: 15,
    tags: ['效率', '时间管理', '技巧']
  },
  {
    id: 8,
    image: new URL('../assets/picture/微信图片_20240504222657.jpg', import.meta.url).href,
    avater: new URL('../assets/picture/YoyuEN.png', import.meta.url).href,
    title: '创新思维培养方法',
    summary: '创新思维是新时代的核心竞争力。本文探讨如何培养创新思维，激发潜能，创造更多可能。',
    time: '5个月前',
    comments: 12,
    tags: ['创新', '思维', '方法']
  }
])
</script>

<style scoped>
.knowledge-blog-container {
  padding: 0;
}

.blog-grid {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(400px, 1fr));
  gap: 20px;
  padding: 20px 0;
}

.blog-card {
  border-radius: 8px;
  overflow: hidden;
  background: var(--bg-primary, #fff);
  box-shadow: 0 2px 12px rgba(0, 0, 0, 0.1);
  transition: all 0.3s ease;
  cursor: pointer;
}

.blog-card:hover {
  box-shadow: 0 4px 20px rgba(0, 0, 0, 0.15);
  transform: translateY(-2px);
}

.card-image {
  position: relative;
  width: 100%;
  height: 300px;
  overflow: hidden;
  background: #f0f0f0;
}

.card-image img {
  width: 100%;
  height: 100%;


  object-fit: cover;
  transition: transform 0.3s ease;
}



.blog-card:hover .card-image img {
  transform: scale(1.05);
}

.card-overlay {
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background: linear-gradient(to bottom,
      rgba(0, 0, 0, 0) 0%,
      rgba(0, 0, 0, 0.2) 50%,
      rgba(0, 0, 0, 0.7) 100%);
  transition: background 0.3s ease;
}

.blog-card:hover .card-overlay {
  background: linear-gradient(to bottom,
      rgba(0, 0, 0, 0) 0%,
      rgba(0, 0, 0, 0.3) 50%,
      rgba(0, 0, 0, 0.8) 100%);
}

.time-badge {
  position: absolute;
  top: 10px;
  right: 10px;
  background: rgba(0, 0, 0, 0.3);
  backdrop-filter: blur(10px);
  -webkit-backdrop-filter: blur(10px);
  color: #fff;
  padding: 4px 10px;
  border-radius: 4px;
  font-size: 12px;
  z-index: 2;
}

.author-avatar {
  position: absolute;
  top: 10px;
  left: 10px;
  width: 32px;
  height: 32px;
  border-radius: 50%;
  overflow: hidden;
  z-index: 2;
  border: 2px solid rgba(255, 255, 255, 0.8);
  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.2);
}

.author-avatar img {
  width: 100%;
  height: 100%;
  object-fit: cover;
}

.comment-count {
  position: absolute;
  top: 10px;
  right: 80px;
  display: flex;
  align-items: center;
  gap: 4px;
  color: #fff;
  font-size: 12px;
  background: rgba(0, 0, 0, 0.3);
  backdrop-filter: blur(10px);
  -webkit-backdrop-filter: blur(10px);
  padding: 4px 8px;
  border-radius: 4px;
  z-index: 2;
  opacity: 0;
  transform: translateY(-10px);
  transition: all 0.3s ease;
}

.blog-card:hover .comment-count {
  opacity: 1;
  transform: translateY(0);
}

.card-content {
  padding: 16px;
}

.card-title {
  margin: 0 0 12px 0;
  font-size: 14px;
  font-weight: 600;
  color: #fff;
  line-height: 1.4;
  display: -webkit-box;
  -webkit-line-clamp: 2;
  -webkit-box-orient: vertical;
  overflow: hidden;
  position: absolute;
  bottom: 40px;
  left: 16px;
  right: 16px;
  z-index: 2;
  transition: all 0.3s ease;
  opacity: 1;
  transform: translateY(0);
}

.card-summary {
  margin: 0 0 12px 0;
  font-size: 13px;
  color: #e0e0e0;
  line-height: 1.5;
  position: absolute;
  bottom: 40px;
  left: 16px;
  right: 16px;
  z-index: 2;
  opacity: 0;
  transform: translateY(10px);
  transition: all 0.3s ease;
  pointer-events: none;
  display: -webkit-box;
  -webkit-line-clamp: 3;
  -webkit-box-orient: vertical;
  overflow: hidden;
}

.blog-card:hover .card-title {
  opacity: 0;
  transform: translateY(-10px);
}

.blog-card:hover .card-summary {
  opacity: 1;
  transform: translateY(0);
}

.card-tags {
  display: flex;
  flex-wrap: wrap;
  gap: 6px;
  position: absolute;
  bottom: 10px;
  left: 16px;
  right: 16px;
  z-index: 2;
}

/* 去掉 el-tag 背景，改为透明文字样式（适配 scoped） */
.card-tags ::v-deep .el-tag {
  background: transparent !important;
  color: #fff !important;
  border: none !important;
  padding: 2px 8px !important;
  box-shadow: none !important;
}
</style>
