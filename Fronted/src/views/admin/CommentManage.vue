<template>
  <div class="comment-manage">
    <div class="page-header">
      <h1 class="page-title">评论管理</h1>
    </div>

    <div class="filter-bar">
      <input
        v-model="searchKeyword"
        type="text"
        class="search-input"
        placeholder="搜索评论内容..."
        @input="handleSearch"
      />
      <select v-model="filterStatus" class="filter-select" @change="handleFilter">
        <option value="">全部状态</option>
        <option value="approved">已通过</option>
        <option value="pending">待审核</option>
      </select>
    </div>

    <div class="content-list">
      <div v-for="comment in comments" :key="comment.id" class="content-item">
        <div class="content-main">
          <div class="content-header">
            <div class="user-info">
              <span class="user-name">{{ comment.userName }}</span>
              <span v-if="comment.recommended" class="badge-recommended">推荐</span>
              <span class="badge-status" :class="comment.status">
                {{ comment.status === 'approved' ? '已通过' : '待审核' }}
              </span>
            </div>
          </div>
          <p class="comment-content">{{ comment.content }}</p>
          <div class="comment-target">
            <span>💬 评论于: {{ comment.targetTitle }}</span>
          </div>
          <div class="content-meta">
            <span>📅 {{ formatDate(comment.createTime) }}</span>
            <span>❤️ {{ comment.likes || 0 }} 点赞</span>
          </div>
        </div>
        <div class="content-actions">
          <button
            v-if="comment.status === 'pending'"
            class="btn-icon btn-approve"
            @click="approveComment(comment.id)"
            title="通过"
          >
            ✓
          </button>
          <button
            class="btn-icon"
            :class="{ active: comment.recommended }"
            @click="toggleRecommend(comment)"
            title="推荐"
          >
            ⭐
          </button>
          <button class="btn-icon btn-danger" @click="deleteComment(comment.id)" title="删除">
            🗑️
          </button>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue';
import {
  fetchAllComments,
  approveComment as approveCommentApi,
  removeComment,
  toggleCommentRecommend
} from '@/api/comment/comment';
import { ElMessage } from 'element-plus';

const comments = ref([]);
const searchKeyword = ref('');
const filterStatus = ref('');

const formatDate = (dateStr) => {
  if (!dateStr) return '';
  const date = new Date(dateStr);
  return date.toLocaleDateString('zh-CN');
};

const handleSearch = () => {
  loadComments();
};

const handleFilter = () => {
  loadComments();
};

const approveComment = async (id) => {
  try {
    await approveCommentApi(id);
    ElMessage.success('审核通过');
    loadComments();
  } catch (error) {
    console.error('审核失败', error);
    ElMessage.error('审核失败');
  }
};

const toggleRecommend = async (comment) => {
  try {
    const newStatus = !comment.recommended;
    await toggleCommentRecommend(comment.id, newStatus);
    comment.recommended = newStatus;
    ElMessage.success('推荐状态已更新');
  } catch (error) {
    console.error('切换推荐失败', error);
    ElMessage.error('切换推荐失败');
  }
};

const deleteComment = async (id) => {
  if (!confirm('确定要删除这条评论吗？')) return;

  try {
    await removeComment(id);
    ElMessage.success('删除成功');
    loadComments();
  } catch (error) {
    console.error('删除失败', error);
    ElMessage.error('删除失败');
  }
};

const loadComments = async () => {
  try {
    const params = {
      keyword: searchKeyword.value,
      status: filterStatus.value
    };
    const res = await fetchAllComments(params);
    comments.value = res.data || [];
  } catch (error) {
    console.error('获取评论列表失败', error);
    ElMessage.error('获取评论列表失败');
  }
};

onMounted(() => {
  loadComments();
});
</script>

<style scoped>
.comment-manage {
  max-width: 1200px;
}

.page-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 24px;
}

.page-title {
  font-size: 28px;
  font-weight: 600;
  margin: 0;
  color: #000;
}

.filter-bar {
  display: flex;
  gap: 12px;
  margin-bottom: 24px;
}

.search-input {
  flex: 1;
  padding: 10px 16px;
  border: 1px solid #000;
  border-radius: 6px;
  font-size: 14px;
}

.search-input:focus {
  outline: none;
  box-shadow: 0 0 0 2px rgba(0, 0, 0, 0.1);
}

.filter-select {
  padding: 10px 16px;
  border: 1px solid #000;
  border-radius: 6px;
  font-size: 14px;
  background: #fff;
  cursor: pointer;
}

.content-list {
  display: flex;
  flex-direction: column;
  gap: 16px;
}

.content-item {
  background: #fff;
  border: 1px solid #000;
  border-radius: 8px;
  padding: 20px;
  display: flex;
  justify-content: space-between;
  align-items: flex-start;
  gap: 16px;
  transition: all 0.2s;
}

.content-item:hover {
  box-shadow: 4px 4px 0 #000;
  transform: translate(-2px, -2px);
}

.content-main {
  flex: 1;
}

.content-header {
  margin-bottom: 8px;
}

.user-info {
  display: flex;
  align-items: center;
  gap: 8px;
}

.user-name {
  font-size: 16px;
  font-weight: 600;
  color: #000;
}

.badge-recommended {
  background: #ffd700;
  color: #000;
  padding: 2px 8px;
  border-radius: 4px;
  font-size: 12px;
  font-weight: 600;
}

.badge-status {
  padding: 2px 8px;
  border-radius: 4px;
  font-size: 12px;
  font-weight: 600;
}

.badge-status.approved {
  background: #d4edda;
  color: #155724;
}

.badge-status.pending {
  background: #fff3cd;
  color: #856404;
}

.comment-content {
  font-size: 14px;
  color: #333;
  margin: 8px 0;
  line-height: 1.6;
}

.comment-target {
  font-size: 13px;
  color: #666;
  margin: 8px 0;
}

.content-meta {
  display: flex;
  gap: 16px;
  font-size: 13px;
  color: #999;
}

.content-actions {
  display: flex;
  gap: 8px;
}

.btn-icon {
  background: none;
  border: 1px solid #000;
  padding: 6px 12px;
  border-radius: 4px;
  cursor: pointer;
  font-size: 16px;
  transition: all 0.2s;
}

.btn-icon:hover {
  background: #000;
}

.btn-icon.active {
  background: #ffd700;
  border-color: #ffd700;
}

.btn-approve {
  font-size: 18px;
  font-weight: bold;
}

.btn-approve:hover {
  background: #28a745;
  border-color: #28a745;
  color: #fff;
}

.btn-danger:hover {
  background: #dc3545;
  border-color: #dc3545;
}

/* 移动端适配 */
@media (max-width: 768px) {
  .page-header {
    flex-direction: column;
    align-items: stretch;
    gap: 16px;
  }

  .page-title {
    font-size: 24px;
  }

  .filter-bar {
    flex-direction: column;
  }

  .content-item {
    flex-direction: column;
  }

  .content-actions {
    width: 100%;
    justify-content: flex-end;
  }
}
</style>
