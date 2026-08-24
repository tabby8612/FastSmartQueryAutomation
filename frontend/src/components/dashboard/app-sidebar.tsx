"use client"

import * as React from "react"
import {
  IconDashboard,
  IconHelp,
  IconSearch,
  IconSettings,
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

const data = {
  student: [
    {
      title: "Dashboard",
      url: "#",
      icon: IconDashboard,
    },
    {
      title: "Submit Issue",
      url: "#",
      icon: IconDashboard,
    },
    {
      title: "My Issue",
      url: "#",
      icon: IconDashboard,
    }
  ],
  officer: [
    {
      title: "Dashboard",
      url: "#",
      icon: IconDashboard,
    },
    {
      title: "Assigned Issues",
      url: "#",
      icon: IconDashboard,
    },
  ],
  admin: [
    {
      title: "Dashboard",
      url: "#",
      icon: IconDashboard,
    },
    {
      title: "All Issue",
      url: "#",
      icon: IconDashboard,
    },
    {
      title: "Users",
      url: "#",
      icon: IconDashboard,
    },
    {
      title: "Categories",
      url: "#",
      icon: IconDashboard,
    },
    {
      title: "Department",
      url: "#",
      icon: IconDashboard,
    }
  ],
}

export function AppSidebar({ roleName, ...props }: React.ComponentProps<typeof Sidebar> & { roleName?: string | null }) {
  const { user } = useAuth()
  const effectiveRole = roleName || user?.rolename || "student"
  const navItems = data[effectiveRole as keyof typeof data] || data.student

  return (
    <Sidebar collapsible="offcanvas" {...props}>
      <SidebarHeader>
        <SidebarMenu>
          <SidebarMenuItem className=" flex items-center justify-center">
            <img src="https://static.vecteezy.com/system/resources/previews/020/150/775/non_2x/email-automation-icon-design-vector.jpg" alt="email automation" className="size-52"/>
            </SidebarMenuItem>
        </SidebarMenu>
      </SidebarHeader>
      <SidebarContent>
        <NavMain items={navItems} />
      </SidebarContent>
      <SidebarFooter>
        <NavUser user={{
          name: user?.name || "User",
          email: user?.email || "user@example.com",
          avatar: "/avatars/shadcn.jpg",
        }} />
      </SidebarFooter>
    </Sidebar>
  )
}
