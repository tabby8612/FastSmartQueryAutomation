"use client"

import * as React from "react"
import {
  IconDashboard,
  IconHelp,
  IconSearch,
  IconSettings,
  IconAddressBook
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
import { BookAlertIcon, BriefcaseBusinessIcon, NotebookPenIcon, TagsIcon, UserCircle2 } from "lucide-react"

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
      url: "#",
      icon: IconAddressBook,
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
  ],
  admin: [
    {
      title: "Dashboard",
      url: "/admin/dashboard",
      icon: IconDashboard,
    },
    {
      title: "All Issue",
      url: "/admin/issues",
      icon: IconDashboard,
    },
    {
      title: "Users",
      url: "/admin/issues",
      icon: IconDashboard,
    },
    {
      title: "Categories",
      url: "/admin/categories",
      icon: IconDashboard,
    },
    {
      title: "Department",
      url: "/admin/department",
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
