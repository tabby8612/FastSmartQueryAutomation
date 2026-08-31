from fastapi import HTTPException, status
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
            .options(joinedload(User.department), joinedload(User.roles))
            .where(User.email == user_data.username)
        )
        user = result.unique().scalar_one_or_none()
        if not user:
            return None
        if not verify_password(user_data.password, user.password):
            return None
        return user

    @staticmethod
    async def authorize_google_account(db, userinfo):
        google_sub = userinfo["sub"]
        email = userinfo["email"]
        email_verified = userinfo.get("email_verified", False)

        if not email_verified:
            raise HTTPException(
                status_code=status.HTTP_400_BAD_REQUEST,
                detail="Google Email is not verified",
            )

        user = await AuthService.find_user_by_google_sub(db, google_sub)

        if user is None:
            user = await AuthService.find_user_by_email(db, email, google_sub)

        return user

    @staticmethod
    async def find_user_by_google_sub(db, google_sub: str):
        stmt = (
            select(User)
            .where(User.google_sub == google_sub)
            .options(joinedload(User.department), joinedload(User.roles))
        )

        result = await db.execute(stmt)

        return result.unique().scalar_one_or_none()

    @staticmethod
    async def find_user_by_email(db, email: str, google_sub: str):
        stmt = (
            select(User)
            .where(User.email == email)
            .options(joinedload(User.department), joinedload(User.roles))
        )

        result = await db.execute(stmt)

        user = result.unique().scalar_one_or_none()

        if user:
            user.google_sub = google_sub

        return user
