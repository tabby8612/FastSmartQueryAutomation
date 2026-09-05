from pydantic import BaseModel, ConfigDict
from datetime import datetime

from app.Enums.ReplyStatusEnum import ReplyStatusEnum


class ReplyCreate(BaseModel):
    text: str


class ReplyUpdate(BaseModel):
    text: str


class User(BaseModel):
    id: int
    full_name: str
    is_student: bool
    is_officer: bool
    is_admin: bool


class ReplyResponse(BaseModel):
    id: int
    ticket_id: int
    creator_id: int | None
    is_ai_draft: bool
    text: str
    status: ReplyStatusEnum
    send_at: datetime | None
    created_at: datetime
    creator: User | None

    model_config = ConfigDict(from_attributes=True)
