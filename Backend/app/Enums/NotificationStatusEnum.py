from enum import Enum


class NotificationStatusEnum(str, Enum):
    PENDING = "pending"
    SENT = "sent"
    FAILED = "failed"
