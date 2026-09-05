import { useEffect, useRef, useState, type CSSProperties } from "react"
import { Link, useParams } from "react-router-dom"
import { isAxiosError } from "axios"
import { ArrowLeft, Loader2, Save, Send, Sparkles } from "lucide-react"
import { AppSidebar } from "@/components/dashboard/app-sidebar"
import { SiteHeader } from "@/components/dashboard/site-header"
import { SidebarInset, SidebarProvider } from "@/components/ui/sidebar"
import { Button } from "@/components/ui/button"
import { Badge } from "@/components/ui/badge"
import { Textarea } from "@/components/ui/textarea"
import { useAuth } from "@/contexts/auth-context"
import api from "@/lib/axios"
import type { Reply, Ticket } from "@/types"

function errorMessage(error: unknown) {
  if (isAxiosError(error) && typeof error.response?.data?.detail === "string") {
    return error.response.data.detail as string
  }
  return "The request failed. Please try again."
}

function formatDate(value: string | null) {
  if (!value) return ""
  const date = new Date(value)
  return Number.isNaN(date.getTime()) ? "" : date.toLocaleString()
}

export function StudentTicketDetail() {
  const { ticketId } = useParams()
  // Reset editor and request state when navigating between tickets.
  return <TicketDetailContent key={ticketId} ticketId={ticketId ?? ""} />
}

function TicketDetailContent({ ticketId }: { ticketId: string }) {
  const { getAccessToken, getRoleName } = useAuth()
  const token = getAccessToken()
  const [ticket, setTicket] = useState<Ticket | null>(null)
  const [replies, setReplies] = useState<Reply[]>([])
  const [draft, setDraft] = useState<Reply | null>(null)
  const [text, setText] = useState("")
  const [loading, setLoading] = useState(true)
  const [loadError, setLoadError] = useState("")
  const [error, setError] = useState("")
  const [notice, setNotice] = useState("")
  const [attempt, setAttempt] = useState(0)
  const [action, setAction] = useState<"generate" | "save" | "send" | null>(null)
  const pending = useRef(false)
  const busy = action !== null
  const dirty = text !== (draft?.text ?? "")
  const headers = { Authorization: `Bearer ${token}` }

  useEffect(() => {
    const controller = new AbortController()
    async function load() {
      setLoading(true)
      setLoadError("")
      try {
        if (!/^\d+$/.test(ticketId)) throw new Error("Invalid ticket ID")
        const config = { headers: { Authorization: `Bearer ${token}` }, signal: controller.signal }
        const [ticketResponse, repliesResponse] = await Promise.all([
          api.get<Ticket>(`/tickets/${ticketId}`, config),
          api.get<Reply[]>(`/tickets/${ticketId}/replies/`, config),
        ])
        if (controller.signal.aborted) return
        setTicket(ticketResponse.data)
        setReplies(repliesResponse.data)
        const savedDraft = repliesResponse.data.filter(reply => reply.status === "draft").at(-1) ?? null
        setDraft(savedDraft)
        setText(savedDraft?.text ?? "")
      } catch (error) {
        if (!controller.signal.aborted) setLoadError(errorMessage(error))
      } finally {
        if (!controller.signal.aborted) setLoading(false)
      }
    }
    void load()
    return () => controller.abort()
  }, [ticketId, token, attempt])

  function remember(reply: Reply) {
    setReplies(previous => [...previous.filter(item => item.id !== reply.id), reply].sort((a, b) => a.id - b.id))
    setDraft(reply.status === "draft" ? reply : null)
    setText(reply.status === "draft" ? reply.text : "")
  }

  async function perform(nextAction: "generate" | "save" | "send") {
    if (pending.current || !ticket) return
    if (nextAction === "generate" && (dirty || draft)) return
    if (nextAction !== "generate" && !text.trim()) return
    pending.current = true
    setAction(nextAction)
    setError("")
    setNotice("")
    try {
      if (nextAction === "generate") {
        const response = await api.post<Reply>(`/tickets/${ticketId}/replies/ai-draft`, null, { headers })
        remember(response.data)
        setNotice("AI draft created. Review and edit it before sending.")
      } else {
        let saved = draft
        if (!saved || dirty) {
          const response = saved
            ? await api.put<Reply>(`/tickets/${ticketId}/replies/${saved.id}`, { text }, { headers })
            : await api.post<Reply>(`/tickets/${ticketId}/replies/`, { text }, { headers })
          saved = response.data
          remember(saved)
        }
        if (nextAction === "send") {
          const response = await api.post<Reply>(`/replies/${saved.id}/send`, null, { headers })
          remember(response.data)
          setNotice("Reply sent successfully.")
        } else {
          setNotice("Draft saved.")
        }
      }
    } catch (error) {
      setError(errorMessage(error))
    } finally {
      pending.current = false
      setAction(null)
    }
  }

  const priority = ["LOW", "MEDIUM", "HIGH"][ticket?.escalation_level ?? 0] ?? "LOW"
  const drafts = replies.filter(reply => reply.status === "draft")

  return (
    <SidebarProvider style={{ "--sidebar-width": "calc(var(--spacing) * 72)", "--header-height": "calc(var(--spacing) * 16)" } as CSSProperties}>
      <AppSidebar variant="inset" roleName={getRoleName()} />
      <SidebarInset>
        <SiteHeader />
        <main className="mx-auto flex w-full max-w-5xl flex-col gap-5 p-4 md:p-8">
          <Link to={`/student/my-issues`} className="flex items-center gap-2 text-sm text-muted-foreground hover:text-foreground"><ArrowLeft className="size-4" /> Back to issues</Link>
          {loading ? (
            <div role="status" className="flex items-center justify-center gap-3 rounded-xl border bg-card p-16"><Loader2 className="size-5 animate-spin" /> Loading ticket and conversation…</div>
          ) : loadError ? (
            <div role="alert" className="space-y-4 rounded-xl border bg-card p-6"><p>{loadError}</p><Button onClick={() => setAttempt(value => value + 1)}>Retry</Button></div>
          ) : ticket && (
            <article className="overflow-hidden rounded-2xl border bg-card shadow-sm">
              <header className="space-y-4 border-b p-6">
                <div className="flex flex-wrap items-center justify-between gap-3">
                  <p className="font-medium text-muted-foreground">Ticket #{ticket.tracking_id}</p>
                  <div className="flex gap-2"><Badge variant="outline" className="capitalize">{ticket.status}</Badge><Badge className={priority === "HIGH" ? "bg-red-100 text-red-800" : priority === "MEDIUM" ? "bg-amber-100 text-amber-800" : "bg-green-100 text-green-800"}>{priority}</Badge></div>
                </div>
                <h1 className="break-words text-2xl font-semibold md:text-3xl capitalize">{ticket.subject}</h1>
              </header>
              <section className="space-y-6 border-b p-6" aria-label="Ticket details">
                <dl className="grid gap-4 text-sm sm:grid-cols-3">
                  <div><dt className="text-muted-foreground">Student</dt><dd className="mt-1 font-medium">{ticket.student?.full_name ?? "Unknown student"}</dd></div>
                  <div><dt className="text-muted-foreground">Category</dt><dd className="mt-1 font-medium capitalize">{ticket.category?.name ?? "Uncategorized"}</dd></div>
                  <div><dt className="text-muted-foreground">Department</dt><dd className="mt-1 font-medium capitalize">{ticket.department?.name ?? "Unassigned"}</dd></div>
                  <div><dt className="text-muted-foreground">Channel</dt><dd className="mt-1 font-medium capitalize">{ticket.channel}</dd></div>
                  <div><dt className="text-muted-foreground">Status</dt><dd className="mt-1 font-medium capitalize">{ticket.status}</dd></div>
                  <div><dt className="text-muted-foreground">Priority</dt><dd className="mt-1 font-medium capitalize">{priority}</dd></div>
                  <div><dt className="text-muted-foreground">Awaiting Student Input</dt><dd className="mt-1 font-medium capitalize">{ticket.awaiting_student_input ? 'Yes' : 'No'}</dd></div>
                  <div><dt className="text-muted-foreground">Assign To</dt><dd className="mt-1 font-medium capitalize">{ticket.assigned?.full_name ?? "-"}</dd></div>
                </dl>
                <div className="text-sm">
                  <p className="text-muted-foreground">Ticket Query</p>
                  <p className="whitespace-pre-wrap break-words text-sm leading-7">{ticket.body}</p>
                </div>
              </section>
              <section className="space-y-4 border-b p-6" aria-labelledby="conversation-heading">
                <h2 id="conversation-heading" className="text-lg font-semibold">Conversation</h2>
                <div className="mr-4 space-y-2 rounded-xl bg-muted p-4 sm:mr-12">
                  <p className="text-sm font-semibold">Student · {ticket.student?.full_name ?? "Unknown"}</p>
                  <p className="whitespace-pre-wrap break-words text-sm leading-6">{ticket.body}</p>
                  <p className="text-xs text-muted-foreground">{formatDate(ticket.created_at)}</p>
                </div>
                {replies.filter(reply => reply.status === "sent").map(reply => (
                  <div key={reply.id} className={`${reply.creator?.is_officer ? "ml-4 sm:ml-12 bg-primary/5" : "mr-4 sm:mr-12 bg-muted"} space-y-2 rounded-xl border p-4`}>
                    <p className="text-sm font-semibold">{reply.creator?.is_officer ? "Officer" : reply.creator?.is_admin ? "Admin" : "Student"} <span className="font-normal text-muted-foreground">· Sent</span></p>
                    <p className="whitespace-pre-wrap break-words text-sm leading-6">{reply.text}</p>
                    <p className="text-xs text-muted-foreground">{formatDate(reply.send_at)}</p>
                  </div>
                ))}
              </section>
              <section className="space-y-4 p-6" aria-labelledby="reply-heading" aria-busy={busy}>
                <h2 id="reply-heading" className="text-lg font-semibold">Reply</h2>
                {drafts.length > 0 && <div className="space-y-2"><label htmlFor="saved-draft" className="text-sm font-medium">Saved drafts</label><select id="saved-draft" className="w-full rounded-lg border bg-background p-2 text-sm" disabled={busy || dirty} value={draft?.id ?? ""} onChange={event => { const selected = drafts.find(reply => reply.id === Number(event.target.value)); if (selected) { setDraft(selected); setText(selected.text); setError(""); setNotice("") } }}><option value="" disabled>Select a draft</option>{drafts.map(reply => <option key={reply.id} value={reply.id}>Draft #{reply.id} · {formatDate(reply.created_at)}</option>)}</select></div>}
                
                <p className="text-sm text-muted-foreground">{action === "generate" ? "This may take a little while. Please wait while your draft is generated." : draft ? "Review your saved draft and edit it before sending." : "Generate a draft or write your own reply below."}</p>
                <label htmlFor="reply-text" className="sr-only">Reply text</label>
                <Textarea id="reply-text" value={text} onChange={event => setText(event.target.value)} disabled={busy} placeholder="Hello Sir,…" className="min-h-64 p-4 leading-7" />
                {error && <p role="alert" className="text-sm text-destructive">{error}</p>}
                <p role="status" className="text-sm text-muted-foreground">{busy ? (action === "save" ? "Saving draft…" : action === "send" ? "Saving changes and sending reply…" : "Generating draft…") : notice || (dirty ? "Unsaved changes" : "")}</p>
                <div className="flex flex-wrap justify-end gap-3">
                  <Button variant="outline" disabled={busy || !text.trim() || (!!draft && !dirty)} onClick={() => void perform("save")}>{action === "save" ? <Loader2 className="animate-spin" /> : <Save />}{action === "save" ? "Saving…" : "Save Draft"}</Button>
                  <Button disabled={busy || !text.trim()} onClick={() => void perform("send")}>{action === "send" ? <Loader2 className="animate-spin" /> : <Send />}{action === "send" ? "Sending…" : "Send Reply"}</Button>
                </div>
              </section>
            </article>
          )}
        </main>
      </SidebarInset>
    </SidebarProvider>
  )
}
