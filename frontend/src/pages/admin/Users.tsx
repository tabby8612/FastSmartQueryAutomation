import { AppSidebar } from "@/components/dashboard/app-sidebar";
import { SiteHeader } from "@/components/dashboard/site-header";
import { SidebarInset, SidebarProvider } from "@/components/ui/sidebar";
import { useEffect, useMemo, useState } from "react";
import { useNavigate } from "react-router-dom";
import { useAuth } from "@/contexts/auth-context";
import api from "@/lib/axios";
import { UsersDataTable } from "@/components/admin/users-data-table";
import type { Department, User } from "@/types";
import { Button } from "@/components/ui/button";
import { IconUserPlus } from "@tabler/icons-react";
import { Card, CardContent, CardHeader } from "@/components/ui/card";
import { Label } from "@/components/ui/label";
import { Input } from "@/components/ui/input";
import {
  Select,
  SelectContent,
  SelectItem,
  SelectTrigger,
  SelectValue,
} from "@/components/ui/select";
import { isAxiosError } from "axios";

export function Users() {
  const { role_name, access_token, logout } = useAuth();
  const navigate = useNavigate();
  const [users, setUsers] = useState<User[]>([]);
  const [allDepartments, setAllDepartments] = useState<Department[] | null>(null)
  const [loading, setLoading] = useState(true);
  const [from, setFrom] = useState("");
  const [to, setTo] = useState("");
  const [filters, setfilters] = useState<{
    from: string;
    to: string;
    nameEmail: string;
    role: string | null;
    dept_id: number | null
  }>({
    from: "",
    to: "",
    nameEmail: "",
    role: null,
    dept_id: null
  });
  const [nameEmailSearch, setNameEmailSearch] = useState("");
  const [selectedRole, setSelectedRole] = useState<string | null>(null);
  const [selectedDepartmentID, setSelectedDepartmentID] = useState<number|null>(null)

  const invalidRange = Boolean(from && to && from > to);

  const allRoles = useMemo(() => ["student", "officer", "hod", "admin"], []);

  useEffect(() => {
    const config = {
      headers: {
        Authorization: `Bearer ${access_token}`,
      },
      params: {
        start_date: filters.from || undefined,
        end_date: filters.to || undefined,
        name_email: filters.nameEmail || undefined,
        role: filters.role || undefined,
        dept_id: filters.dept_id || undefined
      },
    };

    const fetchQueries = async () => {
      try {
        const response = await api.get<User[]>("/users", config);
        setUsers(response.data);
      } catch (error) {
        console.error("Failed to fetch queries:", error);

        if (isAxiosError(error) && error.status == 408) {
          logout()
          navigate("/")          
        }
      } finally {
        setLoading(false);
      }
    };

    const fetchDepartments = async () => {
      try {
        const dept_response = await api.get<Department[]>("/departments/", { headers: config.headers })

        setAllDepartments(dept_response.data)        
      } catch (error) {

        console.error("Failed to fetch department:", error);        
      }
    }

    if (!allDepartments) fetchDepartments()

    fetchQueries();
  }, [filters, access_token]);

  const allUsers = users;

  return (
    <SidebarProvider
      style={
        {
          "--sidebar-width": "calc(var(--spacing) * 60)",
          "--header-height": "calc(var(--spacing) * 20)",
        } as React.CSSProperties
      }
    >
      <AppSidebar variant="inset" roleName={role_name} />
      <SidebarInset>
        <SiteHeader />
        <div className="flex flex-1 flex-col">
          <div className="@container/main flex flex-1 flex-col gap-2">
            <div className="flex flex-col gap-4 py-4 md:gap-6 md:py-6">
              <div className="md:py-6 py-3 bg-white mx-5 px-6 rounded-2xl flex flex-col gap-5">
                <div className="flex flex-col gap-4 md:flex-row md:items-center md:justify-between">
                  <div className="flex flex-col gap-5">
                    <h1 className="text-3xl font-bold">All Users</h1>
                    <p className="text-muted-foreground text-xl">
                      Here is the overview of all users
                    </p>
                  </div>
                  <div className="flex flex-col gap-3 sm:flex-row">
                    <Button
                      onClick={() => navigate("/admin/users/create-student")}
                    >
                      <IconUserPlus />
                      Create Student
                    </Button>
                    <Button
                      onClick={() => navigate("/admin/users/create-officer")}
                    >
                      <IconUserPlus />
                      Create Officer
                    </Button>
                    <Button
                      onClick={() => navigate("/admin/users/create-hod")}
                    >
                      <IconUserPlus />
                      Create Hod
                    </Button>
                    <Button
                      onClick={() => navigate("/admin/users/create-admin")}
                    >
                      <IconUserPlus />
                      Create Admin
                    </Button>
                  </div>
                </div>
              </div>
              <Card className="md:py-6 py-3 bg-white mx-5 px-6 rounded-2xl flex flex-col gap-5">
                <CardHeader>
                  <h1 className="text-2xl font-bold">User Filters</h1>
                  <p className="text-muted-foreground">
                    User by joining date. Leave dates blank to view all time.
                  </p>
                </CardHeader>
                <CardContent>
                  <form
                    className="flex flex-wrap items-end gap-4"
                    onSubmit={(event) => {
                      event.preventDefault();
                      if (!invalidRange)
                        setfilters({
                          to: to,
                          from: from,
                          nameEmail: nameEmailSearch,
                          role: selectedRole,
                          dept_id: selectedDepartmentID
                        });
                    }}
                  >
                    <div className="grid gap-2">
                      <Label htmlFor="analytics-from">From</Label>
                      <Input
                        id="analytics-from"
                        type="date"
                        value={from}
                        max={to || undefined}
                        onChange={(event) => setFrom(event.target.value)}
                      />
                    </div>
                    <div className="grid gap-2">
                      <Label htmlFor="analytics-to">To</Label>
                      <Input
                        id="analytics-to"
                        type="date"
                        value={to}
                        min={from || undefined}
                        onChange={(event) => setTo(event.target.value)}
                      />
                    </div>
                    <div className="grid gap-2">
                      <Label htmlFor="nameEmailSearch">Name/Email</Label>
                      <Input
                        id="nameEmailSearch"
                        type="text"
                        placeholder="Search by name or email"
                        value={nameEmailSearch}
                        onChange={(e) => setNameEmailSearch(e.target.value)}
                      />
                    </div>
                    <div className="grid gap-2">
                      <Label htmlFor="analytics-role">Role</Label>
                      <Select
                        value={selectedRole === null ? "all" : selectedRole}
                        onValueChange={(value) =>
                          setSelectedRole(
                            value === null || value === "all" ? null : value,
                          )
                        }
                      >
                        <SelectTrigger
                          id="analytics-role"
                          className="min-w-48"
                          aria-label="Filter by Role"
                        >
                          <SelectValue className="capitalize">
                            {selectedRole === null
                              ? "All Roles"
                              : allRoles?.find((role) => role === selectedRole)}
                          </SelectValue>
                        </SelectTrigger>
                        <SelectContent>
                          <SelectItem value="all">All Roles</SelectItem>
                          {allRoles &&
                            allRoles.map((role) => (
                              <SelectItem
                                key={role}
                                value={role}
                                className="capitalize"
                              >
                                {role}
                              </SelectItem>
                            ))}
                        </SelectContent>
                      </Select>
                    </div>
                    
                    <div className="grid gap-2">
                      <Label htmlFor="department">Department</Label>
                      <Select
                        value={
                          selectedDepartmentID === null
                            ? "all"
                            : String(selectedDepartmentID)
                        }
                        onValueChange={(value) =>
                          setSelectedDepartmentID(
                            value === null || value === "all"
                              ? null
                              : Number(value),
                          )
                        }
                      >
                        <SelectTrigger
                          id="analytics-department"
                          className="min-w-48  w-xs"
                          aria-label="Filter by department"
                        >
                          <SelectValue className="capitalize">
                            {selectedDepartmentID === null
                              ? "All Departments"
                              : allDepartments?.find(
                                  (dept) => dept.id === selectedDepartmentID,
                                )?.name}
                          </SelectValue>
                        </SelectTrigger>
                        <SelectContent>
                          <SelectItem value="all">All departments</SelectItem>
                          {allDepartments &&
                            allDepartments.map((dept) => (
                              <SelectItem
                                key={dept.id}
                                value={String(dept.id)}
                                className="capitalize"
                              >
                                {dept.name}
                              </SelectItem>
                            ))}
                        </SelectContent>
                      </Select>
                    </div>

                    <Button type="submit" disabled={loading || invalidRange}>
                      Apply
                    </Button>
                    <Button
                      type="button"
                      variant="outline"
                      disabled={loading}
                      onClick={() => {
                        setFrom("");
                        setTo("");
                        setNameEmailSearch("");
                        setSelectedRole(null);
                        setfilters({
                          to: "",
                          from: "",
                          nameEmail: "",
                          role: "",
                          dept_id: null
                          
                        });
                      }}
                    >
                      Reset
                    </Button>
                  </form>
                  {invalidRange && (
                    <p role="alert" className="mt-3 text-sm text-destructive">
                      From must be on or before To.
                    </p>
                  )}
                </CardContent>
              </Card>
              <div className="py-2 mx-6 rounded-2xl pt-5 bg-white">
                {loading ? (
                  <p className="px-6 py-4 text-muted-foreground">
                    Loading users...
                  </p>
                ) : (
                  <UsersDataTable data={allUsers} />
                )}
              </div>
            </div>
          </div>
        </div>
      </SidebarInset>
    </SidebarProvider>
  );
}
