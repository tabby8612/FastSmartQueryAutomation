from fastapi import APIRouter, Depends

from app.helpers.security import get_current_user, get_db
from app.models.user import User
from app.services.search_service import SearchService

from sqlalchemy.ext.asyncio import AsyncSession

router = APIRouter()


@router.get("/search")
async def search(
    q: str | None = None,
    current_user: User = Depends(get_current_user),
    db: AsyncSession = Depends(get_db),
):
    search_result = await SearchService.search(db, current_user, q)
    return search_result
