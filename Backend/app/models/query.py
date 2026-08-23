from __future__ import annotations

from datetime import datetime
from decimal import Decimal

from sqlalchemy import String, Text, Numeric, SmallInteger, ForeignKey, Index
from sqlalchemy.orm import Mapped, mapped_column, relationship
from app.database import Base
from app.models.base import TimestampMixin


class Query(Base, TimestampMixin):
    __tablename__ = "queries"

    id: Mapped[int] = mapped_column(primary_key=True, autoincrement=True)
    tracking_id: Mapped[str] = mapped_column(
        String(255), unique=True, nullable=False, index=True
    )
    student_id: Mapped[int] = mapped_column(ForeignKey("users.id"), nullable=True)
    assigned_id: Mapped[int | None] = mapped_column(
        ForeignKey("users.id"), nullable=True
    )
    department_id: Mapped[int] = mapped_column(
        ForeignKey("departments.id"), nullable=True
    )
    category_id: Mapped[int] = mapped_column(ForeignKey("categories.id"), nullable=True)
    channel: Mapped[str] = mapped_column(String(255), nullable=False)
    subject: Mapped[str] = mapped_column(String(255), nullable=False)
    body: Mapped[str] = mapped_column(Text, nullable=False)
    intent: Mapped[str] = mapped_column(String(255), nullable=True)
    confidence_level: Mapped[Decimal] = mapped_column(Numeric(4, 3), nullable=True)
    status: Mapped[str] = mapped_column(String(255), nullable=False)
    escalation_level: Mapped[int] = mapped_column(
        SmallInteger, nullable=False, default=0
    )
    awaiting_student_input: Mapped[bool] = mapped_column(nullable=False, default=False)
    resolved_at: Mapped[datetime | None] = mapped_column(nullable=True)

    student: Mapped[User] = relationship(foreign_keys=[student_id])
    assigned: Mapped[User | None] = relationship(foreign_keys=[assigned_id])
    department: Mapped[Department] = relationship(foreign_keys=[department_id])
    category: Mapped[Category] = relationship(foreign_keys=[category_id])
