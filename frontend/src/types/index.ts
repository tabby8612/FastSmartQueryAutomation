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
    "priority": string,
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
    "ticket_status_history": TicketStatusHistory[],
    "replies": Reply[]
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

export type TicketStatusHistory = {
    id: number,
    new_status: TicketStatus,
    new_status_label: string
    created_at: string,
    old_status: TicketStatus,
    ticket_id: number,
    changed_by: number,
    updated_at: string
}

export type TicketStatus = "open" | "pending" | "assigned" | "in_progress" | "resolved" | "closed"

export type AnalyticsSummary = {
    total_tickets: number
    pending_tickets: number
    resolved_tickets: number
    escalated_tickets: number
}

export type TicketTrend = {
    date: string,
    count: number
}

export type AnalyticsCount = {
    name: string,
    count: number
}

export type Escalation = {
    total_escalated: number,
    not_escalated: number,
    escalation_rate: string
}

export type DepartmentPerformance = {
    department: string,
    total: number,
    pending: number,
    escalated: number,
    closed: number
}

export type Announcement = {
    id: number,
    title: string,
    body: string,
    audience_type: string,
    department_id?: number,
    creator_id: number,
    created_at: string,
    creator: User,
    department?: Department
  }

export type QueryReport = {
    id: number;
    tracking_id: string;

    subject: string;

    student_name: string | null;

    department_name: string | null;

    category_name: string | null;

    assigned_officer: string | null;

    channel: string;

    status: string;

    priority: string;

    intent: string | null;

    confidence_level: number | null;

    escalation_level: number;

    created_at: string;

    resolved_at: string | null;
}