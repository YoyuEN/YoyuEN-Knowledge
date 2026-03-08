<template>
  <div class="photo-manage">
    <div class="page-header">
      <h1 class="page-title">照片管理</h1>
      <button class="btn-primary" @click="showUploadDialog = true">
        <span>➕</span> 上传照片
      </button>
    </div>

    <div class="photo-grid">
      <div v-for="photo in photos" :key="photo.id" class="photo-card">
        <div class="photo-preview">
          <img :src="photo.url" :alt="photo.description" />
        </div>
        <div class="photo-info">
          <div class="photo-desc">{{ photo.description || '无描述' }}</div>
          <div class="photo-date">{{ formatDate(photo.createTime) }}</div>
        </div>
        <div class="photo-actions">
          <button class="btn-icon" @click="editPhoto(photo)" title="编辑">✏️</button>
          <button class="btn-icon btn-danger" @click="deletePhoto(photo.id)" title="删除">🗑️</button>
        </div>
      </div>
    </div>

    <!-- 上传对话框 -->
    <div v-if="showUploadDialog" class="dialog-overlay" @click="showUploadDialog = false">
      <div class="dialog" @click.stop>
        <div class="dialog-header">
          <h3>上传照片</h3>
          <button class="close-btn" @click="showUploadDialog = false">✕</button>
        </div>
        <div class="dialog-body">
          <div class="upload-area" @click="$refs.fileInput.click()">
            <input
              ref="fileInput"
              type="file"
              accept="image/*"
              @change="handleFileSelect"
              style="display: none"
            />
            <div v-if="!previewUrl" class="upload-placeholder">
              <span class="upload-icon">📁</span>
              <p>点击选择图片</p>
            </div>
            <img v-else :src="previewUrl" class="upload-preview" />
          </div>
          <div class="form-group">
            <label>描述</label>
            <input
              v-model="uploadForm.description"
              type="text"
              class="form-input"
              placeholder="输入照片描述（可选）"
            />
          </div>
        </div>
        <div class="dialog-footer">
          <button class="btn-secondary" @click="showUploadDialog = false">取消</button>
          <button class="btn-primary" @click="handleUpload" :disabled="!selectedFile">上传</button>
        </div>
      </div>
    </div>

    <!-- 编辑对话框 -->
    <div v-if="showEditDialog" class="dialog-overlay" @click="showEditDialog = false">
      <div class="dialog" @click.stop>
        <div class="dialog-header">
          <h3>编辑照片</h3>
          <button class="close-btn" @click="showEditDialog = false">✕</button>
        </div>
        <div class="dialog-body">
          <div class="form-group">
            <label>描述</label>
            <input
              v-model="editForm.description"
              type="text"
              class="form-input"
              placeholder="输入照片描述"
            />
          </div>
        </div>
        <div class="dialog-footer">
          <button class="btn-secondary" @click="showEditDialog = false">取消</button>
          <button class="btn-primary" @click="handleEditSave">保存</button>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue';
import { fetchPhotoList, uploadPhoto, updatePhoto, removePhoto } from '../../api/photo/photo.js';
import { ElMessage } from 'element-plus';

const photos = ref([]);
const showUploadDialog = ref(false);
const showEditDialog = ref(false);
const selectedFile = ref(null);
const previewUrl = ref('');
const uploadForm = ref({
  description: ''
});
const editForm = ref({
  id: null,
  description: ''
});

const formatDate = (dateStr) => {
  if (!dateStr) return '';
  const date = new Date(dateStr);
  return date.toLocaleDateString('zh-CN');
};

const handleFileSelect = (event) => {
  const file = event.target.files[0];
  if (file) {
    selectedFile.value = file;
    previewUrl.value = URL.createObjectURL(file);
  }
};

const handleUpload = async () => {
  if (!selectedFile.value) return;

  const formData = new FormData();
  formData.append('file', selectedFile.value);
  formData.append('description', uploadForm.value.description);

  try {
    await uploadPhoto(formData);
    ElMessage.success('上传成功');
    showUploadDialog.value = false;
    selectedFile.value = null;
    previewUrl.value = '';
    uploadForm.value.description = '';
    loadPhotos();
  } catch (error) {
    console.error('上传失败', error);
    ElMessage.error('上传失败');
  }
};

const editPhoto = (photo) => {
  editForm.value = {
    id: photo.id,
    description: photo.description || ''
  };
  showEditDialog.value = true;
};

const handleEditSave = async () => {
  try {
    await updatePhoto(editForm.value);
    ElMessage.success('更新成功');
    showEditDialog.value = false;
    loadPhotos();
  } catch (error) {
    console.error('更新失败', error);
    ElMessage.error('更新失败');
  }
};

const deletePhoto = async (id) => {
  if (!confirm('确定要删除这张照片吗？')) return;

  try {
    await removePhoto(id);
    ElMessage.success('删除成功');
    loadPhotos();
  } catch (error) {
    console.error('删除失败', error);
    ElMessage.error('删除失败');
  }
};

const loadPhotos = async () => {
  try {
    const res = await fetchPhotoList();
    photos.value = res.data || [];
  } catch (error) {
    console.error('获取照片列表失败', error);
    ElMessage.error('获取照片列表失败');
  }
};

onMounted(() => {
  loadPhotos();
});
</script>

<style scoped>
.photo-manage {
  max-width: 1200px;
}

.page-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 30px;
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

.btn-primary:disabled {
  background: #ccc;
  border-color: #ccc;
  cursor: not-allowed;
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

.photo-grid {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(280px, 1fr));
  gap: 20px;
}

.photo-card {
  background: #fff;
  border: 1px solid #000;
  border-radius: 8px;
  overflow: hidden;
  transition: all 0.2s;
}

.photo-card:hover {
  box-shadow: 4px 4px 0 #000;
  transform: translate(-2px, -2px);
}

.photo-preview {
  width: 100%;
  height: 200px;
  overflow: hidden;
  background: #f5f5f5;
}

.photo-preview img {
  width: 100%;
  height: 100%;
  object-fit: cover;
}

.photo-info {
  padding: 12px;
  border-top: 1px solid #e0e0e0;
}

.photo-desc {
  font-size: 14px;
  color: #000;
  margin-bottom: 4px;
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
}

.photo-date {
  font-size: 12px;
  color: #999;
}

.photo-actions {
  display: flex;
  gap: 8px;
  padding: 12px;
  border-top: 1px solid #e0e0e0;
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
  max-width: 500px;
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

.upload-area {
  border: 2px dashed #000;
  border-radius: 8px;
  padding: 40px;
  text-align: center;
  cursor: pointer;
  transition: all 0.2s;
  margin-bottom: 20px;
}

.upload-area:hover {
  background: #f9f9f9;
}

.upload-placeholder {
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 12px;
}

.upload-icon {
  font-size: 48px;
}

.upload-preview {
  max-width: 100%;
  max-height: 300px;
  border-radius: 4px;
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

.form-input {
  width: 100%;
  padding: 10px;
  border: 1px solid #000;
  border-radius: 4px;
  font-size: 14px;
  box-sizing: border-box;
}

.form-input:focus {
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

  .photo-grid {
    grid-template-columns: repeat(auto-fill, minmax(150px, 1fr));
    gap: 12px;
  }

  .photo-preview {
    height: 150px;
  }

  .dialog {
    width: 95%;
  }

  .upload-area {
    padding: 20px;
  }
}
</style>
