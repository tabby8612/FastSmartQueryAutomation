from enum import Enum


class ReplyStatusEnum(str, Enum):
    DRAFT = "draft"
    SENT = "sent"
