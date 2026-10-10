import { useEffect, useState, type CSSProperties, type ReactNode } from "react";
import { Bar, BarChart, CartesianGrid, Line, LineChart, Pie, PieChart, ResponsiveContainer, Tooltip, XAxis, YAxis } from "recharts";
import { AppSidebar } from "@/components/dashboard/app-sidebar";
import { SiteHeader } from "@/components/dashboard/site-header";
import { SidebarInset, SidebarProvider } from "@/components/ui/sidebar";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { useAuth } from "@/contexts/auth-context";
import api from "@/lib/axios";
import type { AnalyticsCount, AnalyticsSummary, Category, Department, DepartmentPerformance, Escalation, Ticket, TicketTrend } from "@/types";
import { isAxiosError } from "axios";
import { useNavigate } from "react-router-dom";
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from "@/components/ui/select";
import { DepartmentPerformanceTable } from "@/components/admin/department-performance-table";
import { exportToExcel, exportToPDF } from "@/services/export_service";
import { IconFileExcel, IconPdf } from "@tabler/icons-react";
import { toast } from "sonner";

type Analytics = { summary: AnalyticsSummary; trend: TicketTrend[]; channel: AnalyticsCount[], status: AnalyticsCount[]; category: AnalyticsCount[]; department: AnalyticsCount[]; priority: AnalyticsCount[]; escalations: Escalation };
const colors = ["#2563eb", "#16a34a", "#f59e0b", "#9333ea", "#ef4444", "#0891b2"];
const number = new Intl.NumberFormat();
const label = (value: string) => value.replace(/_/g, " ").replace(/\b\w/g, (letter) => letter.toUpperCase());
const dateLabel = (value: string) => new Date(`${value}T00:00:00`).toLocaleDateString(undefined, { month: "short", day: "numeric" });

function Panel({ title, empty, children }: { title: string; empty: boolean; children: ReactNode }) {
  return <Card className="min-w-0">
    <CardHeader><CardTitle>{title}</CardTitle></CardHeader>
    <CardContent>{empty ? <div className="flex h-64 items-center justify-center text-muted-foreground">No queries in this date range.</div> : children}</CardContent>
  </Card>;
}

function Distribution({ data }: { data: AnalyticsCount[] }) {
  const slices = data.map((item, index) => ({ ...item, name: label(item.name), fill: colors[index % colors.length] }));
  return <>
    <div className="h-56"><ResponsiveContainer width="100%" height="100%">
      <PieChart><Pie data={slices} dataKey="count" nameKey="name" innerRadius="55%" outerRadius="85%" paddingAngle={2} /><Tooltip /></PieChart>
    </ResponsiveContainer></div>
    <ul className="flex flex-wrap justify-center gap-x-5 gap-y-2 text-sm">
      {slices.map((item) => <li key={item.name} className="flex items-center gap-2"><span className="size-2.5 rounded-full" style={{ background: item.fill }} />{item.name}: <span className="font-medium">{number.format(item.count)}</span></li>)}
    </ul>
  </>;
}

function HorizontalBars({ data }: { data: AnalyticsCount[] }) {
  return <div className="max-h-96 overflow-y-auto"><div style={{ height: Math.max(260, data.length * 44) }}>
    <ResponsiveContainer width="100%" height="100%">
      <BarChart accessibilityLayer data={data} layout="vertical" margin={{ left: 0, right: 20 }}>
        <CartesianGrid horizontal={false} strokeDasharray="3 3" />
        <XAxis type="number" allowDecimals={false} />
        <YAxis type="category" dataKey="name" width={120} tick={{ fontSize: 12 }} interval={0} />
        <Tooltip /><Bar dataKey="count" name="Queries" fill={colors[0]} radius={[0, 4, 4, 0]} maxBarSize={26} />
      </BarChart>
    </ResponsiveContainer>
  </div></div>;
}

export function AdminDashboard() {
  const { access_token } = useAuth();
  const [from, setFrom] = useState("");
  const [to, setTo] = useState("");
  const [range, setRange] = useState<{ from: string; to: string; departmentId: number | null; categoryId: number | null }>({ from: "", to: "", departmentId: null, categoryId: null });
  const [selectedDepartmentID, setSelectedDepartmentID] = useState<number | null>(null)
  const [allDepartments, setAllDepartments] = useState<Department[] | null>(null)
  const [selectedCategoryID, setSelectedCategoryID] = useState<number | null>(null)
  const [allCategories, setAllCategories] = useState<Category[] | null>(null)
  const [departmentPerformance, setDepartmentPerformance] = useState<DepartmentPerformance[] | null>(null)
  const [data, setData] = useState<Analytics | null>(null);
  const [tickets, setTickets] = useState<Ticket[] | null>(null)
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState("");
  const invalidRange = Boolean(from && to && from > to);

  const navigate = useNavigate();

  useEffect(() => {
    if (!access_token) return;
    const controller = new AbortController();
    async function fetchAnalytics() {
      setLoading(true);
      setError("");
      const config = {
        headers: { Authorization: `Bearer ${access_token}` },
        params: { start_date: range.from || undefined, end_date: range.to || undefined, department_id: range.departmentId ?? undefined, category_id: range.categoryId ?? undefined },
        signal: controller.signal,
      };
      try {
        const [ticketData, summary, trend, channel, status, category, department, priority, escalations, deptPerformance, departments, categories] = await Promise.all([
          api.get<Ticket[]>("/reports/tickets", config),
          api.get<AnalyticsSummary>("/admin/analytics/summary", config),
          api.get<TicketTrend[]>("/admin/analytics/tickets-over-time", config),
          api.get<AnalyticsCount[]>("/admin/analytics/by-channel", config),
          api.get<AnalyticsCount[]>("/admin/analytics/by-status", config),
          api.get<AnalyticsCount[]>("/admin/analytics/by-category", config),
          api.get<AnalyticsCount[]>("/admin/analytics/by-department", config),
          api.get<AnalyticsCount[]>("/admin/analytics/by-priority", config),
          api.get<Escalation>("/admin/analytics/escalations", config),
          api.get<DepartmentPerformance[]>("/admin/analytics/department-report/", config),
          api.get<Department[]>("/departments/", { headers: config.headers, signal: controller.signal }),
          api.get<Category[]>("/categories/", { headers: config.headers, signal: controller.signal }),
        ]);
        if (!controller.signal.aborted) {
          setData({ summary: summary.data, trend: trend.data, channel: channel.data, status: status.data, category: category.data, department: department.data, priority: priority.data, escalations: escalations.data })
          setAllDepartments(departments.data)
          setAllCategories(categories.data)
          setDepartmentPerformance(deptPerformance.data)
          setTickets(ticketData.data)
        }
      } catch (error) {
        if (!controller.signal.aborted) setError("Unable to load analytics. Please try again.");

        if (isAxiosError(error) && error.status == 408) navigate("/")

      } finally {
        if (!controller.signal.aborted) setLoading(false);
      }
    }
    void fetchAnalytics();
    return () => controller.abort();
  }, [access_token, range, navigate]);

  console.log(tickets)

  return <SidebarProvider style={{ "--sidebar-width": "calc(var(--spacing) * 72)", "--header-height": "calc(var(--spacing) * 16)" } as CSSProperties}>
    <AppSidebar variant="inset" roleName="admin" />
    <SidebarInset>
      <SiteHeader />
      <main className="flex flex-1 flex-col gap-6 p-4 md:p-6">
        <Card>
          <CardHeader><h1 className="text-2xl font-bold">Admin Analytics</h1><p className="text-muted-foreground">Query activity by creation date. Leave dates blank to view all time.</p></CardHeader>
          <CardContent>
            <form className="flex flex-wrap items-end gap-4" onSubmit={(event) => { event.preventDefault(); if (!invalidRange) setRange({ from, to, departmentId: selectedDepartmentID, categoryId: selectedCategoryID }); }}>
              <div className="grid gap-2"><Label htmlFor="analytics-from">From</Label><Input id="analytics-from" type="date" value={from} max={to || undefined} onChange={(event) => setFrom(event.target.value)} /></div>
              <div className="grid gap-2"><Label htmlFor="analytics-to">To</Label><Input id="analytics-to" type="date" value={to} min={from || undefined} onChange={(event) => setTo(event.target.value)} /></div>
              <div className="grid gap-2"><Label htmlFor="analytics-department">Department</Label><Select
                value={selectedDepartmentID === null ? "all" : String(selectedDepartmentID)}
                onValueChange={(value) => setSelectedDepartmentID(value === null || value === "all" ? null : Number(value))}
              >
                <SelectTrigger id="analytics-department" className="min-w-48  w-xs" aria-label="Filter by department">
                  <SelectValue className="capitalize">{selectedDepartmentID === null ? "All Departments" : allDepartments?.find(dept => dept.id === selectedDepartmentID)?.name}</SelectValue>
                </SelectTrigger>
                <SelectContent>
                  <SelectItem value="all">All departments</SelectItem>
                  {
                    allDepartments && allDepartments.map(dept => <SelectItem key={dept.id} value={String(dept.id)} className="capitalize">{dept.name}</SelectItem>)
                  }

                </SelectContent>
              </Select></div>
              <div className="grid gap-2"><Label htmlFor="analytics-categories">Categories</Label><Select
                value={selectedCategoryID === null ? "all" : String(selectedCategoryID)}
                onValueChange={(value) => setSelectedCategoryID(value === null || value === "all" ? null : Number(value))}
              >
                <SelectTrigger id="analytics-category" className="w-full min-w-48" aria-label="Filter by category">
                  <SelectValue className="capitalize">{selectedCategoryID === null ? "All Category" : allCategories?.find(category => category.id === selectedCategoryID)?.name}</SelectValue>
                </SelectTrigger>
                <SelectContent>
                  <SelectItem value="all">All Categories</SelectItem>
                  {
                    allCategories && allCategories.map(category => <SelectItem key={category.id} value={String(category.id)} className="capitalize w-full">{category.name}</SelectItem>)
                  }

                </SelectContent>
              </Select></div>
              <Button type="submit" disabled={loading || invalidRange}>Apply</Button>
              <Button type="button" variant="outline" disabled={loading} onClick={() => { setFrom(""); setTo(""); setSelectedDepartmentID(null); setSelectedCategoryID(null); setRange({ from: "", to: "", departmentId: null, categoryId: null }); }}>Reset</Button>
            </form>
            {invalidRange && <p role="alert" className="mt-3 text-sm text-destructive">From must be on or before To.</p>}
          </CardContent>
        </Card>
        {
          tickets && (
            <Card>
              <CardHeader><h1 className="text-2xl font-bold">Export</h1><p className="text-muted-foreground">Choose the correct option to download the filtered report.</p></CardHeader>
              <CardContent>
                <h1 className="text-2xl font-bold mt-2">Number of Filtered Tickets: <span className="text-4xl text-primary">{tickets?.length}</span></h1>
                <div className="mt-7 flex gap-3">
                  <Button className="w-1/2 h-10" onClick={() => {
                    if (tickets.length < 1) {
                      toast.error("No data available to export", {
                        richColors: true,
                        position: "top-center"
                      })
                    } else {
                      exportToExcel(tickets)
                    }
                  }}><IconFileExcel />Export to XLSX</Button>
                  <Button className="w-1/2 h-10" onClick={() => {
                    if (tickets.length < 1) {
                      toast.error("No data available to export", {
                        richColors: true,
                        position: "top-center"
                      })
                    } else {
                      exportToPDF(tickets)
                    }
                  }}><IconPdf />Export to PDF</Button>
                </div>
              </CardContent>
            </Card>
          )
        }

        <section aria-label="Analytics results" aria-busy={loading} className="flex flex-col gap-6">
          {loading ? <p role="status" className="py-16 text-center text-muted-foreground">Loading analytics...</p> : error ? <Card><CardContent className="flex flex-wrap items-center justify-between gap-4"><p role="alert" className="text-destructive">{error}</p><Button onClick={() => setRange({ ...range })}>Retry</Button></CardContent></Card> : data && <>
            <p className="text-sm text-black">Showing: {range.from || "All dates"} to {range.to || "Present"}</p>
            <div className="grid gap-4 sm:grid-cols-2 xl:grid-cols-4">
              {([
                ["Total", data.summary.total_tickets], ["Pending", data.summary.pending_tickets],
                ["Resolved", data.summary.resolved_tickets], ["Escalated", data.summary.escalated_tickets],
              ] as const).map(([title, count]) => <Card key={title}><CardHeader><CardTitle className="text-muted-foreground">{title}</CardTitle></CardHeader><CardContent className="text-3xl font-bold tabular-nums">{number.format(count)}</CardContent></Card>)}
            </div>
            <div className="grid gap-6 xl:grid-cols-2">
              <div className="col-span-full">
                <Panel title="Queries Over Time" empty={!data.trend.length}>
                  <div className="h-72"><ResponsiveContainer width="100%" height="100%">
                    <LineChart accessibilityLayer data={data.trend} margin={{ top: 12, right: 20, left: 0, bottom: 8 }}>
                      <CartesianGrid vertical={false} strokeDasharray="3 3" />
                      <XAxis dataKey="date" tickFormatter={dateLabel} minTickGap={32} /><YAxis allowDecimals={false} width={45} />
                      <Tooltip /><Line type="linear" dataKey="count" name="Queries" stroke={colors[0]} strokeWidth={2} dot={{ r: 3 }} />
                    </LineChart>
                  </ResponsiveContainer></div>
                </Panel>
              </div>
              <Panel title="Query Status Distribution" empty={!data.status.some((item) => item.count > 0)}><Distribution data={data.status} /></Panel>
              <Panel title="Queries by Channel" empty={!data.channel.length}><HorizontalBars data={data.channel} /></Panel>
              <Panel title="Queries by Category" empty={!data.category.length}><HorizontalBars data={data.category} /></Panel>
              <Panel title="Queries by Department" empty={!data.department.length}><HorizontalBars data={data.department} /></Panel>
              <Panel title="Priority Distribution" empty={!data.priority.some((item) => item.count > 0)}><Distribution data={data.priority} /></Panel>
              <Panel title="Escalation Statistics" empty={false}>
                <div className="mb-4"><p className="text-3xl font-bold">{data.escalations.escalation_rate}</p><p className="text-sm text-muted-foreground">of queries escalated</p></div>
                <HorizontalBars data={[{ name: "Escalated", count: data.escalations.total_escalated }, { name: "Not escalated", count: data.escalations.not_escalated }]} />
              </Panel>
            </div>
          </>}
        </section>
        <div className="py-2 rounded-2xl pt-5 bg-white">
          <DepartmentPerformanceTable data={departmentPerformance ? departmentPerformance : []} />
        </div>
      </main>
    </SidebarInset>
  </SidebarProvider>;
}
