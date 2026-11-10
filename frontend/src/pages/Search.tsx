import { useEffect, useState, type CSSProperties } from "react"
import { data, useNavigate, useSearchParams } from "react-router-dom"
import { isAxiosError } from "axios"
import { AppSidebar } from "@/components/dashboard/app-sidebar"
import { SiteHeader } from "@/components/dashboard/site-header"
import { SidebarInset, SidebarProvider } from "@/components/ui/sidebar"
import { useAuth } from "@/contexts/auth-context"
import api from "@/lib/axios"
import { type SearchData } from "@/types"
import { Card, CardContent } from "@/components/ui/card"
import { Tabs, TabsContent, TabsList, TabsTrigger } from "@/components/ui/tabs"

function errorMessage(error: unknown) {
  if (isAxiosError(error) && typeof error.response?.data?.detail === "string") {
    return error.response.data.detail as string
  }
  return "The request failed. Please try again."
}

function formatDate(value: string | null) {
  if (!value) return ""
  const date = new Date(value)
  return Number.isNaN(date.getTime()) ? "" : date.toLocaleString()
}

export function SearchPage() {
  const { getRoleName, getAccessToken } = useAuth()
  const [searchParams, setSearchParams] = useSearchParams()
  const [searchResults, setSearchResults] = useState<SearchData | null>(null)
  const navigate = useNavigate()

  const [loading, setLoading] = useState(false)
  const [loadError, setLoadError] = useState("")


  const searchQuery = searchParams.get("q")
  const token = getAccessToken()
  const role_name = getRoleName()

  useEffect(() => {
    const controller = new AbortController()

    async function load_search() {
      setLoading(true)
      setLoadError("")
      try {
        if (!searchQuery?.trim()) return

        const searchResponse = await api.get<SearchData>(`/search/`, {
          params: {
            q: searchQuery
          },
          headers: { Authorization: `Bearer ${token}` },
          signal: controller.signal
        })

        if (controller.signal.aborted) return

        setSearchResults(searchResponse.data)
      } catch (error) {
        if (!controller.signal.aborted) setLoadError(errorMessage(error))

        if (isAxiosError(error) && error.status === 408) {
          setTimeout(() => {
            navigate("/")
          }, 2000)
        }
      } finally {
        if (!controller.signal.aborted) setLoading(false)
      }
    }

    load_search()

    return () => controller.abort()
  }, [searchQuery, token])


  return (
    <SidebarProvider style={{ "--sidebar-width": "calc(var(--spacing) * 72)", "--header-height": "calc(var(--spacing) * 16)" } as CSSProperties}>
      <AppSidebar variant="inset" roleName={role_name} />
      <SidebarInset>
        <SiteHeader />
        {
          loadError && <p className="mx-auto my-5 capitalize text-lg text-red-500">{loadError}</p>
        }
        <section className="py-2 md:py-6 bg-white mx-5 px-6 rounded-2xl flex flex-col gap-3 md:gap-5 mt-3">
          <h1 className="text-xl md:text-3xl font-bold">Search Results</h1>
          <p className="text-muted-foreground text-sm md:text-xl">
            Showing results for search term: {searchParams.get("q")}
          </p>
        </section>
        {
          !loading && (
            <section className="py-2 md:py-6 bg-white mx-5 px-6 rounded-2xl flex flex-col gap-3 md:gap-5 mt-3">
              <h1 className="text-2xl font-bold">Search Results</h1>
              {
                searchResults && (
                  <Tabs defaultValue="overview" className="">
                    <TabsList className="w-full bg-stone-100" variant="line">
                      {
                        searchResults.tabs.map(tab => {
                          const key: string = tab

                          const value: [] = searchResults.data[key as keyof typeof data]

                          return (
                            <TabsTrigger value={tab} className="capitalize hover:bg-blue-100" key={tab}>{tab} <span className="px-1 py-0.5 text-xs rounded-full bg-stone-200">{value.length}</span></TabsTrigger>
                          )
                        })
                      }
                    </TabsList>
                    <TabsContent value="announcements" >
                      <Card>
                        <CardContent>
                          {
                            searchResults.data.announcements.map(announcement => {
                              const timestamp = announcement.created_at;
                              const dateObj = new Date(timestamp);

                              const formattedDate = new Intl.DateTimeFormat('en-US', {
                                dateStyle: 'long',
                                timeStyle: 'short'
                              }).format(dateObj);

                              return (
                                <div className="not-last:border-b border-stone-200 my-7 " key={announcement.id}>
                                  <p>{formattedDate}</p>
                                  <h1 className="text-lg font-bold mt-3 capitalize" dangerouslySetInnerHTML={{ __html: announcement.title.toLocaleLowerCase().replace(searchQuery ?? "", `<span class="bg-amber-200 px-1.5 py-0.5 rounded-sm">${searchQuery}</span>`) }} />
                                  <p className="my-2 " dangerouslySetInnerHTML={{ __html: announcement.body.toLowerCase().replace(searchQuery ?? "", `<span class="bg-amber-200 px-1.5 py-0.5 rounded-sm">${searchQuery}</span>`) }} />
                                </div>
                              )
                            })
                          }

                        </CardContent>
                      </Card>

                    </TabsContent>
                    <TabsContent value="tickets" >
                      <Card>
                        <CardContent className="">
                          {
                            searchResults.data.tickets.map(ticket => {
                              const timestamp = ticket.created_at;
                              const dateObj = new Date(timestamp);

                              const formattedDate = new Intl.DateTimeFormat('en-US', {
                                dateStyle: 'long',
                                timeStyle: 'short'
                              }).format(dateObj);

                              return (
                                <div className="not-last:border-b border-stone-200 my-7 " key={ticket.id}>
                                  <p>{ticket.tracking_id} - {formattedDate}</p>
                                  <h1 className="text-lg font-bold mt-3 capitalize" dangerouslySetInnerHTML={{ __html: ticket.subject.replace(searchQuery ?? "", `<span class="bg-amber-200 px-1.5 py-0.5 rounded-sm">${searchQuery}</span>`) }} />
                                  <p className="my-2" dangerouslySetInnerHTML={{ __html: ticket.body.replace(searchQuery ?? "", `<span class="bg-amber-200 px-1.5 py-0.5 rounded-sm">${searchQuery}</span>`) }} />
                                </div>
                              )
                            })
                          }

                        </CardContent>
                      </Card>

                    </TabsContent>
                    <TabsContent value="notifications" >
                      <Card>
                        <CardContent className="">
                          {
                            searchResults.data.notifications.map(notification => {
                              const timestamp = notification.created_at;
                              const dateObj = new Date(timestamp);

                              const formattedDate = new Intl.DateTimeFormat('en-US', {
                                dateStyle: 'long',
                                timeStyle: 'short'
                              }).format(dateObj);

                              return (
                                <div className="not-last:border-b border-stone-200 my-7" key={notification.id}>
                                  <p>{formattedDate}</p>
                                  <h1 className="text-lg font-bold mt-3 capitalize" dangerouslySetInnerHTML={{ __html: notification.subject.toLocaleLowerCase().replace(searchQuery ?? "", `<span class="bg-amber-200 px-1.5 py-0.5 rounded-sm">${searchQuery}</span>`) }} />
                                  <p className="my-2" dangerouslySetInnerHTML={{ __html: notification.message_body.toLocaleLowerCase().replace(searchQuery ?? "", `<span class="bg-amber-200 px-1.5 py-0.5 rounded-sm">${searchQuery}</span>`) }} />
                                </div>
                              )
                            })
                          }

                        </CardContent>
                      </Card>

                    </TabsContent>
                  </Tabs>

                )
              }


            </section>

          )
        }

      </SidebarInset>
    </SidebarProvider>
  )



}
