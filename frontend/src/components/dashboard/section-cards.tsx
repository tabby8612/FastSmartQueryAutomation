import { IconTrendingDown, IconTrendingUp, IconUserPlus, IconUsers } from "@tabler/icons-react"

import { SectionCard } from "@/components/dashboard/section-card"

export function SectionCards() {
  return (
    <div className="grid grid-cols-1 gap-4 px-4 *:data-[slot=card]:bg-gradient-to-t *:data-[slot=card]:from-primary/5 *:data-[slot=card]:to-card *:data-[slot=card]:shadow-xs lg:px-6 @xl/main:grid-cols-2 @5xl/main:grid-cols-4 dark:*:data-[slot=card]:bg-card">
      <SectionCard
        title="Total Revenue"
        value="$1,250.00"
        description="Trending up this month"
        icon={IconTrendingUp}
        trend={{ value: "+12.5%", direction: "up" }}
      />
      <SectionCard
        title="New Customers"
        value="1,234"
        description="Down 20% this period"
        icon={IconTrendingDown}
        trend={{ value: "-20%", direction: "down" }}
      />
      <SectionCard
        title="Active Accounts"
        value="45,678"
        description="Strong user retention"
        icon={IconUsers}
        trend={{ value: "+12.5%", direction: "up" }}
      />
      <SectionCard
        title="Growth Rate"
        value="4.5%"
        description="Meets growth projections"
        icon={IconTrendingUp}
        trend={{ value: "+4.5%", direction: "up" }}
      />
    </div>
  )
}
