from datetime import date

from pydantic import BaseModel, ConfigDict
from app.schemas.department import DepartmentResponse
from app.schemas.role import RoleResponse


class UserBase(BaseModel):
    student_id: str | None = None
    email: str
    full_name: str
    department_id: int | None = None
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


class OfficerOptionResponse(BaseModel):
    user_id: int
    name: str

    model_config = ConfigDict(from_attributes=True)


class ProfileResponse(UserBase):
    id: int
    department: DepartmentResponse | None
    roles: list[RoleResponse] | None

    model_config = ConfigDict(from_attributes=True)
