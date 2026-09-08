"use client"

import * as React from "react"
import {
  closestCenter,
  DndContext,
  KeyboardSensor,
  MouseSensor,
  TouchSensor,
  useSensor,
  useSensors,
  type DragEndEvent,
  type UniqueIdentifier,
} from "@dnd-kit/core"
import { restrictToVerticalAxis } from "@dnd-kit/modifiers"
import {
  arrayMove,
  SortableContext,
  useSortable,
  verticalListSortingStrategy,
} from "@dnd-kit/sortable"
import { CSS } from "@dnd-kit/utilities"
import {
  IconChevronDown,
  IconChevronLeft,
  IconChevronRight,
  IconChevronsLeft,
  IconChevronsRight,
  IconCircleCheckFilled,
  IconGripVertical,
  IconLayoutColumns,
  IconLoader,
  IconPlus,
} from "@tabler/icons-react"
import {
  columnFilteringFeature,
  columnVisibilityFeature,
  createColumnHelper,
  createFilteredRowModel,
  createPaginatedRowModel,
  createSortedRowModel,
  filterFn_equals,
  filterFn_includesString,
  FlexRender,
  rowPaginationFeature,
  rowSelectionFeature,
  rowSortingFeature,
  sortFn_alphanumeric,
  sortFn_text,
  tableFeatures,
  useTable,
  type ColumnFiltersState,
  type ColumnVisibilityState,
  type Row,
  type SortingState,
} from "@tanstack/react-table"
import { z } from "zod"

import { Badge } from "@/components/ui/badge"
import { Button } from "@/components/ui/button"
import { Checkbox } from "@/components/ui/checkbox"
import {
  DropdownMenu,
  DropdownMenuCheckboxItem,
  DropdownMenuContent,
  DropdownMenuTrigger,
} from "@/components/ui/dropdown-menu"
import { Label } from "@/components/ui/label"
import {
  Select,
  SelectContent,
  SelectItem,
  SelectTrigger,
  SelectValue,
} from "@/components/ui/select"
import {
  Table,
  TableBody,
  TableCell,
  TableHead,
  TableHeader,
  TableRow,
} from "@/components/ui/table"
import {
  Tabs,
  TabsContent,
  TabsList,
  TabsTrigger,
} from "@/components/ui/tabs"
import { Drawer, DrawerClose, DrawerContent, DrawerDescription, DrawerFooter, DrawerHeader, DrawerTitle, DrawerTrigger } from "../ui/drawer"
import { type ChartConfig } from "../ui/chart"
import { useIsMobile } from "@/hooks/use-mobile"
import { useAuth } from "@/contexts/auth-context"
import { Link, useNavigate } from "react-router-dom"
import { ArrowUpDown, Search } from "lucide-react"
import { Input } from "../ui/input"

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
  id: z.number(),
  tracking_id: z.string(),
  channel: z.string(),
  subject: z.string(),
  body: z.string(),
  intent: z.string(),
  status: z.string(),
  awaiting_student_input: z.boolean(),
  resolved_at: z.string(),
  created_at: z.string(),
  student: z.object({
    id: z.number(),
    student_id: z.string(),
    email: z.string(),
    full_name: z.string(),
  }),
  assigned: z.object({
    id: z.number(),
    email: z.string(),
    full_name: z.string(),
  }),
  department: z.object({
    id: z.number(),
    name: z.string(),
  }),
  category: z.object({
    id: z.number(),
    name: z.string(),
  }),
})

export type Query = z.infer<typeof schema>

// Create a separate component for the drag handle
function DragHandle({ id }: { id: number }) {
  const { attributes, listeners } = useSortable({
    id,
  })

  return (
    <Button
      {...attributes}
      {...listeners}
      variant="ghost"
      size="icon"
      className="size-7 text-muted-foreground hover:bg-transparent"
    >
      <IconGripVertical className="size-3 text-muted-foreground" />
      <span className="sr-only">Drag to reorder</span>
    </Button>
  )
}

const columns = columnHelper.columns([
  columnHelper.display({
    id: "drag",
    header: () => null,
    cell: ({ row }) => <DragHandle id={row.original.id} />,
  }),
  // columnHelper.display({
  //   id: "select",
  //   header: ({ table }) => (
  //     <div className="flex items-center justify-center">
  //       <Checkbox
  //         checked={
  //           table.getIsAllPageRowsSelected() ||
  //           (table.getIsSomePageRowsSelected() && "indeterminate")
  //         }
  //         onCheckedChange={(value) => table.toggleAllPageRowsSelected(!!value)}
  //         aria-label="Select all"
  //       />
  //     </div>
  //   ),
  //   cell: ({ row }) => (
  //     <div className="flex items-center justify-center">
  //       <Checkbox
  //         checked={row.getIsSelected()}
  //         onCheckedChange={(value) => row.toggleSelected(!!value)}
  //         aria-label="Select row"
  //       />
  //     </div>
  //   ),
  //   enableSorting: false,
  //   enableHiding: false,
  // }),
  columnHelper.accessor("tracking_id", {
    header: "Tracking ID",
    filterFn: filterFn_includesString,
    enableColumnFilter: true,
    cell: ({ row }) => {
      return <div className="flex justify-center items-center gap-2 ">
        <Link to={`/ticket/${row.original.id}`}>
        <p className="font-semibold hover:border-b-2 hover:cursor-pointer hover:text-primary border-primary h-6 cursor-default text-sm leading-6 tracking-wide">{row.original.tracking_id}</p>
        </Link>
        <TableCellViewer item={row.original} />
      </div>
    },
    enableHiding: false,
  }),
  columnHelper.accessor("subject", {
    header: "Title",
    cell: ({ row }) => (
      <div className="capitalize">
        {`${row.original.subject?.slice(0,20)}...`}
      </div>
    ),
    enableSorting: false,
  }),
  columnHelper.accessor((row) => row.department?.id, {
    id: "department",
    header: "Department",
    filterFn: filterFn_equals,
    enableColumnFilter: true,
    cell: ({ row }) => (
      <div className="capitalize">
        {row.original.department?.name ? `${row.original.department?.name.slice(0,20)}...` : "-"}
      </div>
    ),
    enableSorting: false,
  }),
  columnHelper.accessor("channel", {
    header: ({column}) => {
      return <div
          className="flex gap-1 justify-center items-center"
          onClick={() => column.toggleSorting(column.getIsSorted() === "asc")}
        >
          Channel
          <ArrowUpDown className="ml-2 h-4 w-4 cursor-pointer hover:text-primary" />
        </div>
    },
    cell: ({ row }) => (
      <div className="">
        <Badge>{row.original.channel}
        </Badge>
      </div>
    ),
    enableSorting: true,
    sortFn: sortFn_text,
    filterFn: filterFn_includesString,
    enableColumnFilter: true
  }),
  columnHelper.accessor("status", {
    header: "Status",
    cell: ({ row }) => (
      <Badge variant="outline" className="px-1.5 text-muted-foreground">
        {row.original.status === "open" ? (
          <IconCircleCheckFilled className="fill-green-500 dark:fill-green-400" />
        ) : (
          <IconLoader />
        )}
        {row.original.status}
      </Badge>
    ),
    enableSorting: false,
  }),
  columnHelper.accessor("category", {
    header: "Category",
    cell: ({ row }) => (
      <Badge>{row.original.category?.name[0].toUpperCase() + row.original.category?.name.slice(1, row.original.category?.name.length)}</Badge>
    ),
  }),
  columnHelper.accessor("awaiting_student_input", {
    header: "Awaiting Student Response",
    cell: ({ row }) => (
      <div className="flex justify-center items-center">
        {row.original.awaiting_student_input ? <Badge className="bg-green-200 text-black">Yes</Badge> : <Badge className="bg-red-200 text-black">No</Badge>}
      </div>
    ),
  }),
  columnHelper.accessor("created_at", {
    header: "Created At",
    cell: ({ row }) => {
      return new Intl.DateTimeFormat("en-US", {dateStyle: "medium"}).format(new Date(row.original.created_at))
    },
  }),
  
])

function DraggableRow({
  row,
}: {
  row: Row<typeof features, z.infer<typeof schema>>
}) {
  const { transform, transition, setNodeRef, isDragging } = useSortable({
    id: row.original.id,
  })

  return (
    <TableRow
      data-state={row.getIsSelected() && "selected"}
      data-dragging={isDragging}
      ref={setNodeRef}
      className="relative z-0 data-[dragging=true]:z-10 data-[dragging=true]:opacity-80"
      style={{
        transform: CSS.Transform.toString(transform),
        transition: transition,
      }}
    >
      {row.getVisibleCells().map((cell) => (
        <TableCell key={cell.id}>
          <FlexRender cell={cell} />
        </TableCell>
      ))}
    </TableRow>
  )
}

export function DataTable({
  data: initialData,
}: {
  data: z.infer<typeof schema>[]
}) {
  const [data, setData] = React.useState(() => initialData)
  const { role_name } = useAuth();

  React.useEffect(() => {
    setData(initialData)
  }, [initialData])
  const [rowSelection, setRowSelection] = React.useState({})
  const [columnVisibility, setColumnVisibility] =
    React.useState<ColumnVisibilityState>({})
  const [columnFilters, setColumnFilters] = React.useState<ColumnFiltersState>(
    []
  )
  const [sorting, setSorting] = React.useState<SortingState>([])
  
  const [pagination, setPagination] = React.useState({
    pageIndex: 0,
    pageSize: 10,
  })
  const sortableId = React.useId()
  const sensors = useSensors(
    useSensor(MouseSensor, {}),
    useSensor(TouchSensor, {}),
    useSensor(KeyboardSensor, {})
  )

  const dataIds = React.useMemo<UniqueIdentifier[]>(
    () => data?.map(({ id }) => id) || [],
    [data]
  )

  const departments = React.useMemo(
    () => Array.from(
      new Map(data.flatMap(({ department }) =>
        department ? [[department.id, department] as const] : []
      )).values()
    ).sort((a, b) => a.name.localeCompare(b.name)),
    [data]
  )

  const table = useTable({
    features,
    data,
    columns,
    state: {
      sorting,
      columnVisibility,
      rowSelection,
      columnFilters,
      pagination,
    },
    getRowId: (row) => row.id.toString(),
    enableRowSelection: true,
    onRowSelectionChange: setRowSelection,
    onSortingChange: setSorting,
    onColumnFiltersChange: setColumnFilters,
    onColumnVisibilityChange: setColumnVisibility,
    onPaginationChange: setPagination,
  })

  function handleDragEnd(event: DragEndEvent) {
    const { active, over } = event
    if (active && over && active.id !== over.id) {
      setData((data) => {
        const oldIndex = dataIds.indexOf(active.id)
        const newIndex = dataIds.indexOf(over.id)
        return arrayMove(data, oldIndex, newIndex)
      })
    }
  }

  const navigate = useNavigate()
  
  return (
    <Tabs
      defaultValue="issues"
      className="w-full flex-col justify-start gap-6"
    >
      <div className="flex items-center justify-between px-4 lg:px-6">
        <Label htmlFor="view-selector" className="sr-only">
          View
        </Label>
        <Select defaultValue="issues">
          <SelectTrigger
            className="flex w-fit @4xl/main:hidden"
            size="sm"
            id="view-selector"
          >
            <SelectValue placeholder="Select a view" />
          </SelectTrigger>
          <SelectContent>
            <SelectItem value="issues">Issues</SelectItem>
          </SelectContent>
        </Select>
        <TabsList className="hidden **:data-[slot=badge]:size-5 **:data-[slot=badge]:rounded-full **:data-[slot=badge]:bg-muted-foreground/30 **:data-[slot=badge]:px-1 @4xl/main:flex">
          <TabsTrigger value="issues">Recent Issues</TabsTrigger>
        </TabsList>
        <div className="flex items-center gap-2">
          <DropdownMenu>
            <DropdownMenuTrigger>
              <div className="flex text-xs gap-1.5 shadow border-slate-800 font-semibold justify-center items-center bg-muted/70 px-3 py-1 rounded-lg hover:bg-muted-foreground/10">
                <IconLayoutColumns className="size-4"/>
                <span className="hidden lg:inline">Customize Columns</span>
                <span className="lg:hidden">Columns</span>
                <IconChevronDown />
              </div>
            </DropdownMenuTrigger>
            <DropdownMenuContent align="end" className="w-56">
              {table
                .getAllColumns()
                .filter(
                  (column) =>
                    typeof column.accessorFn !== "undefined" &&
                    column.getCanHide()
                )
                .map((column) => {
                  return (
                    <DropdownMenuCheckboxItem
                      key={column.id}
                      className="capitalize"
                      checked={column.getIsVisible()}
                      onCheckedChange={(value) =>
                        column.toggleVisibility(!!value)
                      }
                    >
                      {column.id}
                    </DropdownMenuCheckboxItem>
                  )
                })}
            </DropdownMenuContent>
          </DropdownMenu>
          {
            role_name == "student" && (
              <div className="flex text-xs gap-1.5 shadow border-slate-800 font-semibold justify-center cursor-default items-center bg-muted/70 px-4 py-2 rounded-lg hover:bg-muted-foreground/10" onClick={() => navigate("/student/submit-issue")}>
                <IconPlus className="size-4"/>
                <span className="hidden lg:inline">Add New Issue</span>
              </div>
            )
          }

        </div>
      </div>
      <TabsContent
        value="issues"
        className="relative flex flex-col gap-4 overflow-auto px-4 lg:px-6"
      >
        <div className="flex flex-wrap items-center gap-2 py-4">
        <Input
          placeholder="Filter by tracking ID..."
          aria-label="Filter by tracking ID"
          value={(table.getColumn("tracking_id")?.getFilterValue() as string) ?? ""}
          onChange={(event) =>
            table.getColumn("tracking_id")?.setFilterValue(event.target.value)
          }
          className="max-w-sm"
        />
        <Select
          items={[
            { value: "all", label: "All departments" },
            ...departments.map((department) => ({
              value: String(department.id),
              label: department.name.slice(0,1).toUpperCase() + department.name.slice(1,),
            })),
          ]}
          value={String(table.getColumn("department")?.getFilterValue() ?? "all")}
          onValueChange={(value) => {
            table.getColumn("department")?.setFilterValue(
              value === "all" || value === null ? undefined : Number(value)
            )
            table.setPageIndex(0)
          }}
        >
          <SelectTrigger className="w-56" aria-label="Filter by department">
            <SelectValue placeholder="All departments" />
          </SelectTrigger>
          <SelectContent>
            <SelectItem value="all">All departments</SelectItem>
            {departments.map((department) => (
              <SelectItem key={department.id} value={String(department.id)}>
                {department.name}
              </SelectItem>
            ))}
          </SelectContent>
        </Select>
      </div>
        <div className="overflow-hidden rounded-lg border">
          <DndContext
            collisionDetection={closestCenter}
            modifiers={[restrictToVerticalAxis]}
            onDragEnd={handleDragEnd}
            sensors={sensors}
            id={sortableId}
          >
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
                    items={dataIds}
                    strategy={verticalListSortingStrategy}
                  >
                    {table.getRowModel().rows.map((row) => (
                      <DraggableRow key={row.id} row={row} />
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
          </DndContext>
        </div>
        <div className="flex items-center justify-between px-4">
          <div className="hidden flex-1 text-sm text-muted-foreground lg:flex">
            {table.getFilteredSelectedRowModel().rows.length} of{" "}
            {table.getFilteredRowModel().rows.length} row(s) selected.
          </div>
          <div className="flex w-full items-center gap-8 lg:w-fit">
            <div className="hidden items-center gap-2 lg:flex">
              <Label htmlFor="rows-per-page" className="text-sm font-medium">
                Rows per page
              </Label>
              <Select
                value={`${table.state.pagination.pageSize}`}
                onValueChange={(value) => {
                  table.setPageSize(Number(value))
                }}
              >
                <SelectTrigger size="sm" className="w-20" id="rows-per-page">
                  <SelectValue placeholder={table.state.pagination.pageSize} />
                </SelectTrigger>
                <SelectContent side="top">
                  {[10, 20, 30, 40, 50].map((pageSize) => (
                    <SelectItem key={pageSize} value={`${pageSize}`}>
                      {pageSize}
                    </SelectItem>
                  ))}
                </SelectContent>
              </Select>
            </div>
            <div className="flex w-fit items-center justify-center text-sm font-medium">
              Page {table.state.pagination.pageIndex + 1} of{" "}
              {table.getPageCount()}
            </div>
            <div className="ml-auto flex items-center gap-2 lg:ml-0">
              <Button
                variant="outline"
                className="hidden h-8 w-8 p-0 lg:flex"
                onClick={() => table.setPageIndex(0)}
                disabled={!table.getCanPreviousPage()}
              >
                <span className="sr-only">Go to first page</span>
                <IconChevronsLeft />
              </Button>
              <Button
                variant="outline"
                className="size-8"
                size="icon"
                onClick={() => table.previousPage()}
                disabled={!table.getCanPreviousPage()}
              >
                <span className="sr-only">Go to previous page</span>
                <IconChevronLeft />
              </Button>
              <Button
                variant="outline"
                className="size-8"
                size="icon"
                onClick={() => table.nextPage()}
                disabled={!table.getCanNextPage()}
              >
                <span className="sr-only">Go to next page</span>
                <IconChevronRight />
              </Button>
              <Button
                variant="outline"
                className="hidden size-8 lg:flex"
                size="icon"
                onClick={() => table.setPageIndex(table.getPageCount() - 1)}
                disabled={!table.getCanNextPage()}
              >
                <span className="sr-only">Go to last page</span>
                <IconChevronsRight />
              </Button>
            </div>
          </div>
        </div>
      </TabsContent>

    </Tabs>
  )
}

function TableCellViewer({ item }: { item: z.infer<typeof schema> }) {
  const isMobile = useIsMobile()

  return (
    <Drawer swipeDirection={isMobile ? "down" : "down"} showSwipeHandle={isMobile}>
      <DrawerTrigger>
        <Search className="size-3 hover:text-blue-600 cursor-pointer" />
      </DrawerTrigger>
      <DrawerContent>
        <DrawerHeader className="gap-10 mb-7">
          <DrawerTitle className="text-2xl font-bold text-primary">{item.tracking_id}</DrawerTitle>
          <DrawerDescription className="text-lg text-slate-600">
            Showing issue details for the Item Tracking # {item.tracking_id}
          </DrawerDescription>
        </DrawerHeader>
        <div className="grid grid-cols-3 gap-6 justify-center items-center overflow-y-auto px-4 size-8/12 mx-auto ">
          <div className="flex flex-col gap-2">
            <Label htmlFor="tracking_id" className="font-bold">Tracking ID</Label>
            <p>{item.tracking_id}</p>
          </div>
          <div className="flex flex-col gap-2">
            <Label htmlFor="student_name" className="font-bold">Student Name</Label>
            <p>{item.student?.full_name ?? "-"}</p>
          </div>
          <div className="flex flex-col gap-2">
            <Label htmlFor="officer_name" className="font-bold">Officer Name</Label>
            <p>{item.assigned?.full_name ?? "-"}</p>
          </div>
          <div className="flex flex-col gap-2">
            <Label htmlFor="department_name" className="font-bold capitalize">Department Name</Label>
            <p className="capitalize">{item.department?.name ?? "-"}</p>
          </div>
          <div className="flex flex-col gap-2">
            <Label htmlFor="category_name" className="font-bold capitalize">Category Name</Label>
            <p className="capitalize">{item.category?.name ?? "-"}</p>
          </div>
          <div className="flex flex-col gap-2">
            <Label htmlFor="channel" className="font-bold">Channel Name</Label>
            <Badge>{item.channel}</Badge>
          </div>
          <div className="flex flex-col gap-2">
            <Label htmlFor="intent" className="font-bold">Intent</Label>
            <p className="capitalize">{item.intent}</p>
          </div>
          <div className="flex flex-col gap-2">
            <Label htmlFor="status" className="font-bold">Status</Label>
            {
              item.status === "open" && <Badge className="bg-green-700 text-white">{item.status}</Badge>
            }
            {
              item.status === "pending" && <Badge className="bg-orange-400 text-white">{item.status}</Badge>
            }
            {
              item.status === "closed" && <Badge>{item.status}</Badge>
            }
          </div>
          <div className="flex flex-col gap-2">
            <Label htmlFor="intent" className="font-bold">Awaiting Student Response</Label>
            {
              item.awaiting_student_input ? <Badge className="bg-green-700 text-white">Yes</Badge> : <Badge className="bg-red-700 text-white">No</Badge>
            }
            
          </div>
          <div className="flex flex-col gap-2">
            <Label htmlFor="created_at" className="font-bold">Created At</Label>
            <p>{item.created_at ? new Intl.DateTimeFormat("en-US").format(new Date(item.created_at)) : "None"}</p>
          </div>
          <div className="flex flex-col gap-2">
            <Label htmlFor="resolved_at" className="font-bold">Resolved At</Label>
            <p>{item.resolved_at ? new Intl.DateTimeFormat("en-US").format(new Date(item.resolved_at)) : "None"}</p>
          </div>
          <div className="flex flex-col gap-2 col-span-full">
            <Label htmlFor="subject" className="font-bold">Subject</Label>
            <p>{item.subject}</p>
          </div>
          <div className="flex flex-col gap-2 col-span-full">
            <Label htmlFor="description" className="font-bold">Description</Label>
            <p>{item.body}</p>
          </div>
        </div>
        <DrawerFooter>
          <DrawerClose className="pt-10">
            <Button variant="outline">Close</Button>
          </DrawerClose>
        </DrawerFooter>
      </DrawerContent>
    </Drawer>
  )
}


