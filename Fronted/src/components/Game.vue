<template>
  <div class="game-container">
    <div class="swiper-container">
      <swiper
        :slides-per-view="1"
        :space-between="16"
        :navigation="true"
        :pagination="{ clickable: true }"
        :free-mode="true"
        @swiper="onSwiper"
        @slide-change="onSlideChange"
        class="game-swiper"
      >
        <swiper-slide
          v-for="game in gameList"
          :key="game.id"
          class="game-swiper-slide"
        >
          <Card16x9
            :background-image="game.cover"
            class="game-card-item"
          >
            <div class="card-info">
              <h4 class="game-name">{{ game.name }}</h4>
              <span class="game-category">{{ game.category }}</span>
            </div>
          </Card16x9>
        </swiper-slide>
      </swiper>
    </div>

    <!-- 游戏详细信息区域 -->
    <div v-if="currentGame" class="game-details">
      <div class="game-details-container">
        <div class="game-details-header">
          <h3>{{ currentGame.name }}</h3>
          <span class="game-category">{{ currentGame.category }}</span>
        </div>
        <div class="game-details-content">
          <p>{{ currentGame.description }}</p>
        </div>
      </div>

      <div class="comment-container">
        <CommentSection :data="currentGame" :comments="comments" />
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, computed } from "vue";
import { Trophy } from "@element-plus/icons-vue";
import Card16x9 from "./Card16x9.vue";
import { useRouter } from "vue-router";
import { Swiper, SwiperSlide } from "swiper/vue";
import "swiper/css";
import "swiper/css/navigation";
import "swiper/css/pagination";
import defaultCover from "../assets/picture/YoyuEN.png";
import cover1 from "../assets/picture/image.png";
import CommentSection from "./CommentSection.vue";

const router = useRouter();

// 当前选中的游戏
const currentGame = ref(null);
let swiperInstance = null;

// swiper实例
const onSwiper = (swiper) => {
  swiperInstance = swiper;
  // 初始化时设置当前游戏
  currentGame.value = gameList.value[swiper.activeIndex];
};

// 幻灯片切换事件
const onSlideChange = () => {
  if (swiperInstance) {
    currentGame.value = gameList.value[swiperInstance.activeIndex];
  }
};

const gameList = ref([
  {
    id: 1,
    name: "王者荣耀",
    category: "MOBA",
    cover: cover1,
    description:
      "《王者荣耀》是一款5V5团队公平竞技手游，国民MOBA手游大作！5v5王者峡谷、5v5深渊大乱斗、以及3v3、1v1等多样模式一键体验，热血竞技尽享快感！",
  },
  {
    id: 2,
    name: "三角洲行动",
    category: "射击",
    cover: defaultCover,
    description:
      "《三角洲行动》是一款全新战术射击游戏，玩家将扮演三角洲部队的精英成员，参与各种高难度的特种作战任务，体验真实的战场环境和紧张刺激的战斗。",
  },
  {
    id: 3,
    name: "鸣潮",
    category: "开放世界",
    cover: defaultCover,
    description:
      "《鸣潮》是一款开放世界动作角色扮演游戏，玩家将探索一个充满神秘力量的奇幻世界，通过战斗、解谜和探索，揭开这个世界的秘密。",
  },
  {
    id: 4,
    name: "崩坏星穹铁道",
    category: "角色扮演",
    cover: defaultCover,
    description:
      "《崩坏星穹铁道》是米哈游出品的全新银河冒险策略RPG游戏。玩家将乘坐星穹列车，穿梭于无数奇异世界之间，与同伴一同对抗“星核”带来的威胁，踏上开拓宇宙的旅程。",
  },
]);

// 按游戏ID分类的评论数据
const gameComments = ref({
  1: [ // 王者荣耀的评论
    {
      id: 1,
      avatar: "/src/assets/picture/YoyuEN.png",
      author: "游戏爱好者",
      time: "2024-01-10 14:30",
      content: "王者荣耀太好玩了！5V5对战模式很刺激。",
      replies: [],
    },
    {
      id: 2,
      avatar: "/src/assets/picture/YoyuEN.png",
      author: "新手玩家",
      time: "2024-01-11 09:45",
      content: "刚入手王者荣耀，还在学习各个英雄的技能。",
      replies: [],
    },
    {
      id: 3,
      avatar: "/src/assets/picture/YoyuEN.png",
      author: "老玩家",
      time: "2024-01-12 16:20",
      content: "期待王者荣耀新版本的更新，希望能有更多新英雄！",
      replies: [],
    }
  ],
  2: [ // 三角洲行动的评论
    {
      id: 4,
      avatar: "/src/assets/picture/YoyuEN.png",
      author: "射击游戏迷",
      time: "2024-01-13 10:20",
      content: "三角洲行动的画面效果太棒了，真实感很强！",
      replies: [],
    },
    {
      id: 5,
      avatar: "/src/assets/picture/YoyuEN.png",
      author: "军事爱好者",
      time: "2024-01-14 15:45",
      content: "游戏中的武器系统很专业，很喜欢这种战术射击游戏。",
      replies: [],
    }
  ],
  3: [ // 鸣潮的评论
    {
      id: 6,
      avatar: "/src/assets/picture/YoyuEN.png",
      author: "开放世界玩家",
      time: "2024-01-15 09:30",
      content: "鸣潮的开放世界设计得很精美，探索起来很有意思。",
      replies: [],
    },
    {
      id: 7,
      avatar: "/src/assets/picture/YoyuEN.png",
      author: "动作游戏迷",
      time: "2024-01-16 14:20",
      content: "战斗系统很流畅，技能连招很有快感！",
      replies: [],
    }
  ],
  4: [ // 崩坏星穹铁道的评论
    {
      id: 8,
      avatar: "/src/assets/picture/YoyuEN.png",
      author: "RPG爱好者",
      time: "2024-01-17 11:10",
      content: "崩坏星穹铁道的剧情很吸引人，角色塑造得很成功。",
      replies: [],
    },
    {
      id: 9,
      avatar: "/src/assets/picture/YoyuEN.png",
      author: "米哈游粉丝",
      time: "2024-01-18 16:50",
      content: "一如既往的高质量，期待后续的更新内容！",
      replies: [],
    },
    {
      id: 10,
      avatar: "/src/assets/picture/YoyuEN.png",
      author: "新玩家",
      time: "2024-01-19 10:30",
      content: "刚玩了几天，感觉很有意思，就是有些系统还不太明白。",
      replies: [
        {
          id: 11,
          avatar: "/src/assets/picture/YoyuEN.png",
          author: "老玩家",
          time: "2024-01-19 11:00",
          content: "多玩几天就会了，有问题可以问我哦！",
        }
      ],
    }
  ]
})

// 根据当前游戏ID获取对应的评论
const comments = computed(() => {
  if (!currentGame.value) return []
  return gameComments.value[currentGame.value.id] || []
})
</script>

<style scoped>
/* 导入快看世界体字体 */
@font-face {
  font-family: "快看世界体";
  src: url("../assets/fonts/kuaikanshijieti.ttf") format("truetype");
  font-weight: normal;
  font-style: normal;
}

.game-container {
  padding: 0 24px;
  height: 100%;
  display: flex;
  flex-direction: row;
  gap: 24px;
  overflow: hidden;
}

.game-header {
  display: flex;
  align-items: center;
  gap: 16px;
  margin-bottom: 24px;
  padding-bottom: 16px;
  border-bottom: 1px solid var(--border-color);
}

.header-icon {
  width: 48px;
  height: 48px;
  border-radius: 12px;
  background: linear-gradient(
    135deg,
    var(--primary-color),
    var(--primary-color-light)
  );
  display: flex;
  align-items: center;
  justify-content: center;
  color: white;
}

.header-content h3 {
  margin: 0 0 4px;
  font-size: 20px;
  font-weight: 600;
  color: var(--text-primary);
}

.game-count {
  font-size: 13px;
  color: var(--text-secondary);
}

.swiper-container {
  width: 55%;
  height: 100%;
}

/* 游戏详细信息区域 */
.game-details {
  width: 45%;
  padding-top: 20px;
  overflow-y: auto;
  height: calc(100vh - 60px);
  scrollbar-width: none;
}

.game-swiper {
  width: 100%;
  height: calc(100% - 40px);
  margin-top: 20px;
}

.game-swiper-slide {
  width: 100%;
  height: 100%;
  display: flex;
  justify-content: center;
  align-items: center;
}

.game-card-item {
  width: 100%;
  height: 70%;
  transition: transform 0.2s ease, box-shadow 0.2s ease;
  cursor: pointer;
}

.card-info {
  width: 100%;
  height: 100%;
  display: flex;
  flex-direction: column;
  justify-content: flex-end;
  padding: 16px;
  background: linear-gradient(to top, rgba(0, 0, 0, 0.7) 0%, transparent 60%);
}

.game-name {
  margin: 0 0 8px;
  font-size: 16px;
  font-weight: 600;
  color: white;
  text-shadow: 0 2px 4px rgba(0, 0, 0, 0.3);
}

.game-category {
  font-size: 12px;
  color: rgba(255, 255, 255, 0.9);
  background: rgba(255, 255, 255, 0.2);
  backdrop-filter: blur(4px);
  padding: 4px 10px;
  border-radius: 4px;
  width: fit-content;
}

.game-details-container {
  background-color: white;
  border-radius: 8px;
  box-shadow: 0 2px 12px rgba(0, 0, 0, 0.08);
  border: 1px solid var(--border-color);
  padding: 20px;
  margin: 0 20px 20px 20px;
}

.game-details-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 16px;
}

.game-details-header h3 {
  margin: 0;
  font-size: 20px;
  font-weight: 600;
  color: var(--text-primary);
  font-family: "快看世界体", system-ui, sans-serif;
}

.game-details-header .game-category {
  font-size: 12px;
  color: var(--text-secondary);
  background: var(--background-light);
  backdrop-filter: none;
  padding: 4px 10px;
  border-radius: 4px;
  width: fit-content;
}

.game-details-content p {
  margin: 0 0 24px 0;
  font-size: 14px;
  line-height: 1.6;
  color: var(--text-secondary);
}

.game-container::-webkit-scrollbar {
  width: 6px;
}

.game-container::-webkit-scrollbar-track {
  background: transparent;
}

.game-container::-webkit-scrollbar-thumb {
  background: var(--primary-color);
  border-radius: 3px;
}
</style>
