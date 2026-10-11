from sqlalchemy.ext.asyncio import AsyncSession

from app.models.ticket import Ticket
from app.models.user import User
from app.models.reply import Reply

from app.Enums.ReplyStatusEnum import ReplyStatusEnum

from app.services.instructor_leave_service import InstructorLeaveService


class AutoReplyService:
    @staticmethod
    async def create_leave_auto_reply(db: AsyncSession, ticket: Ticket, officer: User):
        if not InstructorLeaveService.is_currently_on_leave(officer):
            return None

        if not officer.auto_reply_message:
            return None

        reply = Reply(
            creator_id=officer.id,
            ticket_id=ticket.id,
            is_ai_draft=0,
            is_auto_reply=1,
            text=officer.auto_reply_message,
            status=ReplyStatusEnum.SENT,
        )

        db.add(reply)

        return reply
