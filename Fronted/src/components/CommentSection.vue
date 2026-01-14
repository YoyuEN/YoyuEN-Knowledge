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

</style>