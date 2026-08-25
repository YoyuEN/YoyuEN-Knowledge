import { NavLink, Outlet, useNavigate } from 'react-router-dom'
import {
  Home,
  BookOpen,
  MessageCircle,
  NotebookPen,
  User,
  Moon,
  Sun,
  LayoutGrid,
} from 'lucide-react'
import { cn } from '@/lib/utils'
import { useTheme } from '@/theme/ThemeProvider'
import { isAuthenticated } from '@/utils/auth'

interface NavItem {
  to: string
  label: string
  icon: typeof Home
  /** 移动端 tabbar 简写标签 */
  tabLabel?: string
}

const NAV_ITEMS: NavItem[] = [
  { to: '/', label: '首页', icon: Home },
  { to: '/content', label: '内容', icon: BookOpen },
  { to: '/chat', label: 'AI对话', icon: MessageCircle },
  { to: '/diary', label: '时光手札', icon: NotebookPen, tabLabel: '手札' },
  { to: '/profile', label: '关于我', icon: User, tabLabel: '我的' },
]

export default function Layout() {
  const { theme, toggleTheme } = useTheme()
  const navigate = useNavigate()

  const goAdmin = () => {
    navigate(isAuthenticated() ? '/admin' : '/login?redirect=%2Fadmin')
  }

  return (
    <div className="flex min-h-screen flex-col bg-canvas text-body">
      {/* 顶部导航 */}
      <header className="sticky top-0 z-40 border-b border-hairline bg-canvas/80 backdrop-blur-md">
        <div className="mx-auto flex h-16 max-w-6xl items-center justify-between px-4 sm:px-6">
          <NavLink to="/" className="font-brand text-2xl tracking-wide text-ink">
            悠远知识库
          </NavLink>

          {/* 桌面端水平菜单 */}
          <nav className="hidden items-center gap-1 md:flex">
            {NAV_ITEMS.map(({ to, label, icon: Icon }) => (
              <NavLink
                key={to}
                to={to}
                end={to === '/'}
                className={({ isActive }) =>
                  cn(
                    'flex items-center gap-1.5 rounded-md px-3 py-2 text-sm font-medium transition-colors',
                    isActive
                      ? 'bg-surface-soft text-primary'
                      : 'text-body hover:bg-surface-soft hover:text-ink'
                  )
                }
              >
                <Icon className="h-4 w-4" />
                {label}
              </NavLink>
            ))}
          </nav>

          <div className="flex items-center gap-1">
            <button
              type="button"
              onClick={goAdmin}
              title="后台管理"
              className="hidden rounded-md p-2 text-body transition-colors hover:bg-surface-soft hover:text-ink md:inline-flex"
            >
              <LayoutGrid className="h-5 w-5" />
            </button>
            <button
              type="button"
              onClick={toggleTheme}
              title={theme === 'dark' ? '切换到亮色' : '切换到暗色'}
              className="rounded-md p-2 text-body transition-colors hover:bg-surface-soft hover:text-ink"
            >
              {theme === 'dark' ? <Sun className="h-5 w-5" /> : <Moon className="h-5 w-5" />}
            </button>
          </div>
        </div>
      </header>

      {/* 主内容 */}
      <main className="mx-auto w-full max-w-6xl flex-1 px-4 pb-24 pt-6 sm:px-6 md:pb-10">
        <Outlet />
      </main>

      {/* 移动端底部 tabbar */}
      <nav className="fixed inset-x-0 bottom-0 z-40 border-t border-hairline bg-canvas/95 backdrop-blur-md md:hidden">
        <div className="mx-auto flex max-w-6xl items-stretch">
          {NAV_ITEMS.map(({ to, label, tabLabel, icon: Icon }) => (
            <NavLink
              key={to}
              to={to}
              end={to === '/'}
              className={({ isActive }) =>
                cn(
                  'flex flex-1 flex-col items-center gap-0.5 py-2 text-[11px] transition-colors',
                  isActive ? 'text-primary' : 'text-muted'
                )
              }
            >
              <Icon className="h-5 w-5" />
              {tabLabel ?? label}
            </NavLink>
          ))}
        </div>
      </nav>
    </div>
  )
}
