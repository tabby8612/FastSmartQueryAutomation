from sqlalchemy.ext.asyncio import AsyncSession

from app.schemas.announcements import AnnouncementCreate

from app.models.user import User
from app.models.announcements import Announcements as Announcement

from sqlalchemy import select, or_
from sqlalchemy.orm import selectinload


class AnnouncementService:
    @staticmethod
    async def create(db: AsyncSession, data: AnnouncementCreate, admin_id: int):
        announcement = Announcement(
            title=data.title,
            body=data.body,
            audience_type=data.audience_type,
            department_id=data.department_id,
            creator_id=admin_id,
        )

        db.add(announcement)
        await db.commit()
        await db.refresh(announcement)

        return announcement

    @staticmethod
    async def get_recipients(db: AsyncSession, announcement: Announcement):
        stmt = select(User).where(User.is_active.is_(True), User.is_student.is_(True))

        if announcement.audience_type == "department":
            stmt = stmt.where(User.department_id == announcement.department_id)

        result = await db.execute(stmt)

        return list(result.scalars().all())

    @staticmethod
    async def admin_index(db: AsyncSession):
        stmt = select(Announcement).options(
            selectinload(Announcement.department), selectinload(Announcement.creator)
        )

        result = await db.execute(stmt)

        return list(result.scalars().all())

    @staticmethod
    async def student_index(db: AsyncSession, student: User):
        stmt = (
            select(Announcement)
            .options(
                selectinload(Announcement.department),
                selectinload(Announcement.creator),
            )
            .where(
                or_(
                    Announcement.audience_type == "all",
                    Announcement.department_id == student.department_id,
                )
            )
        )

        result = await db.execute(stmt)

        return list(result.scalars().all())
