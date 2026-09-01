import { useEffect, useState } from "react"
import { useNavigate } from "react-router-dom"
import { IconArrowLeft, IconDeviceFloppy } from "@tabler/icons-react"

import { AppSidebar } from "@/components/dashboard/app-sidebar"
import { SiteHeader } from "@/components/dashboard/site-header"
import { Button } from "@/components/ui/button"
import { Input } from "@/components/ui/input"
import { Label } from "@/components/ui/label"
import {
  Select,
  SelectContent,
  SelectItem,
  SelectTrigger,
  SelectValue,
} from "@/components/ui/select"
import { SidebarInset, SidebarProvider } from "@/components/ui/sidebar"
import { Switch } from "@/components/ui/switch"
import { Textarea } from "@/components/ui/textarea"
import { useAuth } from "@/contexts/auth-context"
import api from "@/lib/axios"
import type { Department } from "@/types"

type OfficerFormErrors = {
  email?: string
  full_name?: string
  department_id?: string
  password?: string
  on_leave?: string
  auto_reply_message?: string
  leave_start_day?: string
  leave_end_day?: string
}

export function CreateOfficer() {
  const { role_name, access_token } = useAuth()
  const navigate = useNavigate()
  const [departments, setDepartments] = useState<Department[]>([])
  const [departmentsLoading, setDepartmentsLoading] = useState(true)
  const [email, setEmail] = useState("")
  const [fullName, setFullName] = useState("")
  const [departmentId, setDepartmentId] = useState("")
  const [password, setPassword] = useState("")
  const [onLeave, setOnLeave] = useState(false)
  const [leaveStartDate, setLeaveStartDate] = useState("")
  const [leaveEndDate, setLeaveEndDate] = useState("")
  const [autoReplyMessage, setAutoReplyMessage] = useState("")
  const [errors, setErrors] = useState<OfficerFormErrors>({})
  const [submissionError, setSubmissionError] = useState("")
  const [successMessage, setSuccessMessage] = useState("")
  const [submitting, setSubmitting] = useState(false)

  useEffect(() => {
    const fetchDepartments = async () => {
      try {
        const response = await api.get<Department[]>("/departments", {
          headers: { Authorization: `Bearer ${access_token}` },
        })
        setDepartments(response.data)
      } catch (error) {
        console.error("Failed to fetch departments:", error)
        setSubmissionError("Failed to load departments.")
      } finally {
        setDepartmentsLoading(false)
      }
    }

    fetchDepartments()
  }, [access_token])

  const clearFieldError = (field: keyof OfficerFormErrors) => {
    if (errors[field]) {
      setErrors((prev) => ({ ...prev, [field]: undefined }))
    }
    if (submissionError) setSubmissionError("")
    if (successMessage) setSuccessMessage("")
  }

  const handleSubmit = async (e: React.FormEvent<HTMLFormElement>) => {
    e.preventDefault()
    setErrors({})
    setSubmissionError("")
    setSuccessMessage("")

    if (!departmentId) {
      setErrors({ department_id: "Please select a department." })
      return
    }

    setSubmitting(true)

    try {
      await api.post(
        "/users/create_officer",
        {
          email,
          full_name: fullName,
          department_id: Number(departmentId),
          password,
          on_leave: onLeave,
          leave_start_day: onLeave ? leaveStartDate || null : null,
          leave_end_day: onLeave ? leaveEndDate || null : null,
          auto_reply_message: autoReplyMessage || null,
        },
        {
          headers: { Authorization: `Bearer ${access_token}` },
        }
      )

      setSuccessMessage("Officer created successfully.")
      setEmail("")
      setFullName("")
      setDepartmentId("")
      setPassword("")
      setOnLeave(false)
      setLeaveStartDate("")
      setLeaveEndDate("")
      setAutoReplyMessage("")
    } catch (error: any) {
      const detail = error.response?.data?.detail
      const fieldErrors: OfficerFormErrors = {}

      if (Array.isArray(detail)) {
        detail.forEach((err: any) => {
          const field = err.loc?.at(-1)
          if (field === "email") fieldErrors.email = err.msg
          if (field === "full_name") fieldErrors.full_name = err.msg
          if (field === "department_id") fieldErrors.department_id = err.msg
          if (field === "password") fieldErrors.password = err.msg
          if (field === "on_leave") fieldErrors.on_leave = err.msg
          if (field === "leave_start_day") fieldErrors.leave_start_day = err.msg
          if (field === "leave_end_day") fieldErrors.leave_end_day = err.msg
          if (field === "auto_reply_message") fieldErrors.auto_reply_message = err.msg
        })
      } else if (typeof detail === "string") {
        setSubmissionError(detail)
      } else {
        setSubmissionError("Failed to create officer. Please try again.")
      }

      setErrors(fieldErrors)
    } finally {
      setSubmitting(false)
    }
  }

  return (
    <SidebarProvider
      style={
        {
          "--sidebar-width": "calc(var(--spacing) * 72)",
          "--header-height": "calc(var(--spacing) * 16)",
        } as React.CSSProperties
      }
    >
      <AppSidebar variant="inset" roleName={role_name} />
      <SidebarInset>
        <SiteHeader />
        <div className="flex flex-1 flex-col">
          <div className="@container/main flex flex-1 flex-col gap-2">
            <div className="flex flex-col gap-4 py-4 md:gap-6 md:py-6">
              <div className="md:py-6 bg-white mx-5 px-6 rounded-2xl flex flex-col gap-5">
                <h1 className="text-3xl font-bold">Create Officer</h1>
                <p className="text-muted-foreground text-xl">
                  Add a new officer account
                </p>
              </div>

              <div className="py-6 mx-6 rounded-2xl bg-white">
                <form onSubmit={handleSubmit} className="mx-auto flex w-full max-w-2xl flex-col gap-5 px-6">
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
                          setFullName(e.target.value)
                          clearFieldError("full_name")
                        }}
                        placeholder="Enter officer name"
                        className="border-stone-500"
                        required
                      />
                      {errors.full_name && <p className="text-sm text-red-500">{errors.full_name}</p>}
                    </div>

                    <div className="flex flex-col gap-2">
                      <Label htmlFor="email">Email</Label>
                      <Input
                        id="email"
                        type="email"
                        value={email}
                        onChange={(e) => {
                          setEmail(e.target.value)
                          clearFieldError("email")
                        }}
                        placeholder="Enter officer email"
                        className="border-stone-500"
                        required
                      />
                      {errors.email && <p className="text-sm text-red-500">{errors.email}</p>}
                    </div>
                  </div>

                  <div className="grid gap-5 md:grid-cols-2">
                    <div className="flex flex-col gap-2">
                      <Label htmlFor="department_id">Department</Label>
                      <Select
                        value={departmentId}
                        onValueChange={(value) => {
                          setDepartmentId(value ?? "")
                          clearFieldError("department_id")
                        }}
                      >
                        <SelectTrigger id="department_id" className="w-full border-stone-500">
                          <SelectValue placeholder={departmentsLoading ? "Loading departments..." : "Select department"} />
                        </SelectTrigger>
                        <SelectContent>
                          {departments.map((department) => (
                            <SelectItem key={department.id} value={`${department.id}`}>
                              {department.name}
                            </SelectItem>
                          ))}
                        </SelectContent>
                      </Select>
                      {errors.department_id && <p className="text-sm text-red-500">{errors.department_id}</p>}
                    </div>

                    <div className="flex flex-col gap-2">
                      <Label htmlFor="password">Password</Label>
                      <Input
                        id="password"
                        type="password"
                        value={password}
                        onChange={(e) => {
                          setPassword(e.target.value)
                          clearFieldError("password")
                        }}
                        placeholder="Enter password"
                        className="border-stone-500"
                        required
                      />
                      {errors.password && <p className="text-sm text-red-500">{errors.password}</p>}
                    </div>
                  </div>

                  <div className="flex items-center justify-between rounded-lg border border-stone-300 px-3 py-3">
                    <div className="flex flex-col gap-1">
                      <Label htmlFor="is_officer">Officer Account</Label>
                      <p className="text-sm text-muted-foreground">Officer role is always enabled for this page.</p>
                    </div>
                    <Switch id="is_officer" checked disabled aria-label="Officer account" />
                  </div>

                  <div className="flex items-center justify-between rounded-lg border border-stone-300 px-3 py-3">
                    <div className="flex flex-col gap-1">
                      <Label htmlFor="on_leave">On Leave</Label>
                      <p className="text-sm text-muted-foreground">Enable leave dates for this officer.</p>
                    </div>
                    <Switch
                      id="on_leave"
                      checked={onLeave}
                      onCheckedChange={(checked) => {
                        setOnLeave(checked)
                        clearFieldError("on_leave")
                        if (!checked) {
                          setLeaveStartDate("")
                          setLeaveEndDate("")
                        }
                      }}
                      aria-label="On leave"
                    />
                  </div>
                  {errors.on_leave && <p className="-mt-3 text-sm text-red-500">{errors.on_leave}</p>}

                  <div className="grid gap-5 md:grid-cols-2">
                    <div className="flex flex-col gap-2">
                      <Label htmlFor="leave_start_day">Leave Start Date</Label>
                      <Input
                        id="leave_start_day"
                        type="date"
                        value={leaveStartDate}
                        onChange={(e) => {
                          setLeaveStartDate(e.target.value)
                          clearFieldError("leave_start_day")
                        }}
                        className="border-stone-500"
                        disabled={!onLeave}
                      />
                      {errors.leave_start_day && <p className="text-sm text-red-500">{errors.leave_start_day}</p>}
                    </div>

                    <div className="flex flex-col gap-2">
                      <Label htmlFor="leave_end_day">Leave End Date</Label>
                      <Input
                        id="leave_end_day"
                        type="date"
                        value={leaveEndDate}
                        onChange={(e) => {
                          setLeaveEndDate(e.target.value)
                          clearFieldError("leave_end_day")
                        }}
                        className="border-stone-500"
                        disabled={!onLeave}
                      />
                      {errors.leave_end_day && <p className="text-sm text-red-500">{errors.leave_end_day}</p>}
                    </div>
                  </div>

                  <div className="flex flex-col gap-2">
                    <Label htmlFor="auto_reply_message">Auto Reply Message</Label>
                    <Textarea
                      id="auto_reply_message"
                      value={autoReplyMessage}
                      onChange={(e) => {
                        setAutoReplyMessage(e.target.value)
                        clearFieldError("auto_reply_message")
                      }}
                      placeholder="Enter auto reply message"
                      className="min-h-28 border-stone-500"
                    />
                    {errors.auto_reply_message && <p className="text-sm text-red-500">{errors.auto_reply_message}</p>}
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
                    <Button type="submit" className="w-1/2" disabled={submitting || departmentsLoading}>
                      <IconDeviceFloppy />
                      {submitting ? "Creating..." : "Create Officer"}
                    </Button>
                  </div>
                </form>
              </div>
            </div>
          </div>
        </div>
      </SidebarInset>
    </SidebarProvider>
  )
}
