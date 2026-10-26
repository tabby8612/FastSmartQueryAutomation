import { AppSidebar } from "@/components/dashboard/app-sidebar"
import { SiteHeader } from "@/components/dashboard/site-header"
import { SidebarInset, SidebarProvider } from "@/components/ui/sidebar"
import { useEffect, useState } from "react"
import { useAuth } from "@/contexts/auth-context"
import api from "@/lib/axios"
import type { AuditLog, AuditLogs, Option } from "@/types"
import { AuditLogsDataTable } from "@/components/admin/audit-logs-data-table"
import { Card, CardContent, CardHeader } from "@/components/ui/card"
import { Label } from "@/components/ui/label"
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from "@/components/ui/select"
import { Button } from "@/components/ui/button"
import { Input } from "@/components/ui/input"
import { isAxiosError } from "axios"
import { useNavigate } from "react-router-dom"


export function AuditLogs() {
    const { role_name, access_token } = useAuth()
    const [auditLogs, setAuditLogs] = useState<AuditLog[] | null>(null)
    const [loading, setLoading] = useState(true)
    const [filters, setFilters] = useState<{start_date: string | undefined, end_date: string | undefined, action: string | undefined, entity_type: string | undefined} | null>(null)
    const [range, setRange] = useState<{ from: string; to: string}>({ from: "", to: "" });
    const [from, setFrom] = useState("");
    const [to, setTo] = useState("");
    const invalidRange = Boolean(from && to && from > to);
    const [selectedAction, setSelectedAction] = useState<string | null>(null)
    const [selectedEntity, setSelectedEntity] = useState<string | null>(null)
    const [actions, setActions] = useState<Option[] | null>(null)
    const [entities, setEntities] = useState<Option[] | null>(null)
    const navigate = useNavigate()


    useEffect(() => {
        const fetchQueries = async () => {
            try {
                const response = await api.get<AuditLogs>("/admin/audit-logs", {
                    headers: {
                        Authorization: `Bearer ${access_token}`,
                    },
                    params: filters
                })
                setAuditLogs(response.data.items)

                const uniqueActions = Array.from(new Set(response.data.items.map(auditLog => auditLog.action)))
                const uniqueEntities = Array.from(new Set(response.data.items.map(auditLog => auditLog.entity_type)))

                setActions(uniqueActions.map(action => ({
                    "id": action,
                    "name": action.replace(".", " ")
                })).sort((a, b) => a.name.localeCompare(b.name)))
                
                setEntities(uniqueEntities.map(action => ({
                    "id": action,
                    "name": action.replace(".", " ")
                })).sort((a, b) => a.name.localeCompare(b.name)))


            } catch (error) {
                console.error("Failed to fetch queries:", error)

                if (isAxiosError(error) && error.status == 408) navigate("/")
            } finally {
                setLoading(false)
            }
        }

        fetchQueries()
    }, [access_token, filters])

    const auditReport = auditLogs

    console.log(filters)

    return (
        <SidebarProvider
            style={{
                "--sidebar-width": "calc(var(--spacing) * 72)",
                "--header-height": "calc(var(--spacing) * 16)",
            } as React.CSSProperties}
        >
            <AppSidebar variant="inset" roleName={role_name} />
            <SidebarInset>
                <SiteHeader />
                <div className="flex flex-1 flex-col">
                    <div className="@container/main flex flex-1 flex-col gap-2">
                        <div className="flex flex-col gap-4 py-4 md:gap-6 md:py-6">
                            <div className="md:py-6 bg-white mx-5 px-6 rounded-2xl flex flex-col gap-5">
                                <h1 className="text-3xl font-bold">Audit Logs</h1>
                                <p className="text-muted-foreground text-xl">
                                    Here is the events happened in past several hours
                                </p>
                            </div>
                            <Card className="md:py-6 mx-6"  >
                                <CardHeader><h1 className="text-3xl font-bold">Apply Filters</h1><p className="text-muted-foreground">Query activity by creation date. Leave dates blank to view all time.</p></CardHeader>
                                <CardContent>
                                    <form className="flex flex-wrap items-end gap-4" onSubmit={(event) => { event.preventDefault(); if (!invalidRange) setRange({ from, to }); setFilters({start_date: range.from ? range.from : undefined, end_date: range.to ? range.to : undefined, action: selectedAction ?? undefined, entity_type: selectedEntity ?? undefined})}}>
                                        <div className="grid gap-2"><Label htmlFor="analytics-from">From</Label><Input id="analytics-from" type="date" value={from} max={to || undefined} onChange={(event) => setFrom(event.target.value)} /></div>
                                        <div className="grid gap-2"><Label htmlFor="analytics-to">To</Label><Input id="analytics-to" type="date" value={to} min={from || undefined} onChange={(event) => setTo(event.target.value)} /></div>
                                        <div className="grid gap-2"><Label htmlFor="analytics-action">Action</Label><Select
                                            value={selectedAction === null ? "all" : selectedAction}
                                            onValueChange={(value) => setSelectedAction(value === null || value === "all" ? null : value)}
                                        >
                                            <SelectTrigger id="analytics-action" className="min-w-48  w-xs" aria-label="Filter by action">
                                                <SelectValue className="capitalize">{selectedAction === null ? "All Actions" : actions?.find(act => act.id === selectedAction)?.name}</SelectValue>
                                            </SelectTrigger>
                                            <SelectContent>
                                                <SelectItem value="all">All Actions</SelectItem>
                                                {
                                                    actions && actions.map(act => <SelectItem key={act.id} value={act.id} className="capitalize">{act.name}</SelectItem>)
                                                }

                                            </SelectContent>
                                        </Select></div>
                                        <div className="grid gap-2"><Label htmlFor="analytics-entity">Entity Type</Label><Select
                                            value={selectedEntity === null ? "all" : selectedEntity}
                                            onValueChange={(value) => setSelectedEntity(value === null || value === "all" ? null : value)}
                                        >
                                            <SelectTrigger id="analytics-entity" className="min-w-48  w-xs" aria-label="Filter by Entity">
                                                <SelectValue className="capitalize">{selectedEntity === null ? "All Entities" : entities?.find(ent => ent.id === selectedEntity)?.name}</SelectValue>
                                            </SelectTrigger>
                                            <SelectContent>
                                                <SelectItem value="all">All Entities</SelectItem>
                                                {
                                                    entities && entities.map(ent => <SelectItem key={ent.id} value={ent.id} className="capitalize">{ent.name}</SelectItem>)
                                                }

                                            </SelectContent>
                                        </Select></div>

                                        <Button type="submit" disabled={loading || invalidRange}>Apply</Button>
                                        <Button type="button" variant="outline" disabled={loading} onClick={() => { setFrom(""); setTo(""); setSelectedAction(null); setSelectedEntity(null); setRange({ from: "", to: "" }); }}>Reset</Button>
                                    </form>
                                    {invalidRange && <p role="alert" className="mt-3 text-sm text-destructive">From must be on or before To.</p>}
                                </CardContent>
                            </Card>
                            {
                                auditReport && (
                                    <div className="py-2 mx-6 rounded-2xl pt-5 bg-white">
                                        <AuditLogsDataTable data={auditReport} />
                                    </div>
                                )
                            }

                        </div>
                    </div>
                </div>
            </SidebarInset>
        </SidebarProvider>
    )
}
