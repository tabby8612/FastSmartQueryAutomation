from sqlalchemy.ext.asyncio import AsyncSession

from app.models.ticket import Ticket
from app.models.ticket_status_history import TicketStatusHistory

from app.helpers.security import get_current_user


class TicketStatusHistoryService:
    @staticmethod
    async def create(db: AsyncSession, ticket: Ticket, new_status: str, user_id):

        history = TicketStatusHistory(
            ticket_id=ticket.id,
            old_status=ticket.status,
            new_status=new_status,
            changed_by=user_id,
        )

        db.add(history)
        await db.commit()
        await db.refresh(history)
        return history
