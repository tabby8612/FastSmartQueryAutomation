from sqlalchemy.ext.asyncio import AsyncSession

from app.models.user import User

from sqlalchemy import select, or_, and_, Select

from app.models.ticket import Ticket
from app.models.announcements import Announcements
from app.models.notification import Notification

from app.helpers.utils import has_role


class SearchService:
    @staticmethod
    async def search(db: AsyncSession, current_user: User, q: str):
        ticket_stmt = (
            select(Ticket)
            .where(
                or_(
                    Ticket.subject.ilike(f"%{q}%"),
                    Ticket.body.ilike(f"%{q}%"),
                    Ticket.tracking_id.ilike(f"%{q}%"),
                ),
            )
            .limit(10)
        )

        ticket_stmt = SearchService.ticket_rolebase_query_filtering(
            current_user, ticket_stmt
        )

        announcement_stmt = (
            select(Announcements)
            .where(
                or_(
                    Announcements.title.ilike(f"%{q}%"),
                    Announcements.body.ilike(f"%{q}%"),
                )
            )
            .limit(10)
        )

        announcement_stmt = SearchService.announcement_rolebase_query_filtering(
            current_user, announcement_stmt
        )

        notification_stmt = (
            select(Notification)
            .where(
                or_(
                    Notification.subject.ilike(f"%{q}%"),
                    Notification.message_body.ilike(f"%{q}%"),
                ),
            )
            .limit(10)
        )

        notification_stmt = SearchService.notification_rolebase_query_filtering(
            current_user, notification_stmt
        )

        ticket_result = await db.execute(ticket_stmt)
        announcement_result = await db.execute(announcement_stmt)
        notification_result = await db.execute(notification_stmt)

        tickets = list(ticket_result.scalars().all())
        announcements = list(announcement_result.scalars().all())
        notifications = list(notification_result.scalars().all())

        return {
            "tabs": ["tickets", "announcements", "notifications"],
            "data": {
                "tickets": [
                    {
                        "id": ticket.id,
                        "tracking_id": ticket.tracking_id,
                        "subject": ticket.subject,
                        "body": ticket.body,
                        "status": ticket.status,
                        "created_at": ticket.created_at,
                    }
                    for ticket in tickets
                ],
                "announcements": [
                    {
                        "id": announcement.id,
                        "title": announcement.title,
                        "body": announcement.body,
                        "created_at": announcement.created_at,
                    }
                    for announcement in announcements
                ],
                "notifications": [
                    {
                        "id": notification.id,
                        "subject": notification.subject,
                        "message_body": notification.message_body,
                        "created_at": notification.created_at,
                    }
                    for notification in notifications
                ],
            },
        }

    @staticmethod
    def ticket_rolebase_query_filtering(current_user: User, ticket_stmt: Select):
        if has_role(current_user, ["student"]):
            ticket_stmt = ticket_stmt.where(Ticket.student_id == current_user.id)

        elif has_role(current_user, ["officer"]):
            ticket_stmt = ticket_stmt.where(Ticket.assigned_id == current_user.id)

        elif has_role(current_user, ["hod"]):
            ticket_stmt = ticket_stmt.where(
                Ticket.department_id == current_user.department_id
            )

        return ticket_stmt

    @staticmethod
    def announcement_rolebase_query_filtering(
        current_user: User, announcement_stmt: Select
    ):
        if not has_role(current_user, ["admin"]):
            announcement_stmt = announcement_stmt.where(
                or_(
                    Announcements.audience_type == "all",
                    and_(
                        Announcements.audience_type == "department",
                        Announcements.department_id == current_user.department_id,
                    ),
                ),
            )

        return announcement_stmt

    @staticmethod
    def notification_rolebase_query_filtering(
        current_user: User, notification_stmt: Select
    ):
        if not has_role(current_user, ["admin"]):
            notification_stmt = notification_stmt.where(
                and_(Notification.recipient_id == current_user.id)
            )

        return notification_stmt
