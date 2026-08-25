import type { ReactNode } from 'react'
import { Navigate, useLocation } from 'react-router-dom'
import { isAuthenticated } from '@/utils/auth'

interface RequireAuthProps {
  children: ReactNode
}

/**
 * 路由守卫：保护需要认证的路由。
 * 未登录时重定向到 /login，并携带 redirect 查询参数。
 */
export default function RequireAuth({ children }: RequireAuthProps) {
  const location = useLocation()

  if (!isAuthenticated()) {
    const redirect = encodeURIComponent(location.pathname + location.search)
    return <Navigate to={`/login?redirect=${redirect}`} replace />
  }

  return <>{children}</>
}
