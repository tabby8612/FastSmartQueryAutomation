"use client"

import api from "@/lib/axios"
import type { User } from "@/types"
import { createContext, useCallback, useContext, useState, type ReactNode } from "react"

interface AuthContextType {
  access_token: string | null
  role_name: string | null
  user: User | null
  setAuth: (token: string, user: User) => void
  logout: () => void
  getAccessToken: () => string | null
  getRoleName: () => string | null
  getUser: () => User | null
  profile: () => Promise<User | null>
}

const AuthContext = createContext<AuthContextType | undefined>(undefined)

export function AuthProvider({ children }: { children: ReactNode }) {
  const [access_token, setAccessToken] = useState<string | null>(null)
  const [role_name, setRoleName] = useState<string | null>(null)
  const [user, setUser] = useState<User | null>(null)
  
  const getStoredUser = () => {
    const storedUser = localStorage.getItem("user")

    if (!storedUser) return null

    try {
      return JSON.parse(storedUser) as User
    } catch {
      localStorage.removeItem("user")
      return null
    }
  }

  const setAuth = useCallback((token: string, userData: User) => {
    setAccessToken(token)
    setRoleName(userData.rolename)
    setUser(userData)
    localStorage.setItem("access_token", token)
    localStorage.setItem("user", JSON.stringify(userData))
  }, [])

  const logout = useCallback(() => {
    setAccessToken(null)
    setRoleName(null)
    setUser(null)
    localStorage.removeItem("access_token")
    localStorage.removeItem("user")
  }, [])

  const getAccessToken = useCallback(() => {
    return access_token || localStorage.getItem("access_token")
  }, [access_token])

  const getRoleName = useCallback(() => {
    const roleName = user?.rolename;

    if (roleName) {
      return roleName
    }

    const active_user = getStoredUser()

    if (active_user?.rolename) {
      return active_user.rolename
    }

    return null;
  }, [user])

  const getUser = useCallback(() => {
    const active_user = user

    if (active_user) {
      return active_user
    }

    const current_user = getStoredUser()

    if (current_user) {
      return current_user
    }

    return null

  }, [user])

  const profile = useCallback(async () => {
    const accessToken = getAccessToken()

    if (!accessToken) return null 

    try {
        const response = await api.get<User>("/auth/profile", {
          "headers": {
            "Authorization": `Bearer ${accessToken}`,
            "Accept": "application/json"
          }
        })

        setAuth(accessToken, response.data)
        return response.data

      } catch (error) {
        logout()
        return null
      }


  }, [getAccessToken, logout, setAuth])

  return (
    <AuthContext.Provider value={{ access_token, role_name, user, setAuth, logout, getAccessToken, getRoleName, getUser, profile }}>
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
