from sqlalchemy.ext.asyncio import AsyncSession

from app.models.ticket import Ticket
from app.models.ticket_status_history import TicketStatusHistory

from app.services.notification_template import NotificationTemplate
from app.services.notification_service import NotificationService

from app.Enums.NotificationStatusEnum import NotificationStatusEnum
from app.Enums.NotificationChannelEnum import NotificationChannelEnum
from app.Enums.NotificationTypeEnum import NotificationTypeEnum

from app.helpers.security import get_current_user


class TicketStatusHistoryService:
    @staticmethod
    async def create(db: AsyncSession, ticket: Ticket, new_status: str, user_id):

        history = TicketStatusHistory(
            ticket_id=ticket.id,
            old_status=ticket.status,
            new_status=new_status,
            changed_by=user_id,
        )

        db.add(history)
        await db.commit()
        await db.refresh(history)

        status_change_notification_template = NotificationTemplate.status_changed(
            ticket=ticket, old_status=ticket.status, new_status=new_status
        )

        await NotificationService.create_notification(
            db,
            recipient_id=ticket.student_id,
            subject=status_change_notification_template["subject"],
            message_body=status_change_notification_template["body"],
            notification_type=NotificationTypeEnum.STATUS_CHANGED,
            ticket_id=ticket.id,
            notification_status=NotificationStatusEnum.PENDING,
            notification_channel=NotificationChannelEnum.EMAIL,
        )
        return history
