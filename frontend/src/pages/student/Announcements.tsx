import { useEffect, useState, type CSSProperties } from "react"
import { AppSidebar } from "@/components/dashboard/app-sidebar"
import { SiteHeader } from "@/components/dashboard/site-header"
import { SidebarInset, SidebarProvider } from "@/components/ui/sidebar"
import { Button } from "@/components/ui/button"
import { useAuth } from "@/contexts/auth-context"
import api from "@/lib/axios"
import type { Announcement } from "@/types"

export function StudentAnnouncements() {
    const { access_token } = useAuth()
    const [announcements, setAnnouncements] = useState<Announcement[]>([])
    const [loading, setLoading] = useState(true)
    const [error, setError] = useState("")
    const [retry, setRetry] = useState(0)

    useEffect(() => {
        const controller = new AbortController()
        async function fetchAnnouncements() {
            setLoading(true)
            setError("")
            try {
                const response = await api.get<Announcement[]>("/student/announcements", {
                    headers: { Authorization: `Bearer ${access_token}` },
                    signal: controller.signal,
                })
                if (!controller.signal.aborted) setAnnouncements(response.data)
            } catch {
                if (!controller.signal.aborted) setError("Failed to load announcements. Please try again.")
            } finally {
                if (!controller.signal.aborted) setLoading(false)
            }
        }
        void fetchAnnouncements()
        return () => controller.abort()
    }, [access_token, retry])

    return (
        <SidebarProvider style={{ "--sidebar-width": "calc(var(--spacing) * 72)", "--header-height": "calc(var(--spacing) * 16)" } as CSSProperties}>
            <AppSidebar variant="inset" roleName="student" />
            <SidebarInset>
                <SiteHeader />
                <div className="m-5 flex flex-col gap-5">
                    <header className="rounded-xl bg-white p-5">
                        <h1 className="text-3xl font-bold">Announcements</h1>
                        <p className="mt-3 text-muted-foreground">Updates for all students and your department.</p>
                    </header>
                    {loading ? <p role="status" className="p-5">Loading announcements...</p> : error ? (
                        <div role="alert" className="rounded-xl bg-white p-5">
                            <p className="mb-3 text-red-600">{error}</p>
                            <Button onClick={() => setRetry(value => value + 1)}>Try again</Button>
                        </div>
                    ) : announcements.length === 0 ? (
                        <p className="rounded-xl bg-white p-5">No announcements yet.</p>
                    ) : announcements.map(announcement => (
                        <article key={announcement.id} className="rounded-xl bg-white p-5">
                            <h2 className="break-words text-xl font-semibold">{announcement.title}</h2>
                            <div className="mt-2 flex flex-wrap gap-x-4 gap-y-1 text-sm text-muted-foreground">
                                <span>{announcement.audience_type === "all" ? "All students" : announcement.department?.name ?? "Your department"}</span>
                                <time dateTime={announcement.created_at}>{new Date(announcement.created_at).toLocaleDateString(undefined, { dateStyle: "medium" })}</time>
                                <span>{announcement.creator?.full_name}</span>
                            </div>
                            <p className="mt-4 whitespace-pre-wrap break-words">{announcement.body}</p>
                        </article>
                    ))}
                </div>
            </SidebarInset>
        </SidebarProvider>
    )
}
