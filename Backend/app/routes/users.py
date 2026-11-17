from datetime import date

from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.ext.asyncio import AsyncSession

from app.database import get_db
from app.schemas.user import OfficerOptionResponse, UserCreate, UserResponse, UserUpdate

from app.services.user import UserService
from app.services.audit_service import AuditService

from app.helpers.security import get_current_user, allowed_roles

from app.Enums.RolesEnum import RolesEnum
from app.Enums.AuditActionEnum import AuditActionEnum

from app.models.user import User

from app.resources.AuthResource import AuthResource

router = APIRouter(
    prefix="/users",
    tags=["users"],
    dependencies=[Depends(get_current_user)],
)


@router.post(
    "/create_student",
    response_model=UserResponse,
    status_code=status.HTTP_201_CREATED,
)
async def create_student(
    user: UserCreate,
    db: AsyncSession = Depends(get_db),
    current_user=Depends(get_current_user),
    _=Depends(allowed_roles([RolesEnum.ADMIN])),
):
    new_student = await UserService.create(
        db=db,
        student_id=user.student_id,
        email=user.email,
        password=user.password,
        full_name=user.full_name,
        is_active=user.is_active,
        is_student=True,
        is_officer=False,
        is_admin=False,
    )

    await AuditService.record_audit(
        db,
        actor_id=current_user.id,
        action=AuditActionEnum.STUDENT_CREATED,
        entity_type="user",
        entity_id=new_student.id,
        description="new student has been created",
    )

    return new_student


@router.post(
    "/create_officer", response_model=UserResponse, status_code=status.HTTP_201_CREATED
)
async def create_officer(
    user: UserCreate,
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(get_current_user),
    _=Depends(allowed_roles([RolesEnum.ADMIN])),
):
    new_officer = await UserService.create(
        db=db,
        email=user.email,
        password=user.password,
        full_name=user.full_name,
        department_id=user.department_id,
        is_active=user.is_active,
        is_student=False,
        is_officer=True,
        is_admin=False,
        on_leave=user.on_leave,
        auto_reply_message=user.auto_reply_message,
        leave_start_day=user.leave_start_day,
        leave_end_day=user.leave_end_day,
    )

    await AuditService.record_audit(
        db,
        actor_id=current_user.id,
        action=AuditActionEnum.OFFICER_CREATED,
        entity_type="user",
        entity_id=new_officer.id,
        description="new officer has been created",
    )

    return new_officer


@router.post(
    "/create_admin", response_model=UserResponse, status_code=status.HTTP_201_CREATED
)
async def create_admin(
    user: UserCreate,
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(get_current_user),
    _=Depends(allowed_roles([RolesEnum.ADMIN])),
):
    new_admin = await UserService.create(
        db=db,
        email=user.email,
        password=user.password,
        full_name=user.full_name,
        is_active=user.is_active,
        is_student=False,
        is_officer=False,
        is_admin=True,
        on_leave=user.on_leave,
        auto_reply_message=user.auto_reply_message,
        leave_start_day=user.leave_start_day,
        leave_end_day=user.leave_end_day,
    )

    await AuditService.record_audit(
        db,
        actor_id=current_user.id,
        action=AuditActionEnum.ADMIN_CREATED,
        entity_type="user",
        entity_id=new_admin.id,
        description="new admin has been created",
    )

    return new_admin


@router.post(
    "/create_hod",
    response_model=UserResponse,
    status_code=status.HTTP_201_CREATED,
)
async def create_hod(
    user: UserCreate,
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(get_current_user),
    _=Depends(allowed_roles([RolesEnum.ADMIN])),
):
    new_hod = await UserService.create(
        db=db,
        email=user.email,
        password=user.password,
        full_name=user.full_name,
        is_active=user.is_active,
        department_id=user.department_id,
        is_student=False,
        is_officer=False,
        is_admin=False,
        on_leave=user.on_leave,
        auto_reply_message=user.auto_reply_message,
        leave_start_day=user.leave_start_day,
        leave_end_day=user.leave_end_day,
    )

    await AuditService.record_audit(
        db,
        actor_id=current_user.id,
        action=AuditActionEnum.ADMIN_CREATED,
        entity_type="user",
        entity_id=new_hod.id,
        description="new admin has been created",
    )

    return new_hod


@router.get("/")
async def get_users(
    db: AsyncSession = Depends(get_db),
    start_date: date | None = None,
    end_date: date | None = None,
    name_email: str | None = None,
    role: str | None = None,
    dept_id: int | None = None,
    _=Depends(allowed_roles([RolesEnum.ADMIN])),
):
    users = await UserService.get_all(
        db, start_date, end_date, name_email, role, dept_id
    )

    return AuthResource.usersResource(users)


@router.get(
    "/department_officers/{department_id}",
    response_model=list[OfficerOptionResponse],
)
async def get_officers_by_department(
    department_id: int,
    _=Depends(allowed_roles([RolesEnum.ADMIN, RolesEnum.HOD])),
    db: AsyncSession = Depends(get_db),
):
    return await UserService.get_officers_by_department(db, department_id)


@router.get("/{user_id}", response_model=UserResponse)
async def get_user(user_id: int, db: AsyncSession = Depends(get_db)):
    user = await UserService.get_by_id(db, user_id)
    if not user:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND, detail="User not found"
        )
    return user


@router.put("/{user_id}", response_model=UserResponse)
async def update_user(
    user_id: int,
    user_update: UserUpdate,
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(get_current_user),
    _=Depends(allowed_roles([RolesEnum.ADMIN])),
):
    user = await UserService.get_by_id(db, user_id)
    if not user:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND, detail="User not found"
        )
    updated_user = await UserService.update(
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

    await AuditService.record_audit(
        db,
        actor_id=current_user.id,
        action=AuditActionEnum.USER_UPDATED,
        entity_type="user",
        entity_id=updated_user.id,
        description="User has been updated",
    )

    return update_user


@router.delete(
    "/{user_id}",
    status_code=status.HTTP_204_NO_CONTENT,
)
async def delete_user(
    user_id: int,
    db: AsyncSession = Depends(get_db),
    _=Depends(allowed_roles([RolesEnum.ADMIN])),
):
    user = await UserService.get_by_id(db, user_id)
    if not user:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND, detail="User not found"
        )
    await UserService.delete(db, user)

    return {"message": "User is deleted", "success": True}
