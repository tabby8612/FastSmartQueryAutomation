"use client"

import { useEffect } from "react"
import { useAuth } from "@/contexts/auth-context"
import api from "@/lib/axios"
import { useNavigate } from "react-router-dom"

export function ProtectedRoute({ children }: { children: React.ReactNode }) {
  const { access_token, setAuth } = useAuth()
  const browser_access_token = localStorage.getItem("access_token")
  const nevigate = useNavigate()

  useEffect(() => {
    async function fetchProfile(accessToken: string) {
      try {
        const response = await api.get("/auth/profile", {
          "headers": {
            "Authorization": `Bearer ${accessToken}`,
            "Accept": "application/json"
          }
        })

        setAuth(accessToken, response.data)

      } catch (error) {
        nevigate('/')
      }


      
    }

    if (!access_token && !browser_access_token) {
      window.location.href = "/"
    }

    if (!access_token && browser_access_token) {
      fetchProfile(browser_access_token)
    }


  }, [access_token, browser_access_token])

  if (!access_token && !browser_access_token) {
    return null
  }

  return <>{children}</>
}
