export type Ticket = {
    "id": number,
    "tracking_id": string,
    "student_id": number,
    "assigned_id": number,
    "department_id": number,
    "category_id": number,
    "channel": "web_form" | "email" | "whatsapp",
    "subject": string,
    "body": string,
    "intent": string,
    "confidence_level": string,
    "status": "open" | "closed" | "in_progress",
    "escalation_level": number,
    "awaiting_student_input": boolean,
    "resolved_at": string,
    "created_at": string,
    "student": Student,
    "assigned": Officer,
    "department": Department,
    "category": Category,
  }

  export type Reply = {
  id: number
  text: string
  status: "draft" | "sent"
  created_at: string
  send_at: string | null
  creator: Pick<User, "id" | "full_name" | "is_admin" | "is_student" | "is_officer">
}


export type Student = {
    "id": number,
    "student_id": string,
    "email": string,
    "full_name": string
}

export type Officer = {
    "id": number,
    "email": string,
    "full_name": string
}

export type Department = {
    "id": number,
    "name": string,
    "description": string,
    "ticket_count": number
}

export type User = {
    id: number,
    name: string,
    full_name?: string,
    email: string,
    is_active: boolean,
    is_student: boolean,
    is_officer: boolean,
    is_admin: boolean,
    on_leave: boolean,
    auto_reply_message: boolean,
    leave_start_day: string,
    leave_end_day: string,
    department?: {
      id: number,
      name: string
    } | null,
    roles?: unknown[],
    rolename: string
}

export type Category = {
    id: number,
    name: string,
    description: string,
    ticket_count: number
}
