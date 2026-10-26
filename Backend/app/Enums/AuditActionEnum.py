from enum import Enum


class AuditActionEnum(str, Enum):
    WEBFORM_LOGIN = "auth.login"
    GOOGLE_LOGIN = "auth.oauth2.login"
    TICKET_CREATED = "ticket.created"
    TICKET_ASSIGNED = "ticket.assigned"
    STATUS_CHANGED = "ticket.status_changed"
    PRIORITY_CHANGED = "ticket.priority_changed"
    REPLY_CREATED = "reply.created"
    TICKET_ESCALATED = "ticket.escalated"
    ANNOUNCEMENT_CREATED = "announcement.created"
    REPORT_EXPORT = "report.exported"
    INSTRUCTOR_LEAVE = "instructor.leave_changed"
    AUTO_REPLY_CHANGED = "instructor.auto_reply_changed"
    ACCESS_DENIED = "auth.access_denied"
    ACCOUNT_ADMINISTRATION = "user.updated"
    EMAIL_PROCESSED = "email.processed"
    STUDENT_CREATED = "student.created"
    OFFICER_CREATED = "officer.created"
    ADMIN_CREATED = "admin.created"
    USER_UPDATED = "user.updated"
