from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy.future import select

from app.database import get_db
from app.models.user import User
from app.schemas.auth import UserLogin, UserRegister
from app.schemas.user import UserResponse
from app.services.auth import AuthService
from app.helpers.security import create_access_token
from app.resources.AuthResource import AuthResource
from fastapi.security import OAuth2PasswordRequestForm
from fastapi import Depends

router = APIRouter(prefix="/auth", tags=["auth"])


@router.post(
    "/register", response_model=UserResponse, status_code=status.HTTP_201_CREATED
)
async def register(user_data: UserRegister, db: AsyncSession = Depends(get_db)):
    existing = await db.execute(select(User).where(User.email == user_data.email))
    if existing.scalar_one_or_none():
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="Email already registered",
        )
    user = await AuthService.register(
        db=db,
        student_id=user_data.student_id,
        email=user_data.email,
        password=user_data.password,
        full_name=user_data.full_name,
        role_id=user_data.role_id,
        department_id=user_data.department_id,
        is_active=user_data.is_active,
        on_leave=user_data.on_leave,
    )
    return user


@router.post("/login")
async def login(
    user_data: OAuth2PasswordRequestForm = Depends(), db: AsyncSession = Depends(get_db)
):
    user = await AuthService.login(db, user_data)
    if not user:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Invalid email or password",
        )
    access_token = create_access_token({"sub": str(user.id)})
    return {
        "user": AuthResource.userResource(user),
        "access_token": access_token,
        "token_type": "bearer",
    }
