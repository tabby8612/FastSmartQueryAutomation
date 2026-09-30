from app.models.base import TimestampMixin
from app.database import Base

from sqlalchemy.orm import Mapped, mapped_column, relationship
from sqlalchemy import ForeignKey, String, Text


class Announcements(Base, TimestampMixin):
    __tablename__ = "announcements"

    id: Mapped[int] = mapped_column(primary_key=True, autoincrement=True)

    creator_id: Mapped[int] = mapped_column(
        ForeignKey("users.id", ondelete="SET NULL"), nullable=False
    )
    title: Mapped[str] = mapped_column(String(255), nullable=False)
    body: Mapped[str] = mapped_column(Text, nullable=False)
    channel: Mapped[str] = mapped_column(
        String(255), default="email", server_default="email"
    )
    audience_type: Mapped[str] = mapped_column(
        String(255), default="all", server_default="all"
    )
    department_id: Mapped[int] = mapped_column(
        ForeignKey("departments.id", ondelete="SET NULL"), nullable=True
    )

    creator: Mapped["User"] = relationship(foreign_keys=[creator_id])
    department: Mapped["Department | None"] = relationship(foreign_keys=[department_id])
