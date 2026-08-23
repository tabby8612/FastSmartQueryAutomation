import asyncio
import os
from datetime import date

from dotenv import load_dotenv
from sqlalchemy.ext.asyncio import create_async_engine, async_sessionmaker

from app.models.base import Base
from app.models.department import Department
from app.models.category import Category
from app.models.role import Role
from app.models.user import User
from app.models.user_roles import User_Roles
from app.helpers.security import hash_password

load_dotenv()

DATABASE_URL = os.getenv("DATABASE_URL", "sqlite+aiosqlite:///./fastsmartquery.db")

engine = create_async_engine(DATABASE_URL, echo=True)
AsyncSessionLocal = async_sessionmaker(engine, expire_on_commit=False)


async def get_db():
    return AsyncSessionLocal()


async def clear_tables(session):
    await session.execute(User_Roles.__table__.delete())
    await session.execute(User.__table__.delete())
    await session.execute(Category.__table__.delete())
    await session.execute(Department.__table__.delete())
    await session.execute(Role.__table__.delete())
    await session.commit()


async def seed_departments(session):
    departments = [
        Department(
            name="finance and billing",
            description="Queries regarding finance and billng",
            is_active=True,
        ),
        Department(
            name="technical and IT support",
            description="Queries regarding technical support",
            is_active=True,
        ),
        Department(
            name="student account management",
            description="Queries regarding account management",
            is_active=True,
        ),
        Department(
            name="general administration",
            description="Queries regarding customer relation and general queries",
            is_active=True,
        ),
        Department(
            name="sales", description="Queries regarding sales queries", is_active=True
        ),
    ]
    session.add_all(departments)
    await session.commit()
    return departments


async def seed_categories(session, departments):
    categories = [
        Category(
            name="billing",
            description="Billing related queries",
            department_id=departments[0].id,
        ),
        Category(
            name="refund",
            description="refund related queries",
            department_id=departments[0].id,
        ),
        Category(
            name="payment failure",
            description="payment failure related queries",
            department_id=departments[0].id,
        ),
        Category(
            name="invoice",
            description="invoice related queries",
            department_id=departments[0].id,
        ),
        Category(
            name="subscription",
            description="subscription related queries",
            department_id=departments[0].id,
        ),
        Category(
            name="technical",
            description="technical related queries",
            department_id=departments[1].id,
        ),
        Category(
            name="bug report",
            description="bug report related queries",
            department_id=departments[1].id,
        ),
        Category(
            name="performance issue",
            description="performance related queries",
            department_id=departments[1].id,
        ),
        Category(
            name="outage",
            description="outage related queries",
            department_id=departments[1].id,
        ),
        Category(
            name="integration issue",
            description="integration related queries",
            department_id=departments[1].id,
        ),
        Category(
            name="account",
            description="account related queries",
            department_id=departments[2].id,
        ),
        Category(
            name="login issues",
            description="login issues related queries",
            department_id=departments[2].id,
        ),
        Category(
            name="security",
            description="security related queries",
            department_id=departments[2].id,
        ),
        Category(
            name="profile update",
            description="profile update related queries",
            department_id=departments[2].id,
        ),
        Category(
            name="general",
            description="general related queries",
            department_id=departments[3].id,
        ),
        Category(
            name="feedback",
            description="feedback related queries",
            department_id=departments[3].id,
        ),
        Category(
            name="feature request",
            description="feature request related queries",
            department_id=departments[3].id,
        ),
        Category(
            name="complaint",
            description="complaint related queries",
            department_id=departments[3].id,
        ),
        Category(
            name="greeting",
            description="greeting related queries",
            department_id=departments[3].id,
        ),
        Category(
            name="sale inquiry",
            description="sale inquiry related queries",
            department_id=departments[4].id,
        ),
        Category(
            name="demo request",
            description="demo request related queries",
            department_id=departments[4].id,
        ),
        Category(
            name="demo request",
            description="demo request related queries",
            department_id=departments[4].id,
        ),
        Category(
            name="pricing question",
            description="pricing question related queries",
            department_id=departments[4].id,
        ),
        Category(
            name="partnership",
            description="partnership related queries",
            department_id=departments[4].id,
        ),
    ]
    session.add_all(categories)
    await session.commit()
    return categories


async def seed_roles(session):
    roles = [
        Role(name="admin"),
        Role(name="hod"),
        Role(name="officer"),
        Role(name="student"),
    ]
    session.add_all(roles)
    await session.commit()
    return roles


async def seed_users(session, departments, roles):
    users = [
        User(
            student_id="STU001",
            email="admin@example.com",
            password=hash_password("admin123"),
            full_name="Admin User",
            department_id=departments[0].id,
            is_active=True,
        ),
        User(
            student_id="STU002",
            email="student@example.com",
            password=hash_password("student123"),
            full_name="Student User",
            department_id=departments[0].id,
            is_active=True,
        ),
        User(
            student_id="STU003",
            email="staff@example.com",
            password=hash_password("staff123"),
            full_name="Staff User",
            department_id=departments[1].id,
            is_active=True,
        ),
        User(
            student_id="STU004",
            email="hod@example.com",
            password=hash_password("hod123"),
            full_name="HOD User",
            department_id=departments[2].id,
            is_active=True,
        ),
    ]
    session.add_all(users)
    await session.commit()
    return users


async def seed_user_roles(session, users, roles):
    role_map = {role.name: role for role in roles}
    user_map = {user.student_id: user for user in users}

    user_roles = [
        User_Roles(role_id=role_map["admin"].id, user_id=user_map["STU001"].id),
        User_Roles(role_id=role_map["student"].id, user_id=user_map["STU002"].id),
        User_Roles(role_id=role_map["staff"].id, user_id=user_map["STU003"].id),
        User_Roles(role_id=role_map["hod"].id, user_id=user_map["STU004"].id),
        User_Roles(role_id=role_map["staff"].id, user_id=user_map["STU004"].id),
    ]
    session.add_all(user_roles)
    await session.commit()


async def main():
    session = await get_db()
    try:
        print("Clearing existing data...")
        await clear_tables(session)

        print("Seeding departments...")
        departments = await seed_departments(session)

        print("Seeding categories...")
        await seed_categories(session, departments)

        print("Seeding roles...")
        roles = await seed_roles(session)

        print("Seeding users...")
        users = await seed_users(session, departments, roles)

        print("Seeding user roles...")
        await seed_user_roles(session, users, roles)

        print("Seeding completed successfully.")
    finally:
        await session.close()
        await engine.dispose()


if __name__ == "__main__":
    asyncio.run(main())
