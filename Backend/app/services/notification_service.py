from sqlalchemy.ext.asyncio import AsyncSession

from app.Enums.NotificationTypeEnum import NotificationTypeEnum
from app.Enums.NotificationChannelEnum import NotificationChannelEnum
from app.Enums.NotificationStatusEnum import NotificationStatusEnum

from app.models.notification import Notification


class NotificationService:
    @staticmethod
    async def create_notification(
        db: AsyncSession,
        recipient_id: int,
        subject: str,
        message_body: str,
        notification_type: NotificationTypeEnum,
        ticket_id: int,
        notification_channel: NotificationChannelEnum,
        notification_status: NotificationStatusEnum,
    ):
        notification = Notification(
            recipient_id=recipient_id,
            ticket_id=ticket_id,
            subject=subject,
            message_body=message_body,
            type=notification_type,
            channel=notification_channel,
            status=notification_status,
        )

        db.add(notification)
        await db.flush()

        return notification
