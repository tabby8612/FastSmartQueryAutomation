from datetime import datetime, timezone

from sqlalchemy import select

from sqlalchemy.ext.asyncio import AsyncSession

from sqlalchemy.orm import selectinload, joinedload

from app.models.ticket import Ticket
from app.models.department import Department
from app.models.user import User
from app.models.ticket_status_history import TicketStatusHistory
from app.models.reply import Reply


from app.services.notification_template import NotificationTemplate
from app.services.notification_service import NotificationService

from app.Enums.NotificationChannelEnum import NotificationChannelEnum
from app.Enums.NotificationStatusEnum import NotificationStatusEnum
from app.Enums.NotificationTypeEnum import NotificationTypeEnum
from app.Enums.TicketPriorityEnum import TicketPriorityEnum
from app.Enums.QueryStatusEnum import QueryStatusEnum
from app.Enums.ReplyStatusEnum import ReplyStatusEnum


from app.dependencies.hod import get_hod_ticket, get_hod_department


class HODTicketService:
    @staticmethod
    async def get_escalation_tickets(hod_dept: Department, db: AsyncSession):
        stmt = select(Ticket).options(
            selectinload(Ticket.student),
            selectinload(Ticket.assigned),
            selectinload(Ticket.department),
            selectinload(Ticket.category),
            selectinload(Ticket.replies).options(joinedload(Reply.creator)),
            selectinload(Ticket.ticket_status_history),
        )

        stmt = stmt.where(
            Ticket.department_id == hod_dept.id, Ticket.escalation_level > 0
        )

        result = await db.execute(stmt)

        return result.scalars().all()

    @staticmethod
    async def get_ticket(db: AsyncSession, ticket_id: int, hod_dept: Department):
        ticket = await get_hod_ticket(db, ticket_id, hod_dept)

        return ticket

    @staticmethod
    async def take_over(
        db: AsyncSession, ticket_id: int, hod_dept: Department, current_hod: User
    ):
        ticket = await get_hod_ticket(db, ticket_id, hod_dept)

        ticket.assigned_id = current_hod.id

        db.add(ticket)
        await db.flush()
        await db.refresh(ticket)

        return ticket

    @staticmethod
    async def reassign(
        db: AsyncSession, ticket_id: int, hod_dept: Department, officer: User
    ):
        ticket = await get_hod_ticket(db, ticket_id, hod_dept)

        ticket.assigned_id = officer.id

        assigned_notification_template = NotificationTemplate.ticket_assigned(ticket)

        new_assigned_officer_notification = (
            await NotificationService.create_notification(
                db,
                recipient_id=officer.id,
                subject=assigned_notification_template["subject"],
                message_body=assigned_notification_template["body"],
                notification_type=NotificationTypeEnum.TICKET_ASSIGNED,
                ticket_id=ticket.id,
                notification_status=NotificationStatusEnum.PENDING,
                notification_channel=NotificationChannelEnum.EMAIL,
            )
        )
        db.add(ticket)
        db.add(new_assigned_officer_notification)
        await db.flush()

        return ticket

    @staticmethod
    async def change_priority(
        db: AsyncSession,
        ticket_id: int,
        hod_dept: Department,
        priority: TicketPriorityEnum,
    ):
        ticket = await get_hod_ticket(db, ticket_id, hod_dept)

        ticket.priority = priority

        await db.flush()

        return ticket

    @staticmethod
    async def change_status(
        db: AsyncSession,
        ticket_id: int,
        hod_dept: Department,
        status: QueryStatusEnum,
        current_user: User,
    ):
        ticket = await get_hod_ticket(db, ticket_id, hod_dept)

        if status == QueryStatusEnum.RESOLVED:
            ticket.resolved_at = datetime.now(timezone.utc)

        if status == QueryStatusEnum.OPEN:
            ticket.resolved_at = None

        history = TicketStatusHistory(
            ticket_id=ticket.id,
            old_status=ticket.status,
            new_status=status,
            changed_by=current_user.id,
        )

        status_change_notification_template = NotificationTemplate.status_changed(
            ticket, ticket.status, status
        )
        status_change_notification = await NotificationService.create_notification(
            db,
            recipient_id=ticket.student_id,
            subject=status_change_notification_template["subject"],
            message_body=status_change_notification_template["body"],
            notification_type=NotificationTypeEnum.STATUS_CHANGED,
            ticket_id=ticket.id,
            notification_status=NotificationStatusEnum.PENDING,
            notification_channel=NotificationChannelEnum.EMAIL,
        )

        ticket.status = status

        db.add(history)
        db.add(status_change_notification)
        await db.flush()

        return ticket

    @staticmethod
    async def add_reply(
        ticket_id: int,
        current_user: User,
        hod_dept: Department,
        reply_text: str,
        db: AsyncSession,
    ):
        ticket = await get_hod_ticket(db, ticket_id, hod_dept)

        reply = Reply(
            ticket_id=ticket.id,
            creator_id=current_user.id,
            text=reply_text,
            is_ai_draft=0,
            status=ReplyStatusEnum.SENT,
        )
        db.add(reply)
        await db.flush()
        await db.refresh(reply)
        return reply
