from app.models.user import User

from app.services.instructor_leave_service import InstructorLeaveService


class AuthResource:
    @staticmethod
    def userResource(data: User):
        return {
            "id": data.id,
            "name": data.full_name,
            "email": data.email,
            "on_leave": data.on_leave,
            "is_currently_on_leave": InstructorLeaveService.is_currently_on_leave(data),
            "department": (
                {"id": data.department.id, "name": data.department.name}
                if data.department_id
                else None
            ),
            "roles": data.roles,
            "rolename": data.roles[0].name if data.roles else None,
        }
