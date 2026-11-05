from pydantic import BaseModel, ConfigDict, field_validator
from datetime import datetime

from app.helpers.html_sanitizer import sanitize_html
from app.Enums.ReplyStatusEnum import ReplyStatusEnum


class ReplyCreate(BaseModel):
    text: str

    @classmethod
    @field_validator("text")
    def validate_body(cls, value):
        if not value.strip():
            raise ValueError("Query description is required")

        santitized_text = sanitize_html(value)

        if not santitized_text.strip():
            raise ValueError("Query description cannot be empty")

        return santitized_text


class ReplyUpdate(BaseModel):
    text: str

    @classmethod
    @field_validator("body")
    def validate_body(cls, value):
        if not value.strip():
            raise ValueError("Query description is required")

        santitized_text = sanitize_html(value)

        if not santitized_text.strip():
            raise ValueError("Query description cannot be empty")

        return santitized_text


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
