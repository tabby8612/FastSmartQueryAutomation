from enum import Enum


class QueryStatusEnum(str, Enum):
    OPEN = "open"
    PENDING = "pending"
    IN_PROGRESS = "in_progress"
    ASSIGNED = "assigned"
    CLOSED = "closed"
