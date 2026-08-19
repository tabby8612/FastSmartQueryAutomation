from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy.future import select

from app.database import get_db
from app.models.role import Role
from app.schemas.role import RoleCreate, RoleResponse, RoleUpdate

router = APIRouter(prefix="/roles", tags=["roles"])


@router.post("/", response_model=RoleResponse, status_code=status.HTTP_201_CREATED)
async def create_role(role: RoleCreate, db: AsyncSession = Depends(get_db)):
    existing = await db.execute(select(Role).where(Role.name == role.name))
    if existing.scalar_one_or_none():
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="Role with this name already exists",
        )
    new_role = Role(name=role.name)
    db.add(new_role)
    await db.flush()
    await db.refresh(new_role)
    return new_role


@router.get("/", response_model=list[RoleResponse])
async def get_roles(db: AsyncSession = Depends(get_db)):
    result = await db.execute(select(Role))
    return result.scalars().all()


@router.get("/{role_id}", response_model=RoleResponse)
async def get_role(role_id: int, db: AsyncSession = Depends(get_db)):
    result = await db.execute(select(Role).where(Role.id == role_id))
    role = result.scalar_one_or_none()
    if not role:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND, detail="Role not found"
        )
    return role


@router.put("/{role_id}", response_model=RoleResponse)
async def update_role(
    role_id: int, role_update: RoleUpdate, db: AsyncSession = Depends(get_db)
):
    result = await db.execute(select(Role).where(Role.id == role_id))
    role = result.scalar_one_or_none()
    if not role:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND, detail="Role not found"
        )
    if role_update.name is not None:
        existing = await db.execute(
            select(Role).where(Role.name == role_update.name, Role.id != role_id)
        )
        if existing.scalar_one_or_none():
            raise HTTPException(
                status_code=status.HTTP_400_BAD_REQUEST,
                detail="Role with this name already exists",
            )
        role.name = role_update.name
    await db.flush()
    await db.refresh(role)
    return role


@router.delete("/{role_id}", status_code=status.HTTP_204_NO_CONTENT)
async def delete_role(role_id: int, db: AsyncSession = Depends(get_db)):
    result = await db.execute(select(Role).where(Role.id == role_id))
    role = result.scalar_one_or_none()
    if not role:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND, detail="Role not found"
        )
    await db.delete(role)
    await db.flush()
