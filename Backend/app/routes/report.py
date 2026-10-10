from datetime import date

from fastapi import APIRouter, Depends

from sqlalchemy.ext.asyncio import AsyncSession

from app.database import get_db

from app.helpers.security import allowed_rolenames, get_current_user

from app.services.report_service import ReportService

from app.Enums.QueryStatusEnum import QueryStatusEnum
from app.Enums.ChannelEnum import ChannelEnum

router = APIRouter(
    prefix="/reports",
    tags=["reports"],
    dependencies=[Depends(allowed_rolenames(["admin", "hod"]))],
)


@router.get("/tickets")
async def index(
    db: AsyncSession = Depends(get_db),
    start_date: date | None = None,
    end_date: date | None = None,
    department_id: int | None = None,
    category_id: int | None = None,
    priority: str | None = None,
    status: QueryStatusEnum | None = None,
    channel: ChannelEnum | None = None,
    current_user=Depends(get_current_user),
):
    ticketsData = await ReportService.get_tickets(
        db,
        current_user,
        start_date,
        end_date,
        department_id,
        category_id,
        priority,
        status,
        channel,
    )

    return ticketsData
