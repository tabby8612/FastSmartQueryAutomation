"use client";

import * as React from "react";
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
} from "@dnd-kit/core";
import { restrictToVerticalAxis } from "@dnd-kit/modifiers";
import {
  arrayMove,
  SortableContext,
  useSortable,
  verticalListSortingStrategy,
} from "@dnd-kit/sortable";
import { CSS } from "@dnd-kit/utilities";
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
} from "@tabler/icons-react";
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
} from "@tanstack/react-table";
import { z } from "zod";

import { Badge } from "@/components/ui/badge";
import { Button } from "@/components/ui/button";
import { Checkbox } from "@/components/ui/checkbox";
import {
  DropdownMenu,
  DropdownMenuCheckboxItem,
  DropdownMenuContent,
  DropdownMenuTrigger,
} from "@/components/ui/dropdown-menu";
import { Label } from "@/components/ui/label";
import {
  Select,
  SelectContent,
  SelectItem,
  SelectTrigger,
  SelectValue,
} from "@/components/ui/select";
import {
  Table,
  TableBody,
  TableCell,
  TableHead,
  TableHeader,
  TableRow,
} from "@/components/ui/table";
import { Tabs, TabsContent, TabsList, TabsTrigger } from "@/components/ui/tabs";
import {
  Drawer,
  DrawerClose,
  DrawerContent,
  DrawerDescription,
  DrawerFooter,
  DrawerHeader,
  DrawerTitle,
  DrawerTrigger,
} from "../ui/drawer";
import { useIsMobile } from "@/hooks/use-mobile";
import { useAuth } from "@/contexts/auth-context";
import { useNavigate } from "react-router-dom";
import type { User } from "@/types";
import { formatLongDate } from "@/lib/utils";
import { Trash2Icon } from "lucide-react";
import {
  Dialog,
  DialogClose,
  DialogContent,
  DialogDescription,
  DialogFooter,
  DialogHeader,
  DialogTitle,
  DialogTrigger,
} from "../ui/dialog";
import { Field, FieldGroup } from "../ui/field";
import { Input } from "../ui/input";
import api from "@/lib/axios";
import { toast } from "sonner";
import { isAxiosError } from "axios";

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
});

const columnHelper = createColumnHelper<typeof features, User>();

// Create a separate component for the drag handle
function DragHandle({ id }: { id: number }) {
  const { attributes, listeners } = useSortable({
    id,
  });

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
  );
}



function DraggableRow({ row }: { row: Row<typeof features, User> }) {
  const { transform, transition, setNodeRef, isDragging } = useSortable({
    id: row.original.id,
  });

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
  );
}

export function UsersDataTable({ data: initialData }: { data: User[] }) {
  const [data, setData] = React.useState(() => initialData);
  const { role_name, getAccessToken } = useAuth();
  const [selectedUser, setSelectedUser] = React.useState<User | null>(null);
  const [deleteDialogOpen, setDeleteDialogOpen] = React.useState(false);
  const [isDeleting, setIsDeleting] = React.useState(false);
  const [rowSelection, setRowSelection] = React.useState({});
  const [columnVisibility, setColumnVisibility] =
    React.useState<ColumnVisibilityState>({});
  const [columnFilters, setColumnFilters] = React.useState<ColumnFiltersState>(
    [],
  );
  const [sorting, setSorting] = React.useState<SortingState>([]);
  const [pagination, setPagination] = React.useState({
    pageIndex: 0,
    pageSize: 10,
  });

  React.useEffect(() => {
    setData(initialData);
  }, [initialData]);

  
  const sortableId = React.useId();
  const sensors = useSensors(
    useSensor(MouseSensor, {}),
    useSensor(TouchSensor, {}),
    useSensor(KeyboardSensor, {}),
  );

  const dataIds = React.useMemo<UniqueIdentifier[]>(
    () => data?.map(({ id }) => id) || [],
    [data],
  );

  const ACCESS_TOKEN = getAccessToken()

  const columns = columnHelper.columns([
    columnHelper.display({
      id: "drag",
      header: () => null,
      cell: ({ row }) => <DragHandle id={row.original.id} />,
    }),

    columnHelper.accessor("full_name", {
      header: "Full Name",
      cell: ({ row }) => (
        <div className="font-bold">
          {row.original.full_name.length > 20
            ? row.original.full_name.slice(0, 20) + "..."
            : row.original.full_name}
        </div>
      ),
      enableHiding: false,
    }),
    columnHelper.accessor("email", {
      header: "Email",
      cell: ({ row }) => (
        <div className="">{row.original.email.slice(0, 20)}...</div>
      ),
      enableSorting: false,
    }),
    columnHelper.accessor("rolename", {
      header: "Role",
      cell: ({ row }) => (
        <div className="capitalize">{row.original.rolename}</div>
      ),
      enableSorting: false,
    }),
    columnHelper.accessor("department.name", {
      header: "Department",
      cell: ({ row }) => (
        <div className="capitalize">
          {`${row.original.department ? row.original.department.name.slice(0, 20) + "..." : "-"}`}
        </div>
      ),
      enableSorting: false,
    }),
    columnHelper.accessor("is_active", {
      header: "Active",
      cell: ({ row }) => (
        <Badge
          className={row.original.is_active ? "bg-green-600" : "bg-red-600"}
        >
          {row.original.is_active ? "Yes" : "No"}
        </Badge>
      ),
      enableSorting: false,
    }),
    columnHelper.accessor("on_leave", {
      header: "On Leave",
      cell: ({ row }) => (
        <Badge
          className={
            row.original.is_currently_on_leave ? "bg-green-600" : "bg-red-600"
          }
        >
          {row.original.on_leave ? "Yes" : "No"}
        </Badge>
      ),
      enableSorting: false,
    }),
    columnHelper.accessor("created_at", {
      header: "Join Date",
      cell: ({ row }) => (
        <div className="capitalize">
          {formatLongDate(row.original.created_at) ?? "-"}
        </div>
      ),
      enableSorting: false,
    }),
    columnHelper.display({
      id: "action",
      header: () => null,
      cell: ({ row }) => (
        <Button
          variant="destructive"
          size="icon"
          onClick={() => {
            setSelectedUser(row.original);
            setDeleteDialogOpen(true);
          }}
        >
          <Trash2Icon color="red" />
        </Button>
      ),
    }),
  ]);

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
  });

  function handleDragEnd(event: DragEndEvent) {
    const { active, over } = event;
    if (active && over && active.id !== over.id) {
      setData((data) => {
        const oldIndex = dataIds.indexOf(active.id);
        const newIndex = dataIds.indexOf(over.id);
        return arrayMove(data, oldIndex, newIndex);
      });
    }
  }

  async function handleDeleteUser(event: React.MouseEvent) {
    event.preventDefault()
    
    if (!selectedUser) return;
    if (isDeleting) return;

    try {
      setIsDeleting(true)

      await api.delete(`/users/${selectedUser.id}`, {
        headers: {
          "Authorization": `Bearer ${ACCESS_TOKEN}`
        }
      })

      setData(prevUsers => prevUsers.filter(user => user.id !== selectedUser.id))
      
    } catch (error) {
      if (isAxiosError(error)) {
        toast.error(`Unable to delete user - ${error.message}`, {
          'position': "top-center",
          "richColors": true
        })
      }
    } finally {
      setDeleteDialogOpen(false)
      setIsDeleting(false)
    }
    
  }

  const navigate = useNavigate();

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
            <SelectItem value="users">Users</SelectItem>
          </SelectContent>
        </Select>
        <TabsList className="hidden **:data-[slot=badge]:size-5 **:data-[slot=badge]:rounded-full **:data-[slot=badge]:bg-muted-foreground/30 **:data-[slot=badge]:px-1 @4xl/main:flex">
          <TabsTrigger value="users">Recent Users</TabsTrigger>
        </TabsList>
        <div className="flex items-center gap-2">
          <DropdownMenu>
            <DropdownMenuTrigger render={<Button variant="outline" size="sm">
                <IconLayoutColumns />
                <span className="hidden lg:inline">Customize Columns</span>
                <span className="lg:hidden">Columns</span>
                <IconChevronDown />
              </Button>} />
              
            
            <DropdownMenuContent align="end" className="w-56">
              {table
                .getAllColumns()
                .filter(
                  (column) =>
                    typeof column.accessorFn !== "undefined" &&
                    column.getCanHide(),
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
                  );
                })}
            </DropdownMenuContent>
          </DropdownMenu>
          {role_name == "student" && (
            <Button
              variant="outline"
              size="sm"
              onClick={() => navigate("/student/submit-issue")}
            >
              <IconPlus />
              <span className="hidden lg:inline">Add New Issue</span>
            </Button>
          )}
        </div>
      </div>
      <TabsContent
        value="users"
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
            {selectedUser && (
              <Dialog open={deleteDialogOpen}>
                <form>
                  <DialogContent className="sm:max-w-sm" showCloseButton={false}>
                    <DialogHeader>
                      <DialogTitle>Do you want to delete this user?</DialogTitle>
                      <DialogDescription />
                    </DialogHeader>
                    <Trash2Icon color="red" className="bg-stone-100 rounded-full mx-auto p-3" size={50} />
                    <p>This action can't be reversed, once user is deleted, you can't access his tickets</p>
                    <DialogFooter>
                      <DialogClose
                        render={<Button variant="outline" onClick={() => setDeleteDialogOpen(false)}>Cancel</Button>}
                      />
                      <Button type="submit" variant="destructive" onClick={(e) => handleDeleteUser(e)}>Delete User</Button>
                    </DialogFooter>
                  </DialogContent>
                </form>
              </Dialog>
            )}
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
                      );
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
                  table.setPageSize(Number(value));
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
  );
}

function TableCellViewer({ item }: { item: User }) {
  const isMobile = useIsMobile();

  return (
    <Drawer
      swipeDirection={isMobile ? "left" : "down"}
      showSwipeHandle={isMobile}
    >
      <DrawerTrigger>
        <Button variant="link" className="w-fit px-0 text-left text-foreground">
          {item.full_name}
        </Button>
      </DrawerTrigger>
      <DrawerContent>
        <DrawerHeader className="gap-10 mb-7">
          <DrawerTitle className="text-2xl font-bold text-primary">
            {item.full_name}
          </DrawerTitle>
          <DrawerDescription className="text-lg text-slate-600">
            Showing issue details for the Item Tracking # {item.full_name}
          </DrawerDescription>
        </DrawerHeader>
        <div className="grid grid-cols-3 gap-6 justify-center items-center overflow-y-auto px-4 size-8/12 mx-auto ">
          <div className="flex flex-col gap-2">
            <Label htmlFor="tracking_id" className="font-bold">
              Tracking ID
            </Label>
            <p>{item.email}</p>
          </div>
        </div>
        <DrawerFooter>
          <DrawerClose className="pt-10">
            <Button variant="outline">Close</Button>
          </DrawerClose>
        </DrawerFooter>
      </DrawerContent>
    </Drawer>
  );
}
