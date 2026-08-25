import { useEffect, useRef, useState } from 'react'
import { Upload, Trash2, Image as ImageIcon } from 'lucide-react'
import { fetchPhotoList, removePhoto } from '@/api/photo'
import { getToken } from '@/utils/auth'

export default function PhotoList() {
  const [photos, setPhotos] = useState<any[]>([])
  const [loading, setLoading] = useState(true)
  const [uploading, setUploading] = useState(false)
  const inputRef = useRef<HTMLInputElement | null>(null)

  const load = async () => {
    setLoading(true)
    try { const res: any = await fetchPhotoList(); setPhotos(res?.data ?? []) } catch {}
    setLoading(false)
  }
  useEffect(() => { load() }, [])

  const handleUpload = async (e: React.ChangeEvent<HTMLInputElement>) => {
    const file = e.target.files?.[0]
    if (!file) return
    setUploading(true)
    const form = new FormData()
    form.append('photo', file)
    try {
      const token = getToken()
      await fetch('/api/photo/upload', {
        method: 'POST',
        headers: { Authorization: `Bearer ${token || ''}` },
        body: form,
      })
      await load()
    } catch { alert('上传失败') }
    setUploading(false)
    e.target.value = ''
  }

  const remove = async (id: string | number) => {
    if (!confirm('确定要删除该照片吗？')) return
    try { await removePhoto(String(id)); await load() } catch { alert('删除失败') }
  }

  return (
    <div className="p-6">
      <div className="mb-4 flex items-center justify-between">
        <h1 className="text-xl font-semibold text-body-strong">图片管理</h1>
        <button
          onClick={() => inputRef.current?.click()}
          disabled={uploading}
          className="flex items-center gap-1 rounded-lg bg-primary px-4 py-2 text-sm text-primary-foreground hover:bg-primary-active disabled:opacity-50"
        >
          <Upload className="h-4 w-4" />{uploading ? '上传中...' : '上传图片'}
        </button>
        <input ref={inputRef} type="file" accept="image/*" className="hidden" onChange={handleUpload} />
      </div>

      {loading ? (
        <div className="flex justify-center py-20"><div className="h-8 w-8 animate-spin rounded-full border-2 border-primary border-t-transparent" /></div>
      ) : photos.length === 0 ? (
        <div className="flex flex-col items-center justify-center py-20 text-muted-soft">
          <ImageIcon className="h-12 w-12" />
          <p className="mt-2">暂无图片</p>
        </div>
      ) : (
        <div className="grid grid-cols-3 gap-3 sm:grid-cols-4 md:grid-cols-6">
          {photos.map((p: any) => (
            <div key={p.id} className="group relative aspect-square overflow-hidden rounded-lg border border-hairline bg-surface-soft">
              <img src={p.url} alt={p.description || ''} className="h-full w-full object-cover" />
              <div className="absolute inset-0 flex items-center justify-center bg-black/40 opacity-0 transition-opacity group-hover:opacity-100">
                <button onClick={() => remove(p.id)} className="rounded-full bg-white/90 p-1.5 text-error hover:bg-white">
                  <Trash2 className="h-4 w-4" />
                </button>
              </div>
            </div>
          ))}
        </div>
      )}
    </div>
  )
}
