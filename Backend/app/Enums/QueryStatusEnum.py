from enum import Enum


class QueryStatusEnum(str, Enum):
    OPEN = "open"
    PENDING = "pending"
    ASSIGNED = "assigned"
    IN_PROGRESS = "in_progress"
    AWAITING_STUDENT = "awaiting_student"
    ESCALATED = "escalated"
    RESOLVED = "resolved"
    CLOSED = "closed"

    @classmethod
    def to_label(cls, status) -> str | None:
        match status:
            case "open":
                return "Open"
            case "pending":
                return "Pending"
            case "in_progress":
                return "In Progress"
            case "assigned":
                return "Assigned"
            case "awaiting_student":
                return "Awaiting Student"
            case "escalated":
                return "Escalated"
            case "resolved":
                return "Resolved"
            case "closed":
                return "Closed"
            case _:
                return None
