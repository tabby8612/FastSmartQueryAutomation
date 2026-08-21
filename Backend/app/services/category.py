from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy.future import select

from app.models.category import Category


class CategoryService:
    @staticmethod
    async def create(db: AsyncSession, name: str, description: str | None, department_id: int) -> Category:
        category = Category(
            name=name,
            description=description,
            department_id=department_id,
        )
        db.add(category)
        await db.flush()
        await db.refresh(category)
        return category

    @staticmethod
    async def get_all(db: AsyncSession) -> list[Category]:
        result = await db.execute(select(Category))
        return list(result.scalars().all())

    @staticmethod
    async def get_by_id(db: AsyncSession, category_id: int) -> Category | None:
        result = await db.execute(select(Category).where(Category.id == category_id))
        return result.scalar_one_or_none()

    @staticmethod
    async def update(db: AsyncSession, category: Category, name: str | None, description: str | None, department_id: int | None) -> Category:
        if name is not None:
            category.name = name
        if description is not None:
            category.description = description
        if department_id is not None:
            category.department_id = department_id
        await db.flush()
        await db.refresh(category)
        return category

    @staticmethod
    async def delete(db: AsyncSession, category: Category) -> None:
        await db.delete(category)
        await db.flush()
