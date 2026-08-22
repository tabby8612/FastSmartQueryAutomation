from enum import Enum


class ChannelEnum(str, Enum):
    WEB_FORM = "web_form"
    EMAIL = "email"
    WHATSAPP = "whatsapp"
