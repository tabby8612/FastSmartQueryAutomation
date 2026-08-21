from sqlalchemy.future import select
from sqlalchemy.orm import joinedload

from app.models.user import User
from app.helpers.security import verify_password
from app.services.user import UserService
from fastapi.security import OAuth2PasswordRequestForm


class AuthService:
    @staticmethod
    async def register(
        db,
        student_id: str,
        email: str,
        password: str,
        full_name: str,
        role_id: int,
        department_id: int,
        is_active: bool = True,
        on_leave: bool = False,
    ) -> User:

        return await UserService.create(
            db=db,
            student_id=student_id,
            email=email,
            password=password,
            full_name=full_name,
            role_id=role_id,
            department_id=department_id,
            is_active=is_active,
            on_leave=on_leave,
        )

    @staticmethod
    async def login(db, user_data: OAuth2PasswordRequestForm) -> User | None:
        result = await db.execute(
            select(User)
            .options(joinedload(User.department), joinedload(User.role))
            .where(User.email == user_data.username)
        )
        user = result.scalar_one_or_none()
        if not user:
            return None
        if not verify_password(user_data.password, user.password):
            return None
        return user
