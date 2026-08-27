"use client"

import { createContext, useContext, useState, type ReactNode } from "react"

interface User {
  id: number
  name: string
  email: string
  department: { id: number; name: string }
  roles: Array<{ id: number; name: string }>
  rolename: string | null
}

interface AuthContextType {
  access_token: string | null
  role_name: string | null
  user: User | null
  setAuth: (token: string, user: User) => void
  logout: () => void
  getAccessToken: () => string | null
  getRoleName: () => string | null
  getUser: () => User | null
}

const AuthContext = createContext<AuthContextType | undefined>(undefined)

export function AuthProvider({ children }: { children: ReactNode }) {
  const [access_token, setAccessToken] = useState<string | null>(null)
  const [role_name, setRoleName] = useState<string | null>(null)
  const [user, setUser] = useState<User | null>(null)

  const setAuth = (token: string, userData: User) => {
    setAccessToken(token)
    setRoleName(userData.rolename)
    setUser(userData)
    localStorage.setItem("access_token", token)
    localStorage.setItem("user", JSON.stringify(userData))
  }

  const logout = () => {
    setAccessToken(null)
    setRoleName(null)
    setUser(null)
    localStorage.removeItem("access_token")
    localStorage.removeItem("user")
  }

  const getAccessToken = () => {
    return access_token || localStorage.getItem("access_token")
  }

  const getRoleName = () => {
    const roleName = user?.rolename;

    if (roleName) {
      return roleName
    }

    const active_user : User = JSON.parse(localStorage.getItem("user") || "")

    if (active_user?.rolename) {
      return active_user.rolename
    }

    return null;
  }

  const getUser = () => {
    const active_user = user

    if (active_user) {
      return active_user
    }

    const current_user : User = JSON.parse(localStorage.getItem("user") || "")

    if (current_user) {
      return current_user
    }

    return null

  }

  return (
    <AuthContext.Provider value={{ access_token, role_name, user, setAuth, logout, getAccessToken, getRoleName, getUser }}>
      {children}
    </AuthContext.Provider>
  )
}

export function useAuth() {
  const context = useContext(AuthContext)
  if (context === undefined) {
    throw new Error("useAuth must be used within an AuthProvider")
  }
  return context
}
