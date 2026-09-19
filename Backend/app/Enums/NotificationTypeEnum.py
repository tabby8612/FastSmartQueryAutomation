from enum import Enum


class NotificationTypeEnum(str, Enum):
    TICKET_CREATED = "ticket_created"
    TICKET_ASSIGNED = "ticket_assigned"
    NEW_REPLY = "new_reply"
    STATUS_CHANGED = "status_changed"
    ESCALATED = "escalated"
    BROADCAST = "broadcast"
