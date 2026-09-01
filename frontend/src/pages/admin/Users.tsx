import { AppSidebar } from "@/components/dashboard/app-sidebar"
import { SiteHeader } from "@/components/dashboard/site-header"
import { SidebarInset, SidebarProvider } from "@/components/ui/sidebar"
import { useEffect, useState } from "react"
import { useNavigate } from "react-router-dom"
import { useAuth } from "@/contexts/auth-context"
import api from "@/lib/axios"
import { UsersDataTable } from "@/components/admin/users-data-table"
import type { User } from "@/types"
import { Button } from "@/components/ui/button"
import { IconUserPlus } from "@tabler/icons-react"

export function Users() {
  const { role_name, access_token } = useAuth()
  const navigate = useNavigate()
  const [users, setUsers] = useState<User[]>([])
  const [loading, setLoading] = useState(true)

  useEffect(() => {
    const fetchQueries = async () => {
      try {
        const response = await api.get<User[]>("/users", {
          headers: {
            Authorization: `Bearer ${access_token}`,
          },
        })
        setUsers(response.data)
      } catch (error) {
        console.error("Failed to fetch queries:", error)
      } finally {
        setLoading(false)
      }
    }

    fetchQueries()
  }, [access_token])

  const allUsers = users

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
                <div className="flex flex-col gap-4 md:flex-row md:items-center md:justify-between">
                  <div className="flex flex-col gap-5">
                    <h1 className="text-3xl font-bold">All Users</h1>
                    <p className="text-muted-foreground text-xl">
                      Here is the overview of all users
                    </p>
                  </div>
                  <Button onClick={() => navigate("/admin/users/create-student")}>
                    <IconUserPlus />
                    Create Student
                  </Button>
                </div>
                </div>
              <div className="py-2 mx-6 rounded-2xl pt-5 bg-white">
                {loading ? (
                  <p className="px-6 py-4 text-muted-foreground">Loading users...</p>
                ) : (
                  <UsersDataTable data={allUsers} />
                )}
              </div>
            </div>
          </div>
        </div>
      </SidebarInset>
    </SidebarProvider>
  )
}
