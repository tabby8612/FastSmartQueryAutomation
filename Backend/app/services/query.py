from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy.future import select
from sqlalchemy.orm import joinedload
from ml.train import classify_issue

from app.models.query import Query
from app.Enums.QueryStatusEnum import QueryStatusEnum
from app.models.user import User
from app.models.user import Role
from app.helpers.utils import generate_tracking_number
from app.Enums.RolesEnum import RolesEnum


class QueryService:
    @staticmethod
    async def create(
        db: AsyncSession, student_id: int, subject: str, body: str, channel: str
    ) -> Query:
        tracking_id = generate_tracking_number()
        predication_data: dict[str, any] = await classify_issue(db, body)
        officer = await get_officer_id_by_department_id(
            db, predication_data.get("department_id")
        )

        query = Query(
            tracking_id=tracking_id,
            student_id=student_id,
            channel=channel,
            subject=subject,
            body=body,
            status=QueryStatusEnum.OPEN,
            department_id=predication_data.get("department_id"),
            category_id=predication_data.get("category_id"),
            confidence_level=predication_data.get("confidence_score"),
            intent=predication_data.get("category"),
            assigned_id=officer.id if officer is not None else None,
        )
        db.add(query)
        await db.flush()
        await db.refresh(query)
        return query

    @staticmethod
    async def get_all(
        db: AsyncSession, student_id: int | None = None, assigned_id: int | None = None
    ) -> list[Query]:
        stmt = select(Query).options(
            joinedload(Query.student),
            joinedload(Query.assigned),
            joinedload(Query.department),
            joinedload(Query.category),
        )
        if student_id is not None:
            stmt = stmt.where(Query.student_id == student_id)
        if assigned_id is not None:
            stmt = stmt.where(Query.assigned_id == assigned_id)
        result = await db.execute(stmt)
        return list(result.scalars().all())

    @staticmethod
    async def get_by_id(db: AsyncSession, query_id: int) -> Query | None:
        result = await db.execute(select(Query).where(Query.id == query_id))
        return result.scalar_one_or_none()

    @staticmethod
    async def update(
        db: AsyncSession,
        query: Query,
        assigned_id: int | None,
        channel: str | None,
        subject: str | None,
        body: str | None,
        intent: str | None,
        confidence_level: float | None,
        status: str | None,
        escalation_level: int | None,
        awaiting_student_input: bool | None,
        resolved_at,
    ) -> Query:
        if assigned_id is not None:
            query.assigned_id = assigned_id
        if channel is not None:
            query.channel = channel
        if subject is not None:
            query.subject = subject
        if body is not None:
            query.body = body
        if intent is not None:
            query.intent = intent
        if confidence_level is not None:
            query.confidence_level = confidence_level
        if status is not None:
            query.status = status
        if escalation_level is not None:
            query.escalation_level = escalation_level
        if awaiting_student_input is not None:
            query.awaiting_student_input = awaiting_student_input
        if resolved_at is not None:
            query.resolved_at = resolved_at
        await db.flush()
        await db.refresh(query)
        return query

    @staticmethod
    async def delete(db: AsyncSession, query: Query) -> None:
        await db.delete(query)
        await db.flush()


async def get_officer_id_by_department_id(db: AsyncSession, deptID):
    stmt = (
        select(User)
        .options(joinedload(User.roles))
        .where(
            User.department_id == int(deptID),
            User.on_leave == False,
            User.roles.any(Role.name == RolesEnum.OFFICER.name.lower()),
        )
    )
    result = await db.execute(stmt)
    data = result.unique().scalars().first()

    if not data:
        return None

    return data
