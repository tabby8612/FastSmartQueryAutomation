import { Button } from "@/components/ui/button"
import { Separator } from "@/components/ui/separator"
import { SidebarTrigger } from "@/components/ui/sidebar"
import { Bell, BookOpen, ChevronsUpDown, HelpCircle, Search, University } from "lucide-react"
import { Input } from "../ui/input"
import { DropdownMenu, DropdownMenuContent, DropdownMenuGroup, DropdownMenuItem, DropdownMenuSeparator, DropdownMenuTrigger } from "../ui/dropdown-menu"
import { Avatar, AvatarFallback, AvatarImage } from "../ui/avatar"
import { IconDotsVerticalFilled, IconLogout, IconUserCircle } from "@tabler/icons-react"
import { useAuth } from "@/contexts/auth-context"
import { useNavigate } from "react-router-dom"
import { useState, type SubmitEventHandler } from "react"
import type { Notification } from "@/types"
import api from "@/lib/axios"
import { isAxiosError } from "axios"


export function SiteHeader() {
  const { logout, getRoleName, getUser, getAccessToken } = useAuth()
  const [searchText, setSearchText] = useState("")
  const [notifications, setNotifications] = useState<Notification[] | null>(null);
  const [loading, setLoading] = useState(false)

  const navigate = useNavigate()

  const roleName = getRoleName()

  const rolePage = roleName === "student" ? "student" : roleName === "officer" ? "officer" : roleName === "admin" ? "admin" : roleName === "hod" ? "hod" : 'student'

  const current_user = getUser()

  const access_token = getAccessToken()


  const user = {
    name: current_user ? current_user.full_name : "Anyonmous User",
    email: current_user ? current_user.email : "anyonmous@email.com",
    avatar: `${import.meta.env.VITE_API_BASE_URL}${current_user?.profile_image}`
  }

  function handleSearchFormSubmit(event: React.SubmitEvent) {
    event.preventDefault()

    if (!searchText) return;

    navigate(`/${rolePage}/search/?q=${searchText}`)

  }

  const fetchNotifications = async () => {
    if (notifications) return;


    try {
      setLoading(true)
      const response = await api.get<Notification[]>("/notifications", {
        headers: {
          Authorization: `Bearer ${access_token}`,
        },
      })
      setNotifications(response.data)

    } catch (error) {

      if (isAxiosError(error) && error.status === 408) {
        setTimeout(() => {
          navigate("/")
        }, 2000)
      }
    } finally {
      setLoading(false)
    }

  }

  return (
    <header className="bg-white flex h-(--header-height) shrink-0 items-center gap-2 border-b border-b-gray-200 transition-[width,height] ease-linear group-has-data-[collapsible=icon]/sidebar-wrapper:h-(--header-height)">
      <div className="flex w-full items-center gap-1 px-4 lg:gap-2 lg:px-6 ">
        <SidebarTrigger className="-ml-1" />
        <Separator
          orientation="vertical"
          className="mx-2 data-[orientation=vertical]:h-10"
        />
        <h1 className="text-xl font-medium w-0 opacity-0 md:w-fit md:opacity-100"><a href={`/${rolePage}/dashboard`}>FastAutoEmailClassification</a></h1>
        <DropdownMenu>
          <DropdownMenuTrigger className="">
            <ChevronsUpDown size={40} className="rounded-full py-2 px-2 text-stone-600 hover:bg-stone-300 hover:text-black transition-all delay-50 duration-200" />
          </DropdownMenuTrigger>
          <DropdownMenuContent
            className="w-(--radix-dropdown-menu-trigger-width) min-w-56 rounded-lg"
            side={"bottom"}
            align="start"
            sideOffset={1}
          >
            <DropdownMenuGroup>
              <DropdownMenuItem>
                <University />
                <a href="https://vu.edu.pk/" target="_blank">University Official Website</a>
              </DropdownMenuItem>
            </DropdownMenuGroup>
            <DropdownMenuSeparator />
            <DropdownMenuGroup>
              <DropdownMenuItem>
                <BookOpen />
                <a href="https://vulms.vu.edu.pk/" target="_blank">University LMS Website</a>
              </DropdownMenuItem>
            </DropdownMenuGroup>
            <DropdownMenuSeparator />
            <DropdownMenuGroup>
              <DropdownMenuItem onClick={() => navigate(`/${rolePage}/dashboard`)}>
                <HelpCircle />
                University Ticket Support
              </DropdownMenuItem>
            </DropdownMenuGroup>
          </DropdownMenuContent>
        </DropdownMenu>
        <div className="relative w-3/4">
          <form onSubmit={handleSearchFormSubmit}>
            <Input placeholder="search" className="pl-10 h-10" value={searchText} onChange={e => setSearchText(e.target.value)} />

          </form>
          <Search className="absolute top-2 px-1 left-1" />

        </div>

        <DropdownMenu onOpenChange={fetchNotifications}>
          <DropdownMenuTrigger className="">
            <Bell size={40} fill="black" fillOpacity={2} className="rounded-full py-2 px-2 text-stone-600 hover:bg-stone-200 hover:text-black transition-all delay-50 duration-200" />
          </DropdownMenuTrigger>
          <DropdownMenuContent
            className="w-(--radix-dropdown-menu-trigger-width) min-w-56 rounded-lg"
            side={"bottom"}
            align="center"
            sideOffset={1}
          >
            {
              notifications && (
                notifications.slice(0,5).map(notification => (
                  <DropdownMenuGroup key={notification.id}>
                    <DropdownMenuItem className="text-xs py-3 flex flex-col items-start">
                      <p>{new Intl.DateTimeFormat('en-US', {
                                dateStyle: 'long',
                                timeStyle: 'short'
                              }).format(new Date(notification.created_at))} - {notification.type.replace("_", " ").toLocaleUpperCase()}</p>
                      <p>{notification.subject.slice(0,50)}</p>
                    </DropdownMenuItem>
                    <DropdownMenuSeparator />
                  </DropdownMenuGroup>

                ))
              )
            }


          </DropdownMenuContent>
        </DropdownMenu>

        <DropdownMenu>
          <DropdownMenuTrigger className="">
            <div className="flex gap-4 justify-center items-center  w-full">
              <Avatar className="h-8 w-8 rounded-lg grayscale">
                <AvatarImage src={user.avatar} alt={user.name} />
                <AvatarFallback className="rounded-lg">CN</AvatarFallback>
              </Avatar>

            </div>
          </DropdownMenuTrigger>
          <DropdownMenuContent
            className="w-(--radix-dropdown-menu-trigger-width) min-w-56 rounded-lg"
            side={"bottom"}
            align="end"
            sideOffset={4}
          >
            <DropdownMenuGroup>
              <DropdownMenuItem onClick={() => navigate(`/${roleName === "student" ? "student" : roleName === "officer" ? "officer" : roleName === "admin" ? "admin" : roleName === "hod" ? "hod" : 'student'}/account`)}>
                <IconUserCircle />
                Account
              </DropdownMenuItem>
            </DropdownMenuGroup>
            <DropdownMenuSeparator />
            <DropdownMenuItem onClick={() => logout()}>
              <IconLogout />
              Log out
            </DropdownMenuItem>
          </DropdownMenuContent>
        </DropdownMenu>
        <div className="ml-auto flex items-center gap-2">
          <Button variant="ghost" size="sm" className="hidden sm:flex">
            <a
              href="https://github.com/tabby8612/FastSmartQueryAutomation"
              rel="noopener noreferrer"
              target="_blank"
              className="dark:text-foreground"
            >
              GitHub
            </a>
          </Button>
        </div>
      </div>
    </header>
  )
}
