from datetime import datetime, timezone, timedelta
import asyncio
import logging

from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy import select
from sqlalchemy.orm import selectinload, joinedload

from app.schemas.ticket import TicketResponse

from app.models.ticket import Ticket
from app.models.reply import Reply
from app.models.department import Department
from app.models.ticket_status_history import TicketStatusHistory

from app.Enums.QueryStatusEnum import QueryStatusEnum

from app.database import AsyncSessionLocal


class EscalationService:
    @staticmethod
    async def get_overdue_tickets(db: AsyncSession) -> list[Ticket]:
        cutoff_time = datetime.now(timezone.utc) - timedelta(hours=24)

        stmt = (
            select(Ticket, Department.hod_id)
            .join(Department, Department.id == Ticket.department_id)
            .where(
                Ticket.created_at <= cutoff_time,
                Ticket.resolved_at.is_(None),
                Ticket.awaiting_student_input.is_(False),
                Ticket.escalation_level == 0,
                Ticket.status.in_(
                    [
                        QueryStatusEnum.OPEN,
                        QueryStatusEnum.PENDING,
                        QueryStatusEnum.ASSIGNED,
                        QueryStatusEnum.IN_PROGRESS,
                    ]
                ),
                Department.hod_id.is_not(None),
            )
        )

        results = await db.execute(stmt)

        return results.all()

    @staticmethod
    async def escalate_ticket(db: AsyncSession, ticket: Ticket):
        stmt = select(Department).where(Department.id == ticket.department_id)

        result = await db.execute(stmt)

        department = result.scalar_one_or_none()

        if department is None:
            return False

        if department.hod_id is None:
            return False

        ticket.assigned_id = department.hod_id
        ticket.escalation_level = 1
        ticket.status = QueryStatusEnum.ESCALATED

        await db.commit()

        return True

    @staticmethod
    async def process_overdue_ticket(db: AsyncSession):
        tickets = await EscalationService.get_overdue_tickets(db)

        escalated = 0
        for ticket, hod_id in tickets:
            old_status = ticket.status

            ticket.assigned_id = hod_id
            ticket.status = QueryStatusEnum.ESCALATED
            ticket.escalation_level = 1

            history = TicketStatusHistory(
                ticket_id=ticket.id,
                old_status=old_status,
                new_status=QueryStatusEnum.ESCALATED,
                changed_by=None,
            )

            db.add(history)

            escalated += 1

        await db.commit()

        return len(tickets)


async def run_escalation_job():
    async with AsyncSessionLocal() as db:
        try:
            count = await EscalationService.process_overdue_ticket(db)

            logging.info(f"Auto escalation completed. {count} tickets escalated")
            print(f"Auto escalation completed. {count} tickets escalated")

        except Exception:
            await db.rollback()

            logging.exception("Auto Escalaton job failed")
            print("Auto Escalaton job failed")


# async def main():
#     try:
#         session = AsyncSessionLocal()

#         tickets = await EscalationService.process_overdue_ticket(session)

#         print("size is: ", len(tickets))
#     except Exception as e:
#         print("exception error: ", e)
#     finally:
#         await session.close()


# if __name__ == "__main__":
#     asyncio.run(main())
