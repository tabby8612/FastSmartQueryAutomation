import uuid
from io import BytesIO
from pathlib import Path
from dotenv import load_dotenv
import os

from PIL import Image, ImageOps

load_dotenv()


def process_image(
    content: bytes, is_Profile_Photo: bool = False, is_Ticket_Attachment: bool = False
) -> str:
    with Image.open(BytesIO(content)) as original:
        img = ImageOps.exif_transpose(original)

        img = ImageOps.fit(img, (300, 300), Image.Resampling.LANCZOS)

        if img.mode in ("RGBA", "LA", "P"):
            img = img.convert("RGB")

        UPLOAD_PATH = os.getenv("UPLOAD_FOLDER_PATH", "uploads")
        UPLOAD_PATH_DIR = Path(UPLOAD_PATH)

        filename = f"{uuid.uuid4().hex}.jpg"
        filename_key = ""

        if is_Profile_Photo:
            filename_key = f"/profile_images/{filename}"
            UPLOAD_PATH_DIR = UPLOAD_PATH_DIR / "profile_images"

        if is_Ticket_Attachment:
            filename_key = f"/ticket_attachments/{filename}"
            UPLOAD_PATH_DIR = UPLOAD_PATH_DIR / "ticket_attachments"

        filepath = UPLOAD_PATH_DIR / filename

        UPLOAD_PATH_DIR.mkdir(parents=True, exist_ok=True)

        img.save(filepath, "JPEG", quality=85, optimize=True)

    return filename_key


def delete_image(
    filename: str | None,
) -> None:
    if filename is None:
        return

    UPLOAD_PATH = os.getenv("UPLOAD_FOLDER_PATH", "uploads")
    UPLOAD_PATH_DIR = Path(UPLOAD_PATH)

    filepath = UPLOAD_PATH_DIR / filename

    if filepath.exists():
        filepath.unlink()
