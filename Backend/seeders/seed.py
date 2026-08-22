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

DATABASE_URL = os.getenv(
    "DATABASE_URL", "sqlite+aiosqlite:///./fastsmartquery.db"
)

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
        Department(name="Computer Science", description="CS Department", is_active=True),
        Department(name="Information Technology", description="IT Department", is_active=True),
        Department(name="Electrical Engineering", description="EE Department", is_active=True),
    ]
    session.add_all(departments)
    await session.commit()
    return departments


async def seed_categories(session, departments):
    categories = [
        Category(name="Admission", description="Admission related queries", department_id=departments[0].id),
        Category(name="Examination", description="Exam related queries", department_id=departments[0].id),
        Category(name="Scholarship", description="Scholarship related queries", department_id=departments[1].id),
        Category(name="Hostel", description="Hostel related queries", department_id=departments[2].id),
        Category(name="Library", description="Library related queries", department_id=departments[0].id),
    ]
    session.add_all(categories)
    await session.commit()
    return categories


async def seed_roles(session):
    roles = [
        Role(name="admin"),
        Role(name="student"),
        Role(name="staff"),
        Role(name="hod"),
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
