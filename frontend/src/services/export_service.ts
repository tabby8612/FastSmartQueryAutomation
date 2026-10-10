import type { Ticket } from "@/types";
import * as XLSX from "xlsx"
import jsPDF from "jspdf"
import autoTable from "jspdf-autotable"

export function exportToExcel(tickets: Ticket[], file_name = "tickets_report.xlsx") {
    const data = tickets.map(ticket => ({
        "Tracking ID": ticket.tracking_id,
        "Subject": ticket.subject,
        "Student": ticket.student?.full_name ?? "",
        "Department": ticket.department?.name ?? "",
        "Category": ticket.category?.name ?? "",
        "Assigned Officer": ticket.assigned?.full_name ?? "",
        "Channel": ticket.channel,
        "Status": ticket.status,
        "Priority": ticket.priority,
        "Created At": new Date(ticket.created_at).toLocaleDateString("en-US", {
                "dateStyle": "medium"
            }),
        "Resolved At": ticket.resolved_at ? new Date(ticket.resolved_at).toLocaleDateString("en-US", {
                "dateStyle": "medium"
            }) : ''
    }))

    const worksheet = XLSX.utils.json_to_sheet(data)

    const workbook = XLSX.utils.book_new()

    XLSX.utils.book_append_sheet(workbook, worksheet, "Ticket Report")

    XLSX.writeFile(workbook, file_name)
}


export function exportToPDF(tickets: Ticket[], file_name = "tickets_report.pdf") {
    const doc = new jsPDF({
        "orientation": "landscape",
        "unit": "mm",
        "format": "a4"
    })

    doc.setFontSize(22)

    doc.text("University Ticket Management System", 14, 15)

    doc.setFontSize(18)

    doc.text("Ticket Report", 14, 30)

    doc.setFontSize(10)

    doc.text(`Total Tickets: ${tickets.length}`, 14, 40)

    autoTable(doc, {
        startY: 50,

        head: [[
            "Tracking ID",
            "Subject",
            "Student",
            "Department",
            "Category",
            "Assigned Officer",
            "Channel",
            "Status",
            "Priority",
            "Created" ,
            "Resolved"
        ]],

        body: tickets.map(ticket => [
            ticket.tracking_id,
            ticket.subject,
            ticket.student?.full_name ?? "",
            ticket.department?.name ?? "",
            ticket.category?.name ?? "",
            ticket.assigned?.full_name ?? "",
            ticket.channel,
            ticket.status,
            ticket.priority,
            ticket.created_at ? new Date(ticket.created_at).toLocaleDateString("en-US", {
                "dateStyle": "medium"
            }) : "-",
            ticket.resolved_at ? new Date(ticket.resolved_at).toLocaleDateString("en-US", {
                "dateStyle": "medium"
            }) : "-",
        ]),

        styles: {
            fontSize: 7
        },

        headStyles: {
            fontSize: 7
        },

        margin: {
            top: 28,
            left: 10,
            right: 10
        }
    })

    doc.save(file_name)


}