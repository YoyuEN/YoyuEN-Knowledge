<template>
  <div class="detail-container">
    <!-- 文章内容 -->
    <div v-if="data && data.type === 'article'" class="article-detail">
      <!-- 文章封面 -->
      <div class="article-cover">
        <el-image :src="data.cover" fit="cover"></el-image>
      </div>

      <!-- 文章内容容器 -->
      <div class="article-content-container">
        <!-- 文章标题 -->
        <h1 class="article-title">{{ data.title }}</h1>

        <!-- 文章元信息 -->
        <div class="article-meta">
          <!-- 标签 -->
          <div class="article-tags">
            <el-tag
              v-for="(tag, index) in data.tags"
              :key="index"
              type="primary"
              size="small"
            >
              {{ tag }}
            </el-tag>
          </div>

          <!-- 作者信息 -->
          <div class="article-author">
            <el-avatar :src="data.author.avatar" size="small"></el-avatar>
            <span class="author-name">{{ data.author.name }}</span>
          </div>

          <!-- 发布时间和字数 -->
          <div class="article-info">
            <span class="article-time">{{ data.time }}</span>
            <span class="article-word-count">{{ data.wordCount }}字</span>
          </div>
        </div>

        <!-- 文章摘要 -->
        <div class="article-summary">
          <h3>摘要</h3>
          <p>{{ data.summary }}</p>
        </div>

        <!-- AI总结 -->
        <div class="article-ai-summary">
          <h3>AI总结</h3>
          <div class="ai-summary-content">
            <p>{{ data.aiSummary }}</p>
          </div>
        </div>

        <!-- 文章正文 -->
        <div class="article-main-content">
          <div v-html="renderMarkdown(data.content)"></div>
        </div>
      </div>
    </div>

    <!-- 游戏内容 -->
    <div v-else-if="data && data.type === 'game'" class="game-detail">
      <!-- 游戏封面 -->
      <div class="game-cover">
        <el-image :src="data.cover" fit="cover"></el-image>
      </div>

      <!-- 游戏内容容器 -->
      <div class="game-content-container">
        <!-- 游戏标题 -->
        <h1 class="game-title">{{ data.name }}</h1>

        <!-- 游戏元信息 -->
        <div class="game-meta">
          <!-- 分类标签 -->
          <div class="game-category">
            <el-tag type="success" size="small">{{ data.category }}</el-tag>
            <el-tag
              v-if="data.status"
              :type="data.status === '已上线' ? 'primary' : 'warning'"
              size="small"
              >{{ data.status }}</el-tag
            >
          </div>
        </div>

        <!-- 游戏简介 -->
        <div class="game-description">
          <h3>游戏简介</h3>
          <p>{{ data.description }}</p>
        </div>

        <!-- 游戏详细介绍 -->
        <div class="game-introduction">
          <h3>详细介绍</h3>
          <p>{{ data.introduction }}</p>
        </div>

        <!-- 配置要求 -->
        <div class="game-requirements">
          <h3>配置要求</h3>
          <ul>
            <li><strong>操作系统：</strong>{{ data.requirements.os }}</li>
            <li><strong>CPU：</strong>{{ data.requirements.cpu }}</li>
            <li><strong>内存：</strong>{{ data.requirements.ram }}</li>
            <li><strong>存储空间：</strong>{{ data.requirements.storage }}</li>
          </ul>
        </div>
      </div>
    </div>
    <div v-else-if="data === null" class="error-message">
      <el-empty description="未找到相关内容" :image-size="200"></el-empty>
      <el-button
        type="primary"
        @click="$router.push('/')"
        style="margin-top: 20px"
      >
        返回首页
      </el-button>
    </div>
    <div v-else class="loading">
      <el-skeleton :rows="8" animated />
    </div>

    <!-- 评论模块 -->
    <div v-if="data" class="comments-section">
      <div class="comments-header">
        <h2 class="comments-title">评论</h2>
        <span class="comments-count">{{ getTotalComments() }}条评论</span>
      </div>

      <!-- 评论表单 -->
      <div class="comment-form-container">
        <el-form :model="newComment" label-position="top">
          <el-form-item label="评论内容" required>
            <!-- 评论工具栏 -->
            <div class="comment-toolbar">
              <div class="toolbar-left">
                <!-- 直接展示一排表情 -->
                <div class="inline-emoji-picker">
                  <span
                    v-for="emoji in emojis.slice(0, 10)"
                    :key="emoji"
                    class="emoji-item"
                    @click="addEmoji(emoji)"
                  >
                    {{ emoji }}
                  </span>
                  <el-button
                    type="text"
                    size="small"
                    @click="toggleEmojiPicker"
                    class="emoji-expand-btn"
                  >
                    ...
                  </el-button>
                </div>
              </div>
              <div class="toolbar-right">
                <!-- 上传组件改为小图标 -->
                <el-upload
                  action="#"
                  list-type="picture-card"
                  :auto-upload="false"
                  :on-change="handleImageChange"
                  accept="image/*"
                  :limit="1"
                  class="image-upload-btn"
                >
                  <div style="width: 20px; height: 20px; font-size: 16px">
                    📷
                  </div>
                </el-upload>
              </div>
            </div>
            <!-- 完整表情选择器 -->
            <el-popover
              v-model:visible="showEmojiPicker"
              placement="top"
              :width="'300px'"
              trigger="click"
            >
              <div class="emoji-picker">
                <span
                  v-for="emoji in emojis"
                  :key="emoji"
                  class="emoji-item"
                  @click="addEmoji(emoji)"
                >
                  {{ emoji }}
                </span>
              </div>
            </el-popover>

            <!-- 提交评论按钮 -->
            <el-button
              type="primary"
              @click="submitComment"
              :disabled="!newComment.content.trim()"
              class="submit-comment-btn"
            >
              发布评论
            </el-button>
            <el-input
              v-model="newComment.content"
              type="textarea"
              :rows="4"
              placeholder="分享您的想法..."
              resize="none"
              class="comment-textarea"
            ></el-input>
          </el-form-item>
        </el-form>
      </div>

      <!-- 评论区列表 -->
      <div class="comment-sections-list">
        <!-- 每个主评论作为独立评论区 -->
        <div
          v-for="mainComment in comments"
          :key="mainComment.id"
          class="single-comment-section"
        >
          <!-- 评论区内容列表 -->
          <div class="comment-section-content">
            <!-- 第一条评论：对文章的评论 -->
            <div class="comment-item">
              <div class="comment-avatar">
                <el-avatar :src="mainComment.avatar" size="medium"></el-avatar>
              </div>
              <div class="comment-content">
                <div class="comment-header">
                  <div class="comment-meta">
                    <span class="comment-author">{{ mainComment.author }}</span>
                    <span class="comment-time">{{ mainComment.time }}</span>
                  </div>
                  <!-- 回复按钮 -->
                  <div class="comment-actions">
                    <el-button
                      type="text"
                      size="small"
                      @click="showReplyForm(mainComment.id, mainComment.author)"
                      :icon="ChatDotRound"
                    >
                    </el-button>
                  </div>
                </div>
                <div
                  class="comment-text"
                  v-html="renderMarkdown(mainComment.content)"
                ></div>
              </div>
            </div>

            <!-- 其他评论：对评论的评论 -->
            <div v-if="mainComment.replies && mainComment.replies.length > 0">
              <div
                v-for="reply in mainComment.replies"
                :key="reply.id"
                class="comment-item"
              >
                <div class="comment-avatar">
                  <el-avatar :src="reply.avatar" size="small"></el-avatar>
                </div>
                <div class="comment-content">
                  <div class="comment-header">
                    <div class="comment-meta">
                      <span class="comment-author">{{ reply.author }}</span>
                      <span class="comment-time">{{ reply.time }}</span>
                    </div>
                    <!-- 回复按钮 -->
                    <div class="comment-actions">
                      <el-button
                        type="text"
                        size="small"
                        @click="showReplyForm(mainComment.id, reply.author)"
                        :icon="ChatDotRound"
                      >
                      </el-button>
                    </div>
                  </div>
                  <div class="comment-text">
                    <span class="reply-to">回复 @{{ reply.replyTo }}：</span>
                    <span v-html="renderMarkdown(reply.content)"></span>
                  </div>
                </div>
              </div>
            </div>
          </div>

          <!-- 回复表单 -->
          <div
            v-if="replyToCommentId === mainComment.id"
            class="reply-form-container"
          >
            <el-form :model="replyComment" label-position="top">
              <el-form-item label="回复内容" required>
                <el-input
                  v-model="replyComment.content"
                  type="textarea"
                  :rows="3"
                  :placeholder="`回复 @${replyToUsername}：`"
                  resize="none"
                ></el-input>
              </el-form-item>
              <el-form-item>
                <el-button type="primary" @click="submitReply(mainComment.id)">
                  提交回复
                </el-button>
                <el-button @click="cancelReply"> 取消 </el-button>
              </el-form-item>
            </el-form>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted, computed } from "vue";
import { useRoute } from "vue-router";
import { Download, Star, ChatDotRound } from "@element-plus/icons-vue";

// 文章数据列表（实际项目中应该从API或状态管理获取）
const articles = [
  {
    id: 1,
    title: "人工智能在游戏开发中的应用与未来趋势",
    tags: ["人工智能", "游戏开发", "技术趋势"],
    cover: "/src/assets/picture/image.png",
    summary:
      "本文探讨了人工智能技术在游戏开发中的应用现状、关键技术以及未来发展趋势，分析了AI如何改变游戏设计和玩家体验。",
    time: "2024-01-07",
    wordCount: 5280,
    author: {
      name: "张小明",
      avatar: "/src/assets/picture/YoyuEN.png",
    },
    aiSummary:
      "本文主要介绍了人工智能在游戏开发中的应用，包括NPC智能、 procedural content generation、玩家行为分析等方面。AI技术不仅提升了游戏的可玩性和沉浸感，还降低了开发成本。未来，随着大语言模型和强化学习的发展，游戏AI将更加智能和个性化。",
    content: `# 人工智能在游戏开发中的应用与未来趋势

## 一、引言

随着人工智能技术的快速发展，其在游戏开发中的应用越来越广泛。从早期的简单规则AI到如今的深度学习模型，人工智能已经成为现代游戏开发中不可或缺的重要组成部分。本文将探讨人工智能在游戏开发中的应用现状、关键技术以及未来发展趋势。

## 二、AI在游戏中的核心应用

### 2.1 NPC智能

传统游戏中的NPC（非玩家角色）通常只能按照预设的脚本行动，行为模式单一。而现代游戏中，AI技术使得NPC能够具备更复杂的行为和决策能力。通过使用行为树、有限状态机和强化学习等技术，NPC可以根据游戏环境和玩家行为做出动态响应，提供更加真实和具有挑战性的游戏体验。

### 2.2 程序化内容生成

程序化内容生成（PCG）是指利用算法自动生成游戏内容，如地图、关卡、道具等。AI技术的引入使得PCG更加智能和高效。通过使用生成对抗网络（GAN）和变分自编码器（VAE）等深度学习模型，可以生成更加多样化和高质量的游戏内容，大大降低了开发成本，同时增加了游戏的可重玩性。

### 2.3 玩家行为分析

AI技术可以实时分析玩家的游戏行为数据，包括游戏风格、技能水平和偏好等。基于这些分析，游戏可以动态调整难度、提供个性化推荐，并优化游戏体验。例如，对于新手玩家，可以降低游戏难度并提供更多提示；对于高级玩家，可以增加挑战性内容以保持游戏的吸引力。

## 三、关键技术

### 3.1 深度学习

深度学习在游戏AI中的应用主要包括图像识别、自然语言处理和强化学习等。卷积神经网络（CNN）可以用于游戏场景理解和目标检测；循环神经网络（RNN）和Transformer模型可以用于NPC的自然语言交互；强化学习（RL）则可以用于训练智能游戏代理。

### 3.2 强化学习

强化学习是游戏AI中的一项重要技术，通过让AI代理在游戏环境中不断尝试和学习，优化其行为策略。DeepMind的AlphaGo和AlphaStar项目展示了强化学习在复杂游戏中的强大能力。在游戏开发中，强化学习可以用于训练NPC、设计游戏关卡和平衡游戏机制。

### 3.3 大语言模型

近年来，大语言模型（LLM）如GPT-4和Claude在游戏开发中的应用越来越受到关注。LLM可以用于生成游戏对话、剧情和任务描述，甚至可以作为游戏中的虚拟角色与玩家进行自然语言交互。这大大增强了游戏的叙事能力和沉浸感。

## 四、未来趋势

### 4.1 个性化游戏体验

未来的游戏AI将更加注重个性化体验，通过分析玩家的行为数据和偏好，为每个玩家提供量身定制的游戏内容和挑战。这将使得游戏更加具有吸引力和粘性。

### 4.2 跨游戏AI代理

随着元宇宙概念的兴起，跨游戏AI代理将成为可能。玩家可以拥有一个能够在不同游戏中通用的AI代理，该代理可以积累经验和技能，并在不同游戏环境中应用这些知识。

### 4.3 AI辅助游戏设计

AI技术将在游戏设计过程中发挥更加重要的作用，从概念设计到关卡创建，再到游戏测试和优化，AI都可以提供有力的支持。这将大大提高游戏开发效率，缩短开发周期。

## 五、结论

人工智能技术正在深刻改变游戏开发和玩家体验。从NPC智能到程序化内容生成，再到玩家行为分析，AI技术的应用使得游戏更加智能、多样化和个性化。未来，随着技术的不断发展，人工智能将在游戏领域发挥更加重要的作用，为玩家带来更加丰富和沉浸式的游戏体验。`,
  },
  {
    id: 2,
    title: "现代射击游戏的设计理念与创新",
    tags: ["游戏设计", "射击游戏", "创新"],
    cover: "/src/assets/picture/YoyuEN.png",
    summary:
      "本文分析了现代射击游戏的设计理念和创新方向，探讨了如何在保持游戏核心玩法的同时，通过叙事、机制和技术创新提升游戏体验。",
    time: "2024-01-06",
    wordCount: 4850,
    author: {
      name: "李华",
      avatar: "/src/assets/picture/YoyuEN.png",
    },
    aiSummary:
      "本文主要讨论了现代射击游戏的设计理念，包括叙事驱动的游戏设计、战术玩法创新、多人游戏体验优化等方面。作者认为，现代射击游戏不仅注重射击手感和视觉效果，更加强调游戏的叙事性和玩家之间的互动。未来，射击游戏将更加注重沉浸式体验和跨平台功能。",
    content: `# 现代射击游戏的设计理念与创新

## 一、射击游戏的演变

射击游戏作为游戏产业中的重要类型，经历了从简单的像素射击到复杂的3D战术射击的演变过程。早期的射击游戏如《太空侵略者》和《吃豆人》主要以简单的射击和躲避为核心玩法。而现代射击游戏则融合了叙事、战术、角色扮演等多种元素，提供了更加丰富和沉浸式的游戏体验。

## 二、现代射击游戏的核心设计理念

### 2.1 叙事驱动的游戏设计

现代射击游戏越来越注重叙事性，通过引人入胜的故事情节和角色塑造，增强玩家的代入感和情感连接。例如，《使命召唤》系列和《战地》系列都通过精心设计的单人战役模式，讲述了扣人心弦的战争故事。

### 2.2 战术玩法创新

传统射击游戏主要强调快速反应和精确射击，而现代射击游戏则更加注重战术策略。通过引入掩体系统、小队协作、装备定制等元素，玩家需要运用战术思维来取得胜利。例如，《彩虹六号：围攻》和《战术小队》等游戏将战术玩法发挥到了极致。

### 2.3 多人游戏体验优化

多人游戏是现代射击游戏的重要组成部分，游戏开发商通过不断优化匹配系统、平衡游戏机制和增加社交功能，提升玩家的多人游戏体验。例如，《Apex英雄》和《堡垒之夜》等游戏通过创新的战斗 royale模式，吸引了大量玩家。

## 三、技术创新对射击游戏的影响

### 3.1 图形技术的进步

随着游戏引擎和图形技术的不断发展，现代射击游戏的视觉效果越来越逼真。实时光线追踪、高动态范围渲染和物理引擎等技术的应用，使得游戏场景更加真实，增强了玩家的沉浸感。

### 3.2 网络技术的提升

网络技术的提升使得大型多人在线射击游戏成为可能。通过使用专用服务器和优化的网络协议，玩家可以在全球范围内进行流畅的多人游戏体验。此外，云游戏技术的发展也为射击游戏带来了新的可能性。

### 3.3 AI技术的应用

人工智能技术在现代射击游戏中的应用越来越广泛，包括智能NPC、程序化关卡生成和玩家行为分析等方面。AI技术不仅提升了游戏的可玩性，还降低了开发成本。

## 四、未来发展方向

### 4.1 沉浸式体验

未来的射击游戏将更加注重沉浸式体验，通过虚拟现实（VR）和增强现实（AR）技术，将玩家完全置身于游戏世界中。例如，《半衰期：爱莉克斯》和《Pavlov VR》等VR射击游戏已经展示了这种可能性。

### 4.2 跨平台功能

随着游戏平台的多样化，跨平台功能将成为射击游戏的重要发展方向。玩家可以在不同平台之间无缝切换游戏进度，与来自不同平台的玩家一起游戏。

### 4.3 游戏内经济系统

游戏内经济系统将在未来的射击游戏中发挥更加重要的作用，玩家可以通过游戏内交易获取虚拟物品和服务。区块链技术的应用也为游戏内经济系统带来了新的可能性，如非同质化代币（NFT）和去中心化金融（DeFi）等。

## 五、结论

现代射击游戏通过不断的设计理念和技术创新，为玩家提供了更加丰富和沉浸式的游戏体验。从叙事驱动的游戏设计到战术玩法创新，再到技术进步的影响，射击游戏正在不断演进和发展。未来，随着沉浸式技术和跨平台功能的发展，射击游戏将迎来新的发展机遇。`,
  },
];

// 游戏数据列表（实际项目中应该从API或状态管理获取）
const games = [
  {
    id: 1,
    name: "王者荣耀",
    category: "MOBA",
    cover: "/src/assets/picture/image.png",
    status: "已上线",
    description: "国民级MOBA手游，5V5公平对战",
    introduction:
      "《王者荣耀》是腾讯第一5V5团队公平竞技手游，国民MOBA手游大作！5V5王者峡谷、公平对战，还原MOBA经典体验；契约之战、五军对决、边境突围等，带来花式作战乐趣！10秒实时跨区匹配，与好友开黑上分，向最强王者进击！多款英雄任凭选择，一血、五杀、超神，实力碾压，收割全场！敌军即将到达战场，王者召唤师快来集结好友，准备团战，就在《王者荣耀》！",
    requirements: {
      os: "Android 5.0+/iOS 10.0+",
      cpu: "骁龙660/麒麟970",
      ram: "3GB",
      storage: "8GB",
    },
    screenshots: [
      "/src/assets/picture/image.png",
      "/src/assets/picture/image.png",
      "/src/assets/picture/image.png",
    ],
  },
  {
    id: 2,
    name: "三角洲行动",
    category: "射击",
    cover: "/src/assets/picture/YoyuEN.png",
    status: "测试中",
    description: "新一代战术射击手游",
    introduction:
      "《三角洲行动》是一款由腾讯游戏开发的新一代战术射击手游。游戏以现代战争为背景，玩家将扮演特种部队成员，参与各种高风险的军事行动。游戏拥有逼真的武器系统、丰富的战术玩法和精美的画面效果，为玩家带来沉浸式的射击游戏体验。",
    requirements: {
      os: "Android 6.0+/iOS 11.0+",
      cpu: "骁龙855/麒麟980",
      ram: "6GB",
      storage: "15GB",
    },
    screenshots: [
      "/src/assets/picture/YoyuEN.png",
      "/src/assets/picture/YoyuEN.png",
    ],
  },
  {
    id: 3,
    name: "鸣潮",
    category: "开放世界",
    cover: "/src/assets/picture/YoyuEN.png",
    status: "已上线",
    description: "高自由度的开放世界RPG",
    introduction:
      '《鸣潮》是一款由库洛游戏开发的高自由度开放世界动作RPG。游戏设定在一个被"鸣潮"灾害影响的世界，玩家将扮演"漂泊者"，探索这个充满未知和危机的世界，与各种敌人战斗，解开世界的秘密。游戏拥有流畅的战斗系统、精美的画面和丰富的剧情，为玩家带来独特的开放世界体验。',
    requirements: {
      os: "Android 7.0+/iOS 12.0+",
      cpu: "骁龙870/麒麟9000",
      ram: "8GB",
      storage: "20GB",
    },
    screenshots: [
      "/src/assets/picture/YoyuEN.png",
      "/src/assets/picture/YoyuEN.png",
      "/src/assets/picture/YoyuEN.png",
      "/src/assets/picture/YoyuEN.png",
    ],
  },
  {
    id: 4,
    name: "崩坏星穹铁道",
    category: "角色扮演",
    cover: "/src/assets/picture/YoyuEN.png",
    status: "已上线",
    description: "米哈游全新回合制RPG",
    introduction:
      "《崩坏星穹铁道》是米哈游继《原神》之后推出的全新回合制RPG。游戏设定在浩瀚的宇宙中，玩家将乘坐星穹列车，探索各个星球，与各种势力交互，参与激烈的战斗。游戏拥有精美的画面、丰富的剧情和独特的回合制战斗系统，为玩家带来全新的游戏体验。",
    requirements: {
      os: "Android 8.0+/iOS 13.0+",
      cpu: "骁龙888/麒麟9000",
      ram: "8GB",
      storage: "25GB",
    },
    screenshots: [
      "/src/assets/picture/YoyuEN.png",
      "/src/assets/picture/YoyuEN.png",
      "/src/assets/picture/YoyuEN.png",
    ],
  },
];

const route = useRoute();
const activeTab = ref("introduction");

// 根据路由参数获取数据，支持文章和游戏两种类型
const data = computed(() => {
  const id = parseInt(route.params.id);
  // 先尝试从文章数据中查找
  let result = articles.find((item) => item.id === id);
  if (result) {
    result.type = "article";
    return result;
  }
  // 如果没有找到文章，尝试从游戏数据中查找
  result = games.find((item) => item.id === id);
  if (result) {
    result.type = "game";
    return result;
  }
  return null;
});

// 评论数据列表（实际项目中应该从API获取）
const comments = ref([
  {
    id: 1,
    avatar: "/src/assets/picture/YoyuEN.png",
    author: "游戏爱好者",
    time: "2024-01-08 10:30",
    content: "这篇文章写得非常好，对AI在游戏开发中的应用分析得很深入！",
    replies: [
      {
        id: 4,
        avatar: "/src/assets/picture/YoyuEN.png",
        author: "技术专家",
        time: "2024-01-08 15:45",
        content: "我也这么认为，特别是在NPC智能方面的应用很有前景。",
      },
    ],
  },
  {
    id: 2,
    avatar: "/src/assets/picture/YoyuEN.png",
    author: "技术专家",
    time: "2024-01-08 14:20",
    content: "期待看到更多关于大语言模型在游戏中的应用案例。",
    replies: [],
  },
  {
    id: 3,
    avatar: "/src/assets/picture/YoyuEN.png",
    author: "新手玩家",
    time: "2024-01-09 09:45",
    content: "学习了很多，希望能看到更多入门级的内容。",
    replies: [],
  },
]);

// 新评论表单数据
const newComment = ref({
  content: "",
});

// 表情相关数据
const showEmojiPicker = ref(false);
const emojis = ref([
  "😊",
  "😄",
  "😁",
  "😆",
  "😅",
  "😂",
  "🤣",
  "😊",
  "😇",
  "🙂",
  "🙃",
  "😉",
  "😌",
  "😍",
  "🥰",
  "😘",
  "😗",
  "😙",
  "😚",
  "😋",
  "😛",
  "😝",
  "😜",
  "🤪",
  "🤨",
  "🧐",
  "🤓",
  "😎",
  "🤩",
  "🥳",
  "😏",
  "😒",
  "😞",
  "😔",
  "😟",
  "😕",
  "🙁",
  "☹️",
  "😣",
  "😖",
  "😫",
  "😩",
  "🥺",
  "😢",
  "😭",
  "😤",
  "😠",
  "😡",
  "🤬",
  "🤯",
  "😳",
  "🥵",
  "🥶",
  "😱",
  "😨",
  "😰",
  "😥",
  "😓",
  "🤗",
  "🤔",
  "🤭",
  "🤫",
  "🤥",
  "😶",
  "😐",
  "😑",
  "😬",
  "🙄",
  "😯",
  "😦",
  "😧",
  "😮",
  "😲",
  "🥱",
  "😴",
  "🤤",
  "😪",
  "😵",
  "🤐",
  "🥴",
  "🤢",
  "🤮",
  "🤧",
  "😷",
  "🤒",
  "🤕",
  "🤑",
  "🤠",
  "😈",
  "👿",
]);

// 切换表情选择器显示/隐藏
const toggleEmojiPicker = () => {
  showEmojiPicker.value = !showEmojiPicker.value;
};

// 添加表情到评论内容
const addEmoji = (emoji) => {
  newComment.value.content += emoji;
  showEmojiPicker.value = false;
};

// 处理图片上传
const handleImageChange = (file) => {
  // 实际项目中应该上传图片到服务器，这里简化处理
  // 创建图片URL
  const imageUrl = URL.createObjectURL(file.raw);
  // 在评论内容中添加图片链接
  newComment.value.content += `![图片](${imageUrl})`;
};

// 回复评论相关数据
const replyToCommentId = ref(null);
const replyComment = ref({
  content: "",
});

// 简单的Markdown渲染函数（实际项目中应使用专业的Markdown解析库）
const renderMarkdown = (content) => {
  // 空值检查
  if (!content) {
    return "";
  }

  let processedContent = content;
  // 替换标题
  processedContent = processedContent.replace(
    /#{6}\s(.*?)(\n|$)/g,
    "<h6>$1</h6>"
  );
  processedContent = processedContent.replace(
    /#{5}\s(.*?)(\n|$)/g,
    "<h5>$1</h5>"
  );
  processedContent = processedContent.replace(
    /#{4}\s(.*?)(\n|$)/g,
    "<h4>$1</h4>"
  );
  processedContent = processedContent.replace(
    /#{3}\s(.*?)(\n|$)/g,
    "<h3>$1</h3>"
  );
  processedContent = processedContent.replace(
    /#{2}\s(.*?)(\n|$)/g,
    "<h2>$1</h2>"
  );
  processedContent = processedContent.replace(
    /#{1}\s(.*?)(\n|$)/g,
    "<h1>$1</h1>"
  );

  // 替换图片
  processedContent = processedContent.replace(
    /!\[(.*?)\]\((.*?)\)/g,
    '<img src="$2" alt="$1" style="max-width: 100%; height: auto;" />'
  );

  // 替换内联链接
  processedContent = processedContent.replace(
    /\[(.*?)\]\((.*?)\)/g,
    '<a href="$2" target="_blank" rel="noopener noreferrer">$1</a>'
  );

  // 替换普通URL（http://或https://开头）
  processedContent = processedContent.replace(
    /(https?:\/\/[^\s]+)/g,
    '<a href="$1" target="_blank" rel="noopener noreferrer">$1</a>'
  );

  // 替换段落 - 优化正则表达式，确保正确匹配非标题、非空行
  processedContent = processedContent.replace(
    /^(?!<h[1-6]|<\/h[1-6]|\s*$)(.*?)(\n\n|$)/gm,
    "<p>$1</p>"
  );

  return processedContent;
};

// 计算总评论数（包括主评论和子评论）
const getTotalComments = () => {
  let total = comments.value.length;
  comments.value.forEach((comment) => {
    if (comment.replies && comment.replies.length > 0) {
      total += comment.replies.length;
    }
  });
  return total;
};

// 回复用户名
const replyToUsername = ref("");

// 显示回复表单
const showReplyForm = (commentId, username) => {
  replyToCommentId.value = commentId;
  replyToUsername.value = username;
  replyComment.value.content = "";
};

// 取消回复
const cancelReply = () => {
  replyToCommentId.value = null;
  replyComment.value.content = "";
};

// 提交评论
const submitComment = () => {
  // 验证评论内容
  if (!newComment.value.content.trim()) {
    return;
  }

  // 生成新评论ID
  const allComments = [...comments.value];
  comments.value.forEach((comment) => {
    if (comment.replies) {
      allComments.push(...comment.replies);
    }
  });
  const newId =
    allComments.length > 0 ? Math.max(...allComments.map((c) => c.id)) + 1 : 1;

  // 获取当前时间
  const now = new Date();
  const year = now.getFullYear();
  const month = String(now.getMonth() + 1).padStart(2, "0");
  const day = String(now.getDate()).padStart(2, "0");
  const hours = String(now.getHours()).padStart(2, "0");
  const minutes = String(now.getMinutes()).padStart(2, "0");
  const currentTime = `${year}-${month}-${day} ${hours}:${minutes}`;

  // 创建新评论对象
  const comment = {
    id: newId,
    avatar: "/src/assets/picture/YoyuEN.png", // 默认头像
    author: "匿名用户", // 默认用户名
    time: currentTime,
    content: newComment.value.content.trim(),
    replies: [], // 初始化回复数组
  };

  // 添加到评论列表开头
  comments.value.unshift(comment);

  // 清空评论表单
  newComment.value.content = "";
};

// 提交回复
const submitReply = (commentId) => {
  // 验证回复内容
  if (!replyComment.value.content.trim()) {
    return;
  }

  // 生成新回复ID
  const allComments = [...comments.value];
  comments.value.forEach((comment) => {
    if (comment.replies) {
      allComments.push(...comment.replies);
    }
  });
  const newId =
    allComments.length > 0 ? Math.max(...allComments.map((c) => c.id)) + 1 : 1;

  // 获取当前时间
  const now = new Date();
  const year = now.getFullYear();
  const month = String(now.getMonth() + 1).padStart(2, "0");
  const day = String(now.getDate()).padStart(2, "0");
  const hours = String(now.getHours()).padStart(2, "0");
  const minutes = String(now.getMinutes()).padStart(2, "0");
  const currentTime = `${year}-${month}-${day} ${hours}:${minutes}`;

  // 创建新回复对象，包含replyTo字段指向被回复的用户
  const reply = {
    id: newId,
    avatar: "/src/assets/picture/YoyuEN.png", // 默认头像
    author: "匿名用户", // 默认用户名
    time: currentTime,
    content: replyComment.value.content.trim(),
    replyTo: replyToUsername.value, // 指向被回复的用户名
  };

  // 找到对应的主评论并添加回复
  const mainComment = comments.value.find(
    (comment) => comment.id === commentId
  );
  if (mainComment) {
    if (!mainComment.replies) {
      mainComment.replies = [];
    }
    mainComment.replies.push(reply);
  }

  // 关闭回复表单
  cancelReply();
};
</script>

<style scoped>
.detail-container {
  padding: 24px;
  max-width: 1000px;
  margin: 0 auto;
}

.article-detail {
  display: flex;
  flex-direction: column;
  gap: 32px;
}

/* 文章封面样式 */
.article-cover {
  width: 100%;
  height: 350px;
  border-radius: 12px;
  overflow: hidden;
  box-shadow: 0 8px 24px rgba(0, 0, 0, 0.15);
}

.article-cover :deep(.el-image) {
  width: 100%;
  height: 100%;
}

/* 文章内容容器样式 */
.article-content-container {
  background-color: #fff;
  border-radius: 12px;
  padding: 32px;
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.08);
}

/* 文章标题样式 */
.article-title {
  margin: 0 0 24px 0;
  font-size: 36px;
  font-weight: 700;
  color: #333;
  line-height: 1.3;
}

/* 文章元信息样式 */
.article-meta {
  display: flex;
  flex-wrap: wrap;
  align-items: center;
  gap: 24px;
  padding-bottom: 24px;
  border-bottom: 1px solid #e8e8e8;
  margin-bottom: 24px;
}

/* 标签样式 */
.article-tags {
  display: flex;
  gap: 8px;
}

/* 作者信息样式 */
.article-author {
  display: flex;
  align-items: center;
  gap: 8px;
}

.author-name {
  font-size: 14px;
  color: #666;
}

/* 发布时间和字数样式 */
.article-info {
  display: flex;
  gap: 16px;
  font-size: 14px;
  color: #999;
}

/* 文章摘要样式 */
.article-summary {
  background-color: #f5f7fa;
  padding: 20px;
  border-radius: 8px;
  margin-bottom: 32px;
}

.article-summary h3 {
  margin: 0 0 12px 0;
  font-size: 20px;
  font-weight: 600;
  color: #333;
}

.article-summary p {
  margin: 0;
  font-size: 16px;
  color: #666;
  line-height: 1.6;
}

/* AI总结样式 */
.article-ai-summary {
  background-color: #e6f7ff;
  padding: 20px;
  border-radius: 8px;
  margin-bottom: 32px;
  border-left: 4px solid #1890ff;
}

.article-ai-summary h3 {
  margin: 0 0 12px 0;
  font-size: 20px;
  font-weight: 600;
  color: #1890ff;
}

.ai-summary-content p {
  margin: 0;
  font-size: 16px;
  color: #333;
  line-height: 1.6;
}

/* 文章正文样式 */
.article-main-content {
  font-size: 16px;
  color: #333;
  line-height: 1.8;
}

/* 正文标题样式 */
.article-main-content h1 {
  font-size: 28px;
  font-weight: 700;
  color: #333;
  margin: 40px 0 20px 0;
}

.article-main-content h2 {
  font-size: 24px;
  font-weight: 700;
  color: #333;
  margin: 36px 0 18px 0;
}

.article-main-content h3 {
  font-size: 20px;
  font-weight: 700;
  color: #333;
  margin: 32px 0 16px 0;
}

.article-main-content h4 {
  font-size: 18px;
  font-weight: 700;
  color: #333;
  margin: 28px 0 14px 0;
}

.article-main-content h5 {
  font-size: 16px;
  font-weight: 700;
  color: #333;
  margin: 24px 0 12px 0;
}

.article-main-content h6 {
  font-size: 14px;
  font-weight: 700;
  color: #333;
  margin: 20px 0 10px 0;
}

/* 正文段落样式 */
.article-main-content p {
  margin: 0 0 16px 0;
  text-align: justify;
}

/* 加载状态样式 */
.loading {
  padding: 40px;
}

/* 游戏详情样式 */
.game-detail {
  display: flex;
  flex-direction: column;
  gap: 32px;
}

.game-cover {
  width: 100%;
  height: 350px;
  border-radius: 12px;
  overflow: hidden;
  box-shadow: 0 8px 24px rgba(0, 0, 0, 0.15);
}

.game-cover :deep(.el-image) {
  width: 100%;
  height: 100%;
}

.game-content-container {
  background-color: #fff;
  border-radius: 12px;
  padding: 32px;
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.08);
}

.game-title {
  margin: 0 0 24px 0;
  font-size: 36px;
  font-weight: 700;
  color: #333;
  line-height: 1.3;
}

.game-meta {
  display: flex;
  flex-wrap: wrap;
  align-items: center;
  gap: 16px;
  padding-bottom: 24px;
  border-bottom: 1px solid #e8e8e8;
  margin-bottom: 24px;
}

.game-category {
  display: flex;
  gap: 8px;
}

.game-description,
.game-introduction,
.game-requirements {
  margin-bottom: 32px;
}

.game-description h3,
.game-introduction h3,
.game-requirements h3 {
  margin: 0 0 16px 0;
  font-size: 20px;
  font-weight: 600;
  color: #333;
}

.game-description p,
.game-introduction p {
  margin: 0 0 16px 0;
  font-size: 16px;
  color: #666;
  line-height: 1.6;
}

.game-requirements ul {
  margin: 0;
  padding-left: 20px;
  list-style-type: disc;
}

.game-requirements li {
  margin-bottom: 8px;
  font-size: 16px;
  color: #666;
}

/* 评论模块样式 */
.comments-section {
  margin-top: 40px;
  padding: 0;
}

.comments-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 24px;
  padding-bottom: 16px;
  border-bottom: 1px solid #e8e8e8;
}

.comments-title {
  margin: 0;
  font-size: 24px;
  font-weight: 700;
  color: #333;
}

.comments-count {
  font-size: 14px;
  color: #999;
}

/* 评论表单样式 */
.comment-form-container {
  margin-bottom: 32px;
  padding: 28px;
  background-color: #fff;
  border-radius: 16px;
  box-shadow: 0 6px 20px rgba(0, 0, 0, 0.06);
  border: 1px solid #f0f0f0;
  transition: all 0.2s ease;
}

/* 评论区列表样式 */
.comment-sections-list {
  display: flex;
  flex-direction: column;
  gap: 24px;
}

/* 单个评论区样式 */
.single-comment-section {
  border: 1px solid #e8e8e8;
  border-radius: 8px;
  padding: 20px;
  background-color: #fff;
}

/* 评论区头部样式 */
.comment-section-header {
  margin-bottom: 16px;
  padding-bottom: 8px;
  border-bottom: 1px solid #f0f0f0;
}

.comment-section-title {
  margin: 0;
  font-size: 18px;
  font-weight: 600;
  color: #333;
}

/* 评论项样式 */
.comment-item {
  display: flex;
  gap: 16px;
}

.comment-avatar {
  flex-shrink: 0;
}

.comment-content {
  flex: 1;
}

.comment-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 8px;
}

.comment-meta {
  display: flex;
  gap: 12px;
  align-items: center;
}

.comment-author {
  font-weight: 600;
  color: #333;
  font-size: 14px;
}

.comment-time {
  font-size: 12px;
  color: #999;
}

.comment-text {
  font-size: 14px;
  color: #666;
  line-height: 1.6;
  word-break: break-word;
}

/* 评论工具栏样式 */
.comment-toolbar {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 16px;
  padding: 12px 16px;
  background-color: #fafafa;
  border-radius: 12px;
  border: 1px solid #e8e8e8;
  box-shadow: 0 1px 4px rgba(0, 0, 0, 0.05);
}

/* 提交评论按钮样式 */
.submit-comment-btn {
  margin-left: 12px;
  font-size: 14px;
  padding: 9px 20px;
  border-radius: 20px;
  font-weight: 600;
  background: linear-gradient(135deg, #1890ff 0%, #096dd9 100%);
  border: none;
  box-shadow: 0 3px 8px rgba(24, 144, 255, 0.2);
  transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
  text-transform: uppercase;
  letter-spacing: 0.5px;
}

.submit-comment-btn:hover:not(:disabled) {
  background: linear-gradient(135deg, #40a9ff 0%, #1890ff 100%);
  box-shadow: 0 5px 15px rgba(24, 144, 255, 0.4);
  transform: translateY(-2px);
}

.submit-comment-btn:active:not(:disabled) {
  transform: translateY(0);
  box-shadow: 0 2px 5px rgba(24, 144, 255, 0.3);
}

.submit-comment-btn:disabled {
  background: linear-gradient(135deg, #d9d9d9 0%, #bfbfbf 100%);
  color: rgba(0, 0, 0, 0.3);
  box-shadow: none;
  cursor: not-allowed;
  transform: none;
}

/* 表情选择器样式 */
.emoji-picker {
  display: flex;
  flex-wrap: wrap;
  gap: 8px;
  max-height: 200px;
  overflow-y: auto;
  padding: 12px;
  background-color: #fff;
  border-radius: 12px;
  box-shadow: 0 2px 12px rgba(0, 0, 0, 0.1);
}

.emoji-item {
  font-size: 26px;
  cursor: pointer;
  padding: 8px;
  border-radius: 8px;
  transition: all 0.2s ease;
  display: inline-flex;
  align-items: center;
  justify-content: center;
  margin-right: 4px;
}

.emoji-item:hover {
  background-color: rgba(24, 144, 255, 0.1);
  transform: scale(1.2);
  box-shadow: 0 2px 8px rgba(24, 144, 255, 0.2);
}

/* 表情展开按钮样式 */
.emoji-expand-btn {
  font-size: 16px;
  color: #999;
  padding: 4px 8px;
  border-radius: 6px;
  transition: all 0.2s ease;
  margin-left: 4px;
}

.emoji-expand-btn:hover {
  color: #1890ff;
  background-color: rgba(24, 144, 255, 0.1);
}

/* 内联表情选择器样式 */
.inline-emoji-picker {
  display: flex;
  align-items: center;
  gap: 8px;
  margin: 0;
  padding: 0;
  background-color: transparent;
  border-radius: 0;
  box-shadow: none;
  border: none;
}

/* 调整上传组件样式 */
.image-upload-btn {
  display: flex;
  align-items: center;
  justify-content: center;
}

:deep(.el-upload--picture-card) {
  width: 40px;
  height: 40px;
  margin: 0;
  border-radius: 8px;
  transition: all 0.2s ease;
  border: 2px dashed #d9d9d9;
  background-color: rgba(0, 0, 0, 0.02);
}

:deep(.el-upload--picture-card:hover) {
  border-color: #1890ff;
  background-color: rgba(24, 144, 255, 0.1);
  transform: scale(1.1);
}

:deep(.el-upload--picture-card .el-upload-dragger) {
  width: 40px;
  height: 40px;
  padding: 8px;
  border: none;
  background-color: transparent;
  box-shadow: none;
}

.comment-actions {
  margin-top: 12px;
}

/* 子评论列表样式 */
.sub-comments-list {
  margin-top: 16px;
  margin-left: 44px;
  display: flex;
  flex-direction: column;
  gap: 12px;
}

/* 子评论项样式 */
.sub-comment-item {
  border: 1px solid #f0f0f0;
  border-radius: 6px;
  padding: 12px;
  background-color: #fafafa;
}

/* 回复表单样式 */
.reply-form-container {
  margin-top: 16px;
  margin-left: 44px;
  padding: 16px;
  background-color: #f5f7fa;
  border-radius: 6px;
  border: 1px solid #e8e8e8;
}

.comment-form-title {
  margin: 0 0 24px 0;
  font-size: 18px;
  font-weight: 600;
  color: #333;
}

.comment-form-container :deep(.el-form-item__label) {
  font-weight: 600;
  color: #333;
}

/* 评论输入框样式 */
.comment-textarea {
  margin-bottom: 16px;
}

.comment-textarea :deep(.el-textarea__inner) {
  resize: none;
  border-radius: 12px;
  border: 1px solid #e8e8e8;
  padding: 14px 18px;
  font-size: 16px;
  line-height: 1.7;
  transition: all 0.2s ease;
  box-shadow: 0 1px 3px rgba(0, 0, 0, 0.08);
  background-color: #fafafa;
}

.comment-textarea :deep(.el-textarea__inner::placeholder) {
  color: #999;
  font-size: 15px;
  font-style: italic;
}

.comment-textarea :deep(.el-textarea__inner:focus) {
  border-color: #1890ff;
  box-shadow: 0 0 0 2px rgba(24, 144, 255, 0.2);
  outline: none;
  background-color: #fff;
}

.comment-form-container :deep(.el-button--primary) {
  border-radius: 8px;
  padding: 10px 28px;
  font-size: 16px;
  font-weight: 600;
  transition: all 0.2s ease;
}

.comment-form-container :deep(.el-button--primary):hover {
  transform: translateY(-1px);
  box-shadow: 0 4px 12px rgba(24, 144, 255, 0.3);
}

.comment-form-container :deep(.el-button--primary:disabled) {
  opacity: 0.6;
  cursor: not-allowed;
  transform: none;
  box-shadow: none;
}

.comment-form-container :deep(.el-form-item) {
  margin-bottom: 20px;
}

.comment-form-container :deep(.el-form-item__label) {
  font-weight: 600;
  color: #333;
  font-size: 16px;
  margin-bottom: 12px;
}

/* 响应式设计 */
@media (max-width: 768px) {
  .detail-container {
    padding: 16px;
  }

  .article-title,
  .game-title {
    font-size: 28px;
  }

  .article-content-container,
  .game-content-container,
  .comments-section {
    padding: 20px;
  }

  .article-meta,
  .game-meta {
    flex-direction: column;
    align-items: flex-start;
    gap: 12px;
  }

  .comment-item {
    flex-direction: column;
    gap: 12px;
  }
}
</style>
