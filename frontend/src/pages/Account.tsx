import { useEffect, useState, type ChangeEvent } from "react"
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
import { type UserProfile } from "@/types"
import { AxiosError, isAxiosError } from "axios"
import { Card } from "@/components/ui/card"
import { Trash2, Upload } from "lucide-react"
import { toast } from "sonner"
import { Avatar, AvatarFallback, AvatarImage } from "@/components/ui/avatar"
import { Field } from "@/components/ui/field"

type StudentFormErrors = {
  student_id?: string
  name?: string
  email?: string
  password?: string
}

type ChangePassword = {
  old_password: string,
  new_password: string,
  new_password_confirmation: string,
}

export function Account() {
  const { role_name, access_token, getAccessToken, logout } = useAuth()
  const navigate = useNavigate()
  const [user, setUser] = useState<UserProfile | null>(null)
  const [name, setName] = useState<string>("")
  const [email, setEmail] = useState<string>("")
  const [errors, setErrors] = useState<StudentFormErrors>({})
  const [submissionError, setSubmissionError] = useState("")
  const [successMessage, setSuccessMessage] = useState("")
  const [submitting, setSubmitting] = useState(false)
  const [loading, setLoading] = useState(true)
  const [profileImage, setProfileImage] = useState("")
  const [selectedFile, setSelectedFile] = useState<File | null>(null);
  const [ChangePassword, setChangePassword] = useState<ChangePassword>({
    "old_password": "",
    "new_password": "",
    "new_password_confirmation": ""
  })
  


  const ACCESS_TOKEN = getAccessToken()
  const BASE_URL = import.meta.env.VITE_API_BASE_URL
  const MAX_SIZE = import.meta.env.MAX_UPLOAD_SIZE_MB ?? 5

  useEffect(() => {
    const fetchUserProfile = async () => {
      try {
        const response = await api.get<UserProfile>("profile/me", {
          headers: {
            Authorization: `Bearer ${ACCESS_TOKEN}`
          }
        })
        setUser(response.data)
        setName(response.data.full_name)
        setEmail(response.data.email)
        setProfileImage(`${BASE_URL}${response.data.profile_image}`)
      } catch (error) {
        if (error instanceof AxiosError) {
          navigate("/")
        }
      } finally {
        setLoading(false)
      }
    }

    fetchUserProfile()

  }, [ACCESS_TOKEN])

  const clearFieldError = (field: keyof StudentFormErrors) => {
    if (errors[field]) {
      setErrors((prev) => ({ ...prev, [field]: undefined }))
    }
    if (submissionError) setSubmissionError("")
    if (successMessage) setSuccessMessage("")
  }

  const handleImageChange = (event: ChangeEvent<HTMLInputElement>) => {
    const file = event.target.files?.[0];

    if (!file) return;

    if (!file.type.startsWith("image/")) {
      toast.error("Please select a valid image.", {
        position: "top-center",
        "richColors": true
      });
      return;
    }

    if (file.size > (+MAX_SIZE) * 1024 * 1024) {
      toast.error("Image size must be less than 5 MB.",{
        "position": "top-center",
        "richColors": true
      });
      return;
    }

    setSelectedFile(file)
    setProfileImage(URL.createObjectURL(file))

    toast.info("Update Account to save changes", {
      position: "top-center",
      richColors: true,
      duration: 5000,
      closeButton: true
    })
  };

  const handleUpload = async () => {
    if (!selectedFile) return;

    try {
      setLoading(true);

      const formData = new FormData();

      formData.append("file", selectedFile);

      const response = await api.post(
        "/profile/upload-image",
        formData,
        {
          headers: {
            Authorization: `Bearer ${access_token}`,
          },
        }
      );

      setProfileImage(`${BASE_URL}${response.data.profile_image}`)

      toast.success("Personal information updated successfully.", {
        "position": "top-center",
        "richColors": true,
      })



    } catch (error) {
      setProfileImage(`${BASE_URL}${user?.profile_image}`)
      if (isAxiosError(error)) {
        toast.error(
          error.response?.data?.detail
          , {
            "position": "top-center",
            "richColors": true
          });
      } else {
        toast.error(
          "Image upload failed.", {
          "position": "top-center",
          "richColors": true
        }
        );
      }

    } finally {
      setLoading(false);
    }
  };



  const handleProfileChange = async (e: React.SubmitEvent<HTMLFormElement>) => {
    e.preventDefault()
    setErrors({})
    setSubmissionError("")
    setSuccessMessage("")
    setSubmitting(true)

    try {
      const response = await api.put<UserProfile>(
        "/profile/personal-details",
        {
          email,
          full_name: name,
        },
        {
          headers: { Authorization: `Bearer ${access_token}` },
        }
      )


      setName(response.data.full_name)
      setEmail(response.data.email)
      setProfileImage(`${BASE_URL}${response.data.profile_image}`)

      handleUpload()
    } catch (error: any) {
      const detail = error.response?.data?.detail
      const fieldErrors: StudentFormErrors = {}

      if (Array.isArray(detail)) {
        detail.forEach((err: any) => {
          const field = err.loc?.at(-1)
          if (field === "full_name") fieldErrors.name = err.msg
          if (field === "email") fieldErrors.email = err.msg
        })
      } else if (typeof detail === "string") {
        setSubmissionError(detail)
      } else {
        setSubmissionError("Failed to update user. Please try again.")
      }

      setErrors(fieldErrors)
    } finally {
      setSubmitting(false)
    }
  }

  const handlePasswordChange = async (e: React.SubmitEvent<HTMLFormElement>) => {
    e.preventDefault()
    
    try {
      await api.put("/profile/change-password", {
          "old_password": ChangePassword.old_password,
          "new_password": ChangePassword.new_password,
          "password_confirmation": ChangePassword.new_password_confirmation
      }, {
        headers: {
          Authorization: `Bearer ${access_token}`
        }
      })

      toast.success("Password updated successfully", {
        position: 'top-center',
        richColors: true,
        onDismiss: () => {
          logout()
          navigate("/")
        },
        onAutoClose: () => {
          logout()
          navigate("/")
        }
      })

      


    } catch (error) {
      if (isAxiosError(error)) {
        toast.error(error.response?.data.detail, {
        position: 'top-center',
        richColors: true
      })
      }
    }
  }

  const handleImageDelete = async () => {
    try {
      const response = await api.delete<UserProfile>(
        "/profile/upload-image",
        {
          headers: { Authorization: `Bearer ${access_token}` },
        }
      )


      setName(response.data.full_name)
      setEmail(response.data.email)
      setProfileImage(`${BASE_URL}${response.data.profile_image}`)

      toast.success("Profile Image deleted successfully.", {
        "position": "top-center",
        "richColors": true,
      })

    } catch (error: any) {
      toast.error(error.response.data.detail, {
        "richColors": true,
        "position": "top-center"
      })
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
              <div className="md:py-6 py-3 bg-white mx-5 px-6 rounded-2xl flex flex-col gap-5">
                <h1 className="text-3xl font-bold">Account</h1>
                <p className="text-muted-foreground text-xl">
                  Change Your Account Details
                </p>
              </div>

              <div className="py-6 px-3 mx-6 rounded-2xl bg-white">
                {
                  user && (
                    <div className="md:grid md:grid-cols-12 gap-3">
                      <div className="px-3 col-span-5 my-5 md:my-0">
                        <h1 className="font-bold text-2xl">Update Profile Photo</h1>
                        <div className="flex gap-3 mt-7 relative">
                          <Input className="absolute  h-24 w-24 z-1 opacity-0" onChange={(e) => handleImageChange(e)} type="file" />

                          <Avatar className="h-24 w-24">
                            {/* <Upload className="absolute z-10 bg-red-300 top-1/2 right-1/2 " /> */}
                            <AvatarImage
                              src={profileImage}
                              alt="Profile picture"

                            />

                            <AvatarFallback>
                              {user.full_name?.charAt(0)?.toUpperCase()}
                            </AvatarFallback>

                          </Avatar>

                          <div>
                            <h1 className="text-black font-bold text-lg">Profile Photo</h1>
                            <p className="text-sm text-stone-600">Upload a new profile picture.</p>
                            <p className="text-sm text-stone-600">JPG, PNG or WebP · Maximum 5 MB</p>
                          </div>
                        </div>
                        <div className="grid grid-cols-12 mt-3 gap-2">
                          <Button className="relative col-span-10 flex flex-col h-20 cursor-pointer" variant="outline" >
                            <Upload size={10} />
                            Upload New Image
                            <Input className="absolute size-full opacity-0" type="file" onChange={(e) => handleImageChange(e)} />
                          </Button>
                          <Button className="col-span-2 flex flex-col h-20 cursor-pointer" variant="destructive" onClick={() => handleImageDelete()}>
                            <Trash2 />

                          </Button>
                        </div>
                      </div>
                      <form onSubmit={handleProfileChange} className="col-span-7 flex w-full max-w-2xl flex-col gap-5 px-6">
                        <h1 className="font-bold text-2xl">Update Personal Details</h1>
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

                        <div className="">
                          {
                            role_name === "student" && (
                              <div className="flex flex-col gap-2">
                                <Label htmlFor="student_id">Student ID</Label>
                                <Input
                                  id="student_id"
                                  defaultValue={user.student_id}
                                  placeholder="Enter student ID"
                                  className="border-stone-500"
                                  required
                                  disabled
                                />
                              </div>
                            )
                          }


                          <div className="flex flex-col gap-2 mt-5">
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

                        <div className="flex gap-4 pt-2 items-end justify-end">
                          <Button type="submit" className="w-1/2" disabled={submitting}>
                            <IconDeviceFloppy />
                            {submitting ? "Updating..." : "Update Account"}
                          </Button>
                        </div>
                      </form>

                    </div>


                  )
                }

              </div>
              <div className="py-6 mx-6 rounded-2xl bg-white">
                {
                  user && (
                    <div className="px-9">
                      <h1 className="font-bold text-2xl py-3">Change Password</h1>
                      <form onSubmit={handlePasswordChange} className="mt-3">
                        <div className="flex flex-col gap-2">
                          <Label htmlFor="old_password">Old Password</Label>
                          <Input
                            id="old_password"
                            type="password"
                            value={ChangePassword?.old_password}
                            onChange={(e) => {
                              setChangePassword(changePass => ({...changePass, old_password: e.target.value}))
                            }}
                            placeholder="Enter old password"
                            className="border-stone-500"
                            required
                          />
                          {/* {errors.email && <p className="text-sm text-red-500">{errors.email}</p>} */}
                        </div>
                        <div className="flex flex-col gap-2 mt-5">
                          <Label htmlFor="new_password">New Password</Label>
                          <Input
                            id="new_password"
                            type="password"
                            value={ChangePassword?.new_password}
                            onChange={(e) => {
                              setChangePassword(changePass => ({...changePass, new_password: e.target.value}))
                            }}
                            placeholder="Enter new password"
                            className="border-stone-500"
                            required
                          />
                          {/* {errors.email && <p className="text-sm text-red-500">{errors.email}</p>} */}
                        </div>
                        <div className="flex flex-col gap-2 mt-5">
                          <Label htmlFor="new_password_confirmation">New Password Confirmation</Label>
                          <Input
                            id="new_password_confirmation"
                            type="password"
                            value={ChangePassword?.new_password_confirmation}
                            onChange={(e) => {
                              setChangePassword(changePass => ({...changePass, new_password_confirmation: e.target.value}))
                            }}
                            placeholder="Enter new password confirmation"
                            className="border-stone-500"
                            required
                          />
                          {/* {errors.email && <p className="text-sm text-red-500">{errors.email}</p>} */}
                        </div>

                        <div className="flex gap-4 pt-2 items-end justify-end mt-5">
                          <Button type="submit" className="w-xs" disabled={submitting}>
                            <IconDeviceFloppy />
                            {submitting ? "Updating..." : "Update Password"}
                          </Button>
                        </div>
                      </form>

                    </div>
                  )
                }
              </div>
            </div>
          </div>
        </div>
      </SidebarInset>
    </SidebarProvider>
  )
}
