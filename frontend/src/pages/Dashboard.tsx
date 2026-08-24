import { AppSidebar } from "@/components/dashboard/app-sidebar"
import { ChartAreaInteractive } from "@/components/dashboard/chart-area-interactive"
import { DataTable } from "@/components/dashboard/data-table"
import { SectionCard } from "@/components/dashboard/section-card"
import { SectionCards } from "@/components/dashboard/section-cards"
import { SiteHeader } from "@/components/dashboard/site-header"
import {
  SidebarInset,
  SidebarProvider,
} from "@/components/ui/sidebar"
import { useAuth } from "@/contexts/auth-context"
import data from "@/data/sample"
import { BookOpenCheck, BookOpenIcon, Hash } from "lucide-react"


export default function Page() {
  const { role_name, access_token } = useAuth()

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
                <h1 className="text-3xl font-bold">Hello, Tabish</h1>
                <h1 className="text-xl font-bold text-muted-foreground">Here is the overview of issues</h1>
                <div className="grid grid-cols-3 gap-7">
                  <SectionCard title="Open" value="12" description="These are issuses that are opened" icon={BookOpenIcon} />
                  <SectionCard title="Closed" value="5" description="These are issuses that are closed" icon={BookOpenCheck} />
                  <SectionCard title="Total" value="17" description="These are total issuses" icon={Hash} />
                  {/* <SectionCard title="Open" value="12" description="These are issuses that are opened" icon={BookOpenIcon}/> */}
                  {/* <SectionCard title="Open" value="12" description="These are issuses that are opened" icon={BookOpenIcon}/> */}
                  {/* <SectionCard />
                <SectionCard /> */}
                </div>
              </div>
              {/* <div className="px-4 lg:px-6">
                <ChartAreaInteractive />
              </div> */}
              <div className="py-2 mx-6 rounded-2xl pt-5 bg-white">
                <DataTable data={data} />
              </div>
            </div>
          </div>
        </div>
      </SidebarInset>
    </SidebarProvider>
  )
}
