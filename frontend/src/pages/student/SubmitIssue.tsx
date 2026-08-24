import { AppSidebar } from "@/components/dashboard/app-sidebar"
import { SiteHeader } from "@/components/dashboard/site-header"
import { SidebarInset, SidebarProvider } from "@/components/ui/sidebar"
import { useAuth } from "@/contexts/auth-context"
import { Button } from "@/components/ui/button"
import { Input } from "@/components/ui/input"
import { Label } from "@/components/ui/label"
import { Textarea } from "@/components/ui/textarea"


export default function SubmitIssue() {
  const { role_name } = useAuth()

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
          <div className="@container/main  flex flex-1 flex-col gap-2">
            <div className="flex flex-col justify-center items-center gap-4 rounded-2xl bg-white h-full m-5 py-4 md:gap-6 md:py-6 px-4 lg:px-6">
              <div className="w-full p-5  flex flex-col justify-center items-center gap-4">
              <h1 className="text-4xl font-bold">Submit New Issue</h1>
              <p className="text-muted-foreground">Tell us what problem you are facing</p>
              <div className="flex flex-col gap-4 w-2xl pt-10">
                <div className="flex flex-col gap-2">
                  <Label htmlFor="title">Title</Label>
                  <Input id="title" placeholder="Enter the title of your issue" />
                </div>
                <div className="flex flex-col gap-2">
                  <Label htmlFor="description">Description</Label>
                  <Textarea id="textarea-message" placeholder="Type your message here." rows={8} className="h-44" />
                </div>
                <div className="flex gap-4 mt-4 justify-end ">
                  <Button variant="outline" className="w-1/2">Cancel</Button>
                  <Button className="w-1/2">Submit New Issue</Button>
                </div>
              </div>
              </div>
            </div>
          </div>
        </div>
      </SidebarInset>
    </SidebarProvider>
  )
}
