from sqlalchemy.orm import Mapped, mapped_column, relationship
from datetime import datetime

from app.database import Base
from app.models.base import TimestampMixin

from sqlalchemy import String, ForeignKey, Text, SmallInteger


class IncomingEmail(Base, TimestampMixin):
    __tablename__ = "incoming_emails"
    id: Mapped[int] = mapped_column(primary_key=True, autoincrement=True)
    message_id: Mapped[str] = mapped_column(String(255), unique=True, nullable=False)
    email_from: Mapped[str] = mapped_column(String(255), nullable=False)
    creator_id: Mapped[int | None] = mapped_column(
        ForeignKey("users.id", ondelete="SET NULL"), nullable=True
    )
    subject: Mapped[str] = mapped_column(String(255), nullable=True)
    body: Mapped[str] = mapped_column(Text, nullable=True)
    is_processed: Mapped[int] = mapped_column(SmallInteger, nullable=False, default=0)
    ticket_id: Mapped[int | None] = mapped_column(
        ForeignKey("tickets.id", ondelete="SET NULL"), nullable=True
    )
    received_on: Mapped[datetime | None] = mapped_column(nullable=True)

    creator: Mapped[User] = relationship(foreign_keys=[creator_id])
    ticket: Mapped[Ticket] = relationship("Ticket")

    pass
