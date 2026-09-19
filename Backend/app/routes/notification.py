from fastapi import APIRouter, Depends, HTTPException, status

from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy import select

from app.helpers.security import get_current_user
from app.database import get_db

from app.models.notification import Notification
from app.models.user import User

router = APIRouter(
    prefix="/notifications",
    tags=["notifications"],
)


@router.get("/")
async def index(
    db: AsyncSession = Depends(get_db), current_user: User = Depends(get_current_user)
):
    stmt = (
        select(Notification)
        .where(Notification.recipient_id == current_user.id)
        .order_by(Notification.created_at.desc())
    )

    result = await db.execute(stmt)

    return result.scalars().all()


@router.get("/{notification_id}")
async def show(
    notification_id: int,
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(get_current_user),
):
    stmt = (
        select(Notification)
        .where(Notification.recipient_id == current_user.id)
        .where(Notification.id == notification_id)
    )

    result = await db.execute(stmt)

    notification = result.scalar_one_or_none()

    if notification is None:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND, detail="Notification not found"
        )

    return notification
