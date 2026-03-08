<template>
  <div class="knowledge-manage">
    <div class="page-header">
      <h1 class="page-title">知识库管理</h1>
      <button class="btn-primary" @click="showCreateDialog = true">
        <span>➕</span> 新建知识
      </button>
    </div>

    <div class="filter-bar">
      <input
        v-model="searchKeyword"
        type="text"
        class="search-input"
        placeholder="搜索知识标题..."
        @input="handleSearch"
      />
      <select v-model="filterCategory" class="filter-select" @change="handleFilter">
        <option value="">全部分类</option>
        <option value="tech">技术</option>
        <option value="life">生活</option>
        <option value="other">其他</option>
      </select>
    </div>

    <div class="content-list">
      <div v-for="knowledge in knowledgeList" :key="knowledge.id" class="content-item">
        <div class="content-main">
          <div class="content-header">
            <h3 class="content-title">{{ knowledge.title }}</h3>
            <span class="badge-category">{{ getCategoryLabel(knowledge.category) }}</span>
          </div>
          <p class="content-summary">{{ knowledge.content }}</p>
          <div class="content-meta">
            <span>📅 {{ formatDate(knowledge.createTime) }}</span>
            <span>👁️ {{ knowledge.views || 0 }} 次浏览</span>
          </div>
        </div>
        <div class="content-actions">
          <button class="btn-icon" @click="editKnowledge(knowledge)" title="编辑">✏️</button>
          <button class="btn-icon btn-danger" @click="deleteKnowledge(knowledge.id)" title="删除">
            🗑️
          </button>
        </div>
      </div>
    </div>

    <!-- 创建/编辑对话框 -->
    <div v-if="showCreateDialog || showEditDialog" class="dialog-overlay" @click="closeDialog">
      <div class="dialog dialog-large" @click.stop>
        <div class="dialog-header">
          <h3>{{ showEditDialog ? '编辑知识' : '新建知识' }}</h3>
          <button class="close-btn" @click="closeDialog">✕</button>
        </div>
        <div class="dialog-body">
          <div class="form-group">
            <label>标题 *</label>
            <input
              v-model="knowledgeForm.title"
              type="text"
              class="form-input"
              placeholder="输入知识标题"
            />
          </div>
          <div class="form-group">
            <label>分类</label>
            <select v-model="knowledgeForm.category" class="form-select">
              <option value="tech">技术</option>
              <option value="life">生活</option>
              <option value="other">其他</option>
            </select>
          </div>
          <div class="form-group">
            <label>内容 *</label>
            <textarea
              v-model="knowledgeForm.content"
              class="form-textarea"
              rows="10"
              placeholder="输入知识内容"
            ></textarea>
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
  fetchKnowledgeList,
  createKnowledge,
  updateKnowledge,
  removeKnowledge
} from '@/api/knowledge/knowledge';
import { ElMessage } from 'element-plus';

const knowledgeList = ref([]);
const searchKeyword = ref('');
const filterCategory = ref('');
const showCreateDialog = ref(false);
const showEditDialog = ref(false);
const knowledgeForm = ref({
  id: null,
  title: '',
  content: '',
  category: 'tech'
});

const formatDate = (dateStr) => {
  if (!dateStr) return '';
  const date = new Date(dateStr);
  return date.toLocaleDateString('zh-CN');
};

const getCategoryLabel = (category) => {
  const labels = {
    tech: '技术',
    life: '生活',
    other: '其他'
  };
  return labels[category] || category;
};

const handleSearch = () => {
  loadKnowledge();
};

const handleFilter = () => {
  loadKnowledge();
};

const editKnowledge = (knowledge) => {
  knowledgeForm.value = { ...knowledge };
  showEditDialog.value = true;
};

const deleteKnowledge = async (id) => {
  if (!confirm('确定要删除这条知识吗？')) return;

  try {
    await removeKnowledge(id);
    ElMessage.success('删除成功');
    loadKnowledge();
  } catch (error) {
    console.error('删除失败', error);
    ElMessage.error('删除失败');
  }
};

const handleSave = async () => {
  if (!knowledgeForm.value.title || !knowledgeForm.value.content) {
    ElMessage.warning('请填写标题和内容');
    return;
  }

  try {
    if (showEditDialog.value) {
      await updateKnowledge(knowledgeForm.value);
      ElMessage.success('更新成功');
    } else {
      await createKnowledge(knowledgeForm.value);
      ElMessage.success('创建成功');
    }
    closeDialog();
    loadKnowledge();
  } catch (error) {
    console.error('保存失败', error);
    ElMessage.error('保存失败');
  }
};

const closeDialog = () => {
  showCreateDialog.value = false;
  showEditDialog.value = false;
  knowledgeForm.value = {
    id: null,
    title: '',
    content: '',
    category: 'tech'
  };
};

const loadKnowledge = async () => {
  try {
    const params = {
      keyword: searchKeyword.value,
      category: filterCategory.value
    };
    const res = await fetchKnowledgeList(params);
    knowledgeList.value = res.data || [];
  } catch (error) {
    console.error('获取知识列表失败', error);
    ElMessage.error('获取知识列表失败');
  }
};

onMounted(() => {
  loadKnowledge();
});
</script>

<style scoped>
.knowledge-manage {
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

.badge-category {
  background: #e3f2fd;
  color: #1976d2;
  padding: 2px 8px;
  border-radius: 4px;
  font-size: 12px;
  font-weight: 600;
}

.content-summary {
  font-size: 14px;
  color: #666;
  margin: 8px 0;
  line-height: 1.6;
  overflow: hidden;
  text-overflow: ellipsis;
  display: -webkit-box;
  -webkit-line-clamp: 2;
  -webkit-box-orient: vertical;
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
}
</style>
