"use client"

import * as React from "react"
import {
  SortableContext,
  verticalListSortingStrategy,
} from "@dnd-kit/sortable"
import {
  columnFilteringFeature,
  columnVisibilityFeature,
  createColumnHelper,
  createFilteredRowModel,
  createPaginatedRowModel,
  createSortedRowModel,
  filterFn_includesString,
  FlexRender,
  rowPaginationFeature,
  rowSelectionFeature,
  rowSortingFeature,
  sortFn_alphanumeric,
  sortFn_text,
  tableFeatures,
  useTable,
  
} from "@tanstack/react-table"
import { z } from "zod"

import {
  Table,
  TableBody,
  TableCell,
  TableHead,
  TableHeader,
  TableRow,
} from "@/components/ui/table"

import { useAuth } from "@/contexts/auth-context"

// New in v9: declare the features this table uses — anything you don't
// register is tree-shaken out of the bundle.
const features = tableFeatures({
  columnFilteringFeature,
  columnVisibilityFeature,
  rowPaginationFeature,
  rowSelectionFeature,
  rowSortingFeature,
  filteredRowModel: createFilteredRowModel(),
  paginatedRowModel: createPaginatedRowModel(),
  sortedRowModel: createSortedRowModel(),
  filterFns: {includesString: filterFn_includesString},
  sortFns: { alphanumeric: sortFn_alphanumeric, text: sortFn_text },

})

const columnHelper = createColumnHelper<
  typeof features,
  z.infer<typeof schema>
>()

export const schema = z.object({
  department: z.string(),
  total: z.number(),
  pending: z.number(),
  escalated: z.number(),
  closed: z.number(),
})

export type DepartmentPerformance = z.infer<typeof schema>

const columns = columnHelper.columns([
  columnHelper.accessor("department", {
    header: "Department",
    cell: ({ row }) => {
      return <div className="capitalize">
        {row.original.department}
      </div>
    },
    enableHiding: false,
  }),
  columnHelper.accessor("total", {
    header: "Total",
    cell: ({ row }) => (
      <div className="capitalize">
        {row.original.total}
      </div>
    ),
    enableSorting: false,
  }),
  columnHelper.accessor("pending", {
    header: "Pending",
    cell: ({ row }) => (
      <div className="capitalize">
        {row.original.pending}
      </div>
    ),
    enableSorting: false,
  }),
  columnHelper.accessor("escalated", {
    header: "Escalated",
    cell: ({ row }) => (
      <div className="">
        {row.original.escalated}
      </div>
    ),
  }),
  columnHelper.accessor("closed", {
    header: "Closed",
    cell: ({ row }) => (
      <div>{row.original.closed}</div>
    ),
    enableSorting: false,
  }),
  
])


export function DepartmentPerformanceTable({
  data: initialData,
}: {
  data: z.infer<typeof schema>[]
}) {
  const [data, setData] = React.useState(() => initialData)
  
  React.useEffect(() => {
    setData(initialData)
  }, [initialData])

  

  const table = useTable({
    features,
    data,
    columns,
    state: {
    },
    
  })

  return (
    <div
        className="relative flex flex-col gap-4 overflow-auto px-4 lg:px-6"
      >
        <div className="flex flex-wrap items-center gap-2 py-4 text-2xl font-bold">
            <h1>Department Performance</h1>
        
      </div>
        <div className="overflow-hidden rounded-lg border">
          <Table>
              <TableHeader className="sticky top-0 z-10 bg-muted">
                {table.getHeaderGroups().map((headerGroup) => (
                  <TableRow key={headerGroup.id}>
                    {headerGroup.headers.map((header) => {
                      return (
                        <TableHead key={header.id} colSpan={header.colSpan}>
                          {header.isPlaceholder ? null : (
                            <FlexRender header={header} />
                          )}
                        </TableHead>
                      )
                    })}
                  </TableRow>
                ))}
              </TableHeader>
              <TableBody className="**:data-[slot=table-cell]:first:w-8">
                {table.getRowModel().rows?.length ? (
                  <SortableContext
                    items={[]}
                    strategy={verticalListSortingStrategy}
                  >
                    {table.getRowModel().rows.map((row) => (
                      <TableRow
                            data-state={row.getIsSelected() && "selected"}
                            className="relative z-0 data-[dragging=true]:z-10 data-[dragging=true]:opacity-80"
                            
                          >
                            {row.getVisibleCells().map((cell) => (
                              <TableCell key={cell.id}>
                                <FlexRender cell={cell} />
                              </TableCell>
                            ))}
                          </TableRow>
                    ))}
                  </SortableContext>
                ) : (
                  <TableRow>
                    <TableCell
                      colSpan={columns.length}
                      className="h-24 text-center"
                    >
                      No results.
                    </TableCell>
                  </TableRow>
                )}
              </TableBody>
            </Table>
        </div>
        
      </div>
  )
}




