from fastapi import HTTPException, status

from datetime import date

from app.models.user import User


class InstructorLeaveService:

    @staticmethod
    def is_currently_on_leave(instructor: User) -> bool:
        if not instructor.on_leave:
            return False

        today = date.today()

        if instructor.leave_start_day:
            if today < instructor.leave_start_day:
                return False

        if instructor.leave_end_day:
            if today > instructor.leave_end_day:
                return False

        return True

    @staticmethod
    def set_leave(
        officer: User, start_date: date, end_date: date, auto_reply_message: str
    ):
        if start_date > end_date:
            raise HTTPException(
                status_code=status.HTTP_406_NOT_ACCEPTABLE,
                detail="Leave start date cannot be after end date",
            )

        officer.on_leave = True
        officer.leave_start_day = start_date
        officer.leave_end_day = end_date
        officer.auto_reply_message = auto_reply_message

        return officer

    @staticmethod
    def cancel_leave(officer: User):
        officer.on_leave = False
        officer.leave_start_day = None
        officer.leave_end_day = None

        return officer
