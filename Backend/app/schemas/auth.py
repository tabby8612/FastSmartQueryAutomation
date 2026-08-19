from pydantic import BaseModel, ConfigDict


class UserLogin(BaseModel):
    email: str
    password: str


class UserRegister(BaseModel):
    student_id: str
    email: str
    password: str
    full_name: str
    role_id: int
    department_id: int
    is_active: bool = True
    on_leave: bool = False


class Token(BaseModel):
    access_token: str
    token_type: str


class TokenPayload(BaseModel):
    sub: int | None = None
