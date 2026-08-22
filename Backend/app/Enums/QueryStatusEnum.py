from enum import Enum


class QueryStatusEnum(str, Enum):
    OPEN = "open"
    IN_PROGRESS = "in_progress"
    ASSIGNED = "assigned"
    CLOSED = "closed"
