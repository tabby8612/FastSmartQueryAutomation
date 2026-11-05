import os

from dotenv import load_dotenv
from pathlib import Path

from app.models.user import User

load_dotenv()

UPLOAD_PATH = os.getenv("UPLOAD_FOLDER_PATH", "uploads")
UPLOAD_PATH_DIR = Path(UPLOAD_PATH)


class ProfileResource:
    @staticmethod
    def profile(data: User):
        return {
            "id": data.id,
            "student_id": data.student_id,
            "full_name": data.full_name,
            "email": data.email,
            "profile_image": (
                f"/{UPLOAD_PATH + data.profile_image}"
                if data.profile_image
                else f"/{UPLOAD_PATH + "/profile_images/default.jpg"}"
            ),
        }
