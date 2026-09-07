from fastapi import APIRouter, Depends

from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy import select

from app.helpers.security import get_current_user, get_db, allowed_roles

from app.models.user import User
from app.models.ticket_status_history import TicketStatusHistory

from app.Enums.RolesEnum import RolesEnum

router = APIRouter(prefix="/tickets", tags=["ticket history"])


@router.get("/{ticket_id}/status-history")
async def status_history(
    ticket_id: int,
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(get_current_user),
):
    stmt = select(TicketStatusHistory).where(TicketStatusHistory.ticket_id == ticket_id)
    result = await db.execute(stmt)

    return result.scalars().all()
