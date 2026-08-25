export interface CommentReply {
  id: string | number
  avatar?: string
  author: string
  url?: string
  content: string
  time?: string
  replyTo?: string
  replies?: CommentReply[]
}

export interface CommentItem {
  id: string | number
  avatar?: string
  author: string
  url?: string
  content: string
  time?: string
  contentId?: string | number
  contentType?: string
  replies?: CommentReply[]
}

export interface CommentTarget {
  id: string | number
  [key: string]: unknown
}
