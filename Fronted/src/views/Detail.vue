<template>
  <div class="detail-container">
    <!-- 文章内容 -->
    <div v-if="data && data.type === 'article'" class="article-detail">
      <!-- 文章内容容器 -->
      <div class="article-content-container">
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
    <!-- 评论模块 -->
    <div v-if="data" class="comments-section">
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
                    <a
                      :href="mainComment.url"
                      v-if="mainComment.url"
                      class="comment-author"
                      target="_blank"
                      rel="noopener noreferrer"
                      >{{ mainComment.author }}</a
                    >
                    <span v-else class="comment-author">{{
                      mainComment.author
                    }}</span>
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
                      <a
                        :href="reply.url"
                        v-if="reply.url"
                        class="comment-author"
                        target="_blank"
                        rel="noopener noreferrer"
                        >{{ reply.author }}</a
                      >
                      <span v-else class="comment-author">{{
                        reply.author
                      }}</span>
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
        </div>
      </div>
      <!-- 评论表单 -->
      <div class="comment-form-container">
        <el-form :model="newComment" label-position="top">
          <el-form-item required>
            <!-- 表情选择器 -->
            <div v-if="showEmojiPicker" class="emoji-picker-container">
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
            </div>

            <!-- 评论输入区域容器 -->
            <div class="comment-input-wrapper">
              <!-- 评论输入框 -->
              <el-input
                v-model="newComment.content"
                type="textarea"
                :rows="5"
                :placeholder="
                  replyToUsername
                    ? `回复 @${replyToUsername}：`
                    : '分享您的想法...'
                "
                resize="vertical"
                class="comment-textarea"
              ></el-input>

              <!-- 分隔线 -->
              <div class="comment-divider"></div>

              <!-- 评论工具栏 -->
              <div class="comment-toolbar">
                <div class="toolbar-left">
                  <!-- 表情按钮 -->
                  <div class="emoji-button-container">
                    <el-button
                      type="text"
                      size="small"
                      @click="toggleEmojiPicker"
                      class="emoji-button"
                    >
                      <img
                        src="../assets/icons/emotion.png"
                        alt="表情"
                        style="width: 20px; height: 20px; vertical-align: middle; position: relative;"
                      />
                    </el-button>
                  </div>
                </div>
              </div>
            </div>

            <!-- 用户信息输入和操作按钮行 -->
            <div class="user-info-inputs">
              <el-form-item>
                <el-upload
                  action="#"
                  :auto-upload="false"
                  :on-change="handleAvatarChange"
                  accept="image/*"
                  :show-file-list="false"
                  :key="uploadKey"
                  class="avatar-upload-btn"
                >
                  <el-avatar :src="newComment.avatar" size="32"></el-avatar>
                </el-upload>
              </el-form-item>

              <el-form-item>
                <el-input
                  v-model="newComment.nickname"
                  placeholder="昵称"
                  class="short-input"
                ></el-input>
              </el-form-item>

              <el-form-item>
                <el-input
                  v-model="newComment.email"
                  type="email"
                  placeholder="邮箱"
                  class="short-input"
                ></el-input>
              </el-form-item>

              <el-form-item>
                <el-input
                  v-model="newComment.url"
                  type="url"
                  placeholder="链接"
                  class="short-input"
                ></el-input>
              </el-form-item>

              <!-- 提交评论和取消回复按钮 -->
              <el-form-item>
                <el-button
                  type="primary"
                  @click="submitComment"
                  :disabled="!newComment.content.trim()"
                  class="submit-comment-btn"
                >
                  <img
                    src="../assets/icons/comment.png"
                    alt="发布评论"
                    style="width: 18px; height: 18px; vertical-align: middle"
                  />
                </el-button>
                <el-button
                  v-if="replyToUsername"
                  type="text"
                  @click="cancelReply"
                  class="cancel-reply-btn"
                >
                  取消回复
                </el-button>
              </el-form-item>
            </div>
          </el-form-item>
        </el-form>
      </div>
    </div>
    <div v-else class="loading">
      <el-skeleton :rows="8" animated />
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted, onUnmounted, computed } from "vue";
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
      name: "YoyuEN",
      avatar: "/src/assets/picture/YoyuEN.png",
    },
    aiSummary:
      "本文主要介绍了人工智能在游戏开发中的应用，包括NPC智能、 procedural content generation、玩家行为分析等方面。AI技术不仅提升了游戏的可玩性和沉浸感，还降低了开发成本。未来，随着大语言模型和强化学习的发展，游戏AI将更加智能和个性化。",
    content: `

随着人工智能技术的快速发展，其在游戏开发中的应用越来越广泛。从早期的简单规则AI到如今的深度学习模型，人工智能已经成为现代游戏开发中不可或缺的重要组成部分。本文将探讨人工智能在游戏开发中的应用现状、关键技术以及未来发展趋势。

传统游戏中的NPC（非玩家角色）通常只能按照预设的脚本行动，行为模式单一。而现代游戏中，AI技术使得NPC能够具备更复杂的行为和决策能力。通过使用行为树、有限状态机和强化学习等技术，NPC可以根据游戏环境和玩家行为做出动态响应，提供更加真实和具有挑战性的游戏体验。

程序化内容生成（PCG）是指利用算法自动生成游戏内容，如地图、关卡、道具等。AI技术的引入使得PCG更加智能和高效。通过使用生成对抗网络（GAN）和变分自编码器（VAE）等深度学习模型，可以生成更加多样化和高质量的游戏内容，大大降低了开发成本，同时增加了游戏的可重玩性。


AI技术可以实时分析玩家的游戏行为数据，包括游戏风格、技能水平和偏好等。基于这些分析，游戏可以动态调整难度、提供个性化推荐，并优化游戏体验。例如，对于新手玩家，可以降低游戏难度并提供更多提示；对于高级玩家，可以增加挑战性内容以保持游戏的吸引力。




深度学习在游戏AI中的应用主要包括图像识别、自然语言处理和强化学习等。卷积神经网络（CNN）可以用于游戏场景理解和目标检测；循环神经网络（RNN）和Transformer模型可以用于NPC的自然语言交互；强化学习（RL）则可以用于训练智能游戏代理。




强化学习是游戏AI中的一项重要技术，通过让AI代理在游戏环境中不断尝试和学习，优化其行为策略。DeepMind的AlphaGo和AlphaStar项目展示了强化学习在复杂游戏中的强大能力。在游戏开发中，强化学习可以用于训练NPC、设计游戏关卡和平衡游戏机制。


近年来，大语言模型（LLM）如GPT-4和Claude在游戏开发中的应用越来越受到关注。LLM可以用于生成游戏对话、剧情和任务描述，甚至可以作为游戏中的虚拟角色与玩家进行自然语言交互。这大大增强了游戏的叙事能力和沉浸感。


未来的游戏AI将更加注重个性化体验，通过分析玩家的行为数据和偏好，为每个玩家提供量身定制的游戏内容和挑战。这将使得游戏更加具有吸引力和粘性。


随着元宇宙概念的兴起，跨游戏AI代理将成为可能。玩家可以拥有一个能够在不同游戏中通用的AI代理，该代理可以积累经验和技能，并在不同游戏环境中应用这些知识。


AI技术将在游戏设计过程中发挥更加重要的作用，从概念设计到关卡创建，再到游戏测试和优化，AI都可以提供有力的支持。这将大大提高游戏开发效率，缩短开发周期。


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
  {
    id: 4,
    avatar: "/src/assets/picture/YoyuEN.png",
    author: "新手玩家",
    time: "2024-01-09 12:00",
    content: "这篇文章很有帮助，谢谢分享！",
    replies: [],
  },
  {
    id: 5,
    avatar: "/src/assets/picture/YoyuEN.png",
    author: "新手玩家",
    time: "2024-01-09 14:30",
    content: "这篇文章很有帮助，谢谢分享！",
    replies: [],
  },
  {
    id: 6,
    avatar: "/src/assets/picture/YoyuEN.png",
    author: "新手玩家",
    time: "2024-01-09 16:15",
    content: "这篇文章很有帮助，谢谢分享！",
    replies: [],
  }
]);

// 新评论表单数据
const newComment = ref({
  content: "",
  nickname: "",
  email: "",
  url: "",
  avatar: "/src/assets/picture/YoyuEN.png", // 默认头像
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

// 点击其他区域关闭表情选择器
onMounted(() => {
  const handleClickOutside = (event) => {
    const emojiButton = document.querySelector('.emoji-button');
    const emojiPicker = document.querySelector('.emoji-picker-container');
    
    if (emojiPicker && !emojiPicker.contains(event.target) && 
        emojiButton && !emojiButton.contains(event.target)) {
      showEmojiPicker.value = false;
    }
  };
  
  document.addEventListener('click', handleClickOutside);
  
  // 组件卸载时移除事件监听
  onUnmounted(() => {
    document.removeEventListener('click', handleClickOutside);
  });
});

// 添加表情到评论内容
const addEmoji = (emoji) => {
  newComment.value.content += emoji;
  showEmojiPicker.value = false;
};

// 处理头像上传
const handleAvatarChange = (file) => {
  // 实际项目中应该上传图片到服务器，这里简化处理
  // 创建图片URL
  const imageUrl = URL.createObjectURL(file.raw);
  // 保存头像URL到评论数据
  newComment.value.avatar = imageUrl;

  // 重置上传组件，允许再次选择相同文件
  // 通过强制更新组件的key来重置上传组件状态
  uploadKey.value = Date.now();
};

// 用于重置上传组件的key
const uploadKey = ref(0);

// 回复评论相关数据
const replyToCommentId = ref(null);
const replyToUsername = ref(null);

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

// 显示回复表单
const showReplyForm = (commentId, username) => {
  replyToCommentId.value = commentId;
  replyToUsername.value = username;
  newComment.value.content = "";
  // 滚动到评论表单位置
  setTimeout(() => {
    document
      .querySelector(".comment-form-container")
      .scrollIntoView({ behavior: "smooth" });
  }, 100);
};

// 取消回复
const cancelReply = () => {
  replyToCommentId.value = null;
  replyToUsername.value = null;
  newComment.value.content = "";
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

  // 创建新评论或回复对象
  const commentData = {
    id: newId,
    avatar: newComment.value.avatar || "/src/assets/picture/YoyuEN.png", // 使用用户上传的头像或默认头像
    author: newComment.value.nickname || "匿名用户", // 使用用户输入的昵称或默认用户名
    url: newComment.value.url || "", // 保存用户输入的链接
    time: currentTime,
    content: newComment.value.content.trim(),
  };

  if (replyToCommentId.value) {
    // 如果是回复，添加到对应的主评论的replies数组中
    const mainComment = comments.value.find(
      (comment) => comment.id === replyToCommentId.value
    );
    if (mainComment) {
      if (!mainComment.replies) {
        mainComment.replies = [];
      }
      // 添加replyTo字段指向被回复的用户
      mainComment.replies.push({
        ...commentData,
        replyTo: replyToUsername.value,
      });
    }
    // 重置回复状态，无论mainComment是否存在
    replyToCommentId.value = null;
    replyToUsername.value = null;
  } else {
    // 如果是主评论，添加到评论列表开头
    comments.value.unshift({
      ...commentData,
      replies: [], // 初始化回复数组
    });
  }

  // 清空评论表单
  newComment.value.content = "";
  newComment.value.nickname = "";
  newComment.value.email = "";
  newComment.value.url = "";
};
</script>

<style scoped>
.detail-container {
  height: 100%;
  padding: 24px;
  width: 100%;
  margin: 0 auto;
  display: flex;
  gap: 32px;
  flex-wrap: wrap;
}

/* 文章内容区域 - 左侧 */
.article-detail {
  height: 100%;
  flex: 3;
  min-width: 600px;
  position: relative;
  display: flex;
  flex-direction: column;
  gap: 32px;
}

/* 文章和评论之间的分割线 */
.article-detail::after {
  content: "";
  position: absolute;
  right: -16px;
  top: 50px;
  bottom: 50px;
  width: 1px;
  background: linear-gradient(to bottom, transparent, #e8e8e8, transparent);
  z-index: 1;
}

/* 评论区域 - 右侧 */
.comments-section {
  height: 100%;
  flex: 1;
  min-width: 350px;
  display: flex;
  flex-direction: column;
  overflow-y: auto;
  background-color: #fff;
  border-radius: 12px;
  padding: 0 24px;
  position: relative;
}

/* 文章内容区域 */
.article-content-container {
  overflow-y: auto;
  max-height: 100%;
}

/* 自定义滚动条样式 */
.article-content-container::-webkit-scrollbar,
.comments-section::-webkit-scrollbar {
  width: 6px;
}

.article-content-container::-webkit-scrollbar-track,
.comments-section::-webkit-scrollbar-track {
  background: #f1f1f1;
  border-radius: 3px;
}

.article-content-container::-webkit-scrollbar-thumb,
.comments-section::-webkit-scrollbar-thumb {
  background: #c1c1c1;
  border-radius: 3px;
}

.article-content-container::-webkit-scrollbar-thumb:hover,
.comments-section::-webkit-scrollbar-thumb:hover {
  background: #a8a8a8;
}

/* 响应式设计 */
@media (max-width: 1100px) {
  .article-detail::after {
    display: none;
  }

  .article-detail {
    flex: 1;
    min-width: auto;
  }

  .comments-section {
    flex: 1;
    min-width: auto;
    position: static;
    height: auto;
  }
}

/* 文章内容容器样式 */
.article-content-container {
  background-color: #fff;
  border-radius: 12px;
  padding: 32px;
}

/* 文章标题样式 */
.article-title {
  margin: 20px 0 16px 0;
  font-size: 32px;
  font-weight: 700;
  color: #303133;
  line-height: 1.3;
  text-align: center;
}

/* 文章摘要样式 */
.article-summary-text {
  margin: 0 0 24px 0;
  font-size: 18px;
  line-height: 1.6;
  color: #606266;
  max-width: 700px;
  margin-left: auto;
  margin-right: auto;
  text-align: center;
}

/* 文章元信息样式 */
.article-meta {
  position: relative;
  display: block;
  margin-bottom: 16px;
}

/* 标签居中显示 */
.article-tags {
  position: absolute;
  left: 50%;
  transform: translateX(-50%);
  display: flex;
  gap: 8px;
  justify-content: center;
}

/* 作者信息左下角 */
.article-author {
  position: absolute;
  left: 0;
  bottom: 0;
  display: flex;
  align-items: center;
  gap: 8px;
}

/* 发布时间和字数右下角 */
.article-info {
  position: absolute;
  right: 0;
  bottom: 0;
  display: flex;
  gap: 16px;
}

/* 调整元信息容器高度，确保绝对定位元素有足够空间 */
.article-meta {
  height: 80px;
}

.article-tags :deep(.el-tag) {
  background-color: rgba(255, 255, 255, 0.2);
  border-color: rgba(255, 255, 255, 0.3);
  color: white;
}

/* 作者信息样式 */
.article-author {
  display: flex;
  align-items: center;
  gap: 8px;
}

.article-author :deep(.el-avatar) {
  border: 2px solid rgba(255, 255, 255, 0.3);
}

.author-name {
  font-size: 16px;
  color: white;
  font-weight: 500;
  text-shadow: 0 1px 2px rgba(0, 0, 0, 0.3);
}

/* 发布时间和字数样式 */
.article-info {
  display: flex;
  gap: 16px;
  font-size: 14px;
  color: rgba(255, 255, 255, 0.8);
  text-shadow: 0 1px 2px rgba(0, 0, 0, 0.3);
}

.article-info span {
  display: flex;
  align-items: center;
  gap: 4px;
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
  border-radius: 8px;
  margin-bottom: 32px;
}

.article-ai-summary h3 {
  margin: 0 0 12px 0;
  font-size: 20px;
  font-weight: 600;
  color: #333;
}

.ai-summary-content p {
  margin: 0;
  font-size: 16px;
  color: #666;
  line-height: 1.6;
  background-color: #f5f7fa;
  padding: 20px;
  border-radius: 8px;
}

/* 文章正文样式 */
.article-main-content {
  margin-top: 32px;
  font-size: 16px;
  line-height: 1.8;
  color: #333;
}

/* Markdown样式 */
.article-main-content :deep(h1),
.article-main-content :deep(h2),
.article-main-content :deep(h3),
.article-main-content :deep(h4),
.article-main-content :deep(h5),
.article-main-content :deep(h6) {
  margin: 24px 0 16px 0;
  font-weight: 600;
  color: #333;
}

.article-main-content :deep(h1) {
  font-size: 28px;
  border-bottom: 2px solid #eee;
  padding-bottom: 8px;
}

.article-main-content :deep(h2) {
  font-size: 24px;
  border-bottom: 1px solid #eee;
  padding-bottom: 8px;
}

.article-main-content :deep(h3) {
  font-size: 20px;
}

.article-main-content :deep(p) {
  margin: 16px 0;
}

.article-main-content :deep(ul),
.article-main-content :deep(ol) {
  margin: 16px 0;
  padding-left: 24px;
}

.article-main-content :deep(li) {
  margin: 8px 0;
}

.article-main-content :deep(a) {
  color: #409eff;
  text-decoration: none;
}

.article-main-content :deep(a:hover) {
  text-decoration: underline;
}

.article-main-content :deep(img) {
  max-width: 100%;
  height: auto;
  margin: 16px 0;
  border-radius: 8px;
  display: block;
}

.article-main-content :deep(code) {
  background-color: #f5f7fa;
  padding: 2px 6px;
  border-radius: 4px;
  font-family: "Courier New", Courier, monospace;
  font-size: 14px;
}

.article-main-content :deep(pre) {
  background-color: #f5f7fa;
  padding: 16px;
  border-radius: 8px;
  overflow-x: auto;
  margin: 16px 0;
}

.article-main-content :deep(pre code) {
  padding: 0;
  background-color: transparent;
  border-radius: 0;
}

.article-main-content :deep(blockquote) {
  border-left: 4px solid #409eff;
  padding-left: 16px;
  margin: 16px 0;
  color: #666;
}

.article-main-content :deep(table) {
  width: 100%;
  border-collapse: collapse;
  margin: 16px 0;
}

.article-main-content :deep(table th),
.article-main-content :deep(table td) {
  border: 1px solid #eee;
  padding: 8px 12px;
  text-align: left;
}

.article-main-content :deep(table th) {
  background-color: #f5f7fa;
  font-weight: 600;
}



/* 评论区标题 */
.comments-section h3 {
  margin: 0 0 24px 0;
  font-size: 20px;
  font-weight: 600;
  color: #333;
}

/* 评论区列表 */
.comment-sections-list {
  margin-bottom: 24px;
}

/* 单个评论区 */
.single-comment-section {
  padding: 24px 0;
  border-bottom: 1px solid #eee;
}

.single-comment-section:last-child {
  border-bottom: none;
  margin-bottom: 0;
  padding-bottom: 0;
}

/* 评论内容列表 */
.comment-section-content {
  margin-bottom: 24px;
}

/* 评论项 */
.comment-item {
  display: flex;
  gap: 12px;
  margin-bottom: 16px;
}

.comment-item:last-child {
  margin-bottom: 0;
}

/* 评论头像 */
.comment-avatar {
  margin-top: 4px;
}

.comment-avatar :deep(.el-avatar) {
  border: 2px solid #f5f7fa;
}

/* 评论内容 */
.comment-content {
  flex: 1;
  min-width: 0;
}

/* 评论头部 */
.comment-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 8px;
}

/* 评论元信息 */
.comment-meta {
  display: flex;
  align-items: center;
  gap: 12px;
}

/* 评论作者 */
.comment-author {
  font-size: 14px;
  font-weight: 500;
  color: #333;
  text-decoration: none;
}

.comment-author:hover {
  color: #409eff;
  text-decoration: underline;
}

/* 评论时间 */
.comment-time {
  font-size: 12px;
  color: #999;
}

/* 评论操作 */
.comment-actions {
  display: flex;
  gap: 8px;
}

.comment-actions :deep(.el-button) {
  padding: 0;
  font-size: 12px;
  color: #999;
}

.comment-actions :deep(.el-button:hover) {
  color: #409eff;
}

/* 评论文本 */
.comment-text {
  font-size: 14px;
  line-height: 1.6;
  color: #333;
  word-break: break-word;
}

/* 回复标记 */
.reply-to {
  color: #409eff;
  font-weight: 500;
}

/* 回复表单容器 */
.reply-form-container {
  margin-top: 16px;
  padding-top: 16px;
  border-top: 1px dashed #eee;
}

/* 评论表单容器 */
.comment-form-container {
  position: sticky;
  bottom: 0;
  left: 0;
  right: 0;
  background-color: #fff;
  border-radius: 12px;
  padding: 0 24px;
  margin: -24px;
  border: 1px solid #e8e8e8;
  z-index: 10;
}

/* 评论表单 */
.comment-form-container :deep(.el-form) {
  margin-top: 16px;
}

/* 覆盖表单元素内容区域样式 */
.comment-form-container :deep(.el-form-item__content) {
  align-items: center;
  display: block;
  flex: 1;
  flex-wrap: wrap;
  font-size: var(--font-size);
  line-height: 32px;
  min-width: 0;
  position: relative;
}

/* 评论输入区域容器 */
.comment-input-wrapper {
  display: flex;
  flex-direction: row;
  height: 46px;
  border: 1px solid #dcdfe6;
  border-radius: 4px;
  position: relative;
}

/* 评论文本框 */
.comment-textarea :deep(.el-textarea__inner) {
  height: 100%;
}

/* 分隔线 */
.comment-divider {
  height: 1px;
  background-color: #e8e8e8;
  margin: 0;
  padding: 0;
}

/* 评论工具栏 */
.comment-toolbar {
  flex: 0 0 20%;
  display: flex;
  justify-content: flex-start;
  align-items: center;
  padding: 8px 12px;
  background-color: #fafafa;
}

/* 工具栏左侧 */
.toolbar-left {
  display: flex;
  gap: 16px;
  align-items: center;
}

/* 表情按钮容器 */
.emoji-button-container {
  position: relative;
}

/* 表情按钮 */
.emoji-button {
  padding: 4px 8px;
  border-radius: 4px;
  transition: background-color 0.2s;
}

.emoji-button:hover {
  background-color: #e8e8e8;
}

/* 表情选择器容器 */
.emoji-picker-container {
  position: absolute;
  bottom: 100%;
  left: 0;
  margin-bottom: 8px;
  background-color: white;
  border: 1px solid #dcdfe6;
  border-radius: 8px;
  box-shadow: 0 2px 12px rgba(0, 0, 0, 0.1);
  z-index: 1000;
}

/* 表情选择器 */
.emoji-picker {
  display: flex;
  flex-wrap: wrap;
  gap: 8px;
  padding: 12px;
  max-height: 200px;
  overflow-y: auto;
  min-width: 300px;
}

/* 表情项 */
.emoji-item {
  font-size: 20px;
  cursor: pointer;
  padding: 4px;
  border-radius: 4px;
  transition: background-color 0.2s;
}

.emoji-item:hover {
  background-color: #f5f7fa;
}

/* 用户信息输入区域 */
.user-info-inputs {
  display: flex;
  gap: 12px;
  margin-top: 16px;
  flex-wrap: wrap;
}

/* 短输入框 */
.short-input :deep(.el-input__inner) {
  width: 30px;
}

/* 头像上传按钮 */
.avatar-upload-btn {
  cursor: pointer;
}

/* 提交评论按钮 */
.submit-comment-btn {
  padding: 8px 24px;
}

/* 加载状态 */
.loading {
  padding: 48px 24px;
}

/* 响应式设计 */
@media (max-width: 768px) {
  .detail-container {
    padding: 16px;
    flex-direction: column;
  }

  .article-cover {
    height: 400px;
  }

  .article-title {
    font-size: 24px;
  }

  .article-summary-text {
    font-size: 16px;
  }

  .article-meta {
    height: auto;
    display: flex;
    flex-direction: column;
    gap: 12px;
  }

  .article-tags {
    position: relative;
    left: auto;
    transform: none;
    margin-bottom: 8px;
  }

  .article-author {
    position: relative;
    left: auto;
    bottom: auto;
    margin-bottom: 8px;
  }

  .article-info {
    position: relative;
    right: auto;
    bottom: auto;
  }

  .article-content-container {
    padding: 24px;
  }

  .comments-section {
    position: relative;
    top: auto;
    align-self: auto;
    height: auto;
  }

  .user-info-inputs {
    flex-direction: column;
  }

  .short-input :deep(.el-input__inner) {
    width: 100%;
  }
}
</style>
