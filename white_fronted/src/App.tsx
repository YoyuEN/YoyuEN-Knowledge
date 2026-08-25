import { useTheme } from '@/theme/ThemeProvider'
import { Moon, Sun } from 'lucide-react'

function Swatch({ label, varName }: { label: string; varName: string }) {
  return (
    <div className="flex flex-col gap-2">
      <div
        className="h-16 w-full rounded-md border border-[var(--color-hairline)]"
        style={{ background: `var(${varName})` }}
      />
      <span className="text-xs text-[var(--color-muted)]">{label}</span>
    </div>
  )
}

function App() {
  const { theme, toggleTheme } = useTheme()

  return (
    <div className="min-h-dvh bg-[var(--color-canvas)] text-[var(--color-body)]">
      <header className="flex items-center justify-between border-b border-[var(--color-hairline)] px-6 py-4">
        <h1 className="font-brand text-2xl text-[var(--color-ink)]">悠远知识库</h1>
        <button
          type="button"
          onClick={toggleTheme}
          aria-label="切换主题"
          className="inline-flex h-10 w-10 items-center justify-center rounded-md border border-[var(--color-hairline)] text-[var(--color-body)] transition-colors hover:bg-[var(--color-surface-soft)]"
        >
          {theme === 'dark' ? <Sun size={18} /> : <Moon size={18} />}
        </button>
      </header>

      <main className="mx-auto max-w-4xl px-6 py-12">
        <h2 className="mb-2 text-3xl text-[var(--color-ink)]">设计系统就绪</h2>
        <p className="mb-8 text-[var(--color-muted)]">
          当前主题：{theme === 'dark' ? '深色' : '浅色'} · 无彩色渐变背景 · 珊瑚橙点缀
        </p>

        <div className="grid grid-cols-2 gap-4 sm:grid-cols-4">
          <Swatch label="canvas" varName="--color-canvas" />
          <Swatch label="surface-soft" varName="--color-surface-soft" />
          <Swatch label="surface-card" varName="--color-surface-card" />
          <Swatch label="primary" varName="--color-primary" />
          <Swatch label="accent-teal" varName="--color-accent-teal" />
          <Swatch label="accent-amber" varName="--color-accent-amber" />
          <Swatch label="ink" varName="--color-ink" />
          <Swatch label="hairline" varName="--color-hairline" />
        </div>

        <button
          type="button"
          className="mt-8 rounded-md bg-[var(--color-primary)] px-6 py-3 text-[var(--color-primary-foreground)] transition-colors hover:bg-[var(--color-primary-active)]"
        >
          珊瑚橙按钮
        </button>
      </main>
    </div>
  )
}

export default App
