from fastapi import APIRouter, Depends, HTTPException, status

from sqlalchemy.ext.asyncio import AsyncSession

from app.helpers.security import allowed_rolenames

from app.schemas.instructor_leave import InstructorLeave, LeaveResponse

from app.models.user import User

from app.services.instructor_leave_service import InstructorLeaveService
from app.services.user import UserService

from app.helpers.security import get_current_user, get_db

router = APIRouter(
    prefix="/instructor",
    tags=["Instructor Leave"],
    dependencies=[Depends(allowed_rolenames(["officer"]))],
)


@router.get("/leave", response_model=LeaveResponse)
async def get_leave(
    current_user: User = Depends(get_current_user),
    db: AsyncSession = Depends(get_db),
):
    if not current_user.is_officer:
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="Only officer can use this feature",
        )

    officer = await UserService.get_by_id(db, current_user.id)

    return officer


@router.put("/leave", response_model=LeaveResponse)
async def set_leave(
    data: InstructorLeave,
    current_user: User = Depends(get_current_user),
    db: AsyncSession = Depends(get_db),
):
    if not current_user.is_officer:
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="Only officer can use this feature",
        )

    if data.start_date > data.end_date:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="Leave start date cannot be greater than end date",
        )

    officer = InstructorLeaveService.set_leave(
        officer=current_user,
        start_date=data.start_date,
        end_date=data.end_date,
        auto_reply_message=data.auto_reply_message,
    )

    db.add(officer)
    await db.commit()
    await db.refresh(officer)

    return officer


@router.delete("/leave")
async def cancel_leave(
    current_user: User = Depends(get_current_user), db: AsyncSession = Depends(get_db)
):
    if not current_user.is_officer:
        raise HTTPException(
            status.HTTP_403_FORBIDDEN, detail="Only officer can cancel leave"
        )

    InstructorLeaveService.cancel_leave(officer=current_user)

    await db.commit()

    return {"message": "Leave cancelled successfully."}
