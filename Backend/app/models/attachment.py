from sqlalchemy.orm import Mapped, mapped_column, relationship
from sqlalchemy import ForeignKey, String, BigInteger

from app.models.base import TimestampMixin


from app.database import Base


class Attachment(Base, TimestampMixin):
    __tablename__ = "attachments"

    id: Mapped[int] = mapped_column(primary_key=True, autoincrement=True)

    ticket_id: Mapped[int] = mapped_column(
        ForeignKey("tickets.id", ondelete="SET NULL"), nullable=True
    )

    original_filename: Mapped[str] = mapped_column(String(255))

    stored_filename: Mapped[str] = mapped_column(String(255))

    file_path: Mapped[str] = mapped_column(String(500))

    file_type: Mapped[str] = mapped_column(String(255))

    file_size: Mapped[int] = mapped_column(BigInteger)

    uploaded_by: Mapped[int] = mapped_column(
        ForeignKey("users.id", ondelete="SET NULL"), nullable=True
    )

    ticket: Mapped["Ticket"] = relationship(foreign_keys=[ticket_id])
    creator: Mapped["User"] = relationship(foreign_keys=[uploaded_by])
