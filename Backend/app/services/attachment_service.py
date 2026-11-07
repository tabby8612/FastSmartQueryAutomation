import os
import magic
import aiofiles

from dotenv import load_dotenv
from uuid import uuid4

from pathlib import Path
from fastapi import UploadFile, HTTPException, status

from app.models.attachment import Attachment

from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy import select
from sqlalchemy.exc import SQLAlchemyError

load_dotenv()


class AttachmentService:
    MAX_FILE_SIZE = int(os.getenv("MAX_UPLOAD_SIZE_MB", "5")) * 1024 * 1024

    ALLOWED_FILES = {
        ".pdf": "application/pdf",
        ".jpg": "image/jpeg",
        ".jpeg": "image/jpeg",
        ".png": "image/png",
    }

    @staticmethod
    async def validate_file(file: UploadFile):
        if not file.filename:
            raise HTTPException(status.HTTP_400_BAD_REQUEST, "Filename is required")

        extension = Path(file.filename).suffix.lower()

        if extension not in AttachmentService.ALLOWED_FILES:
            raise HTTPException(
                status.HTTP_415_UNSUPPORTED_MEDIA_TYPE, "Unsupported file extension"
            )

        content = await file.read(AttachmentService.MAX_FILE_SIZE + 1)

        if not content:
            raise HTTPException(status.HTTP_400_BAD_REQUEST, "Empty file not allowed")

        if len(content) > AttachmentService.MAX_FILE_SIZE:
            raise HTTPException(
                status.HTTP_400_BAD_REQUEST,
                f"File size cannot exceed {AttachmentService.MAX_FILE_SIZE} MB.",
            )

        detected_mime = magic.from_buffer(content, mime=True)

        expected_mime = AttachmentService.ALLOWED_FILES[extension]

        if detected_mime != expected_mime:
            raise HTTPException(
                status.HTTP_415_UNSUPPORTED_MEDIA_TYPE,
                "File content does not match its extension.",
            )

        await file.seek(0)

    @staticmethod
    async def save_file(file: UploadFile) -> str:
        extension = Path(file.filename).suffix.lower()

        unique_filename = f"ticket_attachments/{uuid4().hex}{extension}"

        upload_path = Path(os.getenv("UPLOAD_FOLDER_PATH", "uploads"))

        upload_path.mkdir(parents=True, exist_ok=True)

        file_path = upload_path / unique_filename

        try:
            await file.seek(0)

            async with aiofiles.open(file_path, "wb") as destination:
                while chunk := await file.read(1024 * 1024):
                    await destination.write(chunk)
        except Exception:
            if file_path.exists():
                file_path.unlink()

            raise HTTPException(
                status_code=status.HTTP_422_UNPROCESSABLE_CONTENT,
                detail="Fail to save attachment",
            )
        finally:
            await file.seek(0)

        return unique_filename

    @staticmethod
    async def create_attachment_record(
        db: AsyncSession,
        ticket_id: int,
        uploaded_by: int,
        file: UploadFile,
        stored_filename: str,
    ) -> Attachment:
        upload_path = Path(os.getenv("UPLOAD_FOLDER_PATH", "uploads"))

        file_path = upload_path / stored_filename

        try:
            attachment = Attachment(
                ticket_id=ticket_id,
                original_filename=file.filename,
                stored_filename=stored_filename,
                file_path=str(file_path),
                file_type=AttachmentService.ALLOWED_FILES[
                    Path(file.filename).suffix.lower()
                ],
                file_size=file_path.stat().st_size,
                uploaded_by=uploaded_by,
            )

            db.add(attachment)
            await db.flush()
            await db.refresh(attachment)

            return attachment
        except Exception as error:
            raise HTTPException(
                status.HTTP_422_UNPROCESSABLE_CONTENT,
                f"Fail to create attachment record - {error}",
            )

    @staticmethod
    async def get_ticket_attachments(
        db: AsyncSession, ticket_id: int
    ) -> list[Attachment]:
        stmt = (
            select(Attachment)
            .where(Attachment.ticket_id == ticket_id)
            .order_by(Attachment.created_at.desc())
        )

        result = await db.execute(stmt)

        attachments = result.scalars().all()

        return list(attachments)

    @staticmethod
    async def get_attachment_by_id(db: AsyncSession, attachment_id: int):
        stmt = select(Attachment).where(Attachment.id == attachment_id)

        result = await db.execute(stmt)

        return result.scalar_one_or_none()

    @staticmethod
    async def delete_attachment(db: AsyncSession, attachment_id: int):
        attachment = await AttachmentService.get_attachment_by_id(db, attachment_id)

        if not attachment:
            raise HTTPException(status.HTTP_404_NOT_FOUND, "Attachment not found")

        upload_path = Path(os.getenv("UPLOAD_FOLDER_PATH", "uploads")).resolve()

        file_path = (upload_path / attachment.stored_filename).resolve()

        if file_path.parent != upload_path:
            raise HTTPException(
                status.HTTP_400_BAD_REQUEST, "Invalid attachment storage path"
            )

        try:
            if file_path.exists():
                if not file_path.is_file():
                    raise OSError("Attachment path is not a file")

                file_path.unlink()
        except OSError:
            raise HTTPException(
                status.HTTP_422_UNPROCESSABLE_CONTENT,
                "Failed to delete attachment file.",
            )

        try:
            await db.delete(attachment)

            await db.commit()

        except SQLAlchemyError:

            await db.rollback()

            raise HTTPException(
                status.HTTP_422_UNPROCESSABLE_CONTENT,
                "Failed to delete attachment record.",
            )
