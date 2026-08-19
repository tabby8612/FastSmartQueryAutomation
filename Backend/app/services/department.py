from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy.future import select

from app.models.department import Department


class DepartmentService:
    @staticmethod
    async def create(db: AsyncSession, name: str, description: str | None, hod_id: int | None, is_active: bool) -> Department:
        department = Department(
            name=name,
            description=description,
            hod_id=hod_id,
            is_active=is_active,
        )
        db.add(department)
        await db.flush()
        await db.refresh(department)
        return department

    @staticmethod
    async def get_all(db: AsyncSession) -> list[Department]:
        result = await db.execute(select(Department))
        return list(result.scalars().all())

    @staticmethod
    async def get_by_id(db: AsyncSession, department_id: int) -> Department | None:
        result = await db.execute(select(Department).where(Department.id == department_id))
        return result.scalar_one_or_none()

    @staticmethod
    async def update(db: AsyncSession, department: Department, name: str | None, description: str | None, hod_id: int | None, is_active: bool | None) -> Department:
        if name is not None:
            department.name = name
        if description is not None:
            department.description = description
        if hod_id is not None:
            department.hod_id = hod_id
        if is_active is not None:
            department.is_active = is_active
        await db.flush()
        await db.refresh(department)
        return department

    @staticmethod
    async def delete(db: AsyncSession, department: Department) -> None:
        await db.delete(department)
        await db.flush()
