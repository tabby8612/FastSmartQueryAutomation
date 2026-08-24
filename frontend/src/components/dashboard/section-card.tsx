import { type LucideIcon } from "lucide-react"

import { Badge } from "@/components/ui/badge"
import {
  Card,
  CardAction,
  CardDescription,
  CardFooter,
  CardHeader,
  CardTitle,
} from "@/components/ui/card"
import { cn } from "@/lib/utils"

interface SectionCardProps {
  title: string
  value: string
  description: string
  icon: LucideIcon
  trend?: {
    value: string
    direction: "up" | "down" | "neutral"
  }
  className?: string
}

export function SectionCard({
  title,
  value,
  description,
  icon: Icon,
  trend,
  className,
}: SectionCardProps) {
  return (
    <Card
      className={cn(
        "from-primary/5 to-card shadow-xs transition hover:shadow-md hover:bg-muted",
        className
      )}
    >
        
      <CardHeader>
        <CardDescription className="text-2xl font-bold">{title}</CardDescription>
        <CardTitle className="text-4xl font-semibold tabular-nums @[250px]/card:text-3xl">
          {value}
        </CardTitle>
        <CardAction>
            <Icon className="size-20 opacity-10" />
          
        </CardAction>
      </CardHeader>
      <CardFooter className="flex-col items-start gap-1.5 text-sm bg-muted">
        <div className="line-clamp-1 flex gap-2 font-medium">
          {trend?.direction === "up" && "↑"}
          {trend?.direction === "down" && "↓"}
          {trend?.direction === "neutral" && "→"}
          {description}
        </div>
      </CardFooter>
    </Card>
  )
}
