from pwdlib import PasswordHash
from datetime import datetime, timezone, timedelta
from jose import jwt, JWTError
from dotenv import load_dotenv
import os

load_dotenv()
JWT_SECRET = os.getenv("JWT_SECRET", "1588789547ASEDERDDDSA")
JWT_ALGORITHM = os.getenv("JWT_ALGORITHM", "HS256")
password_hashed = PasswordHash.recommended()


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
