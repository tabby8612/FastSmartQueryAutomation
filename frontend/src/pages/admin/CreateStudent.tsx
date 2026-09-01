import { useState } from "react"
import { useNavigate } from "react-router-dom"
import { IconArrowLeft, IconDeviceFloppy } from "@tabler/icons-react"

import { AppSidebar } from "@/components/dashboard/app-sidebar"
import { SiteHeader } from "@/components/dashboard/site-header"
import { Button } from "@/components/ui/button"
import { Input } from "@/components/ui/input"
import { Label } from "@/components/ui/label"
import { SidebarInset, SidebarProvider } from "@/components/ui/sidebar"
import { Switch } from "@/components/ui/switch"
import { useAuth } from "@/contexts/auth-context"
import api from "@/lib/axios"

type StudentFormErrors = {
  student_id?: string
  name?: string
  email?: string
  password?: string
}

export function CreateStudent() {
  const { role_name, access_token } = useAuth()
  const navigate = useNavigate()
  const [studentId, setStudentId] = useState("")
  const [name, setName] = useState("")
  const [email, setEmail] = useState("")
  const [password, setPassword] = useState("")
  const [errors, setErrors] = useState<StudentFormErrors>({})
  const [submissionError, setSubmissionError] = useState("")
  const [successMessage, setSuccessMessage] = useState("")
  const [submitting, setSubmitting] = useState(false)

  const clearFieldError = (field: keyof StudentFormErrors) => {
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
    setSubmitting(true)

    try {
      await api.post(
        "/users/create_student",
        {
          student_id: studentId,
          full_name: name,
          email,
          password,
        },
        {
          headers: { Authorization: `Bearer ${access_token}` },
        }
      )

      setSuccessMessage("Student created successfully.")
      setStudentId("")
      setName("")
      setEmail("")
      setPassword("")
    } catch (error: any) {
      const detail = error.response?.data?.detail
      const fieldErrors: StudentFormErrors = {}

      if (Array.isArray(detail)) {
        detail.forEach((err: any) => {
          const field = err.loc?.at(-1)
          if (field === "student_id") fieldErrors.student_id = err.msg
          if (field === "full_name") fieldErrors.name = err.msg
          if (field === "email") fieldErrors.email = err.msg
          if (field === "password") fieldErrors.password = err.msg
        })
      } else if (typeof detail === "string") {
        setSubmissionError(detail)
      } else {
        setSubmissionError("Failed to create student. Please try again.")
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
                <h1 className="text-3xl font-bold">Create Student</h1>
                <p className="text-muted-foreground text-xl">
                  Add a new student account
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
                      <Label htmlFor="student_id">Student ID</Label>
                      <Input
                        id="student_id"
                        value={studentId}
                        onChange={(e) => {
                          setStudentId(e.target.value)
                          clearFieldError("student_id")
                        }}
                        placeholder="Enter student ID"
                        className="border-stone-500"
                        required
                      />
                      {errors.student_id && <p className="text-sm text-red-500">{errors.student_id}</p>}
                    </div>

                    <div className="flex flex-col gap-2">
                      <Label htmlFor="name">Name</Label>
                      <Input
                        id="name"
                        value={name}
                        onChange={(e) => {
                          setName(e.target.value)
                          clearFieldError("name")
                        }}
                        placeholder="Enter student name"
                        className="border-stone-500"
                        required
                      />
                      {errors.name && <p className="text-sm text-red-500">{errors.name}</p>}
                    </div>
                  </div>

                  <div className="grid gap-5 md:grid-cols-2">
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
                        placeholder="Enter student email"
                        className="border-stone-500"
                        required
                      />
                      {errors.email && <p className="text-sm text-red-500">{errors.email}</p>}
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
                      <Label htmlFor="is_student">Student Account</Label>
                      <p className="text-sm text-muted-foreground">Student role is always enabled for this page.</p>
                    </div>
                    <Switch id="is_student" checked disabled aria-label="Student account" />
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
                    <Button type="submit" className="w-1/2" disabled={submitting}>
                      <IconDeviceFloppy />
                      {submitting ? "Creating..." : "Create Student"}
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
