"use client";

import { Button } from "@/components/ui/button";
import {
  FileUpload,
  FileUploadDropzone,
  FileUploadItem,
  FileUploadItemDelete,
  FileUploadItemMetadata,
  FileUploadItemPreview,
  FileUploadList,
  FileUploadTrigger,
} from "@/components/ui/file-upload";
import { Upload, X } from "lucide-react";
import * as React from "react";
import { toast } from "sonner";


type Props = {
  selectedfiles: File[]
  setSelectedFiles: React.Dispatch<React.SetStateAction<File[]>>
}

export function AttachmentBox({selectedfiles, setSelectedFiles}: Props) {
  const onFileReject = React.useCallback((file: File, message: string) => {
    toast(message, {
      description: `"${file.name.length > 20 ? `${file.name.slice(0, 20)}...` : file.name
        }" has been rejected`,
    });
  }, []);

  return (
    <div className="flex flex-col gap-6">
      <FileUpload
        accept="image/*, .pdf, application/pdf"
        maxFiles={2}
        maxSize={4 * 1024 * 1024}
        onAccept={(files) => setSelectedFiles((prevFiles) => [...prevFiles, ...files])}
        onFileReject={onFileReject}
        multiple
        
      >
        <FileUploadDropzone>
          <div className="flex flex-col items-center gap-1">
            <div className="flex items-center justify-center rounded-full border p-2.5">
              <Upload className="size-6 text-muted-foreground" />
            </div>
            <p className="font-medium text-sm">Drag & drop images here</p>
            <p className="text-muted-foreground text-xs">
              Or click to browse (max 2 files, up to 4MB each)
            </p>
          </div>
          <FileUploadTrigger asChild>
            <Button variant="outline" size="sm" className="mt-2 w-fit">
              Browse files
            </Button>
          </FileUploadTrigger>
        </FileUploadDropzone>
        <FileUploadList>
          <p className="font-medium text-sm">Selected files</p>
          {selectedfiles.map((file, index) => (
            <FileUploadItem key={index} value={file}>
              <div className="flex w-full items-center gap-2">
                <FileUploadItemPreview />
                <FileUploadItemMetadata />
                <FileUploadItemDelete asChild>
                  <Button variant="ghost" size="icon" className="size-7" onClick={() => setSelectedFiles(selectedfiles.filter(item => item.name !== file.name))}>
                    <X  />
                  </Button>
                </FileUploadItemDelete>
              </div>
              {/* <FileUploadItemProgress /> */}
            </FileUploadItem>
          ))}
        </FileUploadList>
      </FileUpload>
      
    </div>
  );
}