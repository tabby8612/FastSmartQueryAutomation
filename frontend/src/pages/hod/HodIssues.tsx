import { AppSidebar } from "@/components/dashboard/app-sidebar"
import { SiteHeader } from "@/components/dashboard/site-header"
import { SidebarInset, SidebarProvider } from "@/components/ui/sidebar"
import { useEffect, useState } from "react"
import { useAuth } from "@/contexts/auth-context"
import api from "@/lib/axios"
import { DataTable } from "@/components/dashboard/data-table"
import type { Ticket } from "@/types"
import { Card, CardContent, CardHeader } from "@/components/ui/card"
import { Button } from "@/components/ui/button"
import { exportToExcel, exportToPDF } from "@/services/export_service"
import { IconFileExcel, IconPdf } from "@tabler/icons-react"
import { toast } from "sonner"

export function HodIssues() {
  const { role_name, access_token } = useAuth()
  const [queries, setQueries] = useState<Ticket[]>([])
  const [loading, setLoading] = useState(true)

  useEffect(() => {
    const fetchQueries = async () => {
      try {
        const response = await api.get<Ticket[]>("/hod/tickets/escalated", {
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
  }, [access_token])

  const tickets = queries

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
                <h1 className="text-3xl font-bold">Escalated Issues</h1>
                <p className="text-muted-foreground text-xl">
                  Here is the overview of Escalated Issues
                </p>
                </div>
              {
          tickets && (
            <Card className="md:py-6 bg-white mx-5 px-6">
              <CardHeader><h1 className="text-2xl font-bold">Export Report</h1><p className="text-muted-foreground">Choose the correct option to download the filtered report.</p></CardHeader>
              <CardContent>
                <h1 className="text-2xl font-bold mt-2">Number of Filtered Tickets: <span className="text-4xl text-primary">{tickets?.length}</span></h1>
                <div className="mt-7 flex gap-3">
                  <Button className="w-1/2 h-10" onClick={() => {
                    if (tickets.length < 1) {
                      toast.error("No data available to export", {
                        richColors: true,
                        position: "top-center"
                      })
                    } else {
                      exportToExcel(tickets)
                    }
                  }}><IconFileExcel />Export to XLSX</Button>
                  <Button className="w-1/2 h-10" onClick={() => {
                    if (tickets.length < 1) {
                      toast.error("No data available to export", {
                        richColors: true,
                        position: "top-center"
                      })
                    } else {
                      exportToPDF(tickets)
                    }
                  }}><IconPdf />Export to PDF</Button>
                </div>
              </CardContent>
            </Card>
          )
        }
              <div className="py-2 mx-6 rounded-2xl pt-5 bg-white">
                {/* <OfficerDataTable data={myQueries} /> */}
                <DataTable data={tickets} />
              </div>
            </div>
          </div>
        </div>
      </SidebarInset>
    </SidebarProvider>
  )
}
