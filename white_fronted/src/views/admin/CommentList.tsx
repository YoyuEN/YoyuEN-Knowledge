import { useEffect, useState } from 'react'
import { Check, Star, StarOff, Trash2 } from 'lucide-react'
import { fetchAllComments, approveComment, toggleCommentRecommend, removeComment } from '@/api/comment'

export default function CommentList() {
  const [list, setList] = useState<any[]>([])
  const [loading, setLoading] = useState(true)
  const [pg, setPg] = useState(1)
  const PAGE = 10

  const load = async () => {
    setLoading(true)
    try { const res: any = await fetchAllComments(); setList(res?.data ?? []) } catch {}
    setLoading(false)
  }
  useEffect(() => { load() }, [])

  const approve = async (id: string | number) => {
    try { await approveComment(id); await load() } catch { alert('操作失败') }
  }
  const toggleRec = async (id: string | number, is: boolean) => {
    try { await toggleCommentRecommend(id, !is); await load() } catch { alert('操作失败') }
  }
  const remove = async (id: string | number) => {
    if (!confirm('确定要删除该评论吗？')) return
    try { await removeComment(id); await load() } catch { alert('删除失败') }
  }

  const paged = list.slice((pg - 1) * PAGE, pg * PAGE)

  return (
    <div className="p-6">
      <h1 className="mb-4 text-xl font-semibold text-body-strong">评论管理</h1>
      {loading ? (
        <div className="flex justify-center py-20"><div className="h-8 w-8 animate-spin rounded-full border-2 border-primary border-t-transparent" /></div>
      ) : (
        <>
          <div className="overflow-hidden rounded-xl border border-hairline">
            <table className="w-full">
              <thead className="bg-surface-soft text-left text-xs text-muted">
                <tr>
                  <th className="px-4 py-3 font-medium">作者</th>
                  <th className="px-4 py-3 font-medium">内容</th>
                  <th className="px-4 py-3 font-medium">时间</th>
                  <th className="px-4 py-3 font-medium text-right">操作</th>
                </tr>
              </thead>
              <tbody className="divide-y divide-hairline">
                {paged.map((c: any) => (
                  <tr key={c.id} className="hover:bg-surface-soft/50">
                    <td className="px-4 py-3 text-sm text-body-strong whitespace-nowrap">{c.author}</td>
                    <td className="px-4 py-3 text-sm text-body max-w-[400px] line-clamp-2">{c.content}</td>
                    <td className="px-4 py-3 text-xs text-muted-soft whitespace-nowrap">{c.createTime ?? c.time}</td>
                    <td className="px-4 py-3">
                      <div className="flex justify-end gap-1">
                        <button onClick={() => approve(c.id)} className="rounded p-1.5 text-success hover:bg-success/10" title="通过"><Check className="h-4 w-4" /></button>
                        <button onClick={() => toggleRec(c.id, c.isRecommend || c.recommended)} className="rounded p-1.5 text-accent-amber hover:bg-accent-amber/10" title="推荐">
                          {c.isRecommend || c.recommended ? <Star className="h-4 w-4 fill-current" /> : <StarOff className="h-4 w-4" />}
                        </button>
                        <button onClick={() => remove(c.id)} className="rounded p-1.5 text-error hover:bg-error/10" title="删除"><Trash2 className="h-4 w-4" /></button>
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
    </div>
  )
}
