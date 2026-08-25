import { useEffect, useState } from 'react'
import { Plus, Pencil, Trash2 } from 'lucide-react'
import { fetchContentCategories, createContentCategory, updateContentCategory, removeContentCategory } from '@/api/content'

interface Category {
  type: string
  name: string
  count?: number
}

export default function CategoryList() {
  const [list, setList] = useState<Category[]>([])
  const [loading, setLoading] = useState(true)
  const [dialog, setDialog] = useState(false)
  const [editItem, setEditItem] = useState<Category | null>(null)
  const [form, setForm] = useState({ type: '', name: '' })
  const [saving, setSaving] = useState(false)
  const [pg, setPg] = useState(1)
  const PAGE = 10

  const load = async () => {
    setLoading(true)
    try { const res: any = await fetchContentCategories(); setList(res?.data ?? []) } catch {}
    setLoading(false)
  }

  useEffect(() => { load() }, [])

  const openAdd = () => { setEditItem(null); setForm({ type: '', name: '' }); setDialog(true) }
  const openEdit = (item: Category) => { setEditItem(item); setForm({ type: item.type, name: item.name }); setDialog(true) }

  const save = async () => {
    if (!form.type.trim() || !form.name.trim()) return
    setSaving(true)
    try {
      if (editItem) {
        await updateContentCategory({ oldType: editItem.type, newType: form.type, name: form.name })
      } else {
        await createContentCategory(form)
      }
      setDialog(false)
      await load()
    } catch { alert('操作失败') }
    setSaving(false)
  }

  const remove = async (type: string) => {
    if (!confirm('确定要删除该分类吗？')) return
    try { await removeContentCategory(type); await load() } catch { alert('删除失败') }
  }

  const paged = list.slice((pg - 1) * PAGE, pg * PAGE)

  return (
    <div className="p-6">
      <div className="mb-4 flex items-center justify-between">
        <h1 className="text-xl font-semibold text-body-strong">分类管理</h1>
        <button onClick={openAdd} className="flex items-center gap-1 rounded-lg bg-primary px-4 py-2 text-sm text-primary-foreground hover:bg-primary-active">
          <Plus className="h-4 w-4" />新增分类
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
                  <th className="px-4 py-3 font-medium">分类名称</th>
                  <th className="px-4 py-3 font-medium">分类标识</th>
                  <th className="px-4 py-3 font-medium">文章数</th>
                  <th className="px-4 py-3 font-medium text-right">操作</th>
                </tr>
              </thead>
              <tbody className="divide-y divide-hairline">
                {paged.map((c) => (
                  <tr key={c.type} className="hover:bg-surface-soft/50">
                    <td className="px-4 py-3"><span className="rounded-full bg-primary/10 px-2.5 py-0.5 text-xs text-primary">{c.name}</span></td>
                    <td className="px-4 py-3"><code className="rounded bg-surface-soft px-1.5 py-0.5 text-xs text-body">{c.type}</code></td>
                    <td className="px-4 py-3 text-sm text-body">{c.count ?? 0}</td>
                    <td className="px-4 py-3">
                      <div className="flex justify-end gap-1">
                        <button onClick={() => openEdit(c)} className="rounded p-1.5 text-muted hover:bg-surface-soft hover:text-primary"><Pencil className="h-4 w-4" /></button>
                        <button onClick={() => remove(c.type)} className="rounded p-1.5 text-muted hover:bg-surface-soft hover:text-error"><Trash2 className="h-4 w-4" /></button>
                      </div>
                    </td>
                  </tr>
                ))}
              </tbody>
            </table>
          </div>
          {list.length > PAGE && (
            <div className="mt-4 flex justify-end gap-2">
              <button disabled={pg <= 1} onClick={() => setPg(pg - 1)} className="rounded border border-hairline px-3 py-1.5 text-xs disabled:opacity-30">上一页</button>
              <span className="px-2 py-1.5 text-xs text-muted">{pg} / {Math.ceil(list.length / PAGE)}</span>
              <button disabled={pg >= Math.ceil(list.length / PAGE)} onClick={() => setPg(pg + 1)} className="rounded border border-hairline px-3 py-1.5 text-xs disabled:opacity-30">下一页</button>
            </div>
          )}
        </>
      )}

      {dialog && (
        <div className="fixed inset-0 z-50 flex items-center justify-center bg-black/40" onClick={() => setDialog(false)}>
          <div className="w-full max-w-md rounded-2xl bg-canvas p-6 shadow-xl" onClick={(e) => e.stopPropagation()}>
            <h2 className="mb-4 text-lg font-semibold text-body-strong">{editItem ? '编辑分类' : '新增分类'}</h2>
            <div className="space-y-4">
              <div>
                <label className="mb-1 block text-xs text-muted">分类标识（英文）</label>
                <input value={form.type} onChange={(e) => setForm({ ...form, type: e.target.value })} className="w-full rounded-lg border border-hairline bg-canvas px-3 py-2 text-sm outline-none focus:border-primary" placeholder="article" />
              </div>
              <div>
                <label className="mb-1 block text-xs text-muted">分类名称</label>
                <input value={form.name} onChange={(e) => setForm({ ...form, name: e.target.value })} className="w-full rounded-lg border border-hairline bg-canvas px-3 py-2 text-sm outline-none focus:border-primary" placeholder="文章" />
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
