import os

from dotenv import load_dotenv

from pathlib import Path

from app.models.user import User

from app.services.instructor_leave_service import InstructorLeaveService

load_dotenv()

UPLOAD_PATH = os.getenv("UPLOAD_FOLDER_PATH", "uploads")
UPLOAD_PATH_DIR = Path(UPLOAD_PATH)


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
            "profile_image": (
                f"/{UPLOAD_PATH + data.profile_image}"
                if data.profile_image
                else f"/{UPLOAD_PATH + "/profile_images/default.jpg"}"
            ),
        }
