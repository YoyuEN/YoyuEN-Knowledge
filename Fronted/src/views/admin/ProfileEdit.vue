<template>
  <section class="list-page-container">
    <el-card class="admin-section-card">
      <div class="admin-toolbar">
        <span style="font-size: 16px; font-weight: 600; color: #141413;">个人信息</span>
        <div style="flex: 1;"></div>
        <el-button type="primary" :loading="submitting" @click="submitForm" :icon="Check">保存</el-button>
      </div>

      <div style="max-width: 720px;">
        <el-form :model="form" label-width="100px" label-position="top">
          <el-row :gutter="20">
            <el-col :span="12">
              <el-form-item label="昵称">
                <el-input v-model="form.nickname" placeholder="请输入昵称" />
              </el-form-item>
            </el-col>
            <el-col :span="12">
              <el-form-item label="邮箱">
                <el-input v-model="form.email" placeholder="请输入邮箱" />
              </el-form-item>
            </el-col>
          </el-row>

          <el-form-item label="头像">
            <div style="display: flex; gap: 12px; align-items: flex-start; width: 100%;">
              <el-avatar :size="64" :src="form.avatar || '/src/assets/picture/YoyuEN.png'" />
              <div style="flex: 1; display: flex; flex-direction: column; gap: 8px;">
                <el-upload
                  class="avatar-uploader"
                  :show-file-list="false"
                  :before-upload="beforeAvatarUpload"
                  :http-request="handleAvatarUpload"
                  accept="image/*"
                  drag
                  style="width: 100%;"
                >
                  <div style="display: flex; align-items: center; justify-content: center; gap: 6px; padding: 6px 0;">
                    <el-icon style="font-size: 18px; color: var(--dt-muted);"><Plus /></el-icon>
                    <span style="font-size: 12px; color: var(--dt-muted);">点击或拖拽上传头像</span>
                  </div>
                </el-upload>
                <el-input v-model="form.avatar" placeholder="或输入头像图片URL" size="small" />
              </div>
            </div>
          </el-form-item>

          <el-row :gutter="20">
            <el-col :span="12">
              <el-form-item label="学校 / 公司">
                <el-input v-model="form.school" placeholder="请输入学校或公司" />
              </el-form-item>
            </el-col>
            <el-col :span="12">
              <el-form-item label="所在地">
                <el-input v-model="form.location" placeholder="请输入所在地" />
              </el-form-item>
            </el-col>
          </el-row>

          <el-form-item label="个性签名">
            <el-input v-model="form.signature" placeholder="请输入个性签名" />
          </el-form-item>

          <el-form-item label="欢迎语 / 自我介绍">
            <el-input
              v-model="form.welcomeText"
              type="textarea"
              :rows="4"
              placeholder="请输入欢迎语或自我介绍"
            />
          </el-form-item>

          <el-form-item label="技术栈">
            <div class="tag-editor">
              <el-tag
                v-for="(tag, index) in techStackList"
                :key="tag"
                closable
                effect="plain"
                @close="techStackList.splice(index, 1)"
              >
                {{ tag }}
              </el-tag>
              <div class="tag-add-row">
                <el-input
                  v-model="newTechStack"
                  placeholder="输入后点击新增"
                  size="small"
                  @keyup.enter="addTechStack"
                />
                <el-button type="primary" size="small" @click="addTechStack" :icon="Plus">新增</el-button>
              </div>
            </div>
          </el-form-item>

          <el-form-item label="个人标签">
            <div class="tag-editor">
              <el-tag
                v-for="(tag, index) in tagsList"
                :key="tag"
                closable
                effect="plain"
                @close="tagsList.splice(index, 1)"
              >
                {{ tag }}
              </el-tag>
              <div class="tag-add-row">
                <el-input
                  v-model="newTag"
                  placeholder="输入后点击新增"
                  size="small"
                  @keyup.enter="addTag"
                />
                <el-button type="primary" size="small" @click="addTag" :icon="Plus">新增</el-button>
              </div>
            </div>
          </el-form-item>
        </el-form>
      </div>
    </el-card>
  </section>
</template>

<script setup>
import { ref, onMounted, watch } from 'vue'
import { ElMessage } from 'element-plus'
import { Check, Plus } from '@element-plus/icons-vue'
import { fetchProfileDetail, updateProfile } from '@/api/profile/profile.js'
import { uploadContentCover } from '@/api/content/content.js'

const submitting = ref(false)

const form = ref({
  id: '',
  nickname: '',
  avatar: '',
  signature: '',
  welcomeText: '',
  school: '',
  email: '',
  location: '',
  techStack: '',
  tags: '',
})

const techStackList = ref([])
const tagsList = ref([])
const newTechStack = ref('')
const newTag = ref('')

watch(techStackList, (val) => {
  form.value.techStack = JSON.stringify(val)
})

watch(tagsList, (val) => {
  form.value.tags = JSON.stringify(val)
})

const loadData = async () => {
  try {
    const res = await fetchProfileDetail()
    const data = res.data || {}
    form.value = {
      id: data.id || '',
      nickname: data.nickname || '',
      avatar: data.avatar || '',
      signature: data.signature || '',
      welcomeText: data.welcomeText || '',
      school: data.school || '',
      email: data.email || '',
      location: data.location || '',
      techStack: data.techStack || '',
      tags: data.tags || '',
    }
    try {
      techStackList.value = data.techStack ? JSON.parse(data.techStack) : []
    } catch {
      techStackList.value = data.techStack ? [data.techStack] : []
    }
    try {
      tagsList.value = data.tags ? JSON.parse(data.tags) : []
    } catch {
      tagsList.value = data.tags ? [data.tags] : []
    }
  } catch (error) {
    ElMessage.error(error.message || '加载个人信息失败')
  }
}

const addTechStack = () => {
  const val = newTechStack.value.trim()
  if (!val) return
  if (!techStackList.value.includes(val)) {
    techStackList.value.push(val)
  }
  newTechStack.value = ''
}

const addTag = () => {
  const val = newTag.value.trim()
  if (!val) return
  if (!tagsList.value.includes(val)) {
    tagsList.value.push(val)
  }
  newTag.value = ''
}

const beforeAvatarUpload = (file) => {
  const isImage = file.type.startsWith('image/')
  const isLt2M = file.size / 1024 / 1024 < 2
  if (!isImage) {
    ElMessage.error('只能上传图片文件')
    return false
  }
  if (!isLt2M) {
    ElMessage.error('头像大小不能超过 2MB')
    return false
  }
  return true
}

const handleAvatarUpload = async ({ file }) => {
  const localUrl = URL.createObjectURL(file)
  form.value.avatar = localUrl

  try {
    const res = await uploadContentCover(file)
    if (res.data?.url) {
      form.value.avatar = res.data.url
      ElMessage.success('头像上传成功')
    } else {
      ElMessage.warning('上传成功但未返回地址')
    }
  } catch (error) {
    ElMessage.error(error.message || '头像上传失败')
  }
}

const submitForm = async () => {
  submitting.value = true
  try {
    const payload = { ...form.value }
    await updateProfile(payload)
    ElMessage.success('保存成功')
    await loadData()
  } catch (error) {
    ElMessage.error(error.message || '保存失败')
  } finally {
    submitting.value = false
  }
}

onMounted(() => {
  loadData()
})
</script>

<style scoped>
.list-page-container {
  height: 100%;
  display: flex;
  flex-direction: column;
}

.admin-toolbar {
  display: flex;
  align-items: center;
  gap: 12px;
  padding-bottom: 16px;
  border-bottom: 1px solid var(--admin-border);
  margin-bottom: 16px;
}

:deep(.el-form-item__label) {
  font-weight: 500;
  color: #3d3d3a;
  font-size: 13px;
}

:deep(.el-input__wrapper) {
  border-radius: 8px;
  border: 1px solid #e6dfd8;
  background: #faf9f5;
  box-shadow: none !important;
}

:deep(.el-input__wrapper.is-focus) {
  border-color: #cc785c;
  outline: 3px solid rgba(204, 120, 92, 0.15);
}

:deep(.el-textarea__inner) {
  border-radius: 8px;
  border: 1px solid #e6dfd8;
  background: #faf9f5;
  box-shadow: none !important;
}

:deep(.el-textarea__inner:focus) {
  border-color: #cc785c;
  outline: 3px solid rgba(204, 120, 92, 0.15);
}

:deep(.avatar-uploader .el-upload-dragger) {
  border-radius: 8px;
  border: 1px dashed #e6dfd8;
  background: #f5f0e8;
  padding: 0;
  transition: all 0.3s;
}

:deep(.avatar-uploader .el-upload-dragger:hover) {
  border-color: #cc785c;
  background: #efe9de;
}

.tag-editor {
  display: flex;
  flex-wrap: wrap;
  gap: 8px;
  align-items: center;
}

.tag-add-row {
  display: flex;
  gap: 8px;
  align-items: center;
  flex: 1;
  min-width: 200px;
}
</style>
