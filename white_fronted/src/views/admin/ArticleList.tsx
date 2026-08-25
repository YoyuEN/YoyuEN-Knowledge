import { useEffect, useMemo, useRef, useState } from 'react'
import { Plus, Pencil, Trash2, Star, Search, X, Upload, Image, Eye } from 'lucide-react'
import { fetchAllContent, fetchContentCategories, fetchContentTags, createContent, updateContent, removeContent, toggleContentRecommend } from '@/api/content'
import { removeCommentsByContent } from '@/api/comment'
import { marked } from 'marked'
import { cn } from '@/lib/utils'
import ContentTypeSelector from '@/components/ContentTypeSelector'
import VideoUploader from '@/components/VideoUploader'
import VideoLinkInput from '@/components/VideoLinkInput'

const CAT_NAMES: Record<string, string> = { article: '文章', game: '游戏', study: '学习', video: '视频' }

export default function ArticleList() {
  const [all, setAll] = useState<any[]>([])
  const [categories, setCategories] = useState<any[]>([])
  const [tags, setTags] = useState<any[]>([])
  const [loading, setLoading] = useState(true)
  const [keyword, setKeyword] = useState('')
  const [filterCat, setFilterCat] = useState('')
  const [filterTag, setFilterTag] = useState('')
  const [pg, setPg] = useState(1)
  const PAGE = 10

  // Editor
  const [editor, setEditor] = useState(false)
  const [editItem, setEditItem] = useState<any>(null)
  const [form, setForm] = useState<any>({ contentType: 'article', title: '', category: '', tags: [], cover: '', description: '', content: '', videoUrl: '', videoType: 'file' })
  const [coverPreview, setCoverPreview] = useState('')
  const [previewMd, setPreviewMd] = useState(false)
  const [saving, setSaving] = useState(false)

  const textareaRef = useRef<HTMLTextAreaElement | null>(null)

  const load = async () => {
    setLoading(true)
    try {
      const [contentRes, catRes, tagRes]: any[] = await Promise.allSettled([
        fetchAllContent({ keyword }),
        fetchContentCategories(),
        fetchContentTags(),
      ])
      if (contentRes.status === 'fulfilled') {
        const items = (contentRes.value?.data ?? []).map((c: any) => ({
          ...c,
          desc: c.description ?? c.desc ?? '',
          date: c.createTime ?? c.date ?? '',
        }))
        setAll(items)
      }
      if (catRes.status === 'fulfilled') setCategories(catRes.value?.data ?? [])
      if (tagRes.status === 'fulfilled') setTags(tagRes.value?.data ?? [])
    } catch {}
    setLoading(false)
  }

  useEffect(() => { load() }, [])

  const filtered = useMemo(() => {
    let rows = all
    if (filterCat) rows = rows.filter((r) => (r.category || r.contentType) === filterCat)
    if (filterTag) rows = rows.filter((r) => (r.tags || []).some((t: any) => (typeof t === 'string' ? t : t.name) === filterTag))
    return rows
  }, [all, filterCat, filterTag])

  const paged = filtered.slice((pg - 1) * PAGE, pg * PAGE)

  const openAdd = () => {
    setEditItem(null)
    setForm({ contentType: 'article', title: '', category: '', tags: [], cover: '', description: '', content: '', videoUrl: '', videoType: 'file' })
    setCoverPreview('')
    setPreviewMd(false)
    setEditor(true)
  }

  const openEdit = (item: any) => {
    setEditItem(item)
    setForm({
      contentType: item.contentType || 'article',
      title: item.title || '',
      category: item.category || '',
      tags: item.tags ? (typeof item.tags[0] === 'string' ? item.tags : item.tags.map((t: any) => t.name || t)) : [],
      cover: item.cover || '',
      description: item.description || item.desc || '',
      content: item.content || '',
      videoUrl: item.videoUrl || '',
      videoType: item.videoType || 'file',
    })
    setCoverPreview(item.cover || '')
    setPreviewMd(false)
    setEditor(true)
  }

  const handleRemove = async (item: any) => {
    if (!confirm('确定要删除该内容吗？')) return
    try {
      await removeContent(item.id)
      await load()
    } catch (e: any) {
      if (e?.message?.includes('评论')) {
        if (confirm('该内容下有评论，是否先删除所有评论再删除内容？')) {
          try {
            await removeCommentsByContent(item.id)
            await removeContent(item.id)
            await load()
          } catch { alert('操作失败') }
        }
      } else {
        alert('删除失败')
      }
    }
  }

  const handleToggleRec = async (id: string | number, current: boolean) => {
    try { await toggleContentRecommend(id, !current); await load() } catch { alert('操作失败') }
  }

  const handleCoverUpload = async (e: React.ChangeEvent<HTMLInputElement>) => {
    const file = e.target.files?.[0]
    if (!file) return
    const fd = new FormData()
    fd.append('cover', file)
    try {
      const res = await fetch('/api/content/upload-cover', {
        method: 'POST',
        headers: { Authorization: `Bearer ${localStorage.getItem('yoyuen_token') || ''}` },
        body: fd,
      })
      const data = await res.json()
      if (data.code === 200) {
        const url = data.data?.url ?? ''
        setCoverPreview(url)
        setForm({ ...form, cover: url })
      }
    } catch { alert('上传失败') }
    e.target.value = ''
  }

  const insertFormat = (before: string, after?: string) => {
    const ta = textareaRef.current
    if (!ta) return
    const start = ta.selectionStart
    const end = ta.selectionEnd
    const text = form.content
    const selected = text.slice(start, end)
    const newText = `${before}${selected}${after ?? before}`
    const updated = text.slice(0, start) + newText + text.slice(end)
    setForm({ ...form, content: updated })
    setTimeout(() => { ta.focus(); ta.setSelectionRange(start + before.length, end + before.length) }, 0)
  }

  const save = async () => {
    if (!form.title.trim()) return
    setSaving(true)
    const payload = {
      ...form,
      tags: form.tags || [],
      description: form.description || '',
      category: form.category || 'article',
    }
    try {
      if (editItem) {
        await updateContent({ id: editItem.id, ...payload })
      } else {
        await createContent(payload)
      }
      setEditor(false)
      await load()
    } catch { alert('保存失败') }
    setSaving(false)
  }

  return (
    <div className="p-6">
      <div className="mb-4 flex flex-wrap items-center gap-3">
        <h1 className="text-xl font-semibold text-body-strong mr-auto">文章管理</h1>
        <div className="flex items-center gap-1 rounded-lg border border-hairline bg-canvas px-3 py-2">
          <Search className="h-4 w-4 text-muted-soft" />
          <input
            value={keyword} onChange={(e) => setKeyword(e.target.value)}
            placeholder="搜索..."
            className="bg-transparent text-sm outline-none w-32"
          />
          {keyword && <button onClick={() => setKeyword('')}><X className="h-3 w-3 text-muted" /></button>}
        </div>
        <select value={filterCat} onChange={(e) => setFilterCat(e.target.value)} className="rounded-lg border border-hairline bg-canvas px-3 py-2 text-sm">
          <option value="">全部分类</option>
          {categories.map((c: any) => <option key={c.type} value={c.type}>{c.name}</option>)}
        </select>
        <select value={filterTag} onChange={(e) => setFilterTag(e.target.value)} className="rounded-lg border border-hairline bg-canvas px-3 py-2 text-sm">
          <option value="">全部标签</option>
          {tags.map((t: any) => <option key={t.name} value={t.name}>{t.name}</option>)}
        </select>
        <button onClick={load} className="rounded-lg border border-hairline px-3 py-2 text-sm text-muted">查询</button>
        <button onClick={openAdd} className="flex items-center gap-1 rounded-lg bg-primary px-4 py-2 text-sm text-primary-foreground hover:bg-primary-active">
          <Plus className="h-4 w-4" />新增文章
        </button>
      </div>

      {loading ? (
        <div className="flex justify-center py-20"><div className="h-8 w-8 animate-spin rounded-full border-2 border-primary border-t-transparent" /></div>
      ) : (
        <>
          <div className="overflow-x-auto rounded-xl border border-hairline">
            <table className="w-full">
              <thead className="bg-surface-soft text-left text-xs text-muted">
                <tr>
                  <th className="px-4 py-3 font-medium w-20">封面</th>
                  <th className="px-4 py-3 font-medium">标题</th>
                  <th className="px-4 py-3 font-medium">分类</th>
                  <th className="px-4 py-3 font-medium">标签</th>
                  <th className="px-4 py-3 font-medium">时间</th>
                  <th className="px-4 py-3 font-medium text-right">操作</th>
                </tr>
              </thead>
              <tbody className="divide-y divide-hairline">
                {paged.map((item) => (
                  <tr key={item.id} className="hover:bg-surface-soft/50">
                    <td className="px-4 py-3">
                      {item.cover ? (
                        <img src={item.cover} alt="" className="h-12 w-20 rounded object-cover cursor-pointer" onClick={() => window.open(item.cover)} />
                      ) : <div className="h-12 w-20 rounded bg-surface-soft flex items-center justify-center"><Image className="h-4 w-4 text-muted-soft" /></div>}
                    </td>
                    <td className="px-4 py-3">
                      <div className="flex items-center gap-2">
                        <span className="text-sm text-body-strong line-clamp-1 max-w-[200px]">{item.title}</span>
                        {(item.isRecommended || item.recommend) && <Star className="h-3 w-3 text-accent-amber fill-current flex-shrink-0" />}
                      </div>
                    </td>
                    <td className="px-4 py-3"><span className="rounded-full bg-primary/10 px-2 py-0.5 text-xs text-primary">{CAT_NAMES[item.category] || item.category || item.contentType}</span></td>
                    <td className="px-4 py-3">
                      <div className="flex flex-wrap gap-1">
                        {(item.tags || []).slice(0, 3).map((t: any) => (
                          <span key={typeof t === 'string' ? t : t.name} className="rounded bg-surface-soft px-1.5 py-0.5 text-xs text-muted">
                            {typeof t === 'string' ? t : t.name}
                          </span>
                        ))}
                      </div>
                    </td>
                    <td className="px-4 py-3 text-xs text-muted-soft whitespace-nowrap">{item.createTime ?? item.date}</td>
                    <td className="px-4 py-3">
                      <div className="flex justify-end gap-1">
                        <button onClick={() => openEdit(item)} className="rounded p-1.5 text-muted hover:bg-surface-soft hover:text-primary"><Pencil className="h-4 w-4" /></button>
                        <button onClick={() => handleToggleRec(item.id, item.isRecommended || item.recommend)} className={cn('rounded p-1.5 hover:bg-surface-soft', item.isRecommended || item.recommend ? 'text-accent-amber' : 'text-muted-soft')}>
                          <Star className="h-4 w-4" fill={item.isRecommended || item.recommend ? 'currentColor' : 'none'} />
                        </button>
                        <button onClick={() => handleRemove(item)} className="rounded p-1.5 text-muted hover:bg-surface-soft hover:text-error"><Trash2 className="h-4 w-4" /></button>
                      </div>
                    </td>
                  </tr>
                ))}
              </tbody>
            </table>
          </div>
          {filtered.length > PAGE && (
            <div className="mt-4 flex justify-end gap-2">
              <button disabled={pg <= 1} onClick={() => setPg(pg - 1)} className="rounded border border-hairline px-3 py-1.5 text-xs disabled:opacity-30">上一页</button>
              <span className="px-2 py-1.5 text-xs text-muted">{pg} / {Math.ceil(filtered.length / PAGE)}</span>
              <button disabled={pg >= Math.ceil(filtered.length / PAGE)} onClick={() => setPg(pg + 1)} className="rounded border border-hairline px-3 py-1.5 text-xs disabled:opacity-30">下一页</button>
            </div>
          )}
        </>
      )}

      {/* Editor Dialog */}
      {editor && (
        <div className="fixed inset-0 z-50 flex items-start justify-center bg-black/40 overflow-y-auto py-8" onClick={() => setEditor(false)}>
          <div className="w-full max-w-5xl rounded-2xl bg-canvas shadow-xl mx-4" onClick={(e) => e.stopPropagation()}>
            <div className="flex items-center justify-between border-b border-hairline px-6 py-4">
              <h2 className="text-lg font-semibold text-body-strong">{editItem ? '编辑内容' : '新增内容'}</h2>
              <button onClick={() => setEditor(false)} className="rounded p-1 hover:bg-surface-soft"><X className="h-5 w-5 text-muted" /></button>
            </div>

            <div className="grid gap-6 p-6 md:grid-cols-2">
              {/* Left column */}
              <div className="space-y-4">
                <ContentTypeSelector value={form.contentType} onChange={(v: string) => setForm({ ...form, contentType: v })} showDescription={false} />

                <div>
                  <label className="mb-1 block text-xs text-muted">标题</label>
                  <input value={form.title} onChange={(e) => setForm({ ...form, title: e.target.value })} className="w-full rounded-lg border border-hairline bg-canvas px-3 py-2 text-sm outline-none focus:border-primary" />
                </div>

                <div className="grid grid-cols-2 gap-3">
                  <div>
                    <label className="mb-1 block text-xs text-muted">分类</label>
                    <select value={form.category} onChange={(e) => setForm({ ...form, category: e.target.value })} className="w-full rounded-lg border border-hairline bg-canvas px-3 py-2 text-sm">
                      <option value="">选择分类</option>
                      {categories.map((c: any) => <option key={c.type} value={c.type}>{c.name}</option>)}
                    </select>
                  </div>
                  <div>
                    <label className="mb-1 block text-xs text-muted">标签</label>
                    <select multiple value={form.tags} onChange={(e) => setForm({ ...form, tags: Array.from(e.target.selectedOptions, (o) => o.value) })} className="w-full rounded-lg border border-hairline bg-canvas px-3 py-2 text-sm h-9">
                      {tags.map((t: any) => <option key={t.name} value={t.name}>{t.name}</option>)}
                    </select>
                  </div>
                </div>

                <div>
                  <label className="mb-1 block text-xs text-muted">封面</label>
                  <div className="flex gap-2">
                    <input value={form.cover} onChange={(e) => { setForm({ ...form, cover: e.target.value }); setCoverPreview(e.target.value) }} placeholder="图片 URL 或上传" className="flex-1 rounded-lg border border-hairline bg-canvas px-3 py-2 text-sm outline-none focus:border-primary" />
                    <label className="flex cursor-pointer items-center gap-1 rounded-lg border border-hairline px-3 py-2 text-sm text-muted hover:bg-surface-soft">
                      <Upload className="h-4 w-4" />上传
                      <input type="file" accept="image/*" className="hidden" onChange={handleCoverUpload} />
                    </label>
                  </div>
                  {coverPreview && <img src={coverPreview} alt="" className="mt-2 h-24 rounded-lg object-cover" />}
                </div>

                <div>
                  <label className="mb-1 block text-xs text-muted">描述</label>
                  <textarea value={form.description} onChange={(e) => setForm({ ...form, description: e.target.value })} rows={3} className="w-full rounded-lg border border-hairline bg-canvas px-3 py-2 text-sm outline-none focus:border-primary resize-y" />
                </div>

                {/* Video fields */}
                {form.contentType === 'video' && (
                  <div className="space-y-3 border-t border-hairline pt-3">
                    <div className="flex gap-4 text-sm">
                      <label className="flex items-center gap-1"><input type="radio" checked={form.videoType === 'file'} onChange={() => setForm({ ...form, videoType: 'file' })} /> 上传视频</label>
                      <label className="flex items-center gap-1"><input type="radio" checked={form.videoType === 'link'} onChange={() => setForm({ ...form, videoType: 'link' })} /> 视频链接</label>
                    </div>
                    {form.videoType === 'file' ? (
                      <VideoUploader value={form.videoUrl} onChange={(url: string) => setForm({ ...form, videoUrl: url })} />
                    ) : (
                      <VideoLinkInput value={form.videoUrl} onChange={(url: string) => setForm({ ...form, videoUrl: url })} />
                    )}
                  </div>
                )}
              </div>

              {/* Right column: Markdown editor */}
              <div className="space-y-2">
                <div className="flex items-center justify-between">
                  <label className="text-xs text-muted">正文 (Markdown)</label>
                  <button onClick={() => setPreviewMd(!previewMd)} className="flex items-center gap-1 rounded border border-hairline px-2 py-1 text-xs text-muted hover:bg-surface-soft">
                    <Eye className="h-3 w-3" />{previewMd ? '编辑' : '预览'}
                  </button>
                </div>

                {!previewMd ? (
                  <>
                    {/* Markdown toolbar */}
                    <div className="flex flex-wrap gap-1 rounded-lg border border-hairline bg-surface-soft p-1.5">
                      {[
                        { label: 'B', action: () => insertFormat('**') },
                        { label: 'I', action: () => insertFormat('*') },
                        { label: '~', action: () => insertFormat('~~') },
                        { label: 'H2', action: () => insertFormat('## ') },
                        { label: '>', action: () => insertFormat('> ') },
                        { label: '`', action: () => insertFormat('`') },
                        { label: 'UL', action: () => insertFormat('- ') },
                        { label: '[]', action: () => insertFormat('[', '](url)') },
                      ].map((btn) => (
                        <button key={btn.label} onClick={btn.action} className="rounded px-2 py-0.5 text-xs text-body hover:bg-surface-card font-mono">{btn.label}</button>
                      ))}
                      <label className="cursor-pointer rounded px-2 py-0.5 text-xs text-body hover:bg-surface-card">
                        <Image className="h-3.5 w-3.5 inline" />
                        <input type="file" accept="image/*" className="hidden" onChange={async (e) => {
                          const file = e.target.files?.[0]
                          if (!file) return
                          const fd = new FormData(); fd.append('image', file)
                          try {
                            const res = await fetch('/api/content/upload-content-image', {
                              method: 'POST',
                              headers: { Authorization: `Bearer ${localStorage.getItem('yoyuen_token') || ''}` },
                              body: fd,
                            })
                            const data = await res.json()
                            if (data.code === 200 && data.data?.url) insertFormat('![image](', data.data.url + ')')
                          } catch {}
                          e.target.value = ''
                        }} />
                      </label>
                    </div>
                    <textarea
                      ref={textareaRef}
                      value={form.content}
                      onChange={(e) => setForm({ ...form, content: e.target.value })}
                      rows={16}
                      className="w-full rounded-lg border border-hairline bg-canvas px-3 py-2 text-sm font-mono outline-none focus:border-primary resize-y"
                    />
                  </>
                ) : (
                  <div
                    className="min-h-[300px] rounded-lg border border-hairline bg-surface-card p-4 text-sm prose-markdown text-body leading-relaxed [&_a]:text-primary [&_pre]:bg-surface-soft [&_pre]:p-3 [&_pre]:rounded-lg [&_code]:text-xs [&_h1]:text-lg [&_h2]:text-base [&_img]:max-w-full [&_img]:rounded-lg"
                    dangerouslySetInnerHTML={{ __html: marked.parse(form.content || '', { breaks: true, gfm: true }) as string }}
                  />
                )}
              </div>
            </div>

            <div className="flex justify-end gap-3 border-t border-hairline px-6 py-4">
              <button onClick={() => setEditor(false)} className="rounded-lg border border-hairline px-4 py-2 text-sm text-muted">取消</button>
              <button onClick={save} disabled={saving} className="rounded-lg bg-primary px-6 py-2 text-sm text-primary-foreground hover:bg-primary-active disabled:opacity-50">
                {saving ? '保存中...' : '保存'}
              </button>
            </div>
          </div>
        </div>
      )}
    </div>
  )
}
