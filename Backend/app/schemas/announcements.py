from datetime import datetime

from pydantic import BaseModel, model_validator

from app.schemas.user import UserResponse
from app.schemas.department import DepartmentBase


class AnnouncementCreate(BaseModel):
    title: str
    body: str
    audience_type: str
    department_id: int | None = None

    @model_validator(mode="after")
    def validate_audience(self):
        if self.audience_type == "department" and self.department_id is None:
            raise ValueError("department_id is requirement for department announcement")

        if self.audience_type == "all":
            self.department_id = None

        return self


class AnnouncementResponse(BaseModel):
    id: int
    title: str
    body: str
    audience_type: str
    department_id: int | None
    creator_id: int
    created_at: datetime
    creator: UserResponse
    department: DepartmentBase | None

    model_config = {"from_attributes": True}
