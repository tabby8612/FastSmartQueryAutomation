from datetime import datetime

from pydantic import BaseModel

from app.Enums.NotificationTypeEnum import NotificationTypeEnum
from app.Enums.NotificationChannelEnum import NotificationChannelEnum
from app.Enums.NotificationStatusEnum import NotificationStatusEnum


class NotificationCreate(BaseModel):
    recipicent_id: int
    ticket_id: int | None = None
    type: NotificationTypeEnum
    subject: str
    message_body: str


class NotificationResponse(BaseModel):
    id: int
    recipicent_id: int
    ticket_id: int | None
    type: NotificationTypeEnum
    channel: NotificationChannelEnum
    subject: str
    message_body: str
    status: NotificationStatusEnum
    created_at: datetime
    sent_at: datetime | None

    model_config = {"from_attributes": True}
