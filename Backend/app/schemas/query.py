from datetime import datetime
from decimal import Decimal

from pydantic import BaseModel, ConfigDict


class QueryBase(BaseModel):
    tracking_id: str
    student_id: int
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


class QueryCreate(BaseModel):
    subject: str
    body: str


class QueryUpdate(BaseModel):
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


class QueryResponse(QueryBase):
    id: int

    model_config = ConfigDict(from_attributes=True)
