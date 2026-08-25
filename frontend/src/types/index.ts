export type Query = {
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
    "department": Department
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
}