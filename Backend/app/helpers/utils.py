import random
import string
from datetime import datetime


def generate_tracking_number(prefix="QRY"):
    timestamps = datetime.now().strftime("%Y%m%d-%H%M%S")
    random_part = "".join(random.choices(string.ascii_uppercase + string.digits, k=4))
    return f"{prefix}-{timestamps}-{random_part}"
