from datetime import datetime

from sqlalchemy.orm import Mapped, mapped_column, relationship
from sqlalchemy import ForeignKey, String

from app.models.base import Base, TimestampMixin


class TicketStatusHistory(Base, TimestampMixin):
    __tablename__ = "ticket_status_history"
    id: Mapped[int] = mapped_column(primary_key=True, autoincrement=True)
    ticket_id: Mapped[int | None] = mapped_column(
        ForeignKey("tickets.id", ondelete="SET NULL"), nullable=True
    )
    old_status: Mapped[str] = mapped_column(String(255), nullable=True)
    new_status: Mapped[str] = mapped_column(String(255), nullable=False)
    changed_by: Mapped[int] = mapped_column(ForeignKey("users.id"), nullable=True)

    ticket: Mapped[Ticket] = relationship(
        "Ticket", back_populates="ticket_status_history"
    )
    changedBy: Mapped[User] = relationship(foreign_keys=[changed_by])
