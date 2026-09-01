from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.ext.asyncio import AsyncSession

from app.database import get_db
from app.schemas.department import (
    DepartmentCreate,
    DepartmentResponse,
    DepartmentUpdate,
)
from app.services.department import DepartmentService
from app.helpers.security import allowed_roles, get_current_user
from app.Enums.RolesEnum import RolesEnum

router = APIRouter(
    prefix="/departments",
    tags=["departments"],
    dependencies=[Depends(get_current_user), Depends(allowed_roles([RolesEnum.ADMIN]))],
)


@router.post(
    "/", response_model=DepartmentResponse, status_code=status.HTTP_201_CREATED
)
async def create_department(
    department: DepartmentCreate, db: AsyncSession = Depends(get_db)
):
    return await DepartmentService.create(
        db=db,
        name=department.name,
        description=department.description,
        hod_id=department.hod_id,
        is_active=department.is_active,
    )


@router.get("/", response_model=None)
async def get_departments(db: AsyncSession = Depends(get_db)):
    return await DepartmentService.get_all(db)


@router.get("/{department_id}", response_model=DepartmentResponse)
async def get_department(department_id: int, db: AsyncSession = Depends(get_db)):
    department = await DepartmentService.get_by_id(db, department_id)
    if not department:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND, detail="Department not found"
        )
    return department


@router.put("/{department_id}", response_model=DepartmentResponse)
async def update_department(
    department_id: int,
    department_update: DepartmentUpdate,
    db: AsyncSession = Depends(get_db),
):
    department = await DepartmentService.get_by_id(db, department_id)
    if not department:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND, detail="Department not found"
        )
    return await DepartmentService.update(
        db=db,
        department=department,
        name=department_update.name,
        description=department_update.description,
        hod_id=department_update.hod_id,
        is_active=department_update.is_active,
    )


@router.delete("/{department_id}", status_code=status.HTTP_204_NO_CONTENT)
async def delete_department(department_id: int, db: AsyncSession = Depends(get_db)):
    department = await DepartmentService.get_by_id(db, department_id)
    if not department:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND, detail="Department not found"
        )
    await DepartmentService.delete(db, department)
