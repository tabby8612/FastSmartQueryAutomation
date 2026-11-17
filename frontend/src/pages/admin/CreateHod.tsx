import { useEffect, useState } from "react";
import { useNavigate } from "react-router-dom";
import { IconArrowLeft, IconDeviceFloppy } from "@tabler/icons-react";

import { AppSidebar } from "@/components/dashboard/app-sidebar";
import { SiteHeader } from "@/components/dashboard/site-header";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { SidebarInset, SidebarProvider } from "@/components/ui/sidebar";
import { Switch } from "@/components/ui/switch";
import { useAuth } from "@/contexts/auth-context";
import api from "@/lib/axios";
import {
  Select,
  SelectContent,
  SelectItem,
  SelectTrigger,
  SelectValue,
} from "@/components/ui/select";
import { isAxiosError } from "axios";
import type { Department } from "@/types";

type HodFormErrors = {
  full_name?: string;
  email?: string;
  password?: string;
  department_id?: string;
};

export function CreateHod() {
  const { role_name, access_token } = useAuth();
  const navigate = useNavigate();
  const [fullName, setFullName] = useState("");
  const [email, setEmail] = useState("");
  const [password, setPassword] = useState("");
  const [selectedDepartmentID, setSelectedDepartmentID] = useState<
    number | null
  >(null);
  const [errors, setErrors] = useState<HodFormErrors>({});
  const [submissionError, setSubmissionError] = useState("");
  const [successMessage, setSuccessMessage] = useState("");
  const [submitting, setSubmitting] = useState(false);
  const [allDepartments, setAllDepartments] = useState<Department[] | null>(
    null,
  );

  useEffect(() => {
    async function fetchDepartments() {
      try {
        const response = await api.get("/departments/", {
          headers: { Authorization: `Bearer ${access_token}` },
        });

        setAllDepartments(response.data);
      } catch (error) {
        if (isAxiosError(error) && error.status == 408) navigate("/");

        console.error(error);

        if (isAxiosError(error)) {
          setSubmissionError(error.response?.data?.detail);
        }
      }
    }

    fetchDepartments();
  }, [access_token, navigate]);

  const clearFieldError = (field: keyof HodFormErrors) => {
    if (errors[field]) {
      setErrors((prev) => ({ ...prev, [field]: undefined }));
    }
    if (submissionError) setSubmissionError("");
    if (successMessage) setSuccessMessage("");
  };

  const handleSubmit = async (e: React.FormEvent<HTMLFormElement>) => {
    e.preventDefault();
    setErrors({});
    setSubmissionError("");
    setSuccessMessage("");
    setSubmitting(true);

    console.log({
          full_name: fullName,
          email,
          password,
          department_id: selectedDepartmentID,
        })

    try {
      await api.post(
        "/users/create_hod",
        {
          full_name: fullName,
          email,
          password,
          department_id: selectedDepartmentID,
        },
        {
          headers: { Authorization: `Bearer ${access_token}` },
        },
      );

      setSuccessMessage("HOD created successfully.");
      setFullName("");
      setEmail("");
      setPassword("");
      setSelectedDepartmentID(null);
    } catch (error: any) {
      const detail = error.response?.data?.detail;
      const fieldErrors: HodFormErrors = {};

      if (Array.isArray(detail)) {
        detail.forEach((err: any) => {
          const field = err.loc?.at(-1);
          if (field === "full_name") fieldErrors.full_name = err.msg;
          if (field === "email") fieldErrors.email = err.msg;
          if (field === "password") fieldErrors.password = err.msg;
        });
      } else if (typeof detail === "string") {
        setSubmissionError(detail);
      } else {
        setSubmissionError("Failed to create admin. Please try again.");
      }

      setErrors(fieldErrors);
    } finally {
      setSubmitting(false);
    }
  };

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
                <h1 className="text-3xl font-bold">Create HOD</h1>
                <p className="text-muted-foreground text-xl">
                  Add a new HOD account
                </p>
              </div>

              <div className="py-6 mx-6 rounded-2xl bg-white">
                <form
                  onSubmit={handleSubmit}
                  className="mx-auto flex w-full max-w-2xl flex-col gap-5 px-6"
                >
                  {submissionError && (
                    <div className="rounded-sm bg-red-200 px-3 py-2 text-center text-sm font-bold capitalize text-red-900">
                      {submissionError}
                    </div>
                  )}
                  {successMessage && (
                    <div className="rounded-sm bg-green-100 px-3 py-2 text-center text-sm font-bold text-green-800">
                      {successMessage}
                    </div>
                  )}

                  <div className="grid gap-5 md:grid-cols-2">
                    <div className="flex flex-col gap-2">
                      <Label htmlFor="full_name">Name</Label>
                      <Input
                        id="full_name"
                        value={fullName}
                        onChange={(e) => {
                          setFullName(e.target.value);
                          clearFieldError("full_name");
                        }}
                        placeholder="Enter HOD name"
                        className="border-stone-500"
                        required
                      />
                      {errors.full_name && (
                        <p className="text-sm text-red-500">
                          {errors.full_name}
                        </p>
                      )}
                    </div>

                    <div className="flex flex-col gap-2">
                      <Label htmlFor="email">Email</Label>
                      <Input
                        id="email"
                        type="email"
                        value={email}
                        onChange={(e) => {
                          setEmail(e.target.value);
                          clearFieldError("email");
                        }}
                        placeholder="Enter HOD email"
                        className="border-stone-500"
                        required
                      />
                      {errors.email && (
                        <p className="text-sm text-red-500">{errors.email}</p>
                      )}
                    </div>
                  </div>

                  <div className="grid gap-5 md:grid-cols-2">
                    <div className="flex flex-col gap-2">
                      <Label htmlFor="password">Password</Label>
                      <Input
                        id="password"
                        type="password"
                        value={password}
                        onChange={(e) => {
                          setPassword(e.target.value);
                          clearFieldError("password");
                        }}
                        placeholder="Enter password"
                        className="border-stone-500"
                        required
                      />
                      {errors.password && (
                        <p className="text-sm text-red-500">
                          {errors.password}
                        </p>
                      )}
                    </div>
                    <div className="flex flex-col gap-2">
                      <Label htmlFor="department">Department</Label>
                      <Select
                        value={
                          selectedDepartmentID === null
                            ? "all"
                            : String(selectedDepartmentID)
                        }
                        onValueChange={(value) => {
                          setSelectedDepartmentID(
                            value && value !== "all" ? Number(value) : null,
                          );
                          setErrors((prev) => ({
                            ...prev,
                            department_id: undefined,
                          }));
                        }}
                      >
                        <SelectTrigger
                          id="departments"
                          className="min-w-48  w-full border-stone-500"
                          aria-label="Filter by department"
                        >
                          <SelectValue className="capitalize">
                            {selectedDepartmentID === null
                              ? "Select Department"
                              : allDepartments?.find(
                                  (dept) => dept.id === selectedDepartmentID,
                                )?.name}
                          </SelectValue>
                        </SelectTrigger>
                        <SelectContent>
                          <SelectItem value="all">
                            Select Any Department
                          </SelectItem>
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
                      {errors.department_id && (
                        <p className="text-sm text-red-500">
                          {errors.department_id}
                        </p>
                      )}
                    </div>
                  </div>

                  <div className="flex items-center justify-between rounded-lg border border-stone-300 px-3 py-3">
                    <div className="flex flex-col gap-1">
                      <Label htmlFor="is_admin">HOD Account</Label>
                      <p className="text-sm text-muted-foreground">
                        HOD role is always enabled for this page.
                      </p>
                    </div>
                    <Switch
                      id="is_hod"
                      checked
                      disabled
                      aria-label="Admin account"
                    />
                  </div>

                  <div className="flex gap-4 pt-2">
                    <Button
                      type="button"
                      variant="outline"
                      className="w-1/2 bg-stone-300"
                      onClick={() => navigate("/admin/users")}
                    >
                      <IconArrowLeft />
                      Cancel
                    </Button>
                    <Button
                      type="submit"
                      className="w-1/2"
                      disabled={submitting}
                    >
                      <IconDeviceFloppy />
                      {submitting ? "Creating..." : "Create HOD"}
                    </Button>
                  </div>
                </form>
              </div>
            </div>
          </div>
        </div>
      </SidebarInset>
    </SidebarProvider>
  );
}
