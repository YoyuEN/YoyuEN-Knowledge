import { useState } from 'react'
import { useNavigate, useSearchParams } from 'react-router-dom'
import { useAppDispatch } from '@/store/hooks'
import { setAuthToken, setUserInfo } from '@/store/authSlice'
import { login as loginApi, getCurrentUser } from '@/api/auth'

export default function Login() {
  const [username, setUsername] = useState('')
  const [password, setPassword] = useState('')
  const [loading, setLoading] = useState(false)
  const [error, setError] = useState('')

  const navigate = useNavigate()
  const [searchParams] = useSearchParams()
  const dispatch = useAppDispatch()

  const handleLogin = async (e: React.FormEvent) => {
    e.preventDefault()
    if (!username.trim()) { setError('请输入用户名'); return }
    if (!password) { setError('请输入密码'); return }
    setError('')
    setLoading(true)

    try {
      const res: any = await loginApi({ username: username.trim(), password })
      if (res?.token) {
        dispatch(setAuthToken(res.token))
        try {
          const info: any = await getCurrentUser()
          if (info) {
            dispatch(setUserInfo({
              username: info.username ?? info.nickname ?? username,
              avatar: info.avatar ?? '',
              roles: info.roles ?? [],
            }))
          }
        } catch { /* ignore */ }
        const redirect = searchParams.get('redirect') || '/admin'
        navigate(redirect, { replace: true })
      } else {
        setError(res?.message || '登录失败')
      }
    } catch (e: any) {
      setError(e?.message || '登录失败，请检查用户名和密码')
    } finally {
      setLoading(false)
    }
  }

  return (
    <div className="flex min-h-screen items-center justify-center bg-surface-soft p-4 sm:p-15">
      <div className="flex w-full max-w-[960px] overflow-hidden rounded-2xl bg-canvas shadow-lg">
        <div className="hidden flex-1 flex-col items-center justify-center gap-5 bg-surface-soft px-15 py-15 md:flex">
          <div className="flex h-16 w-16 items-center justify-center rounded-2xl bg-primary/15">
            <span className="font-brand text-3xl text-primary">Y</span>
          </div>
          <h1 className="font-brand text-2xl text-body-strong">YoyuEN 知识库</h1>
          <p className="text-sm text-muted">基于 RAG 技术的智能问答系统</p>
        </div>

        <div className="flex flex-1 flex-col justify-center px-8 py-12 sm:px-15">
          <h2 className="mb-8 text-xl font-semibold text-body-strong">欢迎回来</h2>
          <form onSubmit={handleLogin} className="flex flex-col gap-4">
            <input
              type="text" value={username}
              onChange={(e) => setUsername(e.target.value)}
              placeholder="请输入用户名"
              className="h-11 rounded-lg border border-hairline bg-canvas px-4 text-sm text-body outline-none placeholder:text-muted-soft focus:border-primary"
            />
            <input
              type="password" value={password}
              onChange={(e) => setPassword(e.target.value)}
              placeholder="请输入密码"
              className="h-11 rounded-lg border border-hairline bg-canvas px-4 text-sm text-body outline-none placeholder:text-muted-soft focus:border-primary"
            />
            {error && <p className="text-xs text-error">{error}</p>}
            <button
              type="submit" disabled={loading}
              className="mt-2 h-11 rounded-lg bg-primary text-sm font-medium text-primary-foreground transition-colors hover:bg-primary-active disabled:cursor-not-allowed disabled:bg-primary-disabled disabled:text-muted"
            >
              {loading ? '登录中...' : '登录'}
            </button>
          </form>
        </div>
      </div>

      <div className="absolute top-8 flex items-center gap-2 md:hidden">
        <div className="flex h-10 w-10 items-center justify-center rounded-xl bg-primary/15">
          <span className="font-brand text-xl text-primary">Y</span>
        </div>
        <span className="font-brand text-lg text-body-strong">YoyuEN</span>
      </div>
    </div>
  )
}
