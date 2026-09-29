from datetime import date

from fastapi import APIRouter, Depends

from sqlalchemy.ext.asyncio import AsyncSession

from app.database import get_db

from app.helpers.security import allowed_rolenames

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
):
    results = await AnalyticsService.get_summary(db, start_date, end_date)
    return results


@router.get("/tickets-over-time")
async def tickets_over_time(
    db: AsyncSession = Depends(get_db),
    start_date: date | None = None,
    end_date: date | None = None,
):
    ticket_trend = await AnalyticsService.ticket_trend(db, start_date, end_date)

    return ticket_trend


@router.get("/by-status")
async def by_status(
    db: AsyncSession = Depends(get_db),
    start_date: date | None = None,
    end_date: date | None = None,
):
    result_by_status = await AnalyticsService.get_by_status(db, start_date, end_date)

    return result_by_status


@router.get("/by-category")
async def by_category(
    db: AsyncSession = Depends(get_db),
    start_date: date | None = None,
    end_date: date | None = None,
):
    result_by_category = await AnalyticsService.get_by_category(
        db, start_date, end_date
    )

    return result_by_category


@router.get("/by-department")
async def by_department(
    db: AsyncSession = Depends(get_db),
    start_date: date | None = None,
    end_date: date | None = None,
):
    result_by_department = await AnalyticsService.get_by_department(
        db, start_date, end_date
    )

    return result_by_department


@router.get("/by-priority")
async def by_priority(
    db: AsyncSession = Depends(get_db),
    start_date: date | None = None,
    end_date: date | None = None,
):
    result_by_priority = await AnalyticsService.get_by_priority(
        db, start_date, end_date
    )

    return result_by_priority


@router.get("/escalations")
async def escalations(
    db: AsyncSession = Depends(get_db),
    start_date: date | None = None,
    end_date: date | None = None,
):
    escalated_ticket = await AnalyticsService.get_by_escalation(
        db, start_date, end_date
    )

    return escalated_ticket
