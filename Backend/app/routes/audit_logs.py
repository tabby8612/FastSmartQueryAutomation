from datetime import date

from fastapi import APIRouter, Depends

from app.helpers.security import allowed_rolenames, get_db, get_current_user

from app.models.user import User
from app.models.audit_logs import AuditLog

from app.services.audit_service import AuditService

from sqlalchemy import select, func
from sqlalchemy.orm import selectinload

from sqlalchemy.ext.asyncio import AsyncSession

router = APIRouter(
    prefix="/admin",
    tags=["Audit Logs"],
    dependencies=[Depends(allowed_rolenames(["admin"]))],
)


@router.get("/audit-logs")
async def audit_logs(
    start_date: date | None = None,
    end_date: date | None = None,
    action: str | None = None,
    entity_type: str | None = None,
    status: str | None = None,
    db: AsyncSession = Depends(get_db),
):
    filters = AuditService.filters(start_date, end_date, action, entity_type, status)

    audit_logs = await AuditService.get_audit_log(db, filters)

    return audit_logs


@router.get("/audit-logs/{log_id}")
async def audit_log(log_id: int, db: AsyncSession = Depends(get_db)):
    stmt = (
        select(AuditLog)
        .options(selectinload(AuditLog.user))
        .where(AuditLog.id == log_id)
    )

    result = await db.execute(stmt)

    return result.scalar_one_or_none()
