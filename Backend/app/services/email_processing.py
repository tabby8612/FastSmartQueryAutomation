import random
import string
import os
from dotenv import load_dotenv
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy.future import select

from app.models.user import User
from app.models.user_roles import User_Roles
from app.models.ticket import Ticket
from app.models.category import Category
from app.models.department import Department
from app.models.role import Role
from app.helpers.security import hash_password
from app.helpers.utils import generate_tracking_number
from ml.train import classify_issue
from app.Enums.ChannelEnum import ChannelEnum
from app.Enums.QueryStatusEnum import QueryStatusEnum
from app.Enums.TicketPriorityEnum import TicketPriorityEnum

load_dotenv()
DEFAULT_USER_PASSWORD = os.getenv("DEFAULT_USER_PASSWORD", "123456")


async def get_department_for_category(
    db: AsyncSession, category_name: str
) -> int | None:
    result = await db.execute(select(Category).where(Category.name == category_name))
    category = result.scalar_one_or_none()
    if not category:
        return None
    return category.department_id


async def find_officer(db: AsyncSession, department_id: int) -> User | None:
    result = await db.execute(
        select(User)
        .join(User_Roles, User.id == User_Roles.user_id)
        .join(Role, User_Roles.role_id == Role.id)
        .where(Role.name.in_(["staff", "hod", "officer"]))
        .where(User.department_id == department_id)
        .limit(1)
    )
    return result.scalar_one_or_none()


async def process_incoming_email(
    db: AsyncSession, sender_email: str, subject: str, body: str
) -> Ticket:
    result = await db.execute(select(User).where(User.email == sender_email))
    student = result.scalar_one_or_none()

    if not student:
        student = User(
            student_id=sender_email.split("@")[0],
            email=sender_email,
            password=hash_password(DEFAULT_USER_PASSWORD),
            full_name=sender_email.split("@")[0],
            department_id=None,
            is_active=True,
            on_leave=False,
        )
        db.add(student)
        await db.flush()
        await db.refresh(student)

        result = await db.execute(select(Role).where(Role.name == "student"))
        student_role = result.scalar_one_or_none()
        if student_role:
            db.add(User_Roles(role_id=student_role.id, user_id=student.id))
            await db.flush()

    predication: dict[str, any] = await classify_issue(db, f"{subject} {body}")

    department_id = predication.get("department_id")
    assigned_id = None

    if department_id is not None:
        officer = await find_officer(db, int(department_id))
        assigned_id = officer.id if officer else None

    category = predication.get("category")
    category_id = predication.get("category_id")
    tracking_id = generate_tracking_number()
    priority_level = predication.get("priority")
    predication_score = predication.get("category_confidence_score")

    new_ticket = Ticket(
        tracking_id=tracking_id,
        student_id=student.id,
        assigned_id=assigned_id,
        department_id=department_id,
        category_id=category_id,
        channel=ChannelEnum.EMAIL,
        subject=subject,
        body=body,
        intent=category if category else "general",
        confidence_level=predication_score,
        status=QueryStatusEnum.PENDING,
        escalation_level=TicketPriorityEnum.to_level(priority_level),
        awaiting_student_input=False,
    )
    db.add(new_ticket)
    await db.flush()
    await db.refresh(new_ticket)
    return new_ticket
