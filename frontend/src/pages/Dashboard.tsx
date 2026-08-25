import { AppSidebar } from "@/components/dashboard/app-sidebar"
import { DataTable, type Query } from "@/components/dashboard/data-table"
import { SectionCard } from "@/components/dashboard/section-card"
import { SiteHeader } from "@/components/dashboard/site-header"
import {
  SidebarInset,
  SidebarProvider,
} from "@/components/ui/sidebar"
import { useAuth } from "@/contexts/auth-context"
import { BookOpenCheck, BookOpenIcon, Hash, Loader } from "lucide-react"
import { useEffect, useState } from "react"
import api from "@/lib/axios"
import { ChartAreaInteractive } from "@/components/dashboard/chart-area-interactive"


export default function Page() {
  const { role_name, access_token, user } = useAuth()
  const [tickets, setTickets] = useState<Query[]>([])
  const [loading, setLoading] = useState(true)

  useEffect(() => {
    const fetchTicket = async () => {
      try {
        const response = await api.get<Query[]>("/tickets", {
          headers: {
            Authorization: `Bearer ${access_token}`,
          },
        })
        setTickets(response.data)
      } catch (error) {
        console.error("Failed to fetch tickets:", error)
      } finally {
        setLoading(false)
      }
    }

    fetchTicket()
  }, [access_token])


  const openCount = tickets.filter((q) => q.status.toLowerCase() === "open").length
  const closeCount = tickets.filter((q) => q.status.toLowerCase() === "closed").length
  const inProgressCount = tickets.filter((q) => q.status.toLowerCase() === "in_progress").length
  const totalCount = tickets.length


  return (
    <SidebarProvider
      style={
        {
          "--sidebar-width": "calc(var(--spacing) * 72)",
          "--header-height": "calc(var(--spacing) * 16)",
        } as React.CSSProperties
      }
    >
      <AppSidebar variant="inset" roleName={role_name} />
      <SidebarInset>
        <SiteHeader />
        <div className="flex flex-1 flex-col">
          <div className="@container/main flex flex-1 flex-col gap-2">
            <div className="flex flex-col gap-4 py-4 md:gap-6 md:py-6">
              <div className="md:py-6 bg-white mx-5 px-6 rounded-2xl flex flex-col gap-5">
                <h1 className="text-3xl font-bold">Hello, {user?.name ? user.name : "Anyonmous"}</h1>
                {
                  role_name === "student" && <h1 className="text-xl font-bold text-muted-foreground">Here is the overview of tickets you have created</h1>
                }
                {
                  role_name === "officer" && <h1 className="text-xl font-bold text-muted-foreground">Here is the overview of tickets assigned to you</h1>
                }
                {
                  role_name === "admin" && <h1 className="text-xl font-bold text-muted-foreground">Here is the overview of all tickets</h1>
                }
                <div className="grid grid-cols-4 gap-5">
                  {loading ? (
                    <>
                      <SectionCard title="Open" value="—" description="Loading..." icon={BookOpenIcon} />
                      <SectionCard title="Closed" value="—" description="Loading..." icon={Loader} />
                      <SectionCard title="In Progress" value="—" description="Loading..." icon={BookOpenCheck} />
                      <SectionCard title="Total" value="—" description="Loading..." icon={Hash} />
                    </>
                  ) : (
                    <>
                      <SectionCard title="Open" value={String(openCount)} description="These are tickets that are opened" icon={BookOpenIcon} />
                      <SectionCard title="In Progress" value={String(closeCount)} description="These are tickets that are pending" icon={Loader} />
                      <SectionCard title="Closed" value={String(inProgressCount)} description="These are tickets that are closed" icon={BookOpenCheck} />
                      <SectionCard title="Total" value={String(totalCount)} description="These are total tickets" icon={Hash} />
                    </>
                  )}
                </div>
                <div className="px-4 lg:px-6">
                  {/* <ChartAreaInteractive /> */}
                </div>
              </div>
              <div className="py-2 mx-6 rounded-2xl pt-5 bg-white">
                <DataTable data={tickets} />
              </div>
            </div>
          </div>
        </div>
      </SidebarInset>
    </SidebarProvider>
  )
}
