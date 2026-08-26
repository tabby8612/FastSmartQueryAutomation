from datetime import datetime
from decimal import Decimal

from pydantic import BaseModel, ConfigDict, Field
from app.schemas.user import UserResponse


class TicketBase(BaseModel):
    tracking_id: str
    student_id: int | None = None
    assigned_id: int | None = None
    department_id: int | None = None
    category_id: int | None = None
    channel: str
    subject: str
    body: str
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


class TicketResponse(TicketBase):
    id: int
    created_at: datetime | None
    student: Student | None
    assigned: Officer | None
    department: Department | None
    category: Category | None

    model_config = ConfigDict(from_attributes=True)
