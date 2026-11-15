from datetime import datetime

from pydantic import BaseModel, model_validator, Field, field_validator

from app.schemas.user import UserResponse
from app.schemas.department import DepartmentBase

from app.helpers.html_sanitizer import sanitize_html, plain_text


class AnnouncementCreate(BaseModel):
    title: str = Field(min_length=10, max_length=100)
    body: str = Field(min_length=100, max_length=1000)
    audience_type: str
    department_id: int | None = None

    @field_validator("body")
    @classmethod
    def validate_body(cls, value):
        if not value.strip():
            raise ValueError("Announcement description is required")

        santitized_text = sanitize_html(value)

        if not santitized_text.strip():
            raise ValueError(
                "Announcement description cannot be empty",
            )

        if len(plain_text(santitized_text)) < 100:
            raise ValueError(
                "Announcement description cannot less than 100 characters",
            )

        return santitized_text

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
    channel: str
    department: DepartmentBase | None

    model_config = {"from_attributes": True}
