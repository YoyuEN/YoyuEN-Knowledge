import { createSlice, type PayloadAction } from '@reduxjs/toolkit'
import { getToken, setToken, removeToken } from '@/utils/auth'

export interface UserInfo {
  username: string
  avatar: string
  roles: string[]
}

interface AuthState {
  token: string
  userInfo: UserInfo
}

const initialState: AuthState = {
  token: getToken() || '',
  userInfo: { username: '', avatar: '', roles: [] },
}

const authSlice = createSlice({
  name: 'auth',
  initialState,
  reducers: {
    setAuthToken(state, action: PayloadAction<string>) {
      state.token = action.payload
      setToken(action.payload)
    },
    setUserInfo(state, action: PayloadAction<Partial<UserInfo>>) {
      state.userInfo = { ...state.userInfo, ...action.payload }
    },
    logout(state) {
      state.token = ''
      state.userInfo = { username: '', avatar: '', roles: [] }
      removeToken()
    },
  },
})

export const { setAuthToken, setUserInfo, logout } = authSlice.actions
export default authSlice.reducer
