<template>
  <div class="moment-manage">
    <div class="page-header">
      <h1 class="page-title">碎碎念管理</h1>
      <button class="btn-primary" @click="showCreateDialog = true">
        <span>➕</span> 新建碎碎念
      </button>
    </div>

    <div class="filter-bar">
      <input
        v-model="searchKeyword"
        type="text"
        class="search-input"
        placeholder="搜索内容..."
        @input="handleSearch"
      />
    </div>

    <div class="content-list">
      <div v-for="moment in moments" :key="moment.id" class="content-item">
        <div class="content-main">
          <p class="moment-content">{{ moment.content }}</p>
          <div class="content-meta">
            <span>📅 {{ formatDate(moment.createTime) }}</span>
            <span>❤️ {{ moment.likes || 0 }} 点赞</span>
          </div>
        </div>
        <div class="content-actions">
          <button class="btn-icon" @click="editMoment(moment)" title="编辑">✏️</button>
          <button class="btn-icon btn-danger" @click="deleteMoment(moment.id)" title="删除">
            🗑️
          </button>
        </div>
      </div>
    </div>

    <!-- 创建/编辑对话框 -->
    <div v-if="showCreateDialog || showEditDialog" class="dialog-overlay" @click="closeDialog">
      <div class="dialog" @click.stop>
        <div class="dialog-header">
          <h3>{{ showEditDialog ? '编辑碎碎念' : '新建碎碎念' }}</h3>
          <button class="close-btn" @click="closeDialog">✕</button>
        </div>
        <div class="dialog-body">
          <div class="form-group">
            <label>内容 *</label>
            <textarea
              v-model="momentForm.content"
              class="form-textarea"
              rows="6"
              placeholder="写下你的想法..."
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
  fetchMurmurList,
  createMurmur,
  updateMurmur,
  removeMurmur
} from '@/api/murmur/murmur';
import { ElMessage } from 'element-plus';

const moments = ref([]);
const searchKeyword = ref('');
const showCreateDialog = ref(false);
const showEditDialog = ref(false);
const momentForm = ref({
  id: null,
  content: ''
});

const formatDate = (dateStr) => {
  if (!dateStr) return '';
  const date = new Date(dateStr);
  return date.toLocaleDateString('zh-CN');
};

const handleSearch = () => {
  loadMoments();
};

const editMoment = (moment) => {
  momentForm.value = { ...moment };
  showEditDialog.value = true;
};

const deleteMoment = async (id) => {
  if (!confirm('确定要删除这条碎碎念吗？')) return;

  try {
    await removeMurmur(id);
    ElMessage.success('删除成功');
    loadMoments();
  } catch (error) {
    console.error('删除失败', error);
    ElMessage.error('删除失败');
  }
};

const handleSave = async () => {
  if (!momentForm.value.content) {
    ElMessage.warning('请填写内容');
    return;
  }

  try {
    if (showEditDialog.value) {
      await updateMurmur(momentForm.value);
      ElMessage.success('更新成功');
    } else {
      await createMurmur(momentForm.value);
      ElMessage.success('创建成功');
    }
    closeDialog();
    loadMoments();
  } catch (error) {
    console.error('保存失败', error);
    ElMessage.error('保存失败');
  }
};

const closeDialog = () => {
  showCreateDialog.value = false;
  showEditDialog.value = false;
  momentForm.value = {
    id: null,
    content: ''
  };
};

const loadMoments = async () => {
  try {
    const res = await fetchMurmurList();
    let list = res.data || [];

    // 客户端搜索过滤
    if (searchKeyword.value) {
      list = list.filter(item =>
        item.content.toLowerCase().includes(searchKeyword.value.toLowerCase())
      );
    }

    moments.value = list;
  } catch (error) {
    console.error('获取碎碎念列表失败', error);
    ElMessage.error('获取碎碎念列表失败');
  }
};

onMounted(() => {
  loadMoments();
});
</script>

<style scoped>
.moment-manage {
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

.moment-content {
  font-size: 16px;
  color: #000;
  margin: 0 0 12px 0;
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

.form-textarea {
  width: 100%;
  padding: 10px;
  border: 1px solid #000;
  border-radius: 4px;
  font-size: 14px;
  box-sizing: border-box;
  font-family: inherit;
  resize: vertical;
}

.form-textarea:focus {
  outline: none;
  box-shadow: 0 0 0 2px rgba(0, 0, 0, 0.1);
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
