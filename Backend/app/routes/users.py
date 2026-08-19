from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.ext.asyncio import AsyncSession

from app.database import get_db
from app.schemas.user import UserCreate, UserResponse, UserUpdate
from app.services.user import UserService

router = APIRouter(prefix="/users", tags=["users"])


@router.post("/", response_model=UserResponse, status_code=status.HTTP_201_CREATED)
async def create_user(user: UserCreate, db: AsyncSession = Depends(get_db)):
    return await UserService.create(
        db=db,
        student_id=user.student_id,
        email=user.email,
        password=user.password,
        full_name=user.full_name,
        role_id=user.role_id,
        department_id=user.department_id,
        is_active=user.is_active,
        on_leave=user.on_leave,
        auto_reply_message=user.auto_reply_message,
        leave_start_day=user.leave_start_day,
        leave_end_day=user.leave_end_day,
    )


@router.get("/", response_model=list[UserResponse])
async def get_users(db: AsyncSession = Depends(get_db)):
    return await UserService.get_all(db)


@router.get("/{user_id}", response_model=UserResponse)
async def get_user(user_id: int, db: AsyncSession = Depends(get_db)):
    user = await UserService.get_by_id(db, user_id)
    if not user:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND, detail="User not found"
        )
    return user


@router.put("/{user_id}", response_model=UserResponse)
async def update_user(user_id: int, user_update: UserUpdate, db: AsyncSession = Depends(get_db)):
    user = await UserService.get_by_id(db, user_id)
    if not user:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND, detail="User not found"
        )
    return await UserService.update(
        db=db,
        user=user,
        student_id=user_update.student_id,
        email=user_update.email,
        password=user_update.password,
        full_name=user_update.full_name,
        role_id=user_update.role_id,
        department_id=user_update.department_id,
        is_active=user_update.is_active,
        on_leave=user_update.on_leave,
        auto_reply_message=user_update.auto_reply_message,
        leave_start_day=user_update.leave_start_day,
        leave_end_day=user_update.leave_end_day,
    )


@router.delete("/{user_id}", status_code=status.HTTP_204_NO_CONTENT)
async def delete_user(user_id: int, db: AsyncSession = Depends(get_db)):
    user = await UserService.get_by_id(db, user_id)
    if not user:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND, detail="User not found"
        )
    await UserService.delete(db, user)
