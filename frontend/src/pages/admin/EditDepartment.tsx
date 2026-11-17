import { useEffect, useState, type FormEvent } from "react";
import { useNavigate, useParams } from "react-router-dom";
import { IconArrowLeft, IconDeviceFloppy } from "@tabler/icons-react";

import { AppSidebar } from "@/components/dashboard/app-sidebar";
import { SiteHeader } from "@/components/dashboard/site-header";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import {
  Select,
  SelectContent,
  SelectItem,
  SelectTrigger,
  SelectValue,
} from "@/components/ui/select";
import { SidebarInset, SidebarProvider } from "@/components/ui/sidebar";
import { useAuth } from "@/contexts/auth-context";
import api from "@/lib/axios";
import type { Department } from "@/types";

type OfficerOption = { id: number; full_name: string };

export function EditDepartment() {
  const { departmentId } = useParams<{ departmentId: string }>();
  const { role_name, access_token } = useAuth();
  const navigate = useNavigate();
  const [department, setDepartment] = useState<Department | null>(null);
  const [officers, setOfficers] = useState<OfficerOption[]>([]);
  const [name, setName] = useState("");
  const [description, setDescription] = useState("");
  const [hodId, setHodId] = useState<string | null>(null);
  const [loading, setLoading] = useState(true);
  const [saving, setSaving] = useState(false);
  const [error, setError] = useState("");
  const [success, setSuccess] = useState("");

  useEffect(() => {
    if (!departmentId || !access_token) return;
    let cancelled = false;
    const headers = { Authorization: `Bearer ${access_token}` };

    async function loadDepartment() {
      try {
        const [departmentResponse, officersResponse] = await Promise.all([
          api.get<Department>(`/departments/${departmentId}`, { headers }),
          api.get<OfficerOption[]>(
            `/users/department_officers/${departmentId}`,
            { headers },
          ),
        ]);
        if (cancelled) return;
        const currentDepartment = departmentResponse.data;
        setDepartment(currentDepartment);
        setName(currentDepartment.name);
        setDescription(currentDepartment.description ?? "");
        setHodId(
          currentDepartment.hod_id == null
            ? null
            : String(currentDepartment.hod_id),
        );
        setOfficers(officersResponse.data);
      } catch (requestError) {
        if (!cancelled)
          setError("Could not load this department. Please try again.");
        console.error("Failed to load department details", requestError);
      } finally {
        if (!cancelled) setLoading(false);
      }
    }

    loadDepartment();
    return () => {
      cancelled = true;
    };
  }, [departmentId, access_token]);

  async function handleSubmit(event: FormEvent<HTMLFormElement>) {
    event.preventDefault();
    if (!departmentId || !name.trim()) return;
    setSaving(true);
    setError("");
    setSuccess("");
    try {
      const response = await api.put<Department>(
        `/departments/${departmentId}`,
        {
          name: name.trim(),
          description: description.trim() || null,
          hod_id: hodId === null ? null : Number(hodId),
        },
        {
          headers: { Authorization: `Bearer ${access_token}` },
        },
      );
      setDepartment(response.data);
      setSuccess("Department updated successfully.");
    } catch (requestError) {
      console.error("Failed to update department", requestError);
      setError("Could not save department changes. Please try again.");
    } finally {
      setSaving(false);
    }
  }

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
        <main className="flex flex-1 flex-col gap-4 p-5 md:p-8">
          <section className="rounded-2xl bg-white px-6 py-5">
            <h1 className="text-3xl font-bold">Edit Department</h1>
            <p className="mt-2 text-muted-foreground">
              Update department details and assign its HOD.
            </p>
          </section>
          <section className="rounded-2xl bg-white p-6">
            {loading ? (
              <p>Loading department…</p>
            ) : !department ? (
              <div className="space-y-4">
                <p role="alert" className="text-red-700">
                  {error || "Department not found."}
                </p>
                <Button
                  variant="outline"
                  onClick={() => navigate("/admin/department")}
                >
                  Back to departments
                </Button>
              </div>
            ) : (
              <form
                onSubmit={handleSubmit}
                className="mx-auto flex w-full max-w-2xl flex-col gap-5"
              >
                {error && (
                  <p
                    role="alert"
                    className="rounded bg-red-100 px-3 py-2 text-red-800"
                  >
                    {error}
                  </p>
                )}
                {success && (
                  <p
                    role="status"
                    className="rounded bg-green-100 px-3 py-2 text-green-800"
                  >
                    {success}
                  </p>
                )}
                <div className="flex flex-col gap-2">
                  <Label htmlFor="department-name">Department name</Label>
                  <Input
                    id="department-name"
                    value={name}
                    onChange={(event) => setName(event.target.value)}
                    required
                  />
                </div>
                <div className="flex flex-col gap-2">
                  <Label htmlFor="department-description">Description</Label>
                  <Input
                    id="department-description"
                    value={description}
                    onChange={(event) => setDescription(event.target.value)}
                  />
                </div>
                <div className="flex flex-col gap-2">
                  <Label htmlFor="department-hod">Head of Department</Label>
                  <Select
                    value={hodId}
                    onValueChange={(value) => setHodId(value ? String(value) : null)}
                  >
                    <SelectTrigger id="department-hod" className="w-full">
                      <SelectValue className="capitalize">
                        {
                          hodId == null ? "Select Officer" : officers.find(officer => officer.id === +hodId)?.full_name 
                        }
                      </SelectValue>
                    </SelectTrigger>
                    <SelectContent>
                      <SelectItem value="none">No HOD assigned</SelectItem>
                      {officers.map((officer) => (
                        <SelectItem key={officer.id} value={String(officer.id)}>
                          {officer.full_name}
                        </SelectItem>
                      ))}
                    </SelectContent>
                  </Select>
                  {officers.length === 0 && (
                    <p className="text-sm text-muted-foreground">
                      No officers are assigned to this department yet.
                    </p>
                  )}
                </div>
                <div className="flex gap-3 pt-2">
                  <Button
                    type="button"
                    variant="outline"
                    onClick={() => navigate("/admin/department")}
                  >
                    <IconArrowLeft /> Back
                  </Button>
                  <Button type="submit" disabled={saving || !name.trim()}>
                    <IconDeviceFloppy />
                    {saving ? "Saving…" : "Save changes"}
                  </Button>
                </div>
              </form>
            )}
          </section>
        </main>
      </SidebarInset>
    </SidebarProvider>
  );
}
