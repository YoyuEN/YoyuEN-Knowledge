<template>
  <div class="content-manage">
    <div class="page-header">
      <h1 class="page-title">内容管理</h1>
      <button class="btn-primary" @click="showCreateDialog = true">
        <span>➕</span> 新建文章
      </button>
    </div>

    <div class="filter-bar">
      <input
        v-model="searchKeyword"
        type="text"
        class="search-input"
        placeholder="搜索文章标题..."
        @input="handleSearch"
      />
      <select v-model="filterStatus" class="filter-select" @change="handleFilter">
        <option value="">全部状态</option>
        <option value="published">已发布</option>
        <option value="draft">草稿</option>
      </select>
    </div>

    <div class="content-list">
      <div v-for="article in articles" :key="article.id" class="content-item">
        <div class="content-main">
          <div class="content-header">
            <h3 class="content-title">{{ article.title }}</h3>
            <span v-if="article.recommended" class="badge-recommended">推荐</span>
            <span class="badge-status" :class="article.status">
              {{ article.status === 'published' ? '已发布' : '草稿' }}
            </span>
          </div>
          <p class="content-summary">{{ article.summary }}</p>
          <div class="content-meta">
            <span>📅 {{ formatDate(article.createTime) }}</span>
            <span>👁️ {{ article.views || 0 }} 次浏览</span>
            <span>💬 {{ article.comments || 0 }} 条评论</span>
          </div>
        </div>
        <div class="content-actions">
          <button class="btn-icon" @click="editArticle(article)" title="编辑">✏️</button>
          <button
            class="btn-icon"
            :class="{ active: article.recommended }"
            @click="toggleRecommend(article)"
            title="推荐"
          >
            ⭐
          </button>
          <button class="btn-icon btn-danger" @click="deleteArticle(article.id)" title="删除">
            🗑️
          </button>
        </div>
      </div>
    </div>

    <!-- 创建/编辑对话框 -->
    <div v-if="showCreateDialog || showEditDialog" class="dialog-overlay" @click="closeDialog">
      <div class="dialog dialog-large" @click.stop>
        <div class="dialog-header">
          <h3>{{ showEditDialog ? '编辑文章' : '新建文章' }}</h3>
          <button class="close-btn" @click="closeDialog">✕</button>
        </div>
        <div class="dialog-body">
          <div class="form-group">
            <label>标题 *</label>
            <input
              v-model="articleForm.title"
              type="text"
              class="form-input"
              placeholder="输入文章标题"
            />
          </div>
          <div class="form-group">
            <label>摘要</label>
            <textarea
              v-model="articleForm.summary"
              class="form-textarea"
              rows="3"
              placeholder="输入文章摘要"
            ></textarea>
          </div>
          <div class="form-group">
            <label>内容 *</label>
            <textarea
              v-model="articleForm.content"
              class="form-textarea"
              rows="10"
              placeholder="输入文章内容（支持Markdown）"
            ></textarea>
          </div>
          <div class="form-row">
            <div class="form-group">
              <label>状态</label>
              <select v-model="articleForm.status" class="form-select">
                <option value="draft">草稿</option>
                <option value="published">发布</option>
              </select>
            </div>
            <div class="form-group">
              <label class="checkbox-label">
                <input v-model="articleForm.recommended" type="checkbox" />
                <span>设为推荐</span>
              </label>
            </div>
          </div>
        </div>
        <div class="dialog-footer">
          <button class="btn-secondary" @click="closeDialog">取消</button>
          <button class="btn-primary" @click="handleSave">保存</button>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue';
import {
  fetchAllContent,
  createContent,
  updateContent,
  removeContent,
  toggleContentRecommend
} from '@/api/content/content';
import { ElMessage } from 'element-plus';

const articles = ref([]);
const searchKeyword = ref('');
const filterStatus = ref('');
const showCreateDialog = ref(false);
const showEditDialog = ref(false);
const articleForm = ref({
  id: null,
  title: '',
  summary: '',
  content: '',
  status: 'draft',
  recommended: false
});

const formatDate = (dateStr) => {
  if (!dateStr) return '';
  const date = new Date(dateStr);
  return date.toLocaleDateString('zh-CN');
};

const handleSearch = () => {
  loadArticles();
};

const handleFilter = () => {
  loadArticles();
};

const editArticle = (article) => {
  articleForm.value = { ...article };
  showEditDialog.value = true;
};

const toggleRecommend = async (article) => {
  try {
    const newStatus = !article.recommended;
    await toggleContentRecommend(article.id, newStatus);
    article.recommended = newStatus;
    ElMessage.success('推荐状态已更新');
  } catch (error) {
    console.error('切换推荐失败', error);
    ElMessage.error('切换推荐失败');
  }
};

const deleteArticle = async (id) => {
  if (!confirm('确定要删除这篇文章吗？')) return;

  try {
    await removeContent(id);
    ElMessage.success('删除成功');
    loadArticles();
  } catch (error) {
    console.error('删除失败', error);
    ElMessage.error('删除失败');
  }
};

const handleSave = async () => {
  if (!articleForm.value.title || !articleForm.value.content) {
    ElMessage.warning('请填写标题和内容');
    return;
  }

  try {
    if (showEditDialog.value) {
      await updateContent(articleForm.value);
      ElMessage.success('更新成功');
    } else {
      await createContent(articleForm.value);
      ElMessage.success('创建成功');
    }
    closeDialog();
    loadArticles();
  } catch (error) {
    console.error('保存失败', error);
    ElMessage.error('保存失败');
  }
};

const closeDialog = () => {
  showCreateDialog.value = false;
  showEditDialog.value = false;
  articleForm.value = {
    id: null,
    title: '',
    summary: '',
    content: '',
    status: 'draft',
    recommended: false
  };
};

const loadArticles = async () => {
  try {
    const params = {
      keyword: searchKeyword.value,
      status: filterStatus.value
    };
    const res = await fetchAllContent(params);
    articles.value = res.data || [];
  } catch (error) {
    console.error('获取文章列表失败', error);
    ElMessage.error('获取文章列表失败');
  }
};

onMounted(() => {
  loadArticles();
});
</script>

<style scoped>
.content-manage {
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

.btn-primary {
  background: #000;
  color: #fff;
  border: 1px solid #000;
  padding: 10px 20px;
  border-radius: 6px;
  cursor: pointer;
  font-size: 14px;
  display: flex;
  align-items: center;
  gap: 6px;
  transition: all 0.2s;
}

.btn-primary:hover {
  background: #333;
}

.btn-secondary {
  background: #fff;
  color: #000;
  border: 1px solid #000;
  padding: 10px 20px;
  border-radius: 6px;
  cursor: pointer;
  font-size: 14px;
  transition: all 0.2s;
}

.btn-secondary:hover {
  background: #f5f5f5;
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
  display: flex;
  align-items: center;
  gap: 8px;
  margin-bottom: 8px;
}

.content-title {
  font-size: 18px;
  font-weight: 600;
  margin: 0;
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

.badge-status.published {
  background: #d4edda;
  color: #155724;
}

.badge-status.draft {
  background: #f8d7da;
  color: #721c24;
}

.content-summary {
  font-size: 14px;
  color: #666;
  margin: 8px 0;
  line-height: 1.6;
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

.btn-danger:hover {
  background: #dc3545;
  border-color: #dc3545;
}

/* 对话框样式 */
.dialog-overlay {
  position: fixed;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background: rgba(0, 0, 0, 0.5);
  display: flex;
  align-items: center;
  justify-content: center;
  z-index: 1000;
}

.dialog {
  background: #fff;
  border: 2px solid #000;
  border-radius: 8px;
  width: 90%;
  max-width: 600px;
  max-height: 90vh;
  overflow: auto;
}

.dialog-large {
  max-width: 800px;
}

.dialog-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 20px;
  border-bottom: 1px solid #000;
}

.dialog-header h3 {
  margin: 0;
  font-size: 20px;
  font-weight: 600;
}

.close-btn {
  background: none;
  border: none;
  font-size: 24px;
  cursor: pointer;
  padding: 0;
  width: 32px;
  height: 32px;
  display: flex;
  align-items: center;
  justify-content: center;
  border-radius: 4px;
  transition: all 0.2s;
}

.close-btn:hover {
  background: #f5f5f5;
}

.dialog-body {
  padding: 20px;
}

.form-group {
  margin-bottom: 16px;
}

.form-group label {
  display: block;
  font-size: 14px;
  font-weight: 600;
  margin-bottom: 8px;
  color: #000;
}

.form-input,
.form-textarea,
.form-select {
  width: 100%;
  padding: 10px;
  border: 1px solid #000;
  border-radius: 4px;
  font-size: 14px;
  box-sizing: border-box;
  font-family: inherit;
}

.form-input:focus,
.form-textarea:focus,
.form-select:focus {
  outline: none;
  box-shadow: 0 0 0 2px rgba(0, 0, 0, 0.1);
}

.form-textarea {
  resize: vertical;
}

.form-row {
  display: flex;
  gap: 16px;
}

.form-row .form-group {
  flex: 1;
}

.checkbox-label {
  display: flex;
  align-items: center;
  gap: 8px;
  cursor: pointer;
  font-weight: normal;
}

.checkbox-label input[type="checkbox"] {
  width: 18px;
  height: 18px;
  cursor: pointer;
}

.dialog-footer {
  display: flex;
  justify-content: flex-end;
  gap: 12px;
  padding: 20px;
  border-top: 1px solid #e0e0e0;
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

  .dialog {
    width: 95%;
  }

  .form-row {
    flex-direction: column;
  }
}
</style>
