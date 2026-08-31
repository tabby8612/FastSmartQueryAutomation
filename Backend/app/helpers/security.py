from pwdlib import PasswordHash
from datetime import datetime, timezone, timedelta
from jose import jwt, JWTError
from dotenv import load_dotenv
import os
from fastapi.security import OAuth2PasswordBearer
from fastapi import Depends, HTTPException, status


from app.database import get_db
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy.future import select
from sqlalchemy.orm import joinedload
from app.models.user import User

load_dotenv()
JWT_SECRET = os.getenv("JWT_SECRET", "1588789547ASEDERDDDSA")
JWT_ALGORITHM = os.getenv("JWT_ALGORITHM", "HS256")
password_hashed = PasswordHash.recommended()
oauth2_scheme = OAuth2PasswordBearer(tokenUrl="/auth/login")


def hash_password(password: str):
    return password_hashed.hash(password)


def verify_password(plain_password, hashed_password):
    return password_hashed.verify(plain_password, hashed_password)


def create_access_token(
    data: dict[str, any], expires_delta: timedelta = timedelta(minutes=30)
):
    to_encode = data.copy()

    expires = datetime.now(timezone.utc) + expires_delta

    to_encode.update({"exp": expires})

    return jwt.encode(to_encode, JWT_SECRET, JWT_ALGORITHM)


def verify_token(token: str):
    try:
        return jwt.decode(token, JWT_SECRET, JWT_ALGORITHM)
    except JWTError:
        return None


async def get_current_user(
    token=Depends(oauth2_scheme), db: AsyncSession = Depends(get_db)
):
    user = await get_active_user_by_token(token, db)

    return user


def allowed_roles(allowed_roles):

    async def check_roles(current_user: User = Depends(get_current_user)):
        role_ids = [role.id for role in current_user.roles]
        print("role_ids", role_ids)
        if not any(roleId in allowed_roles for roleId in role_ids):
            raise HTTPException(
                status_code=status.HTTP_401_UNAUTHORIZED,
                detail="You are not allowed to access this resource",
            )
        return current_user

    return check_roles


async def get_active_user_by_token(token: str, db: AsyncSession):
    payload = verify_token(token)

    if payload is None:
        raise HTTPException(
            status_code=status.HTTP_408_REQUEST_TIMEOUT,
            detail="token is expired",
        )

    user_id = payload.get("sub")

    if user_id is None:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Invald Authentication credentials",
        )

    result = await db.execute(
        select(User)
        .options(joinedload(User.roles), joinedload(User.department))
        .where(User.id == int(user_id))
    )

    user = result.unique().scalar_one_or_none()

    if user is None:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="User Not Found",
        )

    return user
