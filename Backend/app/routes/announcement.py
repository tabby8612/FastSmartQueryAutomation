from fastapi import APIRouter, Depends, BackgroundTasks

from sqlalchemy.ext.asyncio import AsyncSession

from app.schemas.announcements import AnnouncementCreate, AnnouncementResponse

from app.services.announcement_service import AnnouncementService
from app.services.audit_service import AuditService

from app.database import get_db

from app.helpers.security import get_current_user, allowed_rolenames

from app.models.user import User

from app.jobs.announcement_job import send_announcement

from app.Enums.AuditActionEnum import AuditActionEnum

router = APIRouter(tags=["announcements"])


@router.post("/admin/announcements")
async def create_announcement(
    data: AnnouncementCreate,
    background_tasks: BackgroundTasks,
    _=Depends(allowed_rolenames(["admin"])),
    db: AsyncSession = Depends(get_db),
    admin_user: User = Depends(get_current_user),
):
    announcement = await AnnouncementService.create(db, data, admin_user.id)

    background_tasks.add_task(send_announcement, announcement.id)

    await AuditService.record_audit(
        db,
        actor_id=admin_user.id,
        action=AuditActionEnum.ANNOUNCEMENT_CREATED,
        entity_type="announcement",
        entity_id=announcement.id,
        description="New announcement has been created",
    )

    return {
        "message": "A new announcement is created successfully.",
        "announcement_id": announcement.id,
    }


@router.get("/admin/announcements", response_model=list[AnnouncementResponse])
async def get_admin_announcements(
    db: AsyncSession = Depends(get_db),
    _=Depends(allowed_rolenames(["admin"])),
):
    announcements = await AnnouncementService.admin_index(db)

    return announcements


@router.get("/student/announcements", response_model=list[AnnouncementResponse])
async def get_student_announcements(
    db: AsyncSession = Depends(get_db),
    _=Depends(allowed_rolenames(["student"])),
    student: User = Depends(get_current_user),
):
    announcements = await AnnouncementService.student_index(db, student)

    return announcements
