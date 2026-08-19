from sqlalchemy.future import select

from app.models.user import User
from app.helpers.security import verify_password
from app.services.user import UserService


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
    async def login(db, email: str, password: str) -> User | None:
        result = await db.execute(select(User).where(User.email == email))
        user = result.scalar_one_or_none()
        return user
        if not user:
            return None
        if not verify_password(password, user.password):
            return None
        return user
