from datetime import date

from fastapi import APIRouter, Depends

from sqlalchemy.ext.asyncio import AsyncSession

from app.database import get_db

from app.helpers.security import allowed_rolenames, get_current_user
from app.helpers.utils import get_actor_ip

from app.services.report_service import ReportService
from app.services.audit_service import AuditService

from app.Enums.QueryStatusEnum import QueryStatusEnum
from app.Enums.ChannelEnum import ChannelEnum
from app.Enums.AuditActionEnum import AuditActionEnum

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
    ip_address=Depends(get_actor_ip),
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

    await AuditService.record_audit(
        db,
        actor_id=current_user.id,
        action=AuditActionEnum.REPORT_EXPORT,
        entity_type="ticket",
        description="Ticket report has been exported",
        ip_address=str(ip_address),
    )

    return ticketsData
