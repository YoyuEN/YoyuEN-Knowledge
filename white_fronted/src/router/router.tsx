import { createBrowserRouter, Navigate } from 'react-router-dom'
import Layout from '@/components/Layout'
import AdminLayout from '@/components/AdminLayout'
import RequireAuth from '@/router/RequireAuth'

import Home from '@/views/Home'
import Content from '@/views/Content'
import ContentDetail from '@/views/ContentDetail'
import Chat from '@/views/Chat'
import Diary from '@/views/Diary'
import Profile from '@/views/Profile'
import Login from '@/views/Login'

import Dashboard from '@/views/admin/Dashboard'
import ArticleList from '@/views/admin/ArticleList'
import CategoryList from '@/views/admin/CategoryList'
import TagList from '@/views/admin/TagList'
import CommentList from '@/views/admin/CommentList'
import PhotoList from '@/views/admin/PhotoList'
import Statistics from '@/views/admin/Statistics'
import KnowledgeList from '@/views/admin/KnowledgeList'
import DiaryList from '@/views/admin/DiaryList'
import ProfileEdit from '@/views/admin/ProfileEdit'

const router = createBrowserRouter([
  {
    path: '/login',
    element: <Login />,
  },
  {
    path: '/',
    element: <Layout />,
    children: [
      { index: true, element: <Home /> },
      { path: 'content', element: <Content /> },
      { path: 'content-detail/:type/:id', element: <ContentDetail /> },
      { path: 'chat', element: <Chat /> },
      { path: 'diary', element: <Diary /> },
      { path: 'profile', element: <Profile /> },
    ],
  },
  {
    path: '/admin',
    element: (
      <RequireAuth>
        <AdminLayout />
      </RequireAuth>
    ),
    children: [
      { index: true, element: <Navigate to="/admin/dashboard" replace /> },
      { path: 'dashboard', element: <Dashboard /> },
      { path: 'articles', element: <ArticleList /> },
      { path: 'categories', element: <CategoryList /> },
      { path: 'tags', element: <TagList /> },
      { path: 'comments', element: <CommentList /> },
      { path: 'photos', element: <PhotoList /> },
      { path: 'statistics', element: <Statistics /> },
      { path: 'knowledge', element: <KnowledgeList /> },
      { path: 'diary', element: <DiaryList /> },
      { path: 'profile', element: <ProfileEdit /> },
      // 兼容旧路径重定向
      { path: 'content', element: <Navigate to="/admin/articles" replace /> },
      { path: 'moments', element: <Navigate to="/admin/statistics" replace /> },
      { path: 'users', element: <Navigate to="/admin/comments" replace /> },
      { path: 'roles', element: <Navigate to="/admin/photos" replace /> },
      { path: 'permissions', element: <Navigate to="/admin/tags" replace /> },
    ],
  },
  { path: '*', element: <Navigate to="/" replace /> },
])

export default router
