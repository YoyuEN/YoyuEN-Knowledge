import { useMemo, useRef, useState } from 'react'
import { marked } from 'marked'
import { MessageCircle, X } from 'lucide-react'
import { createComment } from '@/api/comment'
import { cn } from '@/lib/utils'
import type { CommentItem, CommentReply, CommentTarget } from '@/types/comment'
import defaultAvatar from '@/assets/picture/YoyuEN.png'

const EMOJIS = [
  '😊', '😄', '😁', '😆', '😅', '😂', '🤣', '😇', '🙂', '🙃',
  '😉', '😌', '😍', '🥰', '😘', '😗', '😙', '😚', '😋', '😛',
  '😝', '😜', '🤪', '🤨', '🧐', '🤓', '😎', '🤩', '🥳', '😏',
  '😒', '😞', '😔', '😟', '😕', '🙁', '☹️', '😣', '😖', '😫',
  '😩', '🥺', '😢', '😭', '😤', '😠', '😡', '🤬', '🤯', '😳',
  '🥵', '🥶', '😱', '😨', '😰', '😥', '😓', '🤗', '🤔', '🤭',
  '🤫', '🤥', '😶', '😐', '😑', '😬', '🙄', '😯', '😦', '😧',
  '😮', '😲', '🥱', '😴', '🤤', '😪', '😵', '🤐', '🥴', '🤢',
  '🤮', '🤧', '😷', '🤒', '🤕', '🤑', '🤠', '😈', '👿',
]

interface CommentSectionProps {
  data: CommentTarget | null | undefined
  comments?: CommentItem[]
  contentType?: string
  onCommentAdded?: () => void
}

interface CommentForm {
  content: string
  nickname: string
  email: string
  url: string
  avatar: string
}

function renderMarkdown(content?: string): string {
  if (!content) return ''
  return marked.parse(content, { breaks: true, gfm: true }) as string
}

function flattenReplies(comment: CommentItem | CommentReply): CommentReply[] {
  const result: CommentReply[] = []
  for (const reply of comment.replies ?? []) {
    result.push(reply)
    result.push(...flattenReplies(reply))
  }
  return result
}

export default function CommentSection({
  data,
  comments = [],
  contentType = '',
  onCommentAdded,
}: CommentSectionProps) {
  const [form, setForm] = useState<CommentForm>({
    content: '',
    nickname: '',
    email: '',
    url: '',
    avatar: defaultAvatar,
  })
  const [showEmojiPicker, setShowEmojiPicker] = useState(false)
  const [replyToCommentId, setReplyToCommentId] = useState<string | number | null>(null)
  const [replyToUsername, setReplyToUsername] = useState<string | null>(null)
  const [submitting, setSubmitting] = useState(false)
  const avatarFileRef = useRef<File | null>(null)
  const formContainerRef = useRef<HTMLDivElement | null>(null)

  const canSubmit = useMemo(() => form.content.trim().length > 0, [form.content])

  const addEmoji = (emoji: string) => {
    setForm((prev) => ({ ...prev, content: prev.content + emoji }))
    setShowEmojiPicker(false)
  }

  const handleAvatarChange = (event: React.ChangeEvent<HTMLInputElement>) => {
    const file = event.target.files?.[0]
    if (!file) return
    avatarFileRef.current = file
    setForm((prev) => ({ ...prev, avatar: URL.createObjectURL(file) }))
  }

  const showReplyForm = (commentId: string | number, username: string) => {
    setReplyToCommentId(commentId)
    setReplyToUsername(username)
    setForm((prev) => ({ ...prev, content: '' }))
    setTimeout(() => {
      formContainerRef.current?.scrollIntoView({ behavior: 'smooth' })
    }, 100)
  }

  const cancelReply = () => {
    setReplyToCommentId(null)
    setReplyToUsername(null)
    setForm((prev) => ({ ...prev, content: '' }))
  }

  const submitComment = async () => {
    if (!form.content.trim() || !data) return
    setSubmitting(true)

    let finalAvatarFile = avatarFileRef.current
    if (!finalAvatarFile) {
      try {
        const response = await fetch(defaultAvatar)
        const blob = await response.blob()
        finalAvatarFile = new File([blob], 'YoyuEN.png', { type: blob.type })
      } catch {
        finalAvatarFile = null
      }
    }

    const payload = new FormData()
    payload.append('contentId', String(data.id))
    payload.append('contentType', contentType)
    payload.append('author', form.nickname || '匿名用户')
    payload.append('userId', localStorage.getItem('userId') || '')
    payload.append('content', form.content.trim())
    payload.append('parentId', replyToCommentId != null ? String(replyToCommentId) : '')
    if (finalAvatarFile) {
      payload.append('avatarFile', finalAvatarFile)
    }

    try {
      await createComment(payload)
      setForm({
        content: '',
        nickname: '',
        email: '',
        url: '',
        avatar: defaultAvatar,
      })
      setReplyToCommentId(null)
      setReplyToUsername(null)
      avatarFileRef.current = null
      onCommentAdded?.()
    } catch (e) {
      console.error('评论提交失败', e)
    } finally {
      setSubmitting(false)
    }
  }

  if (!data) return null

  return (
    <div className="px-5 py-2.5">
      {/* 评论表单 */}
      <div ref={formContainerRef} className="mt-2.5 rounded-xl bg-surface-card p-4">
        <div className="relative">
          <textarea
            value={form.content}
            onChange={(e) => setForm((prev) => ({ ...prev, content: e.target.value }))}
            rows={5}
            placeholder={replyToUsername ? `回复 @${replyToUsername}：` : '分享您的想法...'}
            className="w-full resize-y rounded-lg border border-hairline bg-canvas px-3 py-2 text-body outline-none placeholder:text-muted-soft focus:border-primary"
          />
          <div className="mt-2 flex items-center gap-2">
            <button
              type="button"
              onClick={() => setShowEmojiPicker((v) => !v)}
              className="rounded-md border border-hairline p-1.5 text-muted transition-colors hover:bg-surface-soft"
              aria-label="表情"
            >
              <MessageCircle className="h-4 w-4" />
            </button>
            <span className="text-xs text-muted-soft">选择表情或输入 Markdown</span>
          </div>

          {showEmojiPicker && (
            <div className="mt-2 grid max-h-40 grid-cols-10 gap-1 overflow-y-auto rounded-lg border border-hairline bg-canvas p-2">
              {EMOJIS.map((emoji) => (
                <button
                  type="button"
                  key={emoji}
                  onClick={() => addEmoji(emoji)}
                  className="rounded p-1 text-lg transition-colors hover:bg-surface-soft"
                >
                  {emoji}
                </button>
              ))}
            </div>
          )}
        </div>

        {/* 用户信息输入行 */}
        <div className="mt-3 flex flex-wrap items-center gap-2">
          <label className="cursor-pointer">
            <input type="file" accept="image/*" className="hidden" onChange={handleAvatarChange} />
            <img
              src={form.avatar}
              alt="头像"
              className="h-8 w-8 rounded-full object-cover"
            />
          </label>
          <input
            value={form.nickname}
            onChange={(e) => setForm((prev) => ({ ...prev, nickname: e.target.value }))}
            placeholder="昵称"
            className="h-8 w-28 rounded-md border border-hairline bg-canvas px-2 text-sm text-body outline-none placeholder:text-muted-soft focus:border-primary"
          />
          <input
            value={form.email}
            onChange={(e) => setForm((prev) => ({ ...prev, email: e.target.value }))}
            type="email"
            placeholder="邮箱"
            className="h-8 w-36 rounded-md border border-hairline bg-canvas px-2 text-sm text-body outline-none placeholder:text-muted-soft focus:border-primary"
          />
          <input
            value={form.url}
            onChange={(e) => setForm((prev) => ({ ...prev, url: e.target.value }))}
            type="url"
            placeholder="链接"
            className="h-8 w-36 rounded-md border border-hairline bg-canvas px-2 text-sm text-body outline-none placeholder:text-muted-soft focus:border-primary"
          />
          <button
            type="button"
            onClick={submitComment}
            disabled={!canSubmit || submitting}
            className="inline-flex h-8 items-center gap-1.5 rounded-md bg-primary px-3 text-sm font-medium text-primary-foreground transition-colors hover:bg-primary-active disabled:cursor-not-allowed disabled:bg-primary-disabled disabled:text-muted"
          >
            <MessageCircle className="h-4 w-4" />
            发布
          </button>
          {replyToUsername && (
            <button
              type="button"
              onClick={cancelReply}
              className="inline-flex h-8 items-center gap-1 rounded-md border border-hairline px-2 text-sm text-muted transition-colors hover:bg-surface-soft"
            >
              <X className="h-4 w-4" />
              取消回复
            </button>
          )}
        </div>
      </div>

      {/* 评论列表 */}
      <div className="mt-4 space-y-3">
        {comments.map((mainComment) => (
          <div
            key={mainComment.id}
            id={`comment-${mainComment.id}`}
            className="rounded-xl border border-hairline bg-surface-card"
          >
            <div className="relative p-5">
              {/* 主评论 */}
              <div className="flex flex-col gap-3">
                <div className="flex items-center gap-2">
                  <img
                    src={mainComment.avatar || defaultAvatar}
                    alt={mainComment.author}
                    className="h-9 w-9 rounded-full object-cover"
                  />
                  {mainComment.url ? (
                    <a
                      href={mainComment.url}
                      target="_blank"
                      rel="noopener noreferrer"
                      className="font-medium text-body-strong hover:text-primary"
                    >
                      {mainComment.author}
                    </a>
                  ) : (
                    <span className="font-medium text-body-strong">{mainComment.author}</span>
                  )}
                  <button
                    type="button"
                    onClick={() => showReplyForm(mainComment.id, mainComment.author)}
                    className="ml-auto rounded-md p-1 text-muted transition-colors hover:bg-surface-soft hover:text-primary"
                    aria-label="回复"
                  >
                    <MessageCircle className="h-4 w-4" />
                  </button>
                </div>
                <div
                  className="prose-comment text-body [&_a]:text-primary [&_p]:my-1"
                  dangerouslySetInnerHTML={{ __html: renderMarkdown(mainComment.content) }}
                />
                {mainComment.time && (
                  <span className="text-xs text-muted-soft">{mainComment.time}</span>
                )}
              </div>

              {/* 回复列表（展平） */}
              {mainComment.replies && mainComment.replies.length > 0 && (
                <div className="mt-4 space-y-4">
                  {flattenReplies(mainComment).map((reply) => (
                    <div
                      key={reply.id}
                      id={`comment-${reply.id}`}
                      className={cn(
                        'ml-5 border-t border-hairline pt-4 pl-5',
                      )}
                    >
                      <div className="flex flex-col gap-2">
                        <div className="flex items-center gap-2">
                          <img
                            src={reply.avatar || defaultAvatar}
                            alt={reply.author}
                            className="h-8 w-8 rounded-full object-cover"
                          />
                          {reply.url ? (
                            <a
                              href={reply.url}
                              target="_blank"
                              rel="noopener noreferrer"
                              className="font-medium text-body-strong hover:text-primary"
                            >
                              {reply.author}
                            </a>
                          ) : (
                            <span className="font-medium text-body-strong">{reply.author}</span>
                          )}
                          {reply.replyTo && (
                            <span className="text-xs text-muted">@{reply.replyTo}</span>
                          )}
                          <button
                            type="button"
                            onClick={() => showReplyForm(reply.id, reply.author)}
                            className="ml-auto rounded-md p-1 text-muted transition-colors hover:bg-surface-soft hover:text-primary"
                            aria-label="回复"
                          >
                            <MessageCircle className="h-4 w-4" />
                          </button>
                        </div>
                        {reply.time && (
                          <span className="text-xs text-muted-soft">{reply.time}</span>
                        )}
                        <div
                          className="text-body [&_a]:text-primary [&_p]:my-1"
                          dangerouslySetInnerHTML={{ __html: renderMarkdown(reply.content) }}
                        />
                      </div>
                    </div>
                  ))}
                </div>
              )}
            </div>
          </div>
        ))}
      </div>
    </div>
  )
}
