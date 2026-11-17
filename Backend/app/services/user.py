from datetime import date, datetime, timedelta, timezone

from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy import select, or_, func
from sqlalchemy.orm import joinedload

from fastapi import HTTPException, status

from app.models.user import User
from app.models.role import Role
from app.models.user_roles import User_Roles
from app.helpers.security import hash_password

from app.Enums.RolesEnum import RolesEnum


class UserService:
    @staticmethod
    async def create(
        db: AsyncSession,
        email: str,
        full_name: str,
        student_id: str | None = None,
        password: str | None = None,
        department_id: int | None = None,
        is_active: bool = True,
        is_student: bool = True,
        is_officer: bool = False,
        is_admin: bool = False,
        on_leave: bool = False,
        google_sub: str | None = None,
        auto_reply_message: str | None = None,
        leave_start_day: date | None = None,
        leave_end_day: date | None = None,
    ) -> User:
        if password is not None:
            hashed_password = hash_password(password)

        q = select(User.id, User.email).where(User.email.ilike(f"{email}"))
        q_result = await db.execute(q)
        exist_user = q_result.scalar_one_or_none()

        if exist_user:
            raise HTTPException(
                status_code=status.HTTP_403_FORBIDDEN,
                detail="User with this email already exist",
            )

        user = User(
            student_id=student_id,
            email=email.lower(),
            password=hashed_password if password is not None else None,
            google_sub=google_sub,
            full_name=full_name,
            department_id=department_id,
            is_active=is_active,
            is_student=is_student,
            is_officer=is_officer,
            is_admin=is_admin,
            on_leave=on_leave,
            auto_reply_message=auto_reply_message,
            leave_start_day=leave_start_day,
            leave_end_day=leave_end_day,
        )

        if user.is_admin:
            stmt = select(Role).where(Role.name == "admin")
        elif user.is_officer:
            stmt = select(Role).where(Role.name == "officer")
        elif user.is_student:
            stmt = select(Role).where(Role.name == "student")
        else:
            stmt = select(Role).where(Role.name == "hod")

        result = await db.execute(stmt)
        role = result.scalar_one_or_none()

        if role is not None:
            user.roles = [role]

        db.add(user)
        await db.flush()
        await db.refresh(user)

        stmt = (
            select(User)
            .where(User.id == user.id)
            .options(joinedload(User.department), joinedload(User.roles))
        )

        result = await db.execute(stmt)

        user = result.unique().scalar_one()

        return user

    @staticmethod
    async def get_all(
        db: AsyncSession,
        start_date: date | None = None,
        end_date: date | None = None,
        name_email: str | None = None,
        role: str | None = None,
        dept_id: int | None = None,
    ) -> list[User]:
        filters = UserService.apply_filters(
            start_date, end_date, name_email, role, dept_id
        )

        stmt = (
            select(User)
            .where(*filters)
            .join(User_Roles, User_Roles.user_id == User.id)
            .join(Role, Role.id == User_Roles.role_id)
            .options(joinedload(User.roles), joinedload(User.department))
        )

        result = await db.execute(stmt)
        return list(result.scalars().unique().all())

    @staticmethod
    async def get_by_id(db: AsyncSession, user_id: int) -> User | None:
        stmt = select(User).where(User.id == user_id).options(joinedload(User.roles))

        result = await db.execute(stmt)
        return result.unique().scalar_one_or_none()

    @staticmethod
    async def get_officers_by_department(
        db: AsyncSession, department_id: int
    ) -> list[dict]:
        result = await db.execute(
            select(User).where(
                User.department_id == department_id, User.is_officer.is_(True)
            )
        )
        officers = result.scalars().all()
        return [
            {"id": officer.id, "full_name": officer.full_name} for officer in officers
        ]

    @staticmethod
    async def update(
        db: AsyncSession,
        user: User,
        student_id: str | None = None,
        email: str | None = None,
        password: str | None = None,
        full_name: str | None = None,
        role_id: int | None = None,
        department_id: int | None = None,
        is_active: bool | None = None,
        on_leave: bool | None = None,
        auto_reply_message: str | None = None,
        leave_start_day: date | None = None,
        leave_end_day: date | None = None,
    ) -> User:
        if student_id is not None:
            user.student_id = student_id
        if email is not None:
            user.email = email
        if password is not None:
            hashed_password = hash_password(password)
            user.password = hashed_password
        if full_name is not None:
            user.full_name = full_name
        if role_id is not None:
            user.role_id = role_id
        if department_id is not None:
            user.department_id = department_id
        if is_active is not None:
            user.is_active = is_active
        if on_leave is not None:
            user.on_leave = on_leave
        if auto_reply_message is not None:
            user.auto_reply_message = auto_reply_message
        if leave_start_day is not None:
            user.leave_start_day = leave_start_day
        if leave_end_day is not None:
            user.leave_end_day = leave_end_day
        await db.flush()
        await db.refresh(user)
        return user

    @staticmethod
    async def delete(db: AsyncSession, user: User) -> None:

        if user.is_admin or any(role.name == RolesEnum.ADMIN for role in user.roles):
            result = await db.execute(
                select(User).where(User.is_admin == True, User.is_active == True)
            )

            active_admins = result.scalars().all()

            if len(active_admins) <= 1:
                raise HTTPException(
                    status_code=400,
                    detail="Cannot delete the last active administrator.",
                )

        await db.delete(user)
        await db.flush()

    @staticmethod
    def apply_filters(
        start_date: date | None = None,
        end_date: date | None = None,
        name_email: str | None = None,
        role: str | None = None,
        dept_id: int | None = None,
    ):
        filters = []

        if start_date is not None:
            filters.append(User.created_at >= start_date)

        if end_date is not None:
            filters.append(
                User.created_at
                < datetime.combine(
                    end_date + timedelta(days=1), datetime.min.time(), timezone.utc
                )
            )

        if name_email is not None:
            filters.append(
                or_(
                    User.full_name.ilike(f"%{name_email}%"),
                    User.email.ilike(f"%{name_email}%"),
                )
            )

        if role is not None:
            filters.append(Role.name == role.lower())

        if dept_id is not None:
            filters.append(User.department_id == dept_id)

        return filters
