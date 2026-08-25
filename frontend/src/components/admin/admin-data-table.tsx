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
  FlexRender,
  rowPaginationFeature,
  rowSelectionFeature,
  rowSortingFeature,
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
import { Input } from "@base-ui/react"
import { useAuth } from "@/contexts/auth-context"
import { useNavigate } from "react-router-dom"

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
  columnHelper.display({
    id: "select",
    header: ({ table }) => (
      <div className="flex items-center justify-center">
        <Checkbox
          checked={
            table.getIsAllPageRowsSelected() ||
            (table.getIsSomePageRowsSelected() && "indeterminate")
          }
          onCheckedChange={(value) => table.toggleAllPageRowsSelected(!!value)}
          aria-label="Select all"
        />
      </div>
    ),
    cell: ({ row }) => (
      <div className="flex items-center justify-center">
        <Checkbox
          checked={row.getIsSelected()}
          onCheckedChange={(value) => row.toggleSelected(!!value)}
          aria-label="Select row"
        />
      </div>
    ),
    enableSorting: false,
    enableHiding: false,
  }),
  columnHelper.accessor("tracking_id", {
    header: "Tracking ID",
    cell: ({ row }) => {
      return <TableCellViewer item={row.original} />
    },
    enableHiding: false,
  }),
  columnHelper.accessor("department", {
    header: "Department",
    cell: ({ row }) => (
      <div className="">
        {row.original.department?.name.toUpperCase()}
      </div>
    ),
    enableSorting: false,
  }),
  columnHelper.accessor("channel", {
    header: "Channel",
    cell: ({ row }) => (
      <div className="">
        <Badge>{row.original.channel}
        </Badge>
      </div>
    ),
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
    header: "Awaiting Response",
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

export function AdminDataTable({
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
      defaultValue="outline"
      className="w-full flex-col justify-start gap-6"
    >
      <div className="flex items-center justify-between px-4 lg:px-6">
        <Label htmlFor="view-selector" className="sr-only">
          View
        </Label>
        <Select defaultValue="outline">
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
              <Button variant="outline" size="sm">
                <IconLayoutColumns />
                <span className="hidden lg:inline">Customize Columns</span>
                <span className="lg:hidden">Columns</span>
                <IconChevronDown />
              </Button>
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
              <Button variant="outline" size="sm" onClick={() => navigate("/student/submit-issue")}>
                <IconPlus />
                <span className="hidden lg:inline">Add New Issue</span>
              </Button>
            )
          }

        </div>
      </div>
      <TabsContent
        value="issues"
        className="relative flex flex-col gap-4 overflow-auto px-4 lg:px-6"
      >
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

const chartData = [
  { month: "January", desktop: 186, mobile: 80 },
  { month: "February", desktop: 305, mobile: 200 },
  { month: "March", desktop: 237, mobile: 120 },
  { month: "April", desktop: 73, mobile: 190 },
  { month: "May", desktop: 209, mobile: 130 },
  { month: "June", desktop: 214, mobile: 140 },
]

const chartConfig = {
  desktop: {
    label: "Desktop",
    color: "var(--primary)",
  },
  mobile: {
    label: "Mobile",
    color: "var(--primary)",
  },
} satisfies ChartConfig

function TableCellViewer({ item }: { item: z.infer<typeof schema> }) {
  const isMobile = useIsMobile()

  return (
    <Drawer swipeDirection={isMobile ? "down" : "down"} showSwipeHandle={isMobile}>
      <DrawerTrigger>
        <Button variant="link" className="w-fit px-0 text-left text-foreground">
          {item.tracking_id}
        </Button>
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
            <Label htmlFor="department_name" className="font-bold">Department Name</Label>
            <p>{item.department?.name?.toUpperCase() ?? "-"}</p>
          </div>
          <div className="flex flex-col gap-2">
            <Label htmlFor="category_name" className="font-bold">Category Name</Label>
            <p>{item.category?.name ?? "-"}</p>
          </div>
          <div className="flex flex-col gap-2">
            <Label htmlFor="channel" className="font-bold">Channel Name</Label>
            <p>{item.channel}</p>
          </div>
          <div className="flex flex-col gap-2">
            <Label htmlFor="intent" className="font-bold">Intent</Label>
            <p>{item.intent}</p>
          </div>
          <div className="flex flex-col gap-2">
            <Label htmlFor="status" className="font-bold">Status</Label>
            <Badge className={item.status === "open" ? "bg-green-700 text-white" : "bg-red-600 text-white"}>{item.status}</Badge>
          </div>
          <div className="flex flex-col gap-2">
            <Label htmlFor="intent" className="font-bold">Awaiting Student Response</Label>
            {
              item.awaiting_student_input ? <Badge className="bg-green-700 text-white">Yes</Badge> : <Badge className="bg-red-700 text-white">No</Badge>
            }
            
          </div>
          <div className="flex flex-col gap-2">
            <Label htmlFor="intent" className="font-bold">Created At</Label>
            <p>{item.created_at ? new Intl.DateTimeFormat("en-US").format(new Date(item.created_at)) : "None"}</p>
          </div>
          <div className="flex flex-col gap-2">
            <Label htmlFor="intent" className="font-bold">Resolved At</Label>
            <p>{item.resolved_at ? new Intl.DateTimeFormat("en-US").format(new Date(item.resolved_at)) : "None"}</p>
          </div>
          <div className="flex flex-col gap-2 col-span-full">
            <Label htmlFor="intent" className="font-bold">Subject</Label>
            <p>{item.subject}</p>
          </div>
          <div className="flex flex-col gap-2 col-span-full">
            <Label htmlFor="intent" className="font-bold">Description</Label>
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


