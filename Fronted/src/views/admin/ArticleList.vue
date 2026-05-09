<template>
  <section class="list-page-container">
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
        <el-select v-model="query.category" placeholder="全部分类" clearable style="width: 140px;">
          <el-option v-for="item in categories" :key="item.type" :label="item.name" :value="item.type" />
        </el-select>
        <el-select v-model="query.tag" placeholder="全部标签" clearable style="width: 140px;" @change="loadData">
          <el-option v-for="item in tags" :key="item.name" :label="item.name" :value="item.name" />
        </el-select>
        <div style="flex: 1;"></div>
        <el-button type="primary" @click="openCreate" :icon="Plus">新增文章</el-button>
        <el-button type="warning" @click="resetQuery" :icon="RefreshLeft">重置</el-button>
        <el-button type="primary" @click="loadData" :icon="Search">查询</el-button>
      </div>

      <div class="table-container">
        <el-table
          :data="pagedRows"
          v-loading="loading"
          :row-class-name="() => 'table-row-longpress'"
          @row-contextmenu="handleRowContextMenu"
        >
          <el-table-column label="封面" width="150" align="center">
            <template #default="{ row }">
              <div
                v-if="row.cover"
                class="cover-thumb"
                @click.stop="previewCover(row.cover)"
              >
                <img :src="row.cover" class="cover-thumb-img" />
              </div>
              <span v-else style="color: var(--admin-text-secondary); font-size: 12px;">-</span>
            </template>
          </el-table-column>
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
              <el-tag
                v-for="tag in row.tags || []"
                :key="tag"
                size="small"
                effect="plain"
                style="margin-right: 6px;"
              >{{ tag }}</el-tag>
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
              <el-button link type="success" @click="toggleRecommend(row)" :icon="Star">
                {{ row.isRecommend ? '取消推荐' : '推荐' }}
              </el-button>
              <el-button link type="danger" @click="deleteArticle(row)" :icon="Delete">删除</el-button>
            </template>
          </el-table-column>
        </el-table>
      </div>

      <div class="pagination-container">
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
      width="min(1200px, 94vw)"
      :close-on-click-modal="false"
      :lock-scroll="true"
      class="custom-dialog"
    >
      <el-form :model="form" label-width="80px" label-position="top">
        <el-row :gutter="20">
          <!-- 左侧：元信息 -->
          <el-col :xs="24" :sm="24" :md="12">
            <el-form-item label="内容类型">
              <ContentTypeSelector v-model="form.contentType" @change="handleContentTypeChange" />
            </el-form-item>

            <el-form-item label="标题">
              <el-input v-model="form.title" :placeholder="form.contentType === 'video' ? '请输入视频标题' : '请输入文章标题'" size="large" />
            </el-form-item>

            <el-row :gutter="12">
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

            <el-form-item v-if="form.contentType !== 'video'" label="封面图片">
              <div class="cover-row">
                <div class="cover-upload-col">
                  <el-upload
                    class="cover-uploader"
                    :show-file-list="false"
                    :before-upload="beforeCoverUpload"
                    :http-request="handleCoverUpload"
                    accept="image/*"
                    drag
                  >
                    <template v-if="coverGenerating">
                      <div class="cover-placeholder cover-generating">
                        <el-icon class="cover-generating-icon is-loading"><Loading /></el-icon>
                        <span class="cover-placeholder-text">AI 生成封面中...</span>
                      </div>
                    </template>
                    <template v-else-if="!form.cover">
                      <div class="cover-placeholder">
                        <el-icon class="cover-placeholder-icon"><Plus /></el-icon>
                        <span class="cover-placeholder-text">拖拽图片到此处或 <em>点击上传</em></span>
                      </div>
                    </template>
                    <template v-else>
                      <div class="cover-preview-box">
                        <img :src="form.cover" class="cover-preview-img" />
                        <div class="cover-preview-overlay">
                          <el-icon><Edit /></el-icon>
                          <span>更换封面</span>
                        </div>
                      </div>
                    </template>
                  </el-upload>
                </div>
                <div class="cover-url-col">
                  <el-input v-model="form.cover" placeholder="或直接粘贴图片链接" size="small" />
                  <span class="cover-hint">支持上传或粘贴图片链接</span>
                </div>
              </div>
            </el-form-item>

            <template v-if="form.contentType === 'video'">
              <el-form-item label="视频上传方式">
                <el-radio-group v-model="form.videoType" @change="handleVideoTypeChange">
                  <el-radio value="file">上传视频文件</el-radio>
                  <el-radio value="link">视频链接</el-radio>
                </el-radio-group>
              </el-form-item>

              <el-form-item v-if="form.videoType === 'file'" label="视频文件">
                <VideoUploader v-model="form.videoUrl" @upload-success="handleVideoUploadSuccess" />
              </el-form-item>

              <el-form-item v-if="form.videoType === 'link'" label="视频链接">
                <VideoLinkInput v-model="form.videoUrl" @link-change="handleVideoLinkChange" />
              </el-form-item>
            </template>

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
          </el-col>

          <!-- 右侧：正文 -->
          <el-col :xs="24" :sm="24" :md="12">
            <el-form-item label="正文内容 (Markdown)" style="height: 100%; margin-bottom: 0;">
              <el-tabs v-model="editorTab" style="width: 100%;" class="editor-tabs">
                <el-tab-pane name="edit">
                  <template #label>
                    <span><el-icon style="vertical-align: -2px; margin-right: 4px;"><Edit /></el-icon>编辑</span>
                  </template>
                  <div style="display: flex; flex-direction: column; gap: 8px;">
                    <!-- Markdown 格式工具栏 -->
                    <div class="md-toolbar">
                      <button type="button" class="md-tool-btn" title="加粗" @click="insertFormat('bold')"><strong>B</strong></button>
                      <button type="button" class="md-tool-btn" title="斜体" @click="insertFormat('italic')"><em>I</em></button>
                      <button type="button" class="md-tool-btn" title="删除线" @click="insertFormat('strike')"><s>S</s></button>
                      <span class="md-tool-sep"></span>
                      <button type="button" class="md-tool-btn" title="标题" @click="insertFormat('heading')">H</button>
                      <button type="button" class="md-tool-btn" title="引用" @click="insertFormat('quote')"><el-icon><ChatLineSquare /></el-icon></button>
                      <button type="button" class="md-tool-btn" title="代码块" @click="insertFormat('code')"><el-icon><Document /></el-icon></button>
                      <button type="button" class="md-tool-btn" title="无序列表" @click="insertFormat('ul')"><el-icon><List /></el-icon></button>
                      <button type="button" class="md-tool-btn" title="链接" @click="insertFormat('link')"><el-icon><Link /></el-icon></button>
                      <span class="md-tool-sep"></span>
                      <input ref="imageInput" type="file" accept="image/*" style="display:none" @change="onImageFileChange" />
                      <button type="button" class="md-tool-btn" title="插入图片" @click="imageInput?.click()">
                        <el-icon><PictureFilled /></el-icon>
                      </button>
                      <span class="md-tool-sep"></span>
                      <input ref="docInput" type="file" accept=".txt,.md,.doc,.docx" style="display:none" @change="onDocFileChange" />
                      <button type="button" class="md-tool-btn" title="导入文档" @click="docInput?.click()">
                        <el-icon><Upload /></el-icon>
                      </button>
                    </div>
                    <el-input
                      ref="contentTextarea"
                      v-model="form.content"
                      type="textarea"
                      :rows="20"
                      placeholder="请输入 Markdown 格式的文章内容"
                      style="font-family: 'Consolas', 'Monaco', monospace;"
                    />
                  </div>
                </el-tab-pane>
                <el-tab-pane name="preview">
                  <template #label>
                    <span><el-icon style="vertical-align: -2px; margin-right: 4px;"><View /></el-icon>预览</span>
                  </template>
                  <div class="markdown-preview" v-html="markdownPreview" style="min-height: 360px;" />
                </el-tab-pane>
              </el-tabs>
            </el-form-item>
          </el-col>
        </el-row>
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

    <!-- 封面预览 -->
    <div v-if="showCoverPreview" class="cover-preview-modal" @click="showCoverPreview = false">
      <img :src="previewCoverUrl" @click.stop />
    </div>
  </section>
</template>

<script setup>
import { computed, nextTick, onMounted, ref } from 'vue'
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
  Loading,
  ChatLineSquare,
  List,
  Link,
  PictureFilled,
  Upload,
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
  uploadContentImage,
  parseDocument,
} from '@/api/content/content'
import { fetchCommentCount, removeCommentsByContent } from '@/api/comment/comment'
import ContextMenu from '@/components/ContextMenu.vue'
import ContentTypeSelector from '@/components/ContentTypeSelector.vue'
import VideoUploader from '@/components/VideoUploader.vue'
import VideoLinkInput from '@/components/VideoLinkInput.vue'
import { useTableLongpress } from '@/composables/useTableLongpress'

const loading = ref(false)
const submitting = ref(false)
const coverGenerating = ref(false)
const rows = ref([])
const categories = ref([])
const tags = ref([])
const contextMenuRef = ref(null)
const selectedRow = ref(null)
const contextMenuTitle = ref('')
const contextMenuActions = ref([])
const contentTextarea = ref(null)
const imageInput = ref(null)
const docInput = ref(null)
const showCoverPreview = ref(false)
const previewCoverUrl = ref('')

function previewCover(url) {
  previewCoverUrl.value = url
  showCoverPreview.value = true
}

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

const query = ref({ keyword: '', category: '', tag: '' })

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
    const tagMatch = !query.value.tag || (item.tags || []).includes(query.value.tag)
    return categoryMatch && tagMatch
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

function filterByTag(tag) {
  query.value.keyword = tag
  loadData()
}

const resetQuery = () => {
  query.value = { keyword: '', category: '', tag: '' }
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
  // 先本地预览，让用户立即看到效果
  const localUrl = URL.createObjectURL(file)
  form.value.cover = localUrl

  try {
    const res = await uploadContentCover(file)
    if (res.data?.url) {
      form.value.cover = res.data.url
      ElMessage.success('封面上传成功')
    } else {
      ElMessage.warning('上传成功但未返回封面地址')
    }
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

const getTextareaEl = () => contentTextarea.value?.$el?.querySelector('textarea')

const onDocFileChange = async (e) => {
  const file = e.target.files?.[0]
  if (!file) return
  try {
    const loading = ElMessage.info('正在解析文档...')
    const res = await parseDocument(file)
    loading.close()
    if (res.data?.text) {
      const textarea = getTextareaEl()
      if (textarea) {
        const start = textarea.selectionStart
        const before = form.value.content.substring(0, start)
        const after = form.value.content.substring(start)
        form.value.content = before + res.data.text + '\n' + after
      } else {
        form.value.content = (form.value.content || '') + '\n' + res.data.text + '\n'
      }
      ElMessage.success('文档内容已导入')
    }
  } catch (err) {
    ElMessage.error(err.message || '文档解析失败')
  } finally {
    if (docInput.value) docInput.value.value = ''
  }
}

const onImageFileChange = async (e) => {
  const file = e.target.files?.[0]
  if (!file) return
  try {
    const res = await uploadContentImage(file)
    if (res.data?.url) {
      const md = `![${file.name}](${res.data.url})`
      handleInsertImage(md)
    } else {
      ElMessage.warning('上传成功但未返回图片地址')
    }
  } catch (err) {
    ElMessage.error(err.message || '图片上传失败')
  } finally {
    // 清掉 input 值，允许重复上传同一文件
    if (imageInput.value) imageInput.value.value = ''
  }
}

function insertFormat(type) {
  const textarea = getTextareaEl()
  if (!textarea) return

  const start = textarea.selectionStart
  const end = textarea.selectionEnd
  const sel = form.value.content.substring(start, end) || ''
  const before = form.value.content.substring(0, start)
  const after = form.value.content.substring(end)

  const wraps = {
    bold:       ['**', '**'],
    italic:     ['*', '*'],
    strike:     ['~~', '~~'],
    code:       ['\n```\n', '\n```\n'],
    heading:    ['\n## ', ''],
    quote:      ['\n> ', ''],
    ul:         ['\n- ', ''],
    link:       ['[', '](url)'],
  }

  const [prefix, suffix] = wraps[type] || ['', '']
  form.value.content = before + prefix + sel + suffix + after

  setTimeout(() => {
    textarea.focus()
    if (sel) {
      textarea.setSelectionRange(start + prefix.length, start + prefix.length + sel.length)
    } else {
      const pos = start + prefix.length
      textarea.setSelectionRange(pos, pos)
    }
  }, 0)
}

const handleInsertImage = (markdown) => {
  const textarea = getTextareaEl()
  if (textarea) {
    const start = textarea.selectionStart
    const text = form.value.content || ''
    form.value.content = text.substring(0, start) + '\n' + markdown + '\n' + text.substring(start)
    setTimeout(() => {
      textarea.focus()
      const newPos = start + markdown.length + 2
      textarea.setSelectionRange(newPos, newPos)
    }, 0)
  } else {
    form.value.content = (form.value.content || '') + '\n' + markdown + '\n'
  }
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
  const hadNoCover = !form.value.cover || form.value.cover.startsWith('blob:')
  if (hadNoCover) {
    coverGenerating.value = true
  }

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
      ElMessage.success(hadNoCover ? '发布成功，封面正在后台生成...' : '内容创建成功')
    }

    // 先刷新列表数据，再关闭弹窗 — 避免弹窗关闭动画干扰列表渲染
    await Promise.all([loadBaseData(), loadData()])
    await nextTick()
    editorVisible.value = false
  } catch (error) {
    const msg = error.message || ''
    if (msg.includes('timeout') || msg.includes('Network Error') || msg.includes('超时')) {
      editorVisible.value = false
      ElMessage.warning('请求超时，请刷新页面查看内容是否已保存')
      await loadData()
    } else {
      ElMessage.error(msg || '保存失败')
    }
  } finally {
    submitting.value = false
    coverGenerating.value = false
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
.list-page-container {
  height: 100%;
  display: flex;
  flex-direction: column;
}

.table-container {
  flex: 1;
  overflow-y: auto;
  min-height: 0;
}

.pagination-container {
  padding: 16px 0;
  display: flex;
  justify-content: flex-end;
  border-top: 1px solid var(--admin-border);
  flex-shrink: 0;
}

.clickable-tag {
  cursor: pointer;
  transition: opacity 0.15s;
}

.clickable-tag:hover {
  opacity: 0.7;
}

.table-row-longpress {
  cursor: pointer;
  user-select: none;
}
</style>

<style>
/* 自定义对话框样式 - 基于 DESIGN.md warm-canvas editorial 规范 */
.custom-dialog.el-dialog {
  border-radius: 12px;
  box-shadow: 0 1px 3px rgba(20, 20, 19, 0.08);
  width: min(1200px, 94vw);
  max-height: min(800px, 90vh);
  display: flex;
  flex-direction: column;
  margin: 5vh auto;
  background: #faf9f5;
  border: 1px solid #e6dfd8;
  overflow: hidden;
}

.custom-dialog .el-dialog__header {
  padding: 16px 24px;
  border-bottom: 1px solid #e6dfd8;
  background: #faf9f5;
  border-radius: 12px 12px 0 0;
  margin: 0;
}

.custom-dialog .el-dialog__title {
  font-family: var(--dt-font-display);
  font-size: 18px;
  font-weight: 500;
  color: #141413;
}

.custom-dialog .el-dialog__headerbtn {
  top: 14px;
  right: 16px;
  width: 32px;
  height: 32px;
  background: #f5f0e8;
  border-radius: 50%;
  transition: all 0.25s ease;
}

.custom-dialog .el-dialog__headerbtn:hover {
  background: #efe9de;
  transform: rotate(90deg);
}

.custom-dialog .el-dialog__close {
  font-size: 16px;
  color: #6c6a64;
  font-weight: bold;
}

.custom-dialog .el-dialog__headerbtn:hover .el-dialog__close {
  color: #141413;
}

.custom-dialog .el-dialog__body {
  padding: 24px;
  overflow-y: auto;
  background: #faf9f5;
  flex: 1;
}

.custom-dialog .el-dialog__body::-webkit-scrollbar {
  width: 6px;
}

.custom-dialog .el-dialog__body::-webkit-scrollbar-thumb {
  background: #ebe6df;
  border-radius: 3px;
}

.custom-dialog .el-dialog__body::-webkit-scrollbar-thumb:hover {
  background: #e6dfd8;
}

.custom-dialog .el-dialog__footer {
  padding: 16px 24px;
  border-top: 1px solid #e6dfd8;
  background: #f5f0e8;
  border-radius: 0 0 12px 12px;
}

/* 表单样式 - text-input 规范 */
.custom-dialog .el-form-item__label {
  font-family: var(--dt-font-body);
  font-weight: 500;
  color: #3d3d3a;
  font-size: 13px;
}

.custom-dialog .el-input__wrapper {
  border-radius: 8px;
  border: 1px solid #e6dfd8;
  background: #faf9f5;
  box-shadow: none !important;
}

.custom-dialog .el-input__wrapper.is-focus {
  border-color: #cc785c;
  outline: 3px solid rgba(204, 120, 92, 0.15);
}

.custom-dialog .el-textarea__inner {
  border-radius: 8px;
  border: 1px solid #e6dfd8;
  background: #faf9f5;
  box-shadow: none !important;
}

.custom-dialog .el-textarea__inner:focus {
  border-color: #cc785c;
  outline: 3px solid rgba(204, 120, 92, 0.15);
}

.custom-dialog .el-select .el-input__wrapper {
  border: 1px solid #e6dfd8;
  background: #faf9f5;
  box-shadow: none !important;
}

/* 上传组件 */
.custom-dialog .el-upload-dragger {
  border-radius: 8px;
  border: 1px dashed #e6dfd8;
  background: #f5f0e8;
  transition: all 0.3s;
}

.custom-dialog .el-upload-dragger:hover {
  border-color: #cc785c;
  background: #efe9de;
}

/* 按钮 - button-primary */
.custom-dialog .el-button--primary {
  background-color: #cc785c;
  border-color: #cc785c;
  color: #ffffff;
}

.custom-dialog .el-button--primary:hover {
  background-color: #a9583e;
  border-color: #a9583e;
}

/* 左右布局优化 */
.custom-dialog .el-dialog__body .el-row {
  align-items: stretch;
}

/* 封面行：左侧上传区 + 右侧URL输入 */
  .cover-row {
    display: flex;
    gap: 16px;
    width: 100%;
    align-items: flex-start;
  }

  .cover-upload-col {
    flex: 0 0 240px;
    width: 240px;
  }

  /* 抹掉 Element Plus el-upload 的所有内置间距 */
  .cover-uploader .el-upload {
    width: 100%;
    display: block;
  }

  .cover-uploader .el-upload-dragger {
    width: 100%;
    height: 152px;
    padding: 0 !important;
    overflow: hidden;
    border-radius: 10px;
    border: 1px dashed #d6cfc3;
    background: #f5f0e8;
    transition: border-color 0.25s, background 0.25s;
  }

  .cover-uploader .el-upload-dragger:hover {
    border-color: #cc785c;
    background: #efe9de;
  }

  /* 封面生成中 — 旋转加载 */
  .cover-generating-icon {
    font-size: 32px;
    color: #cc785c;
    animation: cover-spin 1s linear infinite;
  }

  @keyframes cover-spin {
    from { transform: rotate(0deg); }
    to { transform: rotate(360deg); }
  }

  /* 空状态占位 */
  .cover-placeholder {
    width: 100%;
    height: 150px;
    display: flex;
    flex-direction: column;
    align-items: center;
    justify-content: center;
    gap: 6px;
  }

  .cover-placeholder-icon {
    font-size: 28px;
    color: #b0aaa0;
  }

  .cover-placeholder-text {
    font-size: 12px;
    color: #8c8a84;
    text-align: center;
    line-height: 1.4;
  }

  .cover-placeholder-text em {
    color: #cc785c;
    font-style: normal;
  }

  /* 有图片时的预览 — 撑满整个 dragger，零间隙 */
  .cover-preview-box {
    width: 100%;
    height: 152px;
    position: relative;
    overflow: hidden;
    margin: 0;
    line-height: 0;
  }

  .cover-preview-img {
    width: 100%;
    height: 100%;
    object-fit: cover;
    display: block;
  }

  .cover-preview-overlay {
    position: absolute;
    inset: 0;
    display: flex;
    flex-direction: column;
    align-items: center;
    justify-content: center;
    gap: 4px;
    background: rgba(20, 20, 19, 0.45);
    color: #fff;
    font-size: 13px;
    opacity: 0;
    transition: opacity 0.25s;
    cursor: pointer;
  }

  .cover-preview-box:hover .cover-preview-overlay {
    opacity: 1;
  }

  /* 右侧URL输入 */
  .cover-url-col {
    flex: 1;
    display: flex;
    flex-direction: column;
    gap: 6px;
    min-width: 0;
  }

  .cover-hint {
    font-size: 11px;
    color: #a09c94;
    line-height: 1.3;
  }

.custom-dialog .markdown-preview {
  max-height: 580px;
  overflow-y: auto;
  padding: 16px;
  background: #efe9de;
  border-radius: 8px;
  border: 1px solid #e6dfd8;
}

/* Markdown 格式工具栏 */
.md-toolbar {
  display: flex;
  align-items: center;
  gap: 4px;
  padding: 6px 8px;
  background: #f5f0e8;
  border-radius: 8px;
  border: 1px solid #e6dfd8;
  flex-wrap: wrap;
}

.md-tool-btn {
  width: 30px;
  height: 28px;
  border: none;
  border-radius: 6px;
  background: transparent;
  color: #6c6a64;
  cursor: pointer;
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 13px;
  transition: all 0.15s;
}

.md-tool-btn:hover {
  background: #e6dfd8;
  color: #141413;
}

.md-tool-btn .el-icon {
  font-size: 14px;
}

/* 封面缩略图 */
.cover-thumb {
  width: 120px;
  height: 68px;
  border-radius: 4px;
  overflow: hidden;
  cursor: pointer;
  margin: 0 auto;
  border: 1px solid var(--admin-border);
}

.cover-thumb-img {
  width: 100%;
  height: 100%;
  object-fit: cover;
  display: block;
}

/* 封面预览模态 */
.cover-preview-modal {
  position: fixed;
  inset: 0;
  background: rgba(0,0,0,0.85);
  display: flex;
  align-items: center;
  justify-content: center;
  z-index: 9999;
}

.cover-preview-modal img {
  max-width: 90vw;
  max-height: 90vh;
  border-radius: 8px;
}

.md-tool-sep {
  width: 1px;
  height: 18px;
  background: #d6cfc3;
  margin: 0 4px;
}

.md-toolbar :deep(.el-button) {
  margin-left: auto;
}

@media (max-width: 768px) {
  .hide-on-mobile {
    display: none !important;
  }

  .custom-dialog.el-dialog {
    width: 95vw !important;
    max-height: 95vh;
  }

  .custom-dialog .el-dialog__body {
    max-height: calc(95vh - 120px);
  }

  .cover-row {
    flex-direction: column;
  }

  .cover-upload-col {
    flex: 1;
    width: 100%;
  }
}
</style>
