<template>
  <section>
    <div class="admin-page-header">
      <h1 class="admin-page-title">
        <el-icon style="margin-right: 8px; vertical-align: -2px;"><Document /></el-icon>
        文章管理
      </h1>
      <el-button type="primary" @click="openCreate" :icon="Plus">新增文章</el-button>
    </div>

    <el-card class="admin-section-card">
      <div class="admin-toolbar">
        <el-input
          v-model="query.keyword"
          placeholder="搜索标题或内容"
          clearable
          @keyup.enter="loadData"
          :prefix-icon="Search"
          style="max-width: 280px;"
        />
        <el-select v-model="query.category" placeholder="全部分类" clearable style="width: 160px;">
          <el-option v-for="item in categories" :key="item.type" :label="item.name" :value="item.type" />
        </el-select>
        <div style="flex: 1;"></div>
        <el-button @click="resetQuery" :icon="RefreshLeft">重置</el-button>
        <el-button type="primary" @click="loadData" :icon="Search">查询</el-button>
      </div>

      <el-table
        :data="pagedRows"
        stripe
        v-loading="loading"
        style="margin-top: 16px;"
        :row-class-name="() => 'table-row-longpress'"
        @row-contextmenu="handleRowContextMenu"
      >
        <el-table-column prop="title" label="标题" min-width="240" show-overflow-tooltip>
          <template #default="{ row }">
            <div style="display: flex; align-items: center; gap: 8px;">
              <el-tag v-if="row.isRecommend" type="warning" size="small" effect="plain">推荐</el-tag>
              <span>{{ row.title }}</span>
            </div>
          </template>
        </el-table-column>
        <el-table-column label="分类" width="120">
          <template #default="{ row }">
            <el-tag size="small" effect="light">{{ row.categoryName || row.category }}</el-tag>
          </template>
        </el-table-column>
        <el-table-column label="标签" min-width="180">
          <template #default="{ row }">
            <el-tag v-for="tag in row.tags || []" :key="tag" size="small" effect="plain" style="margin-right: 6px;">{{ tag }}</el-tag>
            <span v-if="!row.tags || row.tags.length === 0" style="color: var(--admin-text-secondary);">-</span>
          </template>
        </el-table-column>
        <el-table-column label="统计" width="140" align="center">
          <template #default="{ row }">
            <div style="display: flex; gap: 12px; justify-content: center; font-size: 13px;">
              <span style="color: var(--admin-text-secondary);">
                <el-icon style="vertical-align: -2px;"><ChatDotRound /></el-icon> {{ row.commentCount || 0 }}
              </span>
              <span style="color: var(--admin-text-secondary);">
                <el-icon style="vertical-align: -2px;"><View /></el-icon> {{ row.viewCount || 0 }}
              </span>
            </div>
          </template>
        </el-table-column>
        <el-table-column prop="createTime" label="创建时间" width="170" />
        <el-table-column label="操作" width="240" fixed="right" class-name="hide-on-mobile">
          <template #default="{ row }">
            <el-button link @click="openEdit(row)" :icon="Edit">编辑</el-button>
            <el-button link @click="toggleRecommend(row)" :icon="Star">
              {{ row.isRecommend ? '取消推荐' : '推荐' }}
            </el-button>
            <el-button link type="danger" @click="deleteArticle(row)" :icon="Delete">删除</el-button>
          </template>
        </el-table-column>
      </el-table>

      <div style="margin-top: 20px; display: flex; justify-content: flex-end;">
        <el-pagination
          background
          layout="total, prev, pager, next, jumper"
          :total="filteredRows.length"
          :page-size="pageSize"
          v-model:current-page="currentPage"
        />
      </div>
    </el-card>

    <ContextMenu ref="contextMenuRef" :title="contextMenuTitle" :actions="contextMenuActions">
      <div v-if="selectedRow">
        <div style="margin-bottom: 8px;"><strong>标题：</strong>{{ selectedRow.title }}</div>
        <div style="margin-bottom: 8px;"><strong>分类：</strong>{{ selectedRow.categoryName || selectedRow.category }}</div>
        <div style="margin-bottom: 8px;"><strong>标签：</strong>{{ selectedRow.tags?.join(', ') || '-' }}</div>
        <div style="margin-bottom: 8px;"><strong>评论数：</strong>{{ selectedRow.commentCount || 0 }}</div>
        <div style="margin-bottom: 8px;"><strong>浏览数：</strong>{{ selectedRow.viewCount || 0 }}</div>
        <div style="margin-bottom: 8px;"><strong>创建时间：</strong>{{ selectedRow.createTime }}</div>
        <div v-if="selectedRow.summary" style="margin-top: 12px; padding-top: 12px; border-top: 1px solid #f0f0f0;">
          <strong>摘要：</strong>
          <div style="margin-top: 4px; color: #909399;">{{ selectedRow.summary }}</div>
        </div>
      </div>
    </ContextMenu>

    <el-dialog
      v-model="editorVisible"
      :title="isEdit ? '编辑内容' : '新增内容'"
      width="min(1000px, 96vw)"
      :close-on-click-modal="false"
    >
      <el-form :model="form" label-width="80px" label-position="top">
        <el-form-item label="内容类型">
          <ContentTypeSelector v-model="form.contentType" @change="handleContentTypeChange" />
        </el-form-item>

        <el-row :gutter="16">
          <el-col :span="24">
            <el-form-item label="标题">
              <el-input v-model="form.title" :placeholder="form.contentType === 'video' ? '请输入视频标题' : '请输入文章标题'" size="large" />
            </el-form-item>
          </el-col>
        </el-row>

        <el-row :gutter="16">
          <el-col :span="12">
            <el-form-item label="分类">
              <el-select v-model="form.category" placeholder="请选择分类" style="width: 100%;">
                <el-option v-for="item in categories" :key="item.type" :label="item.name" :value="item.type" />
              </el-select>
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="标签">
              <el-select v-model="form.tags" multiple filterable allow-create default-first-option placeholder="选择或输入标签" style="width: 100%;">
                <el-option v-for="item in tags" :key="item.name" :label="item.name" :value="item.name" />
              </el-select>
            </el-form-item>
          </el-col>
        </el-row>

        <el-form-item label="封面图片">
          <div style="display: flex; gap: 12px; align-items: flex-start; width: 100%;">
            <div style="flex: 1;">
              <el-upload
                class="cover-uploader"
                :show-file-list="false"
                :before-upload="beforeCoverUpload"
                :http-request="handleCoverUpload"
                accept="image/*"
                drag
              >
                <el-icon v-if="!form.cover" class="uploader-icon"><Plus /></el-icon>
                <img v-else :src="form.cover" class="cover-preview" />
                <div class="el-upload__text" v-if="!form.cover">
                  拖拽图片到此处或 <em>点击上传</em>
                </div>
              </el-upload>
            </div>
            <div style="flex: 2;">
              <el-input v-model="form.cover" placeholder="或直接输入图片URL" />
              <div style="margin-top: 8px; font-size: 12px; color: var(--admin-text-secondary);">
                {{ form.contentType === 'video' ? '视频封面图（可自动从视频提取）' : '支持拖拽上传或粘贴图片链接' }}
              </div>
            </div>
          </div>
        </el-form-item>

        <el-form-item v-if="form.contentType === 'video'" label="视频上传方式">
          <el-radio-group v-model="form.videoType" @change="handleVideoTypeChange">
            <el-radio value="file">上传视频文件</el-radio>
            <el-radio value="link">视频链接</el-radio>
          </el-radio-group>
        </el-form-item>

        <el-form-item v-if="form.contentType === 'video' && form.videoType === 'file'" label="视频文件">
          <VideoUploader
            v-model="form.videoUrl"
            @upload-success="handleVideoUploadSuccess"
          />
        </el-form-item>

        <el-form-item v-if="form.contentType === 'video' && form.videoType === 'link'" label="视频链接">
          <VideoLinkInput
            v-model="form.videoUrl"
            @link-change="handleVideoLinkChange"
          />
        </el-form-item>

        <el-form-item :label="form.contentType === 'video' ? '视频简介' : '文章简介'">
          <el-input
            v-model="form.description"
            type="textarea"
            :rows="3"
            maxlength="200"
            show-word-limit
            :placeholder="form.contentType === 'video' ? '请输入视频简介，用于列表展示和SEO' : '请输入文章简介，用于列表展示和SEO'"
          />
        </el-form-item>

        <el-form-item v-if="form.contentType === 'article'" label="正文内容 (Markdown)">
          <el-tabs v-model="editorTab" style="width: 100%;" class="editor-tabs">
            <el-tab-pane name="edit">
              <template #label>
                <span><el-icon style="vertical-align: -2px; margin-right: 4px;"><Edit /></el-icon>编辑</span>
              </template>
              <el-input
                v-model="form.content"
                type="textarea"
                :rows="16"
                placeholder="请输入 Markdown 格式的文章内容"
                style="font-family: 'Consolas', 'Monaco', monospace;"
              />
            </el-tab-pane>
            <el-tab-pane name="preview">
              <template #label>
                <span><el-icon style="vertical-align: -2px; margin-right: 4px;"><View /></el-icon>预览</span>
              </template>
              <div class="markdown-preview" v-html="markdownPreview" />
            </el-tab-pane>
          </el-tabs>
        </el-form-item>
      </el-form>

      <template #footer>
        <div style="display: flex; justify-content: space-between; align-items: center;">
          <span style="font-size: 13px; color: var(--admin-text-secondary);">
            <el-icon style="vertical-align: -2px;"><InfoFilled /></el-icon>
            提示：支持 Markdown 语法
          </span>
          <div>
            <el-button @click="editorVisible = false">取消</el-button>
            <el-button type="primary" :loading="submitting" @click="submitForm" :icon="Check">
              {{ submitting ? '保存中...' : '保存' }}
            </el-button>
          </div>
        </div>
      </template>
    </el-dialog>
  </section>
</template>

<script setup>
import { computed, onMounted, ref } from 'vue'
import { ElMessage, ElMessageBox } from 'element-plus'
import { marked } from 'marked'
import {
  Plus,
  Search,
  RefreshLeft,
  Document,
  Edit,
  Delete,
  Star,
  View,
  ChatDotRound,
  Check,
  InfoFilled,
} from '@element-plus/icons-vue'
import {
  createContent,
  fetchAllContent,
  fetchContentCategories,
  fetchContentTags,
  toggleContentRecommend,
  updateContent,
  removeContent,
  uploadContentCover,
} from '@/api/content/content'
import { fetchCommentCount, removeCommentsByContent } from '@/api/comment/comment'
import ContextMenu from '@/components/ContextMenu.vue'
import ContentTypeSelector from '@/components/ContentTypeSelector.vue'
import VideoUploader from '@/components/VideoUploader.vue'
import VideoLinkInput from '@/components/VideoLinkInput.vue'
import { useTableLongpress } from '@/composables/useTableLongpress'

const loading = ref(false)
const submitting = ref(false)
const rows = ref([])
const categories = ref([])
const tags = ref([])
const contextMenuRef = ref(null)
const selectedRow = ref(null)
const contextMenuTitle = ref('')
const contextMenuActions = ref([])

const showContextMenu = (e, row) => {
  selectedRow.value = row
  contextMenuTitle.value = '文章详情'
  contextMenuActions.value = [
    {
      label: '编辑',
      icon: Edit,
      handler: () => openEdit(row)
    },
    {
      label: row.isRecommend ? '取消推荐' : '推荐',
      icon: Star,
      handler: () => toggleRecommend(row)
    },
    {
      label: '删除',
      icon: Delete,
      danger: true,
      handler: () => deleteArticle(row)
    }
  ]

  const x = e.clientX || e.touches?.[0]?.clientX || 0
  const y = e.clientY || e.touches?.[0]?.clientY || 0
  contextMenuRef.value?.show(x, y)
}

const query = ref({ keyword: '', category: '' })

const editorVisible = ref(false)
const isEdit = ref(false)
const editorTab = ref('edit')
const form = ref({
  id: '',
  title: '',
  description: '',
  category: '',
  cover: '',
  content: '',
  tags: [],
  isRecommend: false,
  contentType: 'article',
  videoType: 'file',
  videoUrl: '',
  videoDuration: 0,
})

const markdownPreview = computed(() => marked.parse(form.value.content || ''))

const filteredRows = computed(() => {
  return rows.value.filter((item) => {
    const categoryMatch = !query.value.category || item.category === query.value.category
    return categoryMatch
  })
})

const currentPage = ref(1)
const pageSize = ref(10)

const pagedRows = computed(() => {
  const start = (currentPage.value - 1) * pageSize.value
  return filteredRows.value.slice(start, start + pageSize.value)
})

const { handleRowContextMenu } = useTableLongpress(showContextMenu, pagedRows, { pageSize: pageSize.value })

const defaultForm = () => ({
  id: '',
  title: '',
  description: '',
  category: categories.value[0]?.type || '',
  cover: '',
  content: '',
  tags: [],
  isRecommend: false,
  contentType: 'article',
  videoType: 'file',
  videoUrl: '',
  videoDuration: 0,
})

const loadBaseData = async () => {
  const [categoryRes, tagRes] = await Promise.all([
    fetchContentCategories(),
    fetchContentTags(),
  ])
  categories.value = categoryRes.data || []
  tags.value = tagRes.data || []
}

const loadData = async () => {
  loading.value = true
  try {
    const res = await fetchAllContent({ keyword: query.value.keyword })
    rows.value = res.data || []
    currentPage.value = 1
  } catch (error) {
    ElMessage.error(error.message || '加载文章失败')
  } finally {
    loading.value = false
  }
}

const resetQuery = () => {
  query.value = { keyword: '', category: '' }
  loadData()
}

const openCreate = () => {
  isEdit.value = false
  form.value = defaultForm()
  editorTab.value = 'edit'
  editorVisible.value = true
}

const openEdit = (row) => {
  isEdit.value = true
  form.value = {
    id: row.id,
    title: row.title || '',
    description: row.description || '',
    category: row.category || '',
    cover: row.cover || '',
    content: row.content || '',
    tags: row.tags || [],
    isRecommend: !!row.isRecommend,
    contentType: row.contentType || 'article',
    videoType: row.videoType || 'file',
    videoUrl: row.videoUrl || '',
    videoDuration: row.videoDuration || 0,
  }
  editorTab.value = 'edit'
  editorVisible.value = true
}

const beforeCoverUpload = (file) => {
  const isImage = file.type.startsWith('image/')
  const isLt5M = file.size / 1024 / 1024 < 5
  if (!isImage) {
    ElMessage.error('只能上传图片文件')
    return false
  }
  if (!isLt5M) {
    ElMessage.error('图片大小不能超过 5MB')
    return false
  }
  return true
}

const handleCoverUpload = async ({ file }) => {
  try {
    const res = await uploadContentCover(file)
    form.value.cover = res.data.cover
    ElMessage.success('封面上传成功')
  } catch (error) {
    ElMessage.error(error.message || '封面上传失败')
  }
}

const handleContentTypeChange = (type) => {
  if (type === 'video') {
    form.value.content = ''
  } else {
    form.value.videoUrl = ''
    form.value.videoType = 'file'
    form.value.videoDuration = 0
  }
}

const handleVideoTypeChange = () => {
  form.value.videoUrl = ''
  form.value.videoDuration = 0
}

const handleVideoUploadSuccess = (data) => {
  form.value.videoUrl = data.url
  form.value.videoDuration = data.duration || 0
  if (data.cover && !form.value.cover) {
    form.value.cover = data.cover
  }
}

const handleVideoLinkChange = (data) => {
  form.value.videoUrl = data.url
}

const submitForm = async () => {
  if (!form.value.title || !form.value.category) {
    ElMessage.warning('请补齐标题和分类')
    return
  }

  if (form.value.contentType === 'article' && !form.value.content) {
    ElMessage.warning('请填写文章正文')
    return
  }

  if (form.value.contentType === 'video' && !form.value.videoUrl) {
    ElMessage.warning('请上传视频或填写视频链接')
    return
  }

  submitting.value = true
  try {
    const payload = {
      ...form.value,
      tags: form.value.tags || [],
      isRecommend: !!form.value.isRecommend,
    }

    if (isEdit.value) {
      await updateContent(payload)
      ElMessage.success('内容更新成功')
    } else {
      await createContent(payload)
      ElMessage.success('内容创建成功')
    }

    editorVisible.value = false
    await Promise.all([loadBaseData(), loadData()])
  } catch (error) {
    ElMessage.error(error.message || '保存失败')
  } finally {
    submitting.value = false
  }
}

const toggleRecommend = async (row) => {
  try {
    await toggleContentRecommend(row.id, !row.isRecommend)
    ElMessage.success('推荐状态已更新')
    await loadData()
  } catch (error) {
    ElMessage.error(error.message || '更新推荐状态失败')
  }
}

const deleteArticle = async (row) => {
  try {
    await ElMessageBox.confirm(`确认删除文章「${row.title}」吗？`, '删除确认', {
      type: 'warning',
      confirmButtonText: '确认删除',
      cancelButtonText: '取消',
    })

    await removeContent(row.id)
    ElMessage.success('删除成功')
    await loadData()
  } catch (error) {
    const msg = error?.message || ''
    if (msg.includes('请先删除评论')) {
      const countRes = await fetchCommentCount(row.id)
      const commentCount = countRes.data || 0
      try {
        await ElMessageBox.confirm(
          `文章下仍有 ${commentCount} 条评论。是否先删除这些评论，再删除文章？`,
          '需要先清理评论',
          {
            type: 'warning',
            confirmButtonText: '先删评论再删文章',
            cancelButtonText: '取消',
          },
        )
        await removeCommentsByContent(row.id)
        await removeContent(row.id)
        ElMessage.success('评论和文章已删除')
        await loadData()
      } catch (innerError) {
        if (innerError !== 'cancel') {
          ElMessage.error(innerError.message || '删除失败')
        }
      }
      return
    }
    if (error !== 'cancel') {
      ElMessage.info('已取消删除')
    }
  }
}

onMounted(async () => {
  await loadBaseData()
  await loadData()
})
</script>

<style scoped>
.table-row-longpress {
  cursor: pointer;
  user-select: none;
}

@media (max-width: 768px) {
  :deep(.hide-on-mobile) {
    display: none !important;
  }
}
</style>
