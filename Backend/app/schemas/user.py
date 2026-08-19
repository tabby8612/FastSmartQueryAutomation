from datetime import date

from pydantic import BaseModel, ConfigDict


class UserBase(BaseModel):
    student_id: str
    email: str
    full_name: str
    role_id: int
    department_id: int
    is_active: bool = True
    on_leave: bool = False
    auto_reply_message: str | None = None
    leave_start_day: date | None = None
    leave_end_day: date | None = None


class UserCreate(UserBase):
    password: str


class UserUpdate(BaseModel):
    student_id: str | None = None
    email: str | None = None
    password: str | None = None
    full_name: str | None = None
    role_id: int | None = None
    department_id: int | None = None
    is_active: bool | None = None
    on_leave: bool | None = None
    auto_reply_message: str | None = None
    leave_start_day: date | None = None
    leave_end_day: date | None = None


class UserResponse(UserBase):
    id: int

    model_config = ConfigDict(from_attributes=True)
