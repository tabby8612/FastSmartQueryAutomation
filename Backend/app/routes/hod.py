from fastapi import APIRouter, Depends

from sqlalchemy.ext.asyncio import AsyncSession

from app.models.user import User

from app.dependencies.hod import get_hod_department, get_department_officer

from app.helpers.security import (
    get_current_user,
    get_db,
    allowed_roles,
    allowed_rolenames,
)

from app.services.hod_ticket_service import HODTicketService

from app.Enums.TicketPriorityEnum import TicketPriorityEnum
from app.Enums.QueryStatusEnum import QueryStatusEnum

from app.schemas.ticket import TicketResponse
from app.schemas.hod import HODPriorityUpdate, HODOfficerUpdate

router = APIRouter(
    prefix="/hod/tickets",
    tags=["hod"],
    dependencies=[Depends(allowed_rolenames(["hod"]))],
)


@router.get("/escalated", response_model=list[TicketResponse])
async def escalated_tickets(
    current_user: User = Depends(get_current_user), db: AsyncSession = Depends(get_db)
):
    department = await get_hod_department(current_user, db)

    tickets = await HODTicketService.get_escalation_tickets(department, db)

    return tickets


@router.get("/{ticket_id}")
async def escalated_ticket(
    ticket_id: int,
    current_user: User = Depends(get_current_user),
    db: AsyncSession = Depends(get_db),
):
    department = await get_hod_department(current_user, db)

    ticket = await HODTicketService.get_ticket(db, ticket_id, department)

    return ticket


@router.patch("/{ticket_id}/take-over")
async def take_over(
    ticket_id: int,
    current_user: User = Depends(get_current_user),
    db: AsyncSession = Depends(get_db),
):
    department = await get_hod_department(current_user, db)

    ticket = await HODTicketService.take_over(db, ticket_id, department, current_user)

    return ticket


@router.put("/{ticket_id}/assign")
async def assign(
    ticket_id: int,
    data: HODOfficerUpdate,
    current_user: User = Depends(get_current_user),
    db: AsyncSession = Depends(get_db),
):
    department = await get_hod_department(current_user, db)

    officer = await get_department_officer(db, department, data.officer_id)

    ticket = await HODTicketService.reassign(db, ticket_id, department, officer)

    return ticket


@router.patch("/{ticket_id}/status")
async def change_status(
    ticket_id: int,
    status: QueryStatusEnum,
    current_user: User = Depends(get_current_user),
    db: AsyncSession = Depends(get_db),
):
    department = await get_hod_department(current_user, db)

    ticket = HODTicketService.change_status(
        db, ticket_id, department, status, current_user
    )

    return {
        "message": f"Ticket {ticket.subject} is successfully change to status {status}.",
        "success": True,
    }


@router.put("/{ticket_id}/priority")
async def change_priority(
    ticket_id: int,
    data: HODPriorityUpdate,
    current_user: User = Depends(get_current_user),
    db: AsyncSession = Depends(get_db),
):
    department = await get_hod_department(current_user, db)

    ticket = await HODTicketService.change_priority(
        db, ticket_id, department, data.priority
    )

    return ticket


@router.patch("/{ticket_id}/reply")
async def add_reply(
    ticket_id: int,
    reply_text: str,
    current_user: User = Depends(get_current_user),
    db: AsyncSession = Depends(get_db),
):
    department = await get_hod_department(current_user, db)

    reply = HODTicketService.add_reply(
        ticket_id, current_user, department, reply_text, db
    )

    return {
        "message": f"Reply has been added.",
        "success": True,
    }
