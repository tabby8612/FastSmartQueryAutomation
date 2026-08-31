import { useNavigate } from "react-router-dom";
import { useEffect } from "react";
import { SidebarInset, SidebarProvider } from "@/components/ui/sidebar";
import { Loader2 } from "lucide-react";
import api from "@/lib/axios";
import type { User } from "@/types";
import { useAuth } from "@/contexts/auth-context";

export default function GoogleCallback() {
    const navigate = useNavigate()
    const {setAuth} = useAuth()

    useEffect(() => {
        const authenticate = async () => {
            try {
                const response = await api.get("/auth/me", {
                    withCredentials: true
                })

                const user : User = response.data?.user
                const access_token : string = response.data?.access_token
                setAuth(access_token, user)

                switch (user.rolename) {
                    case "student":
                        navigate("/student/dashboard")
                        break;

                    case "officer":
                        navigate("/officer/dashboard")
                        break;

                    case "admin":
                        navigate("/admin/dashboard")
                        break;
                
                    default:
                        navigate("/")
                        break;
                }
                
            } catch (error) {
                console.error(error)

                navigate("/")
            }
        }

        authenticate()
    }, [])

    return (
        <SidebarProvider
            style={
                {
                    "--sidebar-width": "calc(var(--spacing) * 72)",
                    "--header-height": "calc(var(--spacing) * 16)",
                } as React.CSSProperties
            }
        >
            <SidebarInset>
                <div className="flex flex-1 flex-col">
                    <div className="@container/main flex flex-1 flex-col gap-2">
                        <div className="flex flex-col gap-4 py-4 md:gap-6 md:py-6">
                            <div className="md:py-6 bg-white mx-5 px-6 rounded-2xl flex flex-col gap-5justify-center items-center">
                                <Loader2 className="size-40 opacity-50 animate-spin"/>
                                <h1 className="text-4xl font-bold">Signing You In...</h1>
                            </div>
                        </div>
                    </div>
                </div>
            </SidebarInset>
        </SidebarProvider>
    )
}
