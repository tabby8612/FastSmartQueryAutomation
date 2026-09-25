from fastapi import HTTPException, status

from sqlalchemy import select
from sqlalchemy.orm import selectinload, joinedload

from sqlalchemy.ext.asyncio import AsyncSession

from app.models.user import User
from app.models.ticket import Ticket
from app.models.reply import Reply

from app.models.department import Department


async def get_hod_department(current_user: User, db: AsyncSession):
    stmt = select(Department).where(
        Department.hod_id == current_user.id, Department.is_active.is_(True)
    )

    result = await db.execute(stmt)

    department = result.scalar_one_or_none()

    if not department:
        raise HTTPException(status.HTTP_404_NOT_FOUND, "HOD Access Required")

    return department


async def get_hod_ticket(db: AsyncSession, ticket_id: int, hod_department: Department):
    stmt = select(Ticket).options(
        selectinload(Ticket.student),
        selectinload(Ticket.assigned),
        selectinload(Ticket.department),
        selectinload(Ticket.category),
        selectinload(Ticket.replies).options(joinedload(Reply.creator)),
        selectinload(Ticket.ticket_status_history),
    )

    stmt = stmt.where(Ticket.id == ticket_id, Ticket.department_id == hod_department.id)

    result = await db.execute(stmt)

    ticket = result.scalar_one_or_none()

    if not ticket:
        raise HTTPException(status_code=404, detail="Ticket Not Found")

    return ticket


async def get_department_officer(db: AsyncSession, dept: Department, officer_id: int):
    stmt = select(User).where(
        User.department_id == dept.id, User.id == officer_id, User.is_officer.is_(True)
    )

    result = await db.execute(stmt)

    officer = result.scalar_one_or_none()

    if not officer:
        raise HTTPException(status_code=404, detail="Officer Not Found")

    return officer
