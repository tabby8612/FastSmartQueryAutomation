from datetime import datetime, date, timedelta, timezone

from sqlalchemy import select, func
from sqlalchemy.ext.asyncio import AsyncSession

from app.models.ticket import Ticket
from app.models.department import Department
from app.models.category import Category


class AnalyticsService:
    @staticmethod
    async def get_summary(
        db: AsyncSession, start_date: date | None, end_date: date | None
    ):
        filters = AnalyticsService.date_filters(start_date, end_date)

        stmt = select(
            func.count(Ticket.id).label("total"),
            func.count(Ticket.id).filter(Ticket.status == "pending").label("pending"),
            func.count(Ticket.id)
            .filter(Ticket.resolved_at.is_not(None))
            .label("resolved"),
            func.count(Ticket.id)
            .filter(Ticket.escalation_level > 0)
            .label("escalated"),
        ).where(*filters)

        total_results = await db.execute(stmt)

        row = total_results.one()

        return {
            "total_tickets": row.total,
            "pending_tickets": row.pending,
            "resolved_tickets": row.resolved,
            "escalated_tickets": row.escalated,
        }

    @staticmethod
    async def get_by_status(
        db: AsyncSession, start_date: date | None, end_date: date | None
    ):
        filters = AnalyticsService.date_filters(start_date, end_date)

        stmt = (
            select(Ticket.status, func.count(Ticket.id).label("count"))
            .where(*filters)
            .group_by(Ticket.status)
            .order_by(func.count(Ticket.id).desc())
        )

        result = await db.execute(stmt)

        return [{"name": row.status, "count": row.count} for row in result.all()]

    @staticmethod
    async def get_by_category(
        db: AsyncSession, start_date: date | None, end_date: date | None
    ):
        filters = AnalyticsService.date_filters(start_date, end_date)

        stmt = (
            select(Category.name, func.count(Ticket.id).label("count"))
            .where(*filters)
            .join(Ticket, Ticket.category_id == Category.id)
            .group_by(Category.id, Category.name)
            .order_by(func.count(Ticket.id).desc())
        )

        result = await db.execute(stmt)

        return [{"name": row.name, "count": row.count} for row in result.all()]

    @staticmethod
    async def get_by_department(
        db: AsyncSession, start_date: date | None, end_date: date | None
    ):
        filters = AnalyticsService.date_filters(start_date, end_date)
        stmt = (
            select(Department.name, func.count(Ticket.id).label("count"))
            .where(*filters)
            .join(Ticket, Ticket.department_id == Department.id)
            .group_by(Department.id, Department.name)
            .order_by(func.count(Ticket.id).desc())
        )

        result = await db.execute(stmt)

        return [{"name": row.name, "count": row.count} for row in result.all()]

    @staticmethod
    async def get_by_priority(
        db: AsyncSession, start_date: date | None, end_date: date | None
    ):
        filters = AnalyticsService.date_filters(start_date, end_date)

        stmt = (
            select(Ticket.priority, func.count(Ticket.id).label("count"))
            .group_by(Ticket.priority)
            .where(*filters)
            .where(Ticket.priority.is_not(None))
            .order_by(func.count(Ticket.id).desc())
        )

        result = await db.execute(stmt)

        return [{"name": row.priority, "count": row.count} for row in result.all()]

    @staticmethod
    async def get_by_escalation(
        db: AsyncSession, start_date: date | None, end_date: date | None
    ):
        filters = AnalyticsService.date_filters(start_date, end_date)

        stmt = select(
            func.count(Ticket.id)
            .filter(Ticket.escalation_level > 0)
            .label("escalated_count"),
            func.count(Ticket.id).label("total_ticket_count"),
        ).where(*filters)

        result = await db.execute(stmt)

        row = result.one()

        escalated = row.escalated_count
        total = row.total_ticket_count
        escalation_rate = escalated / total * 100 if total > 0 else 0

        return {
            "total_escalated": escalated,
            "not_escalated": total - escalated,
            "escalation_rate": f"{escalation_rate:.2f}%",
        }

    @staticmethod
    async def ticket_trend(
        db: AsyncSession, start_date: date | None, end_date: date | None
    ):
        date_column = func.date_trunc("day", Ticket.created_at).label("date")

        filters = AnalyticsService.date_filters(start_date, end_date)

        stmt = (
            select(date_column, func.count(Ticket.id).label("count"))
            .where(*filters)
            .group_by(date_column)
            .order_by(date_column)
        )

        result = await db.execute(stmt)

        return [
            {
                "date": row.date.strftime("%Y-%m-%d"),
                "count": row.count,
            }
            for row in result.all()
        ]

    @staticmethod
    def date_filters(start_date: date | None, end_date: date | None):
        filters = []

        if start_date is not None:
            filters.append(Ticket.created_at >= start_date)

        if end_date is not None:
            filters.append(
                Ticket.created_at
                < datetime.combine(
                    end_date + timedelta(days=1), datetime.min.time(), timezone.utc
                )
            )

        return filters
