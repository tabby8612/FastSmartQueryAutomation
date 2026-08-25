import { AppSidebar } from "@/components/dashboard/app-sidebar"
import { SiteHeader } from "@/components/dashboard/site-header"
import { SidebarInset, SidebarProvider } from "@/components/ui/sidebar"
import { useEffect, useState } from "react"
import { useAuth } from "@/contexts/auth-context"
import api from "@/lib/axios"
import type { Department } from "@/types"
import { DepartmentDataTable } from "@/components/admin/departments-data-table"


export function Departments() {
  const { role_name, access_token } = useAuth()
  const [departments, setDepartments] = useState<Department[]>([])
  const [loading, setLoading] = useState(true)

  useEffect(() => {
    const fetchQueries = async () => {
      try {
        const response = await api.get<Department[]>("/departments", {
          headers: {
            Authorization: `Bearer ${access_token}`,
          },
        })
        setDepartments(response.data)
      } catch (error) {
        console.error("Failed to fetch queries:", error)
      } finally {
        setLoading(false)
      }
    }

    fetchQueries()
  }, [access_token])

  const allDepartments = departments

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
                <h1 className="text-3xl font-bold">All Departments</h1>
                <p className="text-muted-foreground text-xl">
                  Here is the overview of all departments
                </p>
                </div>
              <div className="py-2 mx-6 rounded-2xl pt-5 bg-white">
                <DepartmentDataTable data={allDepartments} />
              </div>
            </div>
          </div>
        </div>
      </SidebarInset>
    </SidebarProvider>
  )
}
