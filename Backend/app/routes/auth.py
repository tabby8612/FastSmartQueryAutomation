from fastapi import APIRouter, Depends, HTTPException, status, Request, Cookie
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy.future import select
from dotenv import load_dotenv
import os
from fastapi.security import OAuth2PasswordRequestForm
from fastapi.responses import RedirectResponse

from app.helpers.security import get_current_user, create_access_token, verify_token
from app.database import get_db
from app.models.user import User
from app.schemas.auth import UserRegister
from app.schemas.user import UserResponse, ProfileResponse
from app.services.auth import AuthService
from app.resources.AuthResource import AuthResource
from app.auth.oauth import oauth
from app.services.user import UserService
from app.models.role import Role
from app.helpers.security import get_active_user_by_token

load_dotenv()

router = APIRouter(prefix="/auth", tags=["auth"])
GOOGLE_REQUEST_URI = os.getenv("GOOGLE_REDIRECT_URI")


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


@router.get("/profile", response_model=None)
async def profile(current_user: User = Depends(get_current_user)):
    return AuthResource.userResource(current_user)


@router.get("/google/login")
async def google_login(request: Request):
    google = oauth.create_client("google")
    redirect_uri = os.getenv("GOOGLE_REDIRECT_URI")

    return await google.authorize_redirect(request, redirect_uri)


@router.get("/google/callback")
async def google_authorize(request: Request, db: AsyncSession = Depends(get_db)):
    token = await oauth.google.authorize_access_token(request)
    userinfo = token["userinfo"]

    user = await AuthService.authorize_google_account(db, userinfo)

    if user is None:
        user = await UserService.create(
            db,
            student_id=None,
            email=userinfo["email"],
            password=None,
            google_sub=userinfo["sub"],
            full_name=userinfo.get("name"),
            department_id=None,
            is_active=True,
            is_student=True,
        )

    if not user.is_active:
        raise HTTPException(status.HTTP_403_FORBIDDEN, detail="Account is inactive")

    access_token = create_access_token({"sub": str(user.id)})

    FRONTEND_URL = os.getenv("FRONTEND_URL", "http://localhost:5173/")
    response = RedirectResponse(url=f"{FRONTEND_URL}auth/callback")

    response.set_cookie(
        key="access_token",
        value=access_token,
        httponly=True,
        secure=False,  # make it true in production https
        samesite="lax",
        max_age=24 * 60 * 60,
    )

    return response


@router.get("/me")
async def auth_profile(
    access_token: str | None = Cookie(default=None), db: AsyncSession = Depends(get_db)
):
    if not access_token:
        raise HTTPException(status.HTTP_401_UNAUTHORIZED, detail="Not Authenticated")

    user = await get_active_user_by_token(access_token, db)

    if not user:
        raise HTTPException(status.HTTP_401_UNAUTHORIZED, detail="Invalid User")

    return {
        "user": AuthResource.userResource(user),
        "access_token": access_token,
        "token_type": "bearer",
    }
