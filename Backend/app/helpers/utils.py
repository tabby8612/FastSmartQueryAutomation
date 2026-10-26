import random
import string
from fastapi import Request

from datetime import datetime

from app.models.user import User


def generate_tracking_number(prefix="QRY"):
    timestamps = datetime.now().strftime("%Y%m%d-%H%M%S")
    random_part = "".join(random.choices(string.ascii_uppercase + string.digits, k=4))
    return f"{prefix}-{timestamps}-{random_part}"


def role_name(user: User) -> str | None:
    return user.roles[0].name if user.roles else None


def get_actor_ip(request: Request) -> str:
    x_forwarded_for = request.headers.get("x-forwarded-for")
    if x_forwarded_for:
        return x_forwarded_for.split(",")[0].strip()

    if request.client and request.client.host:
        return request.client.host

    return "unknown"
