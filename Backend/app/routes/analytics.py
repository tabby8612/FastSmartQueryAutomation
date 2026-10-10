from datetime import date

from fastapi import APIRouter, Depends

from sqlalchemy.ext.asyncio import AsyncSession

from app.database import get_db

from app.helpers.security import allowed_rolenames

from app.models.user import User

from app.services.analytics_service import AnalyticsService

router = APIRouter(
    prefix="/admin/analytics",
    tags=["analytics"],
    dependencies=[Depends(allowed_rolenames(["admin"]))],
)


@router.get("/summary")
async def summary(
    db: AsyncSession = Depends(get_db),
    start_date: date | None = None,
    end_date: date | None = None,
    department_id: int | None = None,
    category_id: int | None = None,
):
    results = await AnalyticsService.get_summary(
        db, start_date, end_date, department_id, category_id
    )
    return results


@router.get("/tickets-over-time")
async def tickets_over_time(
    db: AsyncSession = Depends(get_db),
    start_date: date | None = None,
    end_date: date | None = None,
    department_id: int | None = None,
    category_id: int | None = None,
):
    ticket_trend = await AnalyticsService.ticket_trend(
        db, start_date, end_date, department_id, category_id
    )

    return ticket_trend


@router.get("/by-status")
async def by_status(
    db: AsyncSession = Depends(get_db),
    start_date: date | None = None,
    end_date: date | None = None,
    department_id: int | None = None,
    category_id: int | None = None,
):
    result_by_status = await AnalyticsService.get_by_status(
        db, start_date, end_date, department_id, category_id
    )

    return result_by_status


@router.get("/by-category")
async def by_category(
    db: AsyncSession = Depends(get_db),
    start_date: date | None = None,
    end_date: date | None = None,
    department_id: int | None = None,
    category_id: int | None = None,
):
    result_by_category = await AnalyticsService.get_by_category(
        db, start_date, end_date, department_id, category_id
    )

    return result_by_category


@router.get("/by-department")
async def by_department(
    db: AsyncSession = Depends(get_db),
    start_date: date | None = None,
    end_date: date | None = None,
    department_id: int | None = None,
    category_id: int | None = None,
):
    result_by_department = await AnalyticsService.get_by_department(
        db, start_date, end_date, department_id, category_id
    )

    return result_by_department


@router.get("/by-priority")
async def by_priority(
    db: AsyncSession = Depends(get_db),
    start_date: date | None = None,
    end_date: date | None = None,
    department_id: int | None = None,
    category_id: int | None = None,
):
    result_by_priority = await AnalyticsService.get_by_priority(
        db, start_date, end_date, department_id, category_id
    )

    return result_by_priority


@router.get("/by-channel")
async def by_channel(
    db: AsyncSession = Depends(get_db),
    start_date: date | None = None,
    end_date: date | None = None,
    department_id: int | None = None,
    category_id: int | None = None,
):
    result_by_priority = await AnalyticsService.get_by_channel(
        db, start_date, end_date, department_id, category_id
    )

    return result_by_priority


@router.get("/escalations")
async def escalations(
    db: AsyncSession = Depends(get_db),
    start_date: date | None = None,
    end_date: date | None = None,
    department_id: int | None = None,
    category_id: int | None = None,
):
    escalated_ticket = await AnalyticsService.get_by_escalation(
        db, start_date, end_date, department_id, category_id
    )

    return escalated_ticket


@router.get("/department-report")
async def department_report(
    db: AsyncSession = Depends(get_db),
    start_date: date | None = None,
    end_date: date | None = None,
    department_id: int | None = None,
    category_id: int | None = None,
    allowed_roles: User = Depends(allowed_rolenames(["admin", "hod"])),
):
    escalated_ticket = await AnalyticsService.department_report(
        db, start_date, end_date, department_id, category_id
    )

    return escalated_ticket
