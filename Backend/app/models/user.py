from __future__ import annotations

from datetime import date
from sqlalchemy import String, Text, Boolean, ForeignKey, Date
from sqlalchemy.orm import Mapped, mapped_column, relationship
from app.database import Base
from app.models.base import TimestampMixin
from app.models.role import Role
from app.models.department import Department


class User(Base, TimestampMixin):
    __tablename__ = "users"

    id: Mapped[int] = mapped_column(primary_key=True, autoincrement=True)
    student_id: Mapped[str] = mapped_column(String(255), unique=True, nullable=True)
    email: Mapped[str] = mapped_column(String(255), unique=True, nullable=False)
    password: Mapped[str] = mapped_column(String(255), nullable=False)
    full_name: Mapped[str] = mapped_column(String(255), nullable=False)
    department_id: Mapped[int] = mapped_column(
        ForeignKey("departments.id"), nullable=True
    )
    is_active: Mapped[bool] = mapped_column(Boolean, default=True, nullable=False)
    is_student: Mapped[bool] = mapped_column(Boolean, default=True, nullable=False)
    is_officer: Mapped[bool] = mapped_column(Boolean, default=False, nullable=False)
    is_admin: Mapped[bool] = mapped_column(Boolean, default=False, nullable=False)
    on_leave: Mapped[bool] = mapped_column(Boolean, default=False, nullable=False)
    auto_reply_message: Mapped[str | None] = mapped_column(Text, nullable=True)
    leave_start_day: Mapped[date | None] = mapped_column(Date, nullable=True)
    leave_end_day: Mapped[date | None] = mapped_column(Date, nullable=True)

    department: Mapped[Department] = relationship(
        back_populates="users", foreign_keys=[department_id]
    )

    roles = relationship("Role", secondary="user_roles", back_populates="users")
