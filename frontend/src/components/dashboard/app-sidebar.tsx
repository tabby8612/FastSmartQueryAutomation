"use client"

import * as React from "react"
import {
  IconDashboard,
  IconHelp,
  IconSearch,
  IconSettings,
  IconAddressBook,
  IconUser,
  IconTabs,
  IconBrandOffice
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
      title: "All Issues",
      url: "/admin/issues",
      icon: IconAddressBook,
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
            <img src="https://static.vecteezy.com/system/resources/previews/020/150/775/non_2x/email-automation-icon-design-vector.jpg" alt="email automation" className="size-52"/>
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
          name: user?.name || "User",
          email: user?.email || "user@example.com",
          avatar: "/avatars/shadcn.jpg",
        }} />
      </SidebarFooter>
    </Sidebar>
  )
}
