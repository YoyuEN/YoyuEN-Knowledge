<template>
  <!-- 评论模块 -->
  <div v-if="data" class="comments-section">
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
            <div class="emoji-picker">
              <div class="emoji-scroll-container no-scrollbar">
                <span
                  v-for="emoji in emojis"
                  :key="emoji"
                  class="emoji-item"
                  @click="addEmoji(emoji)"
                >
                  {{ emoji }}
                </span>
              </div>
              <el-button
                type="text"
                size="small"
                @click="toggleEmojiPicker"
                class="emoji-expand-btn"
              >
                <img
                  src="../assets/icons/emotion.png"
                  alt="表情图标"
                  style="width: 18px; height: 18px; vertical-align: middle"
                />
              </el-button>
            </div>
          </div>

          <!-- 用户信息输入和操作按钮行 -->
          <div class="user-info-inputs">
            <el-upload
              action="#"
              :auto-upload="false"
              :on-change="handleAvatarChange"
              accept="image/*"
              :show-file-list="false"
              class="avatar-upload-btn"
            >
              <el-avatar :src="newComment.avatar" size="32"></el-avatar>
            </el-upload>

            <el-input
              v-model="newComment.nickname"
              placeholder="昵称"
              class="short-input"
            ></el-input>

            <el-input
              v-model="newComment.email"
              type="email"
              placeholder="邮箱"
              class="short-input"
            ></el-input>

            <el-input
              v-model="newComment.url"
              type="url"
              placeholder="链接"
              class="short-input"
            ></el-input>

            <!-- 提交评论和取消回复按钮 -->
            <el-button
              type="primary"
              @click="submitComment"
              :disabled="!newComment.content.trim()"
              class="submit-comment-btn"
            >
              <img
                src="../assets/icons/comment.png"
                alt="发布评论"
                class="comment-icon"
                style="width: 18px; height: 18px; vertical-align: middle"
              />
              <el-button
                v-if="replyToUsername"
                type="text"
                @click="cancelReply"
                class="cancel-reply-btn"
              >
                <img
                  src="../assets/icons/fork.png"
                  alt="取消回复"
                  style="width: 18px; height: 18px; vertical-align: middle"
                />
              </el-button>
            </el-button>
          </div>
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
            <div class="comment-content">
              <div class="comment-meta">
                <el-avatar :src="mainComment.avatar" size="medium"></el-avatar>
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
              <span class="comment-time">{{ mainComment.time }}</span>
            </div>
          </div>

          <!-- 其他评论：对评论的评论（展平所有嵌套回复） -->
          <div v-if="mainComment.replies && mainComment.replies.length > 0">
            <div
              v-for="reply in flattenReplies(mainComment)"
              :key="reply.id"
              class="comment-son-item"
            >
              <div class="comment-content">
                <div class="comment-meta">
                  <el-avatar :src="reply.avatar" size="medium"></el-avatar>
                  <a
                    :href="reply.url"
                    v-if="reply.url"
                    class="comment-author"
                    target="_blank"
                    rel="noopener noreferrer"
                    >{{ reply.author }}</a
                  >
                  <span v-else class="comment-author">{{ reply.author }}</span>
                  <!-- 回复按钮 -->
                  <div class="comment-actions">
                    <span class="reply-to">@{{ reply.replyTo }}</span>
                    <el-button
                      type="text"
                      size="small"
                      @click="showReplyForm(reply.id, reply.author)"
                      :icon="ChatDotRound"
                    >
                    </el-button>
                  </div>
                </div>

                <span class="comment-time">{{ reply.time }}</span>
                <div class="comment-text">
                  <span v-html="renderMarkdown(reply.content)"></span>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
    
  </div>
</template>

<script setup>
import { ref } from "vue";
import { ChatDotRound } from "@element-plus/icons-vue";
import { createComment } from "@/api/comment/comment.js";

// 定义组件属性
const props = defineProps({
  data: {
    type: Object,
    required: true,
  },
  comments: {
    type: Array,
    default: () => [],
  },
  contentType: {
    type: String,
    default: '',
  },
});

const emit = defineEmits(['comment-added']);

// 新评论表单数据
const newComment = ref({
  content: "",
  nickname: "",
  email: "",
  url: "",
  avatar: "/src/assets/picture/YoyuEN.png", // 默认头像
});

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
  const emojiPicker = document.querySelector(".emoji-picker");
  emojiPicker.classList.toggle("show");
};

// 添加表情到评论内容
const addEmoji = (emoji) => {
  newComment.value.content += emoji;
  showEmojiPicker.value = false;
};

// 暂存选中的头像文件，提交时随表单一起发送
const avatarFile = ref(null);

const handleAvatarChange = (file) => {
  avatarFile.value = file.raw;
  // 生成本地预览 URL，用于 el-avatar 展示
  newComment.value.avatar = URL.createObjectURL(file.raw);
};

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
  let total = props.comments.length;
  props.comments.forEach((comment) => {
    if (comment.replies && comment.replies.length > 0) {
      total += comment.replies.length;
    }
  });
  return total;
};

// 展平嵌套 replies，用于渲染时保持单层列表
const flattenReplies = (comment) => {
  const result = [];
  for (const reply of (comment.replies || [])) {
    result.push(reply);
    result.push(...flattenReplies(reply));
  }
  return result;
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
const submitComment = async () => {
  // 验证评论内容
  if (!newComment.value.content.trim()) {
    return;
  }

  // 获取最终的头像文件（自定义或默认）
  let finalAvatarFile = avatarFile.value;
  if (!finalAvatarFile) {
    const defaultAvatarUrl = new URL("/src/assets/picture/YoyuEN.png", import.meta.url).href;
    const response = await fetch(defaultAvatarUrl);
    const blob = await response.blob();
    finalAvatarFile = new File([blob], "YoyuEN.png", { type: blob.type });
  }

  const payload = new FormData();
  payload.append("contentId", props.data.id);
  payload.append("contentType", props.contentType);
  payload.append("author", newComment.value.nickname || "匿名用户");
  payload.append("userId", localStorage.getItem("userId") || "");
  payload.append("content", newComment.value.content.trim());
  payload.append("parentId", replyToCommentId.value || "");
  payload.append("avatarFile", finalAvatarFile);

  try {
    await createComment(payload);
    // 清空评论表单
    newComment.value.content = "";
    newComment.value.nickname = "";
    newComment.value.email = "";
    newComment.value.url = "";
    replyToCommentId.value = null;
    replyToUsername.value = null;
    avatarFile.value = null;
    // 通知父组件刷新评论列表
    emit("comment-added");
  } catch (e) {
    console.error("评论提交失败", e);
  }
};
</script>

<style scoped>
.comments-section {
  padding: 10px 20px;
}

.single-comment-section {
  margin-top: 10px;
  background-color: white;
  border-radius: 18px;
  border: 1px solid var(--border-color);
}

.comment-form-container {
  margin-top: 10px;
  background-color: white;
  border-radius: 18px;
}

.comment-section-content {
  padding: 20px;
  position: relative;
}

.comment-content {
  display: flex;
  flex-direction: column;
  gap: 12px;
}
.comment-son-item {
  border-top: 1px solid var(--border-color);
  position: relative;
  padding: 20px 20px 20px 0;
  margin-top: 20px;
}

.comment-son-item .comment-time {
  right: -20px;
}

.comment-time {
  position: absolute;
  top: 0;
  right: 0;
  padding: 0px 12px;
  border-radius: 0 18px 0 18px;
  background: hsl(0deg 0% 0% / 5%);
  font-size: 12px;
}

.comment-meta {
  display: flex;
  align-items: center;
  gap: 8px;
}

.comment-author {
  font-size: 14px;
  font-weight: 600;
  color: var(--text-primary);
}

.comment-actions {
  display: inline-flex;
  flex: auto;
  align-items: center;
  gap: 6px;
}

.comment-actions button {
  border-radius: 24px;
  background: #4040400d;
  padding: 5px;
}

.comment-actions .reply-to {
  border-radius: 24px;
  background: #4040400d;
  padding: 5px;
  font-size: 12px;
}

.comment-text {
  font-size: 14px;
  line-height: 1.6;
  color: var(--text-secondary);
}

.comment-input-wrapper {
  display: flex;
  flex-direction: column;
  flex: 100%;
  background: hsl(0deg 0% 25% / 5%);
  border-radius: 16px;
}

.comment-textarea :deep(.el-textarea__inner) {
  box-shadow: none;
  width: 100%;
  accent-color: hsl(227deg 29% 60%);
  background: none;
  vertical-align: middle;
  appearance: none;
}

.emoji-picker {
  height: 36px;
  display: flex;
  align-items: center;
  border-top: 1px solid var(--border-color);
  padding: 10px;
  transition: height 0.3s ease;
}

.emoji-picker.show {
  height: 108px;
}

.emoji-scroll-container {
  flex: 1;
  display: grid;
  place-items: center;
  grid: auto-flow 36px / repeat(auto-fill, minmax(32px, 1fr));
  font-size: 18px;
  height: inherit;
  scroll-snap-type: y mandatory;
  overscroll-behavior: contain;
  overflow: hidden auto;
}

.emoji-scroll-container span {
  cursor: pointer;
  transition: scale 0.3s ease;
}

.emoji-scroll-container span:hover {
  scale: 1.3;
}

.no-scrollbar {
  scrollbar-width: none;
  -ms-overflow-style: none;
}

.user-info-inputs {
  display: flex;
  align-items: center;
  gap: 12px;
}

.submit-comment-btn {
  border-radius: 24px;
  transition: width 0.3s ease;
  border: 1px solid var(--border-color);
}

.submit-comment-btn:hover {
  border: 1px solid var(--border-color);
}

.submit-comment-btn img:hover {
  scale: 1.3;
  transition: scale 0.3s ease;
}


.cancel-reply-btn {
  padding: 3px;
  height: auto;
  border-radius: 24px;
  transition: background-color 0.3s ease;
}

</style>
