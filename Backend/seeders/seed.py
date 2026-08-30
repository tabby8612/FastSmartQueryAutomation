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
from app.models.ticket import Ticket
from app.helpers.security import hash_password

load_dotenv()

DATABASE_URL = os.getenv("DATABASE_URL", "sqlite+aiosqlite:///./fastsmartquery.db")

engine = create_async_engine(DATABASE_URL, echo=True)
AsyncSessionLocal = async_sessionmaker(engine, expire_on_commit=False)


async def get_db():
    return AsyncSessionLocal()


async def clear_tables(session):
    await session.execute(Ticket.__table__.delete())
    await session.execute(User_Roles.__table__.delete())
    await session.execute(User.__table__.delete())
    await session.execute(Category.__table__.delete())
    await session.execute(Department.__table__.delete())
    await session.execute(Role.__table__.delete())
    await session.commit()


async def seed_departments(session):
    departments = [
        Department(
            name="academic affairs office",
            description="Queries regarding academic and examination",
            is_active=True,
        ),
        Department(
            name="billing accounts & finance office",
            description="Queries regarding billing, accounts, and finance",
            is_active=True,
        ),
        Department(
            name="admissions office",
            description="Queries regarding student admissions",
            is_active=True,
        ),
        Department(
            name="student affairs & administration office",
            description="Queries regarding student affairs and administration",
            is_active=True,
        ),
        Department(
            name="hostel & housing office",
            description="Queries regarding hostel and student housing",
            is_active=True,
        ),
        Department(
            name="library office",
            description="Queries regarding library",
            is_active=True,
        ),
        Department(
            name="information technology (IT) office",
            description="Queries regarding information technology and information communication",
            is_active=True,
        ),
        Department(
            name="facilities & maintenance office",
            description="Queries regarding maintenance of student facilities",
            is_active=True,
        ),
        Department(
            name="security & discipline office",
            description="Queries regarding student security and discipline",
            is_active=True,
        ),
        Department(
            name="transportation office",
            description="Queries regarding transportation service provided by university",
            is_active=True,
        ),
    ]
    session.add_all(departments)
    await session.commit()
    return departments


async def seed_categories(session, departments):
    categories = [
        Category(
            name="general",
            description="general help desk related queries",
            department_id=None,
        ),
        Category(
            name="academic",
            description="academic related queries",
            department_id=departments[0].id,
        ),
        Category(
            name="finance",
            description="billing, accounts and finance related queries",
            department_id=departments[1].id,
        ),
        Category(
            name="admissions",
            description="admissions related queries",
            department_id=departments[2].id,
        ),
        Category(
            name="administration",
            description="administration and student affairs related queries",
            department_id=departments[3].id,
        ),
        Category(
            name="housing",
            description="hostel and student housing related queries",
            department_id=departments[4].id,
        ),
        Category(
            name="library",
            description="library related queries",
            department_id=departments[5].id,
        ),
        Category(
            name="technical",
            description="bug report and information technology (IT) related queries",
            department_id=departments[6].id,
        ),
        Category(
            name="maintenance",
            description="facility maintenance related queries",
            department_id=departments[7].id,
        ),
        Category(
            name="security/discipline",
            description="student security and discipline queries",
            department_id=departments[8].id,
        ),
        Category(
            name="transport",
            description="student transport related queries",
            department_id=departments[9].id,
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
            email="admin@example.com",
            password=hash_password("admin123"),
            full_name="Admin User",
            department_id=departments[0].id,
            is_active=True,
            is_student=False,
            is_officer=False,
            is_admin=True,
        ),
        User(
            student_id="STU001",
            email="student@example.com",
            password=hash_password("student123"),
            full_name="Student User",
            department_id=departments[0].id,
            is_active=True,
            is_student=True,
            is_officer=False,
            is_admin=False,
        ),
        User(
            email="officer@example.com",
            password=hash_password("officer123"),
            full_name="Officer User",
            department_id=departments[1].id,
            is_active=True,
            is_student=False,
            is_officer=True,
            is_admin=False,
        ),
        User(
            email="hod@example.com",
            password=hash_password("hod123"),
            full_name="HOD User",
            department_id=departments[2].id,
            is_active=True,
            is_student=False,
            is_officer=True,
            is_admin=False,
        ),
    ]
    session.add_all(users)
    await session.commit()
    return users


async def seed_user_roles(session, users, roles):
    role_map = {role.name: role for role in roles}
    user_map = {user.email: user for user in users}

    user_roles = [
        User_Roles(
            role_id=role_map["admin"].id, user_id=user_map["admin@example.com"].id
        ),
        User_Roles(role_id=role_map["hod"].id, user_id=user_map["hod@example.com"].id),
        User_Roles(
            role_id=role_map["officer"].id, user_id=user_map["officer@example.com"].id
        ),
        User_Roles(
            role_id=role_map["student"].id, user_id=user_map["student@example.com"].id
        ),
        User_Roles(
            role_id=role_map["officer"].id, user_id=user_map["hod@example.com"].id
        ),
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
