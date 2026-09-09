from datetime import datetime
from decimal import Decimal

from pydantic import BaseModel, ConfigDict, Field, computed_field
from typing import Literal
from app.schemas.user import UserResponse

from app.Enums.QueryStatusEnum import QueryStatusEnum


class TicketBase(BaseModel):
    tracking_id: str
    student_id: int | None = None
    assigned_id: int | None = None
    department_id: int | None = None
    category_id: int | None = None
    channel: str
    subject: str
    body: str
    priority: str | None = None
    intent: str | None = None
    confidence_level: Decimal | None = None
    status: str
    escalation_level: int = 0
    awaiting_student_input: bool = False
    resolved_at: datetime | None = None


class TicketCreate(BaseModel):
    subject: str = Field(min_length=15, max_length=200)
    body: str = Field(min_length=20, max_length=1000)


class TicketUpdate(BaseModel):
    assigned_id: int | None = None
    channel: str | None = None
    subject: str | None = None
    body: str | None = None
    intent: str | None = None
    priority: str | None = None
    confidence_level: Decimal | None = None
    status: str | None = None
    escalation_level: int | None = None
    awaiting_student_input: bool | None = None
    resolved_at: datetime | None = None


class Student(BaseModel):
    id: int
    student_id: str | None
    email: str
    full_name: str


class Officer(BaseModel):
    id: int
    email: str
    full_name: str


class Department(BaseModel):
    id: int
    name: str


class Category(BaseModel):
    id: int
    name: str


class Creator(BaseModel):
    id: int
    full_name: str
    is_student: bool
    is_officer: bool
    is_admin: bool


class Reply(BaseModel):
    id: int
    ticket_id: int
    creator_id: int
    is_ai_draft: int
    text: str
    status: Literal["sent", "draft"]
    send_at: datetime | None
    created_at: datetime
    creator: Creator


class TicketStatusHistory(BaseModel):
    id: int
    new_status: str
    created_at: datetime
    old_status: str | None
    ticket_id: int
    changed_by: int | None

    @computed_field(return_type=str | None)
    @property
    def new_status_label(self):
        return QueryStatusEnum.to_label(self.new_status)


class TicketResponse(TicketBase):
    id: int
    created_at: datetime | None
    student: Student | None
    assigned: Officer | None
    department: Department | None
    category: Category | None
    replies: list[Reply] | None
    ticket_status_history: list[TicketStatusHistory] | None

    model_config = ConfigDict(from_attributes=True)
