from fastapi import APIRouter, Depends, HTTPException, Response, status
from sqlalchemy.ext.asyncio import AsyncSession

from app.database import get_db
from app.Enums.ReplyStatusEnum import ReplyStatusEnum
from app.helpers.security import get_current_user
from app.models.reply import Reply
from app.models.ticket import Ticket
from app.models.user import User
from app.schemas.reply import ReplyCreate, ReplyResponse, ReplyUpdate
from app.services.reply_service import ReplyService
from app.services.TicketService import TicketService

router = APIRouter(prefix="/tickets/{ticket_id}/replies", tags=["replies"])
send_router = APIRouter(prefix="/replies", tags=["replies"])


@send_router.post("/{reply_id}/send", response_model=ReplyResponse)
async def send(
    reply_id: int,
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(get_current_user),
):
    reply = await ReplyService.send_reply(db, reply_id, current_user)
    await db.commit()
    return reply


def can_manage_replies(user: User, ticket: Ticket) -> bool:
    roles = {role.name for role in user.roles}
    if user.is_admin:
        return True
    elif user.is_officer and ticket.assigned_id == user.id:
        return True
    elif user.is_student and ticket.student_id == user.id:
        return True
    else:
        return False


async def get_accessible_ticket(
    ticket_id: int,
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(get_current_user),
) -> Ticket:
    ticket = await TicketService.get_by_id(db, ticket_id)
    if ticket is None:
        raise HTTPException(status_code=404, detail="Ticket not found")

    if current_user.is_student and ticket.student_id != current_user.id:
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="You do not have permission to access these replies",
        )
    elif current_user.is_officer and ticket.assigned_id != current_user.id:
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="You do not have permission to access these replies",
        )

    return ticket


async def get_manageable_ticket(
    ticket: Ticket = Depends(get_accessible_ticket),
    current_user: User = Depends(get_current_user),
) -> Ticket:
    if current_user.is_student and ticket.student_id != current_user.id:
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="You do not have permission to access these replies",
        )
    elif current_user.is_officer and ticket.assigned_id != current_user.id:
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="You do not have permission to access these replies",
        )

    return ticket


async def get_reply(db: AsyncSession, ticket_id: int, reply_id: int) -> Reply:
    reply = await ReplyService.get_by_id(db, ticket_id, reply_id)
    if reply is None:
        raise HTTPException(status_code=404, detail="Reply not found")
    return reply


@router.post("/", response_model=ReplyResponse, status_code=status.HTTP_201_CREATED)
async def create(
    reply: ReplyCreate,
    ticket: Ticket = Depends(get_manageable_ticket),
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(get_current_user),
):
    return await ReplyService.create(db, ticket.id, current_user.id, reply.text)


@router.get("/", response_model=list[ReplyResponse])
async def index(
    ticket: Ticket = Depends(get_accessible_ticket),
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(get_current_user),
):
    replies = await ReplyService.get_replies_by_ticket_id(db, ticket.id)
    if can_manage_replies(current_user, ticket):
        return replies
    return [reply for reply in replies if reply.status == ReplyStatusEnum.SENT]


@router.get("/{reply_id}", response_model=ReplyResponse)
async def show(
    reply_id: int,
    ticket: Ticket = Depends(get_accessible_ticket),
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(get_current_user),
):
    reply = await get_reply(db, ticket.id, reply_id)
    if (
        not can_manage_replies(current_user, ticket)
        and reply.status != ReplyStatusEnum.SENT
    ):
        raise HTTPException(status_code=404, detail="Reply not found")
    return reply


@router.put("/{reply_id}", response_model=ReplyResponse)
async def update(
    reply_id: int,
    reply_update: ReplyUpdate,
    ticket: Ticket = Depends(get_manageable_ticket),
    db: AsyncSession = Depends(get_db),
):
    reply = await get_reply(db, ticket.id, reply_id)
    return await ReplyService.update_reply(db, reply.id, text=reply_update.text)


@router.delete("/{reply_id}", status_code=status.HTTP_204_NO_CONTENT)
async def delete(
    reply_id: int,
    ticket: Ticket = Depends(get_manageable_ticket),
    db: AsyncSession = Depends(get_db),
):
    reply = await get_reply(db, ticket.id, reply_id)
    await ReplyService.delete(db, reply)
    return Response(status_code=status.HTTP_204_NO_CONTENT)


@router.post("/ai-draft")
async def generate_ai_draft(
    ticket: Ticket = Depends(get_manageable_ticket),
    db: AsyncSession = Depends(get_db),
):
    new_reply = await ReplyService.create_ai_draft(db, ticket)

    return new_reply
