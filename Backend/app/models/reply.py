from app.models.base import Base, TimestampMixin
from sqlalchemy.orm import Mapped, mapped_column, relationship
from sqlalchemy import ForeignKey, Boolean, Text, String, DateTime, func, SmallInteger
from datetime import datetime


class Reply(Base, TimestampMixin):
    __tablename__ = "replies"
    id: Mapped[int] = mapped_column(primary_key=True, autoincrement=True)
    ticket_id: Mapped[int] = mapped_column(ForeignKey("tickets.id"), nullable=False)
    creator_id: Mapped[int] = mapped_column(ForeignKey("users.id"), nullable=True)
    is_ai_draft: Mapped[int] = mapped_column(
        SmallInteger, nullable=False, default=0, server_default="0"
    )
    text: Mapped[str] = mapped_column(Text, nullable=False)
    status: Mapped[str] = mapped_column(
        String, nullable=False, default="draft", server_default="draft"
    )
    send_at: Mapped[datetime | None] = mapped_column(
        DateTime(timezone=True), nullable=True
    )

    ticket: Mapped[Ticket] = relationship(
        foreign_keys=[ticket_id], back_populates="replies"
    )
    creator: Mapped[User] = relationship(foreign_keys=[creator_id])
