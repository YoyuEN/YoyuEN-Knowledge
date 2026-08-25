import { useEffect, useState } from 'react'
import { Plus, Pencil, Trash2, Power, PowerOff, Search, X } from 'lucide-react'
import { cn } from '@/lib/utils'
import { fetchKnowledgeBaseList, createKnowledgeBase, updateKnowledgeBase, removeKnowledgeBase, toggleKnowledgeBaseStatus } from '@/api/knowledge'

export default function KnowledgeList() {
  const [list, setList] = useState<any[]>([])
  const [loading, setLoading] = useState(true)
  const [keyword, setKeyword] = useState('')
  const [dialog, setDialog] = useState(false)
  const [editItem, setEditItem] = useState<any>(null)
  const [form, setForm] = useState({ name: '', description: '' })
  const [saving, setSaving] = useState(false)
  const [pg, setPg] = useState(1)
  const PAGE = 10

  const load = async () => {
    setLoading(true)
    try { const res: any = await fetchKnowledgeBaseList({ keyword: keyword || undefined }); setList(res?.data ?? []) } catch {}
    setLoading(false)
  }
  useEffect(() => { load() }, [])

  const openAdd = () => { setEditItem(null); setForm({ name: '', description: '' }); setDialog(true) }
  const openEdit = (item: any) => { setEditItem(item); setForm({ name: item.name, description: item.description || '' }); setDialog(true) }

  const save = async () => {
    if (!form.name.trim()) return
    setSaving(true)
    try {
      if (editItem) {
        await updateKnowledgeBase({ id: editItem.id, ...form })
      } else {
        await createKnowledgeBase({ ...form, status: 'active' })
      }
      setDialog(false); await load()
    } catch { alert('操作失败') }
    setSaving(false)
  }

  const remove = async (id: string | number) => {
    if (!confirm('确定要删除该知识库吗？')) return
    try { await removeKnowledgeBase(String(id)); await load() } catch { alert('删除失败') }
  }

  const toggleStatus = async (id: string | number, currentStatus: any) => {
    const isActive = currentStatus === 'active' || currentStatus === 1
    const newStatus = isActive ? 'inactive' : 'active'
    try { await toggleKnowledgeBaseStatus({ id: String(id), status: newStatus }); await load() } catch { alert('操作失败') }
  }

  const filtered = keyword ? list.filter((k) => k.name?.includes(keyword) || k.description?.includes(keyword)) : list
  const paged = filtered.slice((pg - 1) * PAGE, pg * PAGE)

  return (
    <div className="p-6">
      <div className="mb-4 flex items-center gap-3">
        <h1 className="text-xl font-semibold text-body-strong mr-auto">知识库管理</h1>
        <div className="flex items-center gap-1 rounded-lg border border-hairline bg-canvas px-3 py-2">
          <Search className="h-4 w-4 text-muted-soft" />
          <input value={keyword} onChange={(e) => setKeyword(e.target.value)} placeholder="搜索..." className="bg-transparent text-sm outline-none w-32" />
          {keyword && <button onClick={() => setKeyword('')}><X className="h-3 w-3 text-muted" /></button>}
        </div>
        <button onClick={load} className="rounded-lg border border-hairline px-3 py-2 text-sm text-muted">查询</button>
        <button onClick={openAdd} className="flex items-center gap-1 rounded-lg bg-primary px-4 py-2 text-sm text-primary-foreground hover:bg-primary-active">
          <Plus className="h-4 w-4" />新增
        </button>
      </div>

      {loading ? (
        <div className="flex justify-center py-20"><div className="h-8 w-8 animate-spin rounded-full border-2 border-primary border-t-transparent" /></div>
      ) : (
        <>
          <div className="overflow-hidden rounded-xl border border-hairline">
            <table className="w-full">
              <thead className="bg-surface-soft text-left text-xs text-muted">
                <tr>
                  <th className="px-4 py-3 font-medium">名称</th>
                  <th className="px-4 py-3 font-medium">描述</th>
                  <th className="px-4 py-3 font-medium">文档数</th>
                  <th className="px-4 py-3 font-medium">状态</th>
                  <th className="px-4 py-3 font-medium">创建时间</th>
                  <th className="px-4 py-3 font-medium text-right">操作</th>
                </tr>
              </thead>
              <tbody className="divide-y divide-hairline">
                {paged.map((k) => (
                  <tr key={k.id} className="hover:bg-surface-soft/50">
                    <td className="px-4 py-3 text-sm text-body-strong">{k.name}</td>
                    <td className="px-4 py-3 text-sm text-muted max-w-[200px] line-clamp-1">{k.description}</td>
                    <td className="px-4 py-3 text-sm text-body">{k.docCount ?? k.documentCount ?? 0}</td>
                    <td className="px-4 py-3">
                      <span className={cn('rounded-full px-2 py-0.5 text-xs', k.status === 'active' || k.status === 1 ? 'bg-success/10 text-success' : 'bg-muted/20 text-muted-soft')}>
                        {k.status === 'active' || k.status === 1 ? '启用' : '禁用'}
                      </span>
                    </td>
                    <td className="px-4 py-3 text-xs text-muted-soft whitespace-nowrap">{k.createTime}</td>
                    <td className="px-4 py-3">
                      <div className="flex justify-end gap-1">
                        <button onClick={() => openEdit(k)} className="rounded p-1.5 text-muted hover:bg-surface-soft hover:text-primary"><Pencil className="h-4 w-4" /></button>
                        <button onClick={() => toggleStatus(k.id, k.status)} className="rounded p-1.5 text-muted hover:bg-surface-soft" title="切换状态">
                          {k.status === 'active' || k.status === 1 ? <PowerOff className="h-4 w-4 text-warning" /> : <Power className="h-4 w-4 text-success" />}
                        </button>
                        <button onClick={() => remove(k.id)} className="rounded p-1.5 text-muted hover:bg-surface-soft hover:text-error"><Trash2 className="h-4 w-4" /></button>
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

      {dialog && (
        <div className="fixed inset-0 z-50 flex items-center justify-center bg-black/40" onClick={() => setDialog(false)}>
          <div className="w-full max-w-md rounded-2xl bg-canvas p-6 shadow-xl" onClick={(e) => e.stopPropagation()}>
            <h2 className="mb-4 text-lg font-semibold text-body-strong">{editItem ? '编辑知识库' : '新增知识库'}</h2>
            <div className="space-y-3">
              <div>
                <label className="mb-1 block text-xs text-muted">名称</label>
                <input value={form.name} onChange={(e) => setForm({ ...form, name: e.target.value })} className="w-full rounded-lg border border-hairline bg-canvas px-3 py-2 text-sm outline-none focus:border-primary" />
              </div>
              <div>
                <label className="mb-1 block text-xs text-muted">描述</label>
                <textarea value={form.description} onChange={(e) => setForm({ ...form, description: e.target.value })} rows={3} className="w-full rounded-lg border border-hairline bg-canvas px-3 py-2 text-sm outline-none focus:border-primary resize-y" />
              </div>
            </div>
            <div className="mt-6 flex justify-end gap-3">
              <button onClick={() => setDialog(false)} className="rounded-lg border border-hairline px-4 py-2 text-sm text-muted">取消</button>
              <button onClick={save} disabled={saving} className="rounded-lg bg-primary px-4 py-2 text-sm text-primary-foreground hover:bg-primary-active disabled:opacity-50">
                {saving ? '保存中...' : '保存'}
              </button>
            </div>
          </div>
        </div>
      )}
    </div>
  )
}
