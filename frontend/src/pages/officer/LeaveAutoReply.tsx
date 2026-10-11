import React, { useEffect, useState, type FormEvent } from "react"
import { AppSidebar } from "@/components/dashboard/app-sidebar"
import { SiteHeader } from "@/components/dashboard/site-header"
import { SidebarInset, SidebarProvider } from "@/components/ui/sidebar"
import { useAuth } from "@/contexts/auth-context"
import { Button } from "@/components/ui/button"
import { Input } from "@/components/ui/input"
import { Label } from "@/components/ui/label"
import { Textarea } from "@/components/ui/textarea"
import api from "@/lib/axios"
import { isAxiosError } from "axios"
import { useNavigate } from "react-router-dom"
import type { LeaveStatus } from "@/types"



export default function LeaveAutoReply() {
  const { role_name, access_token } = useAuth()
  const [onLeave, setOnLeave] = useState(false)
  const [startDate, setStartDate] = useState("")
  const [endDate, setEndDate] = useState("")
  const [autoReply, setAutoReply] = useState("")
  const [loading, setLoading] = useState(true)
  const [saving, setSaving] = useState(false)
  const [message, setMessage] = useState("")
  const [error, setError] = useState("")

  const navigate = useNavigate();

  useEffect(() => {
    let active = true
    api.get<LeaveStatus>("/instructor/leave", {
      headers: { Authorization: `Bearer ${access_token}` },
    }).then(({ data }) => {
      if (!active) return
      setOnLeave(data.on_leave)
      setStartDate(data.leave_start_day?.slice(0, 10) ?? "")
      setEndDate(data.leave_end_day?.slice(0, 10) ?? "")
      setAutoReply(data.auto_reply_message ?? "")
    }).catch(() => {
        setError("Unable to load analytics. Please try again.");

        if (isAxiosError(error) && error.status == 408) navigate("/")
      
    }).finally(() => {
      if (active) setLoading(false)
    })
    return () => { active = false }
  }, [access_token])

  const handleSubmit = async (event: React.SubmitEvent) => {
    event.preventDefault()
    setError("")
    setMessage("")
    setSaving(true)
    try {
      if (onLeave) {
        const { data } = await api.delete("/instructor/leave", {
          headers: { Authorization: `Bearer ${access_token}` },
        })
        setOnLeave(false)
        setMessage(data.message ?? "Leave cancelled successfully.")
      } else {
        const { data } = await api.put<LeaveStatus>("/instructor/leave", {
          start_date: startDate,
          end_date: endDate,
          auto_reply_message: autoReply,
        }, {
          headers: { Authorization: `Bearer ${access_token}` },
        })
        setOnLeave(data.is_currently_on_leave ?? true)
        setMessage("Leave set successfully.")
      }
    } catch (err: any) {
      const detail = err.response?.data?.detail
      setError(typeof detail === "string" ? detail : "Unable to update leave status. Please check your details and try again.")
    } finally {
      setSaving(false)
    }
  }

  return (
    <SidebarProvider
      style={{ "--sidebar-width": "calc(var(--spacing) * 60)", "--header-height": "calc(var(--spacing) * 16)" } as React.CSSProperties}
    >
      <AppSidebar variant="inset" roleName={role_name} />
      <SidebarInset>
        <SiteHeader />
        <main className="flex flex-1 flex-col p-5 md:p-8">
          <section className="mx-auto w-full  rounded-2xl border bg-white shadow-sm">
            <header className="border-b px-6 py-5 ">
              <h1 className="text-2xl font-bold py-2">Leave &amp; Auto-Reply</h1>
              <p className="mt-1 text-sm text-muted-foreground py-1">Manage your leave dates and automatic reply.</p>
            </header>
            <form onSubmit={handleSubmit} className="flex flex-col gap-5 p-6 w-full">
              {error && <div role="alert" className="rounded-md bg-red-50 px-3 py-2 text-sm text-red-700">{error}</div>}
              {message && <div role="status" className="rounded-md bg-green-50 px-3 py-2 text-sm text-green-700">{message}</div>}

              <div className=" flex">
                <Label>Leave status:</Label>
                <div className="flex items-center gap-2 text-sm">
                  <span className={`rounded-full ${onLeave ? "bg-green-500" : "bg-gray-400"}`} />
                  {onLeave ? "On Leave" : "Not on leave"}
                </div>
              </div>

              <div className="space-y-2">
                <Label htmlFor="leave-start">Start Date</Label>
                <Input id="leave-start" type="date" value={startDate} onChange={(event) => setStartDate(event.target.value)} required={!onLeave} disabled={onLeave || loading} />
              </div>
              <div className="space-y-2">
                <Label htmlFor="leave-end">End Date</Label>
                <Input id="leave-end" type="date" value={endDate} onChange={(event) => setEndDate(event.target.value)} min={startDate || undefined} required={!onLeave} disabled={onLeave || loading} />
              </div>
              <div className="space-y-2">
                <Label htmlFor="auto-reply">Automatic Reply</Label>
                <Textarea id="auto-reply" value={autoReply} onChange={(event) => setAutoReply(event.target.value)} placeholder="I am currently on leave..." maxLength={1000} required={!onLeave} disabled={onLeave || loading} rows={5} />
                <p className="text-xs text-muted-foreground">Up to 1000 characters.</p>
              </div>
              <Button type="submit" className="w-full sm:w-fit" disabled={loading || saving} variant={onLeave ? "destructive" : "default"}>
                {saving ? "Saving..." : onLeave ? "Cancel Leave" : "Set Leave"}
              </Button>
            </form>
          </section>
        </main>
      </SidebarInset>
    </SidebarProvider>
  )
}
