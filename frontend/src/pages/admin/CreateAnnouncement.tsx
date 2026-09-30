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
import { RadioGroup, RadioGroupItem } from "@/components/ui/radio-group"
import { Field, FieldContent, FieldDescription, FieldLabel, FieldTitle } from "@/components/ui/field"
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from "@/components/ui/select"
import type { Department } from "@/types"
import { isAxiosError } from "axios"
import { Dialog, DialogContent, DialogDescription, DialogFooter, DialogHeader, DialogTitle } from "@/components/ui/dialog"

export default function CreateAnnouncement() {
    const { role_name, access_token } = useAuth()
    const navigate = useNavigate()
    const [successMessage, setSuccessMessage] = useState<string | null>(null)
    const [isDepartmentStudent, setIsDepartmentStudent] = useState(false)
    const [allDepartments, setAllDepartments] = useState<Department[] | null>(null)
    const [errors, setErrors] = useState<Partial<Record<"title" | "body" | "audience_type" | "department_id", string>>>({})
    const [confirmationOpen, setConfirmationOpen] = useState(false)
    const [isSubmitting, setIsSubmitting] = useState(false)
    const [submissionError, setSubmissionError] = useState<string>("")
    const [submissionData, setSubmissionData] = useState({
        title: "",
        body: "",
        audience_type: "all",
        department_id: null as number | null
    })

    useEffect(() => {
        if (successMessage) {
            const timer = setTimeout(() => {
                navigate("/admin/announcements")
            }, 5000)
            return () => clearTimeout(timer)
        }
    }, [successMessage, navigate])

    useEffect(() => {
        async function fetchDepartments() {
            try {
                const response = await api.get("/departments/", { headers: { Authorization: `Bearer ${access_token}` } })

                setAllDepartments(response.data)

            } catch (error) {

                if (isAxiosError(error) && error.status == 408) navigate("/")

                console.error(error)

                if (isAxiosError(error)) {
                    setSubmissionError(error.response?.data?.detail)
                }
            }
        }

        fetchDepartments()
    }, [access_token, navigate])

    const handleSubmit = (e: React.SubmitEvent) => {
        e.preventDefault()
        if (isSubmitting) return
        setErrors({})
        setSubmissionError("")
        if (submissionData.audience_type === "department" && !submissionData.department_id) {
            setErrors({ department_id: "Please select a department." })
            return
        }
        setConfirmationOpen(true)
    }

    const confirmSubmit = async () => {
        if (isSubmitting) return
        setIsSubmitting(true)
        setSubmissionError("")
        try {
            const response = await api.post("/admin/announcements", submissionData, {
                headers: { Authorization: `Bearer ${access_token}` },
            })
            setSuccessMessage(response.data.message)
        } catch (error: unknown) {
            if (isAxiosError(error) && error.status == 408) navigate("/")

            const fieldErrors: typeof errors = {}
            const detail = isAxiosError(error) ? error.response?.data?.detail : undefined
            if (Array.isArray(detail)) {
                detail.forEach((err: { loc?: (string | number)[]; msg?: string }) => {
                    const field = err.loc?.[1] as string
                    if (field === "title" || field === "body" || field === "audience_type" || field === "department_id") {
                        fieldErrors[field] = err.msg
                    }
                })
            } else {
                setSubmissionError(typeof detail === "string" ? detail : "Failed to create announcement. Please try again.")

            }
            
            if (Array.isArray(detail)) setSubmissionError(detail[0]?.msg || "Please check the announcement details.")
            setErrors(fieldErrors)
        } finally {
            setIsSubmitting(false)
            setConfirmationOpen(false)
        }
    }

    return (
        <SidebarProvider
            style={
                {
                    "--sidebar-width": "calc(var(--spacing) * 60)",
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
                                        <p className="text-sm text-muted-foreground">Redirecting to announcements in 5 seconds...</p>
                                    </div>
                                ) : (
                                    <>
                                        <h1 className="text-2xl md:text-4xl font-bold">Submit New Announcement</h1>
                                        <p className="text-muted-foreground text-sm md:text-2xl">You can create announcement for all students or department-wise students</p>
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
                                                    placeholder="Enter the title of your announcement"
                                                    value={submissionData.title}
                                                    onChange={(e) => {
                                                        setSubmissionData(data => {
                                                            return {
                                                                ...data,
                                                                "title": e.target.value
                                                            }
                                                        })
                                                        if (errors.title) setErrors((prev) => ({ ...prev, title: undefined }))
                                                        if (submissionError) setSubmissionError('')
                                                    }}
                                                    className="border-stone-500"
                                                    required
                                                />
                                                {errors.title && <p className="text-red-500 text-sm">{errors.title}</p>}
                                            </div>
                                            <div className="flex flex-col gap-2">
                                                <Label htmlFor="description">Description</Label>
                                                <Textarea id="description" placeholder="Describe your announcement body" className="border-stone-500 h-50" value={submissionData.body} onChange={(e) => {
                                                    setSubmissionData(data => {
                                                        return {
                                                            ...data,
                                                            "body": e.target.value
                                                        }
                                                    })
                                                    if (errors.body) setErrors((prev) => ({ ...prev, body: undefined }))
                                                    if (submissionError) setSubmissionError('')
                                                }} required />
                                                {errors.body && <p className="text-red-500 text-sm">{errors.body}</p>}
                                            </div>
                                            <div className="flex flex-col gap-2 ">
                                                <Label htmlFor="announcement_type">Announcement Type</Label>
                                                <RadioGroup defaultValue="all" className="" onValueChange={(value) => {
                                                    if (value === "all") {
                                                        setSubmissionData(prev => ({ ...prev, "audience_type": "all", "department_id": null }))
                                                        setIsDepartmentStudent(false)
                                                    }

                                                    if (value === "department") {
                                                        setSubmissionData(prev => ({ ...prev, "audience_type": "department" }))
                                                        setIsDepartmentStudent(true)
                                                    }
                                                }}>
                                                    <FieldLabel htmlFor="all" className="">
                                                        <Field orientation="horizontal">
                                                            <FieldContent>
                                                                <FieldTitle>All</FieldTitle>
                                                                <FieldDescription>
                                                                    Create Announcement For All Students.
                                                                </FieldDescription>
                                                            </FieldContent>
                                                            <RadioGroupItem value="all" id="all" />
                                                        </Field>
                                                    </FieldLabel>
                                                    <FieldLabel htmlFor="department" className="">
                                                        <Field orientation="horizontal">
                                                            <FieldContent>
                                                                <FieldTitle>Department</FieldTitle>
                                                                <FieldDescription>Create Announcement For Specfic Department.</FieldDescription>
                                                            </FieldContent>
                                                            <RadioGroupItem value="department" id="department" />
                                                        </Field>
                                                    </FieldLabel>
                                                </RadioGroup>
                                                {errors.audience_type && <p className="text-red-500 text-sm">{errors.audience_type}</p>}
                                            </div>
                                            <div className="flex flex-col gap-2 ">
                                                <Label htmlFor="announcement_type">Department</Label>
                                                <Select
                                                    disabled={!isDepartmentStudent}
                                                    value={submissionData.department_id === null ? "all" : String(submissionData.department_id)}
                                                    onValueChange={(value) => {
                                                        setSubmissionData(prev => ({ ...prev, department_id: value && value !== "all" ? Number(value) : null }))
                                                        setErrors(prev => ({ ...prev, department_id: undefined }))
                                                    }}
                                                >
                                                    <SelectTrigger id="departments" className="min-w-48  w-full border-stone-500" aria-label="Filter by department">
                                                        <SelectValue className="capitalize">{submissionData.department_id === null ? "Select Department" : allDepartments?.find(dept => dept.id === submissionData.department_id)?.name}</SelectValue>
                                                    </SelectTrigger>
                                                    <SelectContent>
                                                        <SelectItem value="all">Select Any Department</SelectItem>
                                                        {
                                                            allDepartments && allDepartments.map(dept => <SelectItem key={dept.id} value={String(dept.id)} className="capitalize">{dept.name}</SelectItem>)
                                                        }

                                                    </SelectContent>
                                                </Select>

                                                {errors.department_id && <p className="text-red-500 text-sm">{errors.department_id}</p>}
                                            </div>
                                            <div className="flex gap-4 mt-4 justify-end">
                                                <Button type="button" className="w-1/2 bg-stone-300" variant="outline" onClick={() => navigate("/admin/announcements")}>Cancel</Button>
                                                <Button type="submit" className="w-1/2" disabled={isSubmitting}>Create Announcement</Button>
                                            </div>
                                        </form>
                                    </>
                                )}
                            </div>


                        </div>
                    </div>
                </div>
                <Dialog open={confirmationOpen} onOpenChange={(open) => { if (!isSubmitting) setConfirmationOpen(open) }}>
                    <DialogContent showCloseButton={!isSubmitting}>
                        <DialogHeader>
                            <DialogTitle>Create this announcement?</DialogTitle>
                            <DialogDescription>Review the details below before confirming. Students in the selected audience will be notified.</DialogDescription>
                        </DialogHeader>
                        <div className="max-h-80 space-y-4 overflow-y-auto break-words">
                            <div><p className="font-semibold">Title</p><p>{submissionData.title}</p></div>
                            <div><p className="font-semibold">Audience</p><p>{submissionData.audience_type === "all" ? "All students" : allDepartments?.find(dept => dept.id === submissionData.department_id)?.name}</p></div>
                            <div><p className="font-semibold">Description</p><p className="whitespace-pre-wrap">{submissionData.body}</p></div>
                        </div>
                        <DialogFooter>
                            <Button type="button" variant="outline" disabled={isSubmitting} onClick={() => setConfirmationOpen(false)}>Cancel</Button>
                            <Button type="button" disabled={isSubmitting} onClick={confirmSubmit}>{isSubmitting ? "Creating..." : "Confirm and create"}</Button>
                        </DialogFooter>
                    </DialogContent>
                </Dialog>
            </SidebarInset>
        </SidebarProvider>
    )
}
