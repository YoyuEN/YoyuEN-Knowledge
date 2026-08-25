import { useEffect, useState } from 'react'
import { fetchProfileDetail, updateProfile } from '@/api/profile'

export default function ProfileEdit() {
  const [form, setForm] = useState({
    nickname: '', avatar: '', signature: '', welcomeText: '',
    school: '', email: '', location: '',
    techStack: '', tags: '',
  })
  const [loading, setLoading] = useState(true)
  const [saving, setSaving] = useState(false)
  const [msg, setMsg] = useState('')

  useEffect(() => {
    fetchProfileDetail()
      .then((res: any) => {
        const d = res?.data
        if (d) {
          setForm({
            nickname: d.nickname || '', avatar: d.avatar || '', signature: d.signature || '',
            welcomeText: d.welcomeText || '', school: d.school || '', email: d.email || '', location: d.location || '',
            techStack: Array.isArray(d.techStack) ? d.techStack.join(', ') : (d.techStack || ''),
            tags: Array.isArray(d.tags) ? d.tags.join(', ') : (d.tags || ''),
          })
        }
      })
      .catch(() => {})
      .finally(() => setLoading(false))
  }, [])

  const save = async () => {
    setSaving(true)
    setMsg('')
    try {
      await updateProfile({
        ...form,
        techStack: form.techStack ? form.techStack.split(',').map((s) => s.trim()).filter(Boolean) : [],
        tags: form.tags ? form.tags.split(',').map((s) => s.trim()).filter(Boolean) : [],
      })
      setMsg('保存成功')
    } catch { setMsg('保存失败') }
    setSaving(false)
  }

  if (loading) {
    return (
      <div className="flex justify-center py-20">
        <div className="h-8 w-8 animate-spin rounded-full border-2 border-primary border-t-transparent" />
      </div>
    )
  }

  const fields = [
    { key: 'nickname', label: '昵称' },
    { key: 'avatar', label: '头像 URL' },
    { key: 'signature', label: '个性签名' },
    { key: 'school', label: '学校/公司' },
    { key: 'email', label: '邮箱' },
    { key: 'location', label: '所在地' },
  ]

  return (
    <div className="mx-auto max-w-xl p-6">
      <h1 className="mb-6 text-xl font-semibold text-body-strong">个人信息</h1>
      <div className="space-y-4">
        {fields.map(({ key, label }) => (
          <div key={key}>
            <label className="mb-1 block text-xs text-muted">{label}</label>
            <input
              value={(form as any)[key]}
              onChange={(e) => setForm({ ...form, [key]: e.target.value })}
              className="w-full rounded-lg border border-hairline bg-canvas px-3 py-2 text-sm outline-none focus:border-primary"
            />
          </div>
        ))}
        <div>
          <label className="mb-1 block text-xs text-muted">欢迎语</label>
          <textarea
            value={form.welcomeText}
            onChange={(e) => setForm({ ...form, welcomeText: e.target.value })}
            rows={3}
            className="w-full rounded-lg border border-hairline bg-canvas px-3 py-2 text-sm outline-none focus:border-primary resize-y"
          />
        </div>
        <div>
          <label className="mb-1 block text-xs text-muted">技术栈（逗号分隔）</label>
          <input
            value={form.techStack}
            onChange={(e) => setForm({ ...form, techStack: e.target.value })}
            className="w-full rounded-lg border border-hairline bg-canvas px-3 py-2 text-sm outline-none focus:border-primary"
            placeholder="Vue.js, React, TypeScript"
          />
        </div>
        <div>
          <label className="mb-1 block text-xs text-muted">个人标签（逗号分隔）</label>
          <input
            value={form.tags}
            onChange={(e) => setForm({ ...form, tags: e.target.value })}
            className="w-full rounded-lg border border-hairline bg-canvas px-3 py-2 text-sm outline-none focus:border-primary"
            placeholder="篮球, Gym, Running"
          />
        </div>
      </div>

      {msg && <p className={`mt-3 text-xs ${msg.includes('失败') ? 'text-error' : 'text-success'}`}>{msg}</p>}

      <button
        onClick={save}
        disabled={saving}
        className="mt-6 w-full rounded-lg bg-primary py-2.5 text-sm font-medium text-primary-foreground hover:bg-primary-active disabled:opacity-50"
      >
        {saving ? '保存中...' : '保存'}
      </button>
    </div>
  )
}
