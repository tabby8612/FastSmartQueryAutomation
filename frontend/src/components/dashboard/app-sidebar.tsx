"use client"

import * as React from "react"
import {
  IconDashboard,
  IconHelp,
  IconAddressBook,
  IconUser,
  IconUserPlus,
  IconTabs,
  IconBrandOffice,
  IconSpeakerphone,
  IconHelicopterLanding
} from "@tabler/icons-react"

import { NavMain } from "@/components/dashboard/nav-main"
import { NavUser } from "@/components/dashboard/nav-user"
import {
  Sidebar,
  SidebarContent,
  SidebarFooter,
  SidebarHeader,
  SidebarMenu,
  SidebarMenuItem,
} from "@/components/ui/sidebar"
import { useAuth } from "@/contexts/auth-context"
import { ChartBar } from "lucide-react"

const data = {
  student: [
    {
      title: "Dashboard",
      url: "/student/dashboard",
      icon: IconDashboard,
    },
    {
      title: "Submit Issue",
      url: "/student/submit-issue",
      icon: IconHelp,
    },
    {
      title: "My Issue",
      url: "/student/my-issues",
      icon: IconAddressBook,
    },
    {
      title: "Announcements",
      url: "/students/announcements",
      icon: IconSpeakerphone,
    }
  ],
  officer: [
    {
      title: "Dashboard",
      url: "/officer/dashboard",
      icon: IconDashboard,
    },
    {
      title: "Assigned Issues",
      url: "/officer/issues",
      icon: IconAddressBook,
    },
    {
      title: "Leave & Auto Reply",
      url: "/officer/leave",
      icon: IconHelicopterLanding,
    },
  ],
  hod: [
    {
      title: "Dashboard",
      url: "/hod/dashboard",
      icon: IconDashboard,
    },
    {
      title: "Escalated Issues",
      url: "/hod/escalated-issues",
      icon: IconAddressBook,
    },
  ],
  admin: [
    {
      title: "Dashboard",
      url: "/admin/dashboard",
      icon: IconDashboard,
    },
    {
      title: "All Issues",
      url: "/admin/issues",
      icon: IconAddressBook,
    },
    {
      title: "Announcements",
      url: "/admin/announcements",
      icon: IconSpeakerphone,
    },
    {
      title: "Users",
      url: "/admin/users",
      icon: IconUser,
    },
    {
      title: "Categories",
      url: "/admin/categories",
      icon: IconTabs,
    },
    {
      title: "Department",
      url: "/admin/department",
      icon: IconBrandOffice,
    },
    {
      title: "Audit Logs",
      url: "/admin/audit-logs",
      icon: ChartBar,
    }
  ],
}

export function AppSidebar({ roleName, ...props }: React.ComponentProps<typeof Sidebar> & { roleName?: string | null }) {
  const { user } = useAuth()
  const effectiveRole = roleName || user?.rolename || null
  const navItems = data[effectiveRole as keyof typeof data]
  
  return (
    <Sidebar collapsible="offcanvas" {...props}>
      <SidebarHeader>
        <SidebarMenu>
          <SidebarMenuItem className=" flex items-center justify-center">
            <img src="https://static.vecteezy.com/system/resources/previews/020/150/775/non_2x/email-automation-icon-design-vector.jpg" alt="email automation" className="size-40"/>
            </SidebarMenuItem>
        </SidebarMenu>
      </SidebarHeader>
      <SidebarContent>
        {
          navItems && <NavMain items={navItems} />
        }
        
      </SidebarContent>
      <SidebarFooter>
        <NavUser user={{
          name: user?.name || user?.full_name || "User",
          email: user?.email || "user@example.com",
          avatar: "/avatars/shadcn.jpg",
        }} />
      </SidebarFooter>
    </Sidebar>
  )
}
