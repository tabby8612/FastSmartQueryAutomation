import { useState } from "react"
import { useNavigate } from "react-router-dom"
import axios from "axios"
import { useAuth } from "@/contexts/auth-context"
import { cn } from "@/lib/utils"
import { Button } from "@/components/ui/button"
import { Card, CardContent } from "@/components/ui/card"
import {
  Field,
  FieldDescription,
  FieldGroup,
  FieldLabel,
  FieldSeparator,
} from "@/components/ui/field"
import { Input } from "@/components/ui/input"
import automation_logo from "@/assets/automation_logo.png"
import api from "@/lib/axios"

export function LoginForm({
  className,
  ...props
}: React.ComponentProps<"div">) {
  const navigate = useNavigate()
  const { setAuth } = useAuth()
  const [error, setError] = useState("")

  const handleSubmit = async (e: React.SubmitEvent<HTMLFormElement>) => {
    e.preventDefault()
    const formData = new FormData(e.currentTarget)

    try {
      const response = await api.post("/auth/login", formData, { headers: { "Content-Type": "application/x-www-form-urlencoded" } })
      const { access_token, user } = response.data
      setAuth(access_token, user)

      if (user.rolename === "student") {
        return navigate("/student/dashboard")
      } else if (user.rolename === "officer") {
        return navigate("/officer/dashboard")
      } else if (user.rolename === "admin") {
        return navigate("/admin/dashboard")
      } else if (user.rolename === "hod") {
        return navigate("/hod/dashboard")
      }

      return navigate("/student/dashboard")

    } catch {
      setError("Invalid email or password")
    }
  }

  return (
    <div className={cn("flex flex-col gap-6", className)} {...props}>
      <Card className="overflow-hidden p-0">
        <CardContent className="grid p-0 md:grid-cols-2">
          <form onSubmit={handleSubmit} className="p-6 md:p-8">
            <FieldGroup>
              <div className="flex flex-col items-center gap-2 text-center">
                <h1 className="text-2xl font-bold">Welcome back</h1>
                <p className="text-balance text-muted-foreground">
                  Login to your account
                </p>
              </div>
              <Field>
                <FieldLabel htmlFor="email">Email</FieldLabel>
                <Input
                  id="username"
                  name="username"
                  type="email"
                  placeholder="m@example.com"
                  required
                />
              </Field>
              <Field>
                <div className="flex items-center">
                  <FieldLabel htmlFor="password">Password</FieldLabel>

                </div>
                <Input id="password" name="password" type="password" required />
              </Field>
              <Field>
                <Button type="submit">Login</Button>
              </Field>
              {error && (
                <p className="text-sm text-red-500">{error}</p>
              )}
              <FieldSeparator className="*:data-[slot=field-separator-content]:bg-card">
                Or continue with
              </FieldSeparator>
              <Button variant="outline" type="button" onClick={() => window.location.href = `${import.meta.env.VITE_API_BASE_URL}/auth/google/login`}>
                <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24">
                  <path
                    d="M12.48 10.92v3.28h7.84c-.24 1.84-.853 3.187-1.787 4.133-1.147 1.147-2.933 2.4-6.053 2.4-4.827 0-8.6-3.893-8.6-8.72s3.773-8.72 8.6-8.72c2.6 0 4.507 1.027 5.907 2.347l2.307-2.307C18.747 1.44 16.133 0 12.48 0 5.867 0 .307 5.387.307 12s5.56 12 12.173 12c3.573 0 6.267-1.173 8.373-3.36 2.16-2.16 2.84-5.213 2.84-7.667 0-.76-.053-1.467-.173-2.053H12.48z"
                    fill="currentColor"
                  />
                </svg>
                <span className=" ">Login/Signup with Google</span>
              </Button>

            </FieldGroup>
          </form>
          <div className="relative hidden bg-muted md:block">
            <img
              src={automation_logo}
              alt="Image"
              className="absolute inset-0 h-full w-full object-cover dark:brightness-[0.2] dark:grayscale"
            />
          </div>
        </CardContent>
      </Card>
      <FieldDescription className="px-6 text-center">
        By clicking continue, you agree to our <a href="#">Terms of Service</a>{" "}
        and <a href="#">Privacy Policy</a>.
      </FieldDescription>
    </div>
  )
}
