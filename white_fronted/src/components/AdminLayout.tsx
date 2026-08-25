import { useEffect, useState } from 'react'
import { NavLink, Outlet, useLocation, useNavigate } from 'react-router-dom'
import {
  LayoutDashboard,
  BarChart3,
  FileText,
  FolderTree,
  Tag,
  MessageSquare,
  Image as ImageIcon,
  BookOpen,
  NotebookPen,
  UserCog,
  Home,
  LogOut,
  Menu as MenuIcon,
  X,
  ChevronDown,
  Sun,
  Moon,
} from 'lucide-react'
import { cn } from '@/lib/utils'
import { useTheme } from '@/theme/ThemeProvider'
import { useAppDispatch, useAppSelector } from '@/store/hooks'
import { logout as logoutAction, setUserInfo } from '@/store/authSlice'
import { logout as logoutApi, getCurrentUser } from '@/api/auth'
import { isAuthenticated } from '@/utils/auth'

interface NavItem {
  to: string
  label: string
  icon: React.ComponentType<{ className?: string }>
}

interface NavGroup {
  title: string
  items: NavItem[]
}

const NAV_GROUPS: NavGroup[] = [
  {
    title: '概览',
    items: [
      { to: '/admin/dashboard', label: '仪表盘', icon: LayoutDashboard },
      { to: '/admin/statistics', label: '数据统计', icon: BarChart3 },
    ],
  },
  {
    title: '内容管理',
    items: [
      { to: '/admin/articles', label: '文章管理', icon: FileText },
      { to: '/admin/categories', label: '分类管理', icon: FolderTree },
      { to: '/admin/tags', label: '标签管理', icon: Tag },
      { to: '/admin/comments', label: '评论管理', icon: MessageSquare },
    ],
  },
  {
    title: '媒体知识',
    items: [
      { to: '/admin/photos', label: '图片管理', icon: ImageIcon },
      { to: '/admin/knowledge', label: '知识库', icon: BookOpen },
      { to: '/admin/diary', label: '日记管理', icon: NotebookPen },
    ],
  },
  {
    title: '设置',
    items: [{ to: '/admin/profile', label: '个人信息', icon: UserCog }],
  },
]

export default function AdminLayout() {
  const navigate = useNavigate()
  const location = useLocation()
  const dispatch = useAppDispatch()
  const { theme, toggleTheme } = useTheme()
  const userInfo = useAppSelector((s) => s.auth.userInfo)

  const [asideOpen, setAsideOpen] = useState(false)
  const [menuOpen, setMenuOpen] = useState(false)

  useEffect(() => {
    if (!isAuthenticated()) {
      navigate('/login', { replace: true })
      return
    }
    if (!userInfo.username) {
      getCurrentUser()
        .then((data: any) => {
          if (data) {
            dispatch(
              setUserInfo({
                username: data.username ?? data.nickname ?? '管理员',
                avatar: data.avatar ?? '',
                roles: data.roles ?? [],
              }),
            )
          }
        })
        .catch(() => {})
    }
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [])

  // Close mobile drawer on route change
  useEffect(() => {
    setAsideOpen(false)
  }, [location.pathname])

  const handleLogout = async () => {
    try {
      await logoutApi()
    } catch {
      // ignore network errors on logout
    }
    dispatch(logoutAction())
    navigate('/login', { replace: true })
  }

  return (
    <div className="min-h-screen bg-surface-soft text-body">
      {/* Header */}
      <header className="fixed inset-x-0 top-0 z-40 flex h-16 items-center justify-between border-b border-hairline bg-canvas px-4 md:px-6">
        <div className="flex items-center gap-3">
          <button
            type="button"
            onClick={() => setAsideOpen((v) => !v)}
            className="grid h-9 w-9 place-items-center rounded-md text-body transition-colors hover:bg-surface-card md:hidden"
            aria-label="切换菜单"
          >
            {asideOpen ? <X className="h-5 w-5" /> : <MenuIcon className="h-5 w-5" />}
          </button>
          <div className="flex items-center gap-2">
            <span className="grid h-9 w-9 place-items-center rounded-lg bg-primary text-primary-foreground font-brand text-lg">
              悠
            </span>
            <div className="hidden flex-col leading-tight sm:flex">
              <strong className="text-sm font-semibold text-body-strong">悠远控制台</strong>
              <span className="text-xs text-muted">Personal Studio</span>
            </div>
          </div>
        </div>

        <div className="flex items-center gap-2">
          <button
            type="button"
            onClick={toggleTheme}
            className="grid h-9 w-9 place-items-center rounded-md text-body transition-colors hover:bg-surface-card"
            aria-label="切换主题"
          >
            {theme === 'dark' ? <Sun className="h-5 w-5" /> : <Moon className="h-5 w-5" />}
          </button>

          <div className="relative">
            <button
              type="button"
              onClick={() => setMenuOpen((v) => !v)}
              onBlur={() => setTimeout(() => setMenuOpen(false), 150)}
              className="flex items-center gap-2 rounded-md px-2 py-1.5 transition-colors hover:bg-surface-card"
            >
              {userInfo.avatar ? (
                <img
                  src={userInfo.avatar}
                  alt="avatar"
                  className="h-7 w-7 rounded-full object-cover"
                />
              ) : (
                <span className="grid h-7 w-7 place-items-center rounded-full bg-primary text-xs text-primary-foreground">
                  {(userInfo.username || '管')[0]}
                </span>
              )}
              <span className="hidden text-sm text-body-strong sm:block">
                {userInfo.username || '管理员'}
              </span>
              <ChevronDown className="h-4 w-4 text-muted" />
            </button>
            {menuOpen && (
              <div className="absolute right-0 top-full mt-1 w-40 overflow-hidden rounded-lg border border-hairline bg-canvas py-1 shadow-lg">
                <button
                  type="button"
                  onMouseDown={handleLogout}
                  className="flex w-full items-center gap-2 px-3 py-2 text-sm text-body transition-colors hover:bg-surface-card"
                >
                  <LogOut className="h-4 w-4" />
                  退出登录
                </button>
              </div>
            )}
          </div>
        </div>
      </header>

      {/* Sidebar */}
      <aside
        className={cn(
          'fixed left-0 top-16 z-30 flex h-[calc(100vh-4rem)] w-[230px] flex-col border-r border-hairline bg-canvas transition-transform duration-300',
          asideOpen ? 'translate-x-0' : '-translate-x-full md:translate-x-0',
        )}
      >
        <nav className="flex-1 overflow-y-auto px-3 py-4">
          {NAV_GROUPS.map((group) => (
            <div key={group.title} className="mb-5">
              <div className="mb-1.5 px-3 text-xs font-medium uppercase tracking-wide text-muted-soft">
                {group.title}
              </div>
              <div className="space-y-0.5">
                {group.items.map((item) => {
                  const Icon = item.icon
                  return (
                    <NavLink
                      key={item.to}
                      to={item.to}
                      className={({ isActive }) =>
                        cn(
                          'flex items-center gap-3 rounded-md px-3 py-2 text-sm transition-colors',
                          isActive
                            ? 'bg-primary/10 font-medium text-primary'
                            : 'text-body hover:bg-surface-card',
                        )
                      }
                    >
                      <Icon className="h-5 w-5" />
                      <span>{item.label}</span>
                    </NavLink>
                  )
                })}
              </div>
            </div>
          ))}
        </nav>

        <div className="border-t border-hairline p-3">
          <NavLink
            to="/"
            className="flex items-center gap-3 rounded-md px-3 py-2 text-sm text-body transition-colors hover:bg-surface-card"
          >
            <Home className="h-5 w-5" />
            <span>返回前台</span>
          </NavLink>
        </div>
      </aside>

      {/* Mobile overlay */}
      {asideOpen && (
        <div
          className="fixed inset-0 top-16 z-20 bg-black/40 md:hidden"
          onClick={() => setAsideOpen(false)}
        />
      )}

      {/* Main */}
      <main className="pt-16 md:pl-[230px]">
        <div className="mx-auto max-w-7xl p-4 md:p-6">
          <Outlet />
        </div>
      </main>
    </div>
  )
}
