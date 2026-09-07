import type { TicketStatusHistory } from "@/types";


type TimelineProps = {
    timeline: TicketStatusHistory[]
}

function formatDate(value: string | null) {
  if (!value) return ""
  const date = new Date(value)
  return Number.isNaN(date.getTime()) ? "" : date.toLocaleString()
}

export default function Timeline({ timeline }: TimelineProps) {
  if (timeline.length === 0) {
    return <p className="p-4 text-sm text-muted-foreground">No status history yet.</p>
  }

  return (
    <div
      role="region"
      aria-label="Ticket status history"
      tabIndex={0}
      className="w-full min-w-0 overflow-x-auto rounded-lg p-4 focus-visible:outline-2 focus-visible:outline-ring"
    >
      <ol className="flex min-w-full w-max">
        {timeline.map((item, index) => (
          <li key={item.id} className="relative w-52 shrink-0 grow">
            <div aria-hidden="true" className="relative mb-4 flex h-6 items-center">
              {index < timeline.length - 1 && (
                <span className="absolute inset-x-0 h-0.5 bg-border" />
              )}
              <span className="relative flex size-6 items-center justify-center rounded-full bg-blue-100 dark:bg-blue-900">
                <span className="size-2.5 rounded-full bg-blue-600 dark:bg-blue-400" />
              </span>
            </div>
            <time dateTime={item.created_at} className="mb-1 block pr-6 text-sm text-muted-foreground">
              {formatDate(item.created_at)}
            </time>
            <h3 className="pr-6 text-lg font-semibold text-foreground">
              {item.new_status_label}
            </h3>
          </li>
        ))}
      </ol>
    </div>
  );
}
