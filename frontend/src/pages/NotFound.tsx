import { type CSSProperties } from "react"
import { SiteHeader } from "@/components/dashboard/site-header"
import { SidebarInset, SidebarProvider } from "@/components/ui/sidebar"
import { Card, CardContent, CardTitle } from "@/components/ui/card"

import { useNavigate } from "react-router-dom"
import { Button } from "@/components/ui/button"
import { IconArrowBack } from "@tabler/icons-react"



export function NotFound() {
    const navigate = useNavigate()
  

  return (
    <SidebarProvider style={{ "--sidebar-width": "calc(var(--spacing) * 60)", "--header-height": "calc(var(--spacing) * 20)" } as CSSProperties}>
      <SidebarInset>
        <SiteHeader />
        <main className="mx-auto flex max-w-7xl flex-col gap-5 p-4 md:p-8 justify-center items-center">
          <Card className="px-12 min-w-7xl mx-auto justify-center items-center">
            <CardTitle className="font-bold text-6xl">404 Not Found</CardTitle>
            <CardContent className="flex flex-col gap-5 justify-center items-center">
                <h1 className="text-foreground/50 text-3xl">Oops! the page you're looking for is not here.</h1>
                <Button className="mx-auto text-3xl px-10 py-8" size="lg" variant="default" onClick={() => navigate(-1)}> <IconArrowBack className="size-10"/> Go Back</Button>
            </CardContent>
          </Card>
        </main>
      </SidebarInset>
    </SidebarProvider>
  )
}
