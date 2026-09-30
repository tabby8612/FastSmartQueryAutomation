import { useEffect, useState, type CSSProperties } from "react";
import { AppSidebar } from "@/components/dashboard/app-sidebar";
import { SiteHeader } from "@/components/dashboard/site-header";
import { SidebarInset, SidebarProvider } from "@/components/ui/sidebar";
import { AnnouncementDataTable } from "@/components/announcement-table";
import { type Announcement } from "@/types";
import api from "@/lib/axios";
import { useAuth } from "@/contexts/auth-context";
import { isAxiosError } from "axios";
import { useNavigate } from "react-router-dom";
import { Button } from "@/components/ui/button";

export function Announcement() {
    const [announcements, setAnnouncements] = useState<Announcement[] | null>(null)
    const [loading, setLoading] = useState(false)
    const [error, setError] = useState("")

    const { access_token } = useAuth()

    const navigate = useNavigate()


    useEffect(() => {
        const fetchAnnouncements = async () => {
            setLoading(true)
            setError("")

            try {
                const response = await api.get<Announcement[]>("/admin/announcements", {
                    headers: {
                        Authorization: `Bearer ${access_token}`
                    }
                })

                setAnnouncements(response.data)

            } catch (error) {
                if (isAxiosError(error) && error.status == 403) {
                    navigate("/")
                }

                setError(`Failed to fetch announcements: ${error}`)
            } finally {
                setLoading(false)
            }
        }

        fetchAnnouncements()

    }, [access_token])


    return <SidebarProvider style={{ "--sidebar-width": "calc(var(--spacing) * 72)", "--header-height": "calc(var(--spacing) * 16)" } as CSSProperties}>
        <AppSidebar variant="inset" roleName="admin" />
        <SidebarInset>
            <SiteHeader />
            <main className="bg-white m-5 p-5 rounded-xl flex justify-between items-center">
                <div>
                    <h1 className="text-3xl font-bold">Announcements</h1>
                    <h2 className="text-xl text-muted-foreground mt-5">Here is a list of announcements</h2>
                </div>
                <div>
                    <Button onClick={() => navigate("/admin/announcements/create")}>Create New Announcement</Button>
                </div>
            </main>
            <main className="bg-white m-5 pt-10 p-2 rounded-xl ">
                <p>{error}</p>
                {
                    !loading && <AnnouncementDataTable data={announcements ? announcements : []} />
                }
            </main>
        </SidebarInset>
    </SidebarProvider>;
}
