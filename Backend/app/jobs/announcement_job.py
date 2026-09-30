from sqlalchemy import select

from app.models.announcements import Announcements as Announcement

from app.services.announcement_service import AnnouncementService
from app.services.gmail_service import get_gmail_service, send_email


from app.database import AsyncSessionLocal


async def send_announcement(announcement_id: int):
    async with AsyncSessionLocal() as db:
        stmt = select(Announcement).where(Announcement.id == announcement_id)

        result = await db.execute(stmt)

        announcement = result.scalar_one_or_none()

        recipients = await AnnouncementService.get_recipients(db, announcement)

        service = get_gmail_service()

        for student in recipients:
            send_email(announcement.body, student.email, announcement.title, service)
