"use client"

import { useEffect } from "react"
import { useAuth } from "@/contexts/auth-context"

export function ProtectedRoute({ children }: { children: React.ReactNode }) {
  const { access_token } = useAuth()
  const browser_access_token = localStorage.getItem("access_token")

  useEffect(() => {
    if (!access_token && !browser_access_token) {
      window.location.href = "/"
    }
  }, [access_token, browser_access_token])

  if (!access_token && !browser_access_token) {
    return null
  }

  return <>{children}</>
}
