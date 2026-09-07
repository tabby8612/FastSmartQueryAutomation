from fastapi import APIRouter, Depends, HTTPException, status, Cookie
from fastapi.responses import StreamingResponse
from sqlalchemy.ext.asyncio import AsyncSession
import json
import asyncio


from app.database import get_db
from app.schemas.ticket import TicketCreate, TicketResponse, TicketUpdate
from app.services.TicketService import TicketService
from app.helpers.security import get_current_user, get_active_user_by_token
from app.models.user import User
from app.Enums.ChannelEnum import ChannelEnum

from app.events.ticket_event_manager import ticket_events

router = APIRouter(prefix="/tickets", tags=["tickets"])


def has_role(user: User, role_names: list[str]) -> bool:
    return any(role.name in role_names for role in user.roles)


def require_roles(*role_names: str):
    def checker(current_user: User = Depends(get_current_user)):
        if not has_role(current_user, list(role_names)):
            raise HTTPException(
                status_code=status.HTTP_403_FORBIDDEN,
                detail="You do not have permission to access this resource",
            )
        return current_user

    return checker


@router.post("/", response_model=None, status_code=status.HTTP_201_CREATED)
async def create(
    ticket: TicketCreate,
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(get_current_user),
):

    new_ticket = await TicketService.create(
        db=db,
        student_id=current_user.id,
        subject=ticket.subject,
        body=ticket.body,
        channel=ChannelEnum.WEB_FORM,
    )

    return {
        "message": f"Your Ticket is Successfully Created. Use Tracking Id {new_ticket.tracking_id} to track your ticket",
        "tracking_id": new_ticket.tracking_id,
        "success": True,
        "channel": ChannelEnum.WEB_FORM.lower(),
    }


@router.get("/", response_model=None)
async def index(
    db: AsyncSession = Depends(get_db), current_user: User = Depends(get_current_user)
):
    if has_role(current_user, ["admin"]):
        return await TicketService.get_all(db)
    if has_role(current_user, ["staff", "hod", "officer"]):
        return await TicketService.get_all(db, assigned_id=current_user.id)
    return await TicketService.get_all(db, student_id=current_user.id)


@router.get("/{ticket_id}", response_model=TicketResponse)
async def show(
    ticket_id: int,
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(get_current_user),
):
    ticket = await TicketService.get_by_id(db, ticket_id)
    if not ticket:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND, detail="ticket not found"
        )
    if has_role(current_user, ["admin"]):
        return ticket
    if (
        has_role(current_user, ["staff", "hod", "officer"])
        and ticket.assigned_id == current_user.id
    ):
        return ticket
    if ticket.student_id == current_user.id:
        return ticket
    raise HTTPException(
        status_code=status.HTTP_403_FORBIDDEN,
        detail="You do not have permission to access this query",
    )


@router.put("/{ticket_id}", response_model=TicketResponse)
async def update(
    ticket_id: int,
    ticket_update: TicketUpdate,
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(get_current_user),
):
    ticket = await TicketService.get_by_id(db, ticket_id)
    if not ticket:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND, detail="ticket not found"
        )
    if has_role(current_user, ["admin"]):
        return await TicketService.update(
            db=db,
            ticket=ticket,
            assigned_id=ticket_update.assigned_id,
            channel=ticket_update.channel,
            subject=ticket_update.subject,
            body=ticket_update.body,
            intent=ticket_update.intent,
            confidence_level=ticket_update.confidence_level,
            status=ticket_update.status,
            escalation_level=ticket_update.escalation_level,
            awaiting_student_input=ticket_update.awaiting_student_input,
            resolved_at=ticket_update.resolved_at,
        )
    if (
        has_role(current_user, ["staff", "hod"])
        and ticket.assigned_id == current_user.id
    ):
        return await TicketService.update(
            db=db,
            ticket=ticket,
            assigned_id=ticket_update.assigned_id,
            channel=ticket_update.channel,
            subject=ticket_update.subject,
            body=ticket_update.body,
            intent=ticket_update.intent,
            confidence_level=ticket_update.confidence_level,
            status=ticket_update.status,
            escalation_level=ticket_update.escalation_level,
            awaiting_student_input=ticket_update.awaiting_student_input,
            resolved_at=ticket_update.resolved_at,
        )
    raise HTTPException(
        status_code=status.HTTP_403_FORBIDDEN,
        detail="You do not have permission to update this query",
    )


@router.put("/{ticket_id}/assign", response_model=TicketResponse)
async def assign(
    ticket_id: int,
    ticket_update: TicketUpdate,
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(require_roles("admin")),
):
    ticket = await TicketService.get_by_id(db, ticket_id)
    if not ticket:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND, detail="ticket not found"
        )
    return await TicketService.update(
        db=db,
        ticket=ticket,
        assigned_id=ticket_update.assigned_id,
        channel=None,
        subject=None,
        body=None,
        intent=None,
        confidence_level=None,
        status=None,
        escalation_level=None,
        awaiting_student_input=None,
        resolved_at=None,
    )


@router.put("/{ticket_id}/status", response_model=TicketResponse)
async def ticket_status(
    ticket_id: int,
    ticket_update: TicketUpdate,
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(get_current_user),
):
    ticket = await TicketService.get_by_id(db, ticket_id)
    if not ticket:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND, detail="ticket not found"
        )
    if has_role(current_user, ["admin"]):
        return await TicketService.update(
            db=db,
            ticket=ticket,
            user_id=current_user.id,
            assigned_id=None,
            channel=None,
            subject=None,
            body=None,
            intent=None,
            confidence_level=None,
            status=ticket_update.status,
            escalation_level=ticket_update.escalation_level,
            awaiting_student_input=ticket_update.awaiting_student_input,
            resolved_at=ticket_update.resolved_at,
        )
    if (
        has_role(current_user, ["staff", "officer", "hod"])
        and ticket.assigned_id == current_user.id
    ):
        return await TicketService.update(
            db=db,
            ticket=ticket,
            user_id=current_user.id,
            assigned_id=None,
            channel=None,
            subject=None,
            body=None,
            intent=None,
            confidence_level=None,
            status=ticket_update.status,
            escalation_level=ticket_update.escalation_level,
            awaiting_student_input=ticket_update.awaiting_student_input,
            resolved_at=ticket_update.resolved_at,
        )
    raise HTTPException(
        status_code=status.HTTP_403_FORBIDDEN,
        detail="You do not have permission to change this query status",
    )


@router.delete("/{ticket_id}", status_code=status.HTTP_204_NO_CONTENT)
async def delete(
    ticket_id: int,
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(require_roles("admin")),
):
    ticket = await TicketService.get_by_id(db, ticket_id)
    if not ticket:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND, detail="ticket not found"
        )
    await TicketService.delete(db, ticket)


@router.get("/{ticket_id}/stream")
async def ticket_stream(
    ticket_id: int,
    db: AsyncSession = Depends(get_db),
    access_token: str | None = Cookie(default=None),
):
    if not access_token:
        raise HTTPException(status.HTTP_401_UNAUTHORIZED, detail="Not Authenticated")

    user = await get_active_user_by_token(access_token, db)

    if not user:
        raise HTTPException(status.HTTP_401_UNAUTHORIZED, detail="Invalid User")

    ticket = await TicketService.get_by_id(db, ticket_id)

    if ticket is None:
        raise HTTPException(status.HTTP_404_NOT_FOUND, detail="Ticket Not Found")

    if user.is_student:
        if ticket.student_id != user.id:
            raise HTTPException(
                status.HTTP_401_UNAUTHORIZED,
                detail="You are not authorized to access this resource",
            )

    if user.is_officer:
        if ticket.assigned_id != user.id:
            raise HTTPException(
                status.HTTP_401_UNAUTHORIZED,
                detail="You are not authorized to access this resource",
            )

    queue = await ticket_events.subscribe(ticket_id)

    async def event_generator():
        try:
            yield ": connected\n\n"
            while True:
                try:
                    event = await asyncio.wait_for(queue.get(), timeout=15)
                except asyncio.TimeoutError:
                    yield ": keep-alive\n\n"
                    continue
                yield f"data: {json.dumps(event)}\n\n"
        finally:
            ticket_events.unsubscribe(ticket_id, queue)

    return StreamingResponse(
        event_generator(),
        media_type="text/event-stream",
        headers={"Cache-Control": "no-cache", "X-Accel-Buffering": "no"},
    )
