import { Download, FileCheck } from "lucide-react";
import { Card, CardDescription, CardTitle } from "../card";
import type { Attachment } from "@/types";
import api from "@/lib/axios";
import { useAuth } from "@/contexts/auth-context";



export function AttachmentCard({ attachment }: { attachment: Attachment }) {
    const { getAccessToken } = useAuth()
    const token = getAccessToken()

    async function downloadfile(attachment_id: number) {
        const config = { headers: { Authorization: `Bearer ${token}` }, responseType: "blob" as const }

        try {
            const response = await api.get(`/attachment/attachments/${attachment_id}/download`, config)

            // Convert response into Blob
            const blob = new Blob([response.data]);

            // Create temporary URL
            const url = window.URL.createObjectURL(blob);

            // Create download link
            const link = document.createElement("a");

            link.href = url;
            link.download = attachment.original_filename;

            // Trigger download
            document.body.appendChild(link);
            link.click();

            // Cleanup
            document.body.removeChild(link);
            window.URL.revokeObjectURL(url);

        } catch (error) {
            console.log("fail to download file: ", error)
        }


    }

    return <Card className="flex px-3 flex-row gap-3 shadow justify-between items-center hover:bg-blue-50 cursor-pointer" onClick={() => downloadfile(attachment.id)}>
        <div className="flex gap-2">
            <FileCheck className="size-10 py-2 px-2 bg-stone-100 rounded-lg" />
            <div className="flex flex-col gap-1.5">
                <CardTitle className="text-sm">{attachment.original_filename}</CardTitle>
                <CardDescription>{attachment.file_type} - {attachment.file_size_in_MB}</CardDescription>
            </div>

        </div>
        <Download className="" />
    </Card>
}