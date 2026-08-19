from datetime import date

from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy.future import select

from app.models.user import User
from app.helpers.security import hash_password


class UserService:
    @staticmethod
    async def create(
        db: AsyncSession,
        student_id: str,
        email: str,
        password: str,
        full_name: str,
        role_id: int,
        department_id: int,
        is_active: bool = True,
        on_leave: bool = False,
        auto_reply_message: str | None = None,
        leave_start_day: date | None = None,
        leave_end_day: date | None = None,
    ) -> User:
        hashed_password = hash_password(password)

        user = User(
            student_id=student_id,
            email=email,
            password=hashed_password,
            full_name=full_name,
            role_id=role_id,
            department_id=department_id,
            is_active=is_active,
            on_leave=on_leave,
            auto_reply_message=auto_reply_message,
            leave_start_day=leave_start_day,
            leave_end_day=leave_end_day,
        )
        db.add(user)
        await db.flush()
        await db.refresh(user)
        return user

    @staticmethod
    async def get_all(db: AsyncSession) -> list[User]:
        result = await db.execute(select(User))
        return list(result.scalars().all())

    @staticmethod
    async def get_by_id(db: AsyncSession, user_id: int) -> User | None:
        result = await db.execute(select(User).where(User.id == user_id))
        return result.scalar_one_or_none()

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
        await db.delete(user)
        await db.flush()
