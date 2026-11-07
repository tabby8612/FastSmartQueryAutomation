from fastapi import APIRouter, Depends, HTTPException, status
from fastapi.responses import FileResponse

from sqlalchemy.ext.asyncio import AsyncSession

from app.helpers.security import get_db, get_current_user, allowed_rolenames
from app.helpers.utils import has_role

from app.models.user import User

from app.services.attachment_service import AttachmentService
from app.services.TicketService import TicketService

from app.Enums.RolesEnum import RolesEnum

router = APIRouter(prefix="/attachment", tags=["Attachment"])


@router.get("/tickets/{ticket_id}/attachments")
async def ticket_attachments(ticket_id: int, db: AsyncSession = Depends(get_db)):
    ticket_attachments = await AttachmentService.get_ticket_attachments(db, ticket_id)

    return ticket_attachments


@router.get("/attachments/{attachment_id}/download")
async def attachment(
    attachment_id: int,
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(get_current_user),
):
    attachment = await AttachmentService.get_attachment_by_id(db, attachment_id)

    if attachment is None:
        raise HTTPException(status.HTTP_404_NOT_FOUND, "Attachment not found.")

    ticket = await TicketService.get_by_id(db, attachment.ticket_id)

    if ticket is None:
        raise HTTPException(
            status.HTTP_404_NOT_FOUND, "Ticket related to the attachment not found."
        )

    if has_role(current_user, [RolesEnum.STUDENT.name.lower()]):
        if ticket.student_id != current_user.id:
            raise HTTPException(
                status.HTTP_401_UNAUTHORIZED,
                "You are not authorized to access this attachment",
            )

    if has_role(current_user, [RolesEnum.OFFICER.name.lower()]):
        if ticket.assigned_id != current_user.id:
            raise HTTPException(
                status.HTTP_401_UNAUTHORIZED,
                "You are not authorized to access this attachment",
            )

    if has_role(current_user, [RolesEnum.HOD.name.lower()]):
        if ticket.department_id != current_user.department_id:
            raise HTTPException(
                status.HTTP_401_UNAUTHORIZED,
                "You are not authorized to access this attachment",
            )

    return FileResponse(
        path=attachment.file_path,
        filename=attachment.stored_filename.replace("/", "_"),
        media_type=attachment.file_type,
    )


@router.delete("/attachments/{attachment_id}")
async def attachment(
    attachment_id: int,
    db: AsyncSession = Depends(get_db),
    allowed_roles: User = Depends(allowed_rolenames(["admin"])),
):
    await AttachmentService.delete_attachment(db, attachment_id)

    return {"message": "Attachment deleted successfully.", "success": True}
