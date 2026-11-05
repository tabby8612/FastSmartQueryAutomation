import os

from dotenv import load_dotenv

from fastapi import HTTPException, status

from sqlalchemy import select

from sqlalchemy.ext.asyncio import AsyncSession

from app.helpers.image_utils import process_image, delete_image

from app.models.user import User

from app.helpers.security import hash_password

from starlette.concurrency import run_in_threadpool

from PIL import UnidentifiedImageError

load_dotenv()

MAX_FILE_SIZE = int(os.getenv("MAX_UPLOAD_SIZE_MB", 5)) * 1024 * 1024


class ProfileService:
    @staticmethod
    async def get_user(db: AsyncSession, user_id: int):
        stmt = select(User).where(User.id == user_id)

        result = await db.execute(stmt)

        return result.scalar_one_or_none()

    @staticmethod
    async def update_personal_detail(
        db: AsyncSession,
        user: User,
        email: str | None = None,
        full_name: str | None = None,
    ):
        if email is not None:
            stmt = select(User).where(User.id != user.id, User.email == email)

            result = await db.execute(stmt)

            existing_user = result.scalar_one_or_none()

            if existing_user:
                raise HTTPException(
                    status_code=status.HTTP_409_CONFLICT,
                    detail="User will same email already exist",
                )

            user.email = email
        if full_name is not None:
            user.full_name = full_name

        await db.flush()
        await db.refresh(user)

        return user

    @staticmethod
    async def update_password(
        db: AsyncSession,
        user: User,
        new_password: str,
    ):
        user.password = hash_password(new_password)

        await db.flush()

        return user

    @staticmethod
    async def upload_profile_image(content: bytes, user: User, db: AsyncSession):

        if len(content) > MAX_FILE_SIZE:
            raise HTTPException(
                status.HTTP_403_FORBIDDEN,
                f"File too large. Max size is {MAX_FILE_SIZE // (1024 * 1024)}MB",
            )

        try:
            new_filename = await run_in_threadpool(process_image, content, True)

        except UnidentifiedImageError as error:
            raise HTTPException(
                status_code=status.HTTP_400_BAD_REQUEST,
                detail="Invalid image file. Please upload a valid image (JPEG, PNG, GIF, WebP)",
            ) from error

        old_filename = user.profile_image

        user.profile_image = new_filename

        await db.commit()
        await db.refresh(user)

        if old_filename:
            delete_image(old_filename)

        return new_filename

    @staticmethod
    async def delete_profile_image(user: User, db: AsyncSession):
        old_filename = user.profile_image

        if old_filename is None:
            raise HTTPException(
                status.HTTP_400_BAD_REQUEST, "No Profile Picture to Delete"
            )

        user.profile_image = None

        await db.flush()
        await db.refresh(user)

        delete_image(old_filename)
