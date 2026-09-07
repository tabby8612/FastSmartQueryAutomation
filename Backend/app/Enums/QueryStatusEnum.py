from enum import Enum


class QueryStatusEnum(str, Enum):
    OPEN = "open"
    PENDING = "pending"
    IN_PROGRESS = "in_progress"
    ASSIGNED = "assigned"
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
            case "closed":
                return "Closed"
            case _:
                return None
