from enum import Enum


class RolesEnum(int, Enum):
    ADMIN = 1
    HOD = 2
    OFFICER = 3
    STUDENT = 4

    @classmethod
    def to_label(cls, role_id: int) -> str | None:
        if role_id == cls.ADMIN:
            return "admin"

        if role_id == cls.HOD:
            return "hod"

        if role_id == cls.OFFICER:
            return "officer"

        if role_id == cls.STUDENT:
            return "student"

        return None


# Must have must to roles
# then change in C:\Users\tabis\Documents\Coding Projects\FastSmartQueryAutomation\Backend\app\services\query.py
