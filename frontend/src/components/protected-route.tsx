"use client"

import { useEffect, useState } from "react"
import { useAuth } from "@/contexts/auth-context"
import { useNavigate } from "react-router-dom"

export function ProtectedRoute({ children }: { children: React.ReactNode }) {
  const { profile } = useAuth()
  const navigate = useNavigate()
  const [checkingProfile, setCheckingProfile] = useState(true)

  useEffect(() => {
    let isMounted = true

    async function verifyProfile() {
      const currentUser = await profile()

      if (!isMounted) return

      if (!currentUser) {
        navigate("/", { replace: true })
        return
      }

      setCheckingProfile(false)
    }

    verifyProfile()

    return () => {
      isMounted = false
    }
  }, [navigate, profile])

  if (checkingProfile) {
    return null
  }

  return <>{children}</>
}
