import { useEffect, useState } from 'react'
import { Plus, Pencil, Trash2 } from 'lucide-react'
import { fetchContentTags, createContentTag, updateContentTag, removeContentTag } from '@/api/content'

interface Tag { name: string; count?: number }

export default function TagList() {
  const [list, setList] = useState<Tag[]>([])
  const [loading, setLoading] = useState(true)
  const [dialog, setDialog] = useState(false)
  const [editItem, setEditItem] = useState<Tag | null>(null)
  const [name, setName] = useState('')
  const [saving, setSaving] = useState(false)
  const [pg, setPg] = useState(1)
  const PAGE = 10

  const load = async () => {
    setLoading(true)
    try { const res: any = await fetchContentTags(); setList(res?.data ?? []) } catch {}
    setLoading(false)
  }
  useEffect(() => { load() }, [])

  const openAdd = () => { setEditItem(null); setName(''); setDialog(true) }
  const openEdit = (item: Tag) => { setEditItem(item); setName(item.name); setDialog(true) }

  const save = async () => {
    if (!name.trim()) return
    setSaving(true)
    try {
      if (editItem) {
        await updateContentTag(editItem.name, name.trim())
      } else {
        await createContentTag(name.trim())
      }
      setDialog(false); await load()
    } catch { alert('操作失败') }
    setSaving(false)
  }

  const remove = async (n: string) => {
    if (!confirm('确定要删除该标签吗？')) return
    try { await removeContentTag(n); await load() } catch { alert('删除失败') }
  }

  const paged = list.slice((pg - 1) * PAGE, pg * PAGE)

  return (
    <div className="p-6">
      <div className="mb-4 flex items-center justify-between">
        <div>
          <h1 className="text-xl font-semibold text-body-strong">标签管理</h1>
          <p className="text-xs text-muted-soft mt-1">共 {list.length} 个标签</p>
        </div>
        <button onClick={openAdd} className="flex items-center gap-1 rounded-lg bg-primary px-4 py-2 text-sm text-primary-foreground hover:bg-primary-active">
          <Plus className="h-4 w-4" />新增标签
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
                  <th className="px-4 py-3 font-medium">标签名</th>
                  <th className="px-4 py-3 font-medium">使用文章数</th>
                  <th className="px-4 py-3 font-medium text-right">操作</th>
                </tr>
              </thead>
              <tbody className="divide-y divide-hairline">
                {paged.map((t) => (
                  <tr key={t.name} className="hover:bg-surface-soft/50">
                    <td className="px-4 py-3"><span className="rounded-full bg-surface-soft px-2.5 py-0.5 text-xs text-body">{t.name}</span></td>
                    <td className="px-4 py-3 text-sm text-body">{t.count ?? 0}</td>
                    <td className="px-4 py-3">
                      <div className="flex justify-end gap-1">
                        <button onClick={() => openEdit(t)} className="rounded p-1.5 text-muted hover:bg-surface-soft hover:text-primary"><Pencil className="h-4 w-4" /></button>
                        <button onClick={() => remove(t.name)} className="rounded p-1.5 text-muted hover:bg-surface-soft hover:text-error"><Trash2 className="h-4 w-4" /></button>
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
          <div className="w-full max-w-sm rounded-2xl bg-canvas p-6 shadow-xl" onClick={(e) => e.stopPropagation()}>
            <h2 className="mb-4 text-lg font-semibold text-body-strong">{editItem ? '重命名标签' : '新增标签'}</h2>
            <input value={name} onChange={(e) => setName(e.target.value)} className="w-full rounded-lg border border-hairline bg-canvas px-3 py-2 text-sm outline-none focus:border-primary" placeholder="标签名称" />
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
