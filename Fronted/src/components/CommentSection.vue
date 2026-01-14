<template>
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
</template>

<script setup>
import { ref, onMounted, onUnmounted, defineProps } from "vue";
import { useRouter } from "vue-router";
import { ChatDotRound } from "@element-plus/icons-vue";

// 定义组件属性
const props = defineProps({
  data: {
    type: Object,
    required: true
  },
  comments: {
    type: Array,
    default: () => []
  }
});

const router = useRouter();

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
  let total = props.comments.length;
  props.comments.forEach((comment) => {
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
  const allComments = [...props.comments];
  props.comments.forEach((comment) => {
    if (comment.replies) {
      allComments.push(...comment.replies);
    }
  });
  const newId = allComments.length > 0 ? Math.max(...allComments.map((c) => c.id)) + 1 : 1;

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
    const mainComment = props.comments.find(
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
    props.comments.unshift({
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
  top: 100%;
  left: 0;
  margin-top: 8px;
  background-color: white;
  border-radius: 8px;
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
  padding: 16px;
  z-index: 1000;
  max-width: 300px;
  overflow-y: auto;
  max-height: 200px;
}

/* 表情选择器 */
.emoji-picker {
  display: flex;
  flex-wrap: wrap;
  gap: 8px;
}

/* 单个表情项 */
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
  align-items: center;
  gap: 12px;
  margin-top: 16px;
}

/* 短输入框 */
.short-input :deep(.el-input__inner) {
  width: 120px;
}

/* 头像上传按钮 */
.avatar-upload-btn {
  cursor: pointer;
}

/* 提交评论按钮 */
.submit-comment-btn :deep(.el-button__content) {
  display: flex;
  align-items: center;
  justify-content: center;
}

/* 自定义滚动条样式 */
.comments-section::-webkit-scrollbar {
  width: 6px;
}

.comments-section::-webkit-scrollbar-track {
  background: #f1f1f1;
  border-radius: 3px;
}

.comments-section::-webkit-scrollbar-thumb {
  background: #c1c1c1;
  border-radius: 3px;
}

.comments-section::-webkit-scrollbar-thumb:hover {
  background: #a8a8a8;
}

/* 响应式设计 */
@media (max-width: 1100px) {
  .comments-section {
    flex: 1;
    min-width: auto;
    position: static;
    height: auto;
  }
}
</style>