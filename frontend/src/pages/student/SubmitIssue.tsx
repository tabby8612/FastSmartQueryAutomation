import { useEffect, useState } from "react"
import { useNavigate } from "react-router-dom"
import { AppSidebar } from "@/components/dashboard/app-sidebar"
import { SiteHeader } from "@/components/dashboard/site-header"
import { SidebarInset, SidebarProvider } from "@/components/ui/sidebar"
import { useAuth } from "@/contexts/auth-context"
import { Button } from "@/components/ui/button"
import { Input } from "@/components/ui/input"
import { Label } from "@/components/ui/label"
import api from "@/lib/axios"
import { Textarea } from "@/components/ui/textarea"

export default function SubmitIssue() {
  const { role_name, access_token } = useAuth()
  const navigate = useNavigate()
  const [subject, setSubject] = useState("")
  const [body, setBody] = useState("")
  const [successMessage, setSuccessMessage] = useState<string | null>(null)
  const [errors, setErrors] = useState<{ subject?: string; body?: string }>({})
  const [submissionError, setSubmissionError] = useState<string>("")

  useEffect(() => {
    if (successMessage) {
      const timer = setTimeout(() => {
        navigate("/student/dashboard")
      }, 10000)
      return () => clearTimeout(timer)
    }
  }, [successMessage, navigate])

  const handleSubmit = async (e: React.SubmitEvent) => {
    e.preventDefault()
    setErrors({})
    setSubmissionError("")
    try {
      const response = await api.post("/tickets/", { subject, body }, {
        headers: { Authorization: `Bearer ${access_token}` },
      })
      setSuccessMessage(response.data.message)
    } catch (error: any) {
      const fieldErrors: { subject?: string; body?: string } = {}
      const detail = error.response?.data?.detail
      if (Array.isArray(detail)) {
        detail.forEach((err: any) => {
          const field = err.loc?.[1] as string
          if (field === "subject" || field === "body") {
            fieldErrors[field] = err.msg
          }
        })
      } else {
        setSubmissionError(error.response?.data?.detail)
      }
      console.error(error.response?.data)
      setErrors(fieldErrors)
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
            <div className="flex flex-col bg-white h-full m-5 rounded-2xl gap-4 py-4 md:gap-6 md:py-6 px-4 lg:px-6">
              <div className="flex flex-col items-center justify-center  h-full m-5 p-5 rounded-2xl gap-4 py-4">
                {successMessage ? (
                  <div className="flex flex-col items-center gap-4">
                    <h1 className="text-4xl font-bold text-green-600">Success!</h1>
                    <p className="text-lg text-center">{successMessage}</p>
                    <p className="text-sm text-muted-foreground">Redirecting to dashboard in 10 seconds...</p>
                  </div>
                ) : (
                  <>
                <h1 className="text-4xl font-bold">Submit New Issue</h1>
                <p className="text-muted-foreground text-2xl">Tell us what problem you are facing</p>
                <form onSubmit={handleSubmit} className="flex flex-col gap-4 max-w-xl  w-full mt-5">
                  {
                    submissionError && (
                      <div className="bg-red-200 px-3 py-2 rounded-sm text-sm flex justify-center items-center">
                    <p className=" mx-auto capitalize font-bold">{submissionError}</p>
                  </div>
                    )
                  }
                  
                <div className="flex flex-col gap-2 my-3">
                  <Label htmlFor="title">Title</Label>
                  <Input
                    id="title"
                    placeholder="Enter the title of your issue"
                    value={subject}
                    onChange={(e) => {
                      setSubject(e.target.value)
                      if (errors.subject) setErrors((prev) => ({ ...prev, subject: undefined }))
                        if (submissionError) setSubmissionError('') 
                    }}
                    className="border-stone-500"
                    required
                  />
                  {errors.subject && <p className="text-red-500 text-sm">{errors.subject}</p>}
                </div>
                <div className="flex flex-col gap-2">
                  <Label htmlFor="description">Description</Label>
                  <Textarea id="description" placeholder="Describe your issue in detail" className="border-stone-500 h-50" value={body} onChange={(e) => {
                    setBody(e.target.value)
                    if (errors.body) setErrors((prev) => ({ ...prev, body: undefined }))
                      if (submissionError) setSubmissionError('')
                  }} required/>
                  {errors.body && <p className="text-red-500 text-sm">{errors.body}</p>}
                  </div>
                <div className="flex gap-4 mt-4 justify-end">
                  <Button type="button" className="w-1/2 bg-stone-300" variant="outline" onClick={() => navigate("/dashboard")}>Cancel</Button>
                  <Button type="submit" className="w-1/2">Submit New Issue</Button>
                </div>
              </form>
                  </>
                )}
              </div>

              
            </div>
          </div>
        </div>
      </SidebarInset>
    </SidebarProvider>
  )
}
