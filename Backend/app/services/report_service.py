from datetime import date, datetime, timedelta, timezone

from sqlalchemy import select
from sqlalchemy.orm import selectinload

from sqlalchemy.ext.asyncio import AsyncSession

from app.models.ticket import Ticket
from app.models.user import User
from app.models.department import Department
from app.models.category import Category

from app.Enums.QueryStatusEnum import QueryStatusEnum
from app.Enums.ChannelEnum import ChannelEnum


class ReportService:
    @staticmethod
    async def get_tickets(
        db: AsyncSession,
        current_user: User,
        start_date: date | None = None,
        end_date: date | None = None,
        department_id: int | None = None,
        category_id: int | None = None,
        priority: str | None = None,
        status: QueryStatusEnum | None = None,
        channel: ChannelEnum | None = None,
    ):
        filters = ReportService.add_filters(
            start_date, end_date, department_id, category_id, priority, status, channel
        )

        stmt = (
            select(Ticket)
            .where(*filters)
            .options(
                selectinload(Ticket.student).load_only(
                    User.id, User.email, User.full_name
                ),
                selectinload(Ticket.assigned).load_only(
                    User.id, User.email, User.full_name
                ),
                selectinload(Ticket.department).load_only(
                    Department.id, Department.name
                ),
                selectinload(Ticket.category).load_only(Category.id, Category.name),
            )
        )

        if ReportService.is_hod(current_user):
            stmt = stmt.where(Ticket.department_id == current_user.department_id)

        result = await db.execute(stmt)

        return list(result.scalars().all())

    @staticmethod
    def is_hod(user: User):
        return any(role.name == "hod" for role in user.roles)

    @staticmethod
    def add_filters(
        start_date, end_date, department_id, category_id, priority, status, channel
    ):
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

        if department_id is not None:
            filters.append(Ticket.department_id == department_id)

        if category_id is not None:
            filters.append(Ticket.category_id == category_id)

        if priority is not None:
            filters.append(Ticket.priority == priority)

        if status is not None:
            filters.append(Ticket.status == status)

        if channel is not None:
            filters.append(Ticket.channel == channel)

        return filters
