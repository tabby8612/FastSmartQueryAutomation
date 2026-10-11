from datetime import date

from pydantic import BaseModel, Field, computed_field

from app.services.instructor_leave_service import InstructorLeaveService


class InstructorLeave(BaseModel):
    start_date: date
    end_date: date
    auto_reply_message: str = Field(min_length=1, max_length=1000)


class LeaveResponse(BaseModel):
    on_leave: bool
    leave_start_day: date | None
    leave_end_day: date | None
    auto_reply_message: str | None

    @computed_field
    @property
    def is_currently_on_leave(self) -> bool:
        return InstructorLeaveService.is_currently_on_leave(self)
