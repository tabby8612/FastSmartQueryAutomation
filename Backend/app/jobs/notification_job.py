import asyncio
from datetime import datetime, timezone

from sqlalchemy import select
from sqlalchemy.orm import selectinload

from sqlalchemy.ext.asyncio import AsyncSession

from app.models.notification import Notification

from app.Enums.NotificationStatusEnum import NotificationStatusEnum

from app.services.gmail_service import get_gmail_service, send_email

from app.database import AsyncSessionLocal


async def get_pending_notification(db: AsyncSession):
    stmt = (
        select(Notification)
        .options(selectinload(Notification.receiver))
        .where(
            Notification.status == NotificationStatusEnum.PENDING,
            Notification.retry_count < 3,
        )
        .limit(20)
    )

    results = await db.execute(stmt)

    return list(results.scalars().all())


async def process_notification(notification: Notification, db: AsyncSession):
    try:
        gmail_service = get_gmail_service()

        await asyncio.to_thread(
            send_email,
            notification.message_body,
            notification.receiver.email,
            notification.subject,
            gmail_service,
        )

        notification.status = NotificationStatusEnum.SENT
        notification.sent_at = datetime.now(timezone.utc)
    except Exception as e:
        notification.retry_count += 1
        notification.error_message = str(e)

        if notification.error_message >= 3:
            notification.status = NotificationStatusEnum.FAILED

    await db.commit()


async def process_pending_notification():

    print("processing pending notification job...")

    async with AsyncSessionLocal() as db:
        notifications = await get_pending_notification(db)

        for notification in notifications:
            await process_notification(notification, db)


if __name__ == "__main__":
    asyncio.run(process_pending_notification())
