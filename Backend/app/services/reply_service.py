from fastapi import HTTPException, status

from datetime import datetime, timezone

from sqlalchemy import select
from sqlalchemy.ext.asyncio import AsyncSession

from app.Enums.ReplyStatusEnum import ReplyStatusEnum
from app.models.reply import Reply
from app.models.ticket import Ticket
from app.models.user import User

from app.services.TicketService import TicketService

from app.services.ai_reply_generator_service import (
    ai_reply_generator,
    build_ticket_context,
)


class ReplyService:
    @staticmethod
    async def create(
        db: AsyncSession, ticket_id: int, creator_id: int, text: str
    ) -> Reply:
        reply = Reply(
            ticket_id=ticket_id,
            creator_id=creator_id,
            text=text,
            is_ai_draft=0,
            status=ReplyStatusEnum.DRAFT,
        )
        db.add(reply)
        await db.flush()
        await db.refresh(reply)
        return reply

    @staticmethod
    async def get_by_id(
        db: AsyncSession, ticket_id: int, reply_id: int
    ) -> Reply | None:
        result = await db.execute(
            select(Reply).where(Reply.id == reply_id, Reply.ticket_id == ticket_id)
        )
        return result.scalar_one_or_none()

    @staticmethod
    async def delete(db: AsyncSession, reply: Reply) -> None:
        await db.delete(reply)
        await db.flush()

    @staticmethod
    async def create_ai_draft(db: AsyncSession, ticket: Ticket) -> Reply:
        context = build_ticket_context(ticket)
        reply_data = ai_reply_generator(context)

        reply = Reply(
            ticket_id=ticket.id,
            is_ai_draft=1,
            text=reply_data.content,
            status=ReplyStatusEnum.DRAFT,
        )

        db.add(reply)
        await db.flush()
        await db.refresh(reply)
        return reply

    @staticmethod
    async def get_replies_by_ticket_id(db: AsyncSession, ticket_id: int) -> list[Reply]:
        stmt = (
            select(Reply)
            .where(Reply.ticket_id == ticket_id)
            .order_by(Reply.created_at.asc(), Reply.id.asc())
        )

        result = await db.execute(stmt)
        return list(result.scalars().all())

    @staticmethod
    async def update_reply(
        db: AsyncSession,
        reply_id: int,
        text: str | None = None,
        status: str | None = None,
    ) -> Reply | None:
        stmt = select(Reply).where(Reply.id == reply_id)
        result = await db.execute(stmt)
        reply = result.scalar_one_or_none()

        if reply is None:
            return None

        if text is not None:
            reply.text = text
        if status is not None:
            reply.status = status

        await db.flush()
        await db.refresh(reply)
        return reply

    @staticmethod
    async def send_reply(db: AsyncSession, reply_id: int, current_user: User) -> Reply:
        stmt = select(Reply).where(Reply.id == reply_id).with_for_update()
        result = await db.execute(stmt)
        reply = result.scalar_one_or_none()

        if reply is None:
            raise HTTPException(
                status_code=status.HTTP_404_NOT_FOUND, detail="Reply not found"
            )

        ticket = await db.get(Ticket, reply.ticket_id)

        if ticket is None:
            raise HTTPException(
                status_code=status.HTTP_404_NOT_FOUND, detail="Ticket not found"
            )

        if (
            not any(role.name == "officer" for role in current_user.roles)
            or ticket.assigned_id != current_user.id
        ):
            raise HTTPException(
                status_code=status.HTTP_403_FORBIDDEN,
                detail="Only the officer assigned to this ticket can send replies",
            )
        if reply.status != ReplyStatusEnum.DRAFT:
            raise HTTPException(
                status_code=status.HTTP_409_CONFLICT,
                detail="Only draft replies can be sent",
            )

        reply.status = ReplyStatusEnum.SENT
        reply.send_at = datetime.now(timezone.utc)

        await db.flush()
        await db.refresh(reply)
        return reply
