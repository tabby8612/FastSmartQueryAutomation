import { AppSidebar } from "@/components/dashboard/app-sidebar"
import { DataTable, type Query } from "@/components/dashboard/data-table"
import { SiteHeader } from "@/components/dashboard/site-header"
import { SidebarInset, SidebarProvider } from "@/components/ui/sidebar"
import { useEffect, useState } from "react"
import { useAuth } from "@/contexts/auth-context"
import api from "@/lib/axios"
import { StudentDataTable } from "@/components/student/student-data-table"

export function MyIssues() {
  const { role_name, access_token, user } = useAuth()
  const [queries, setQueries] = useState<Query[]>([])
  const [loading, setLoading] = useState(true)

  useEffect(() => {
    const fetchQueries = async () => {
      try {
        const response = await api.get<Query[]>("/tickets", {
          headers: {
            Authorization: `Bearer ${access_token}`,
          },
        })
        setQueries(response.data)
      } catch (error) {
        console.error("Failed to fetch queries:", error)
      } finally {
        setLoading(false)
      }
    }

    fetchQueries()
  }, [])

  return (
    <SidebarProvider
      style={{
        "--sidebar-width": "calc(var(--spacing) * 72)",
        "--header-height": "calc(var(--spacing) * 16)",
      } as React.CSSProperties}
    >
      <AppSidebar variant="inset" roleName={role_name} />
      <SidebarInset>
        <SiteHeader />
        <div className="flex flex-1 flex-col">
          <div className="@container/main flex flex-1 flex-col gap-2">
            <div className="flex flex-col gap-4 py-4 md:gap-6 md:py-6">
              <div className="md:py-6 bg-white mx-5 px-6 rounded-2xl flex flex-col gap-5">
                <h1 className="text-3xl font-bold">My Issues</h1>
                <p className="text-muted-foreground text-xl">
                  Here is the overview of issues you have created
                </p>
                </div>
              <div className="py-2 mx-6 rounded-2xl pt-5 bg-white">
                <StudentDataTable data={queries} />
              </div>
            </div>
          </div>
        </div>
      </SidebarInset>
    </SidebarProvider>
  )
}
