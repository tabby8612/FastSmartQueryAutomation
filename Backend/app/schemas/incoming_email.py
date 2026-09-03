from pydantic import BaseModel, EmailStr
from typing import Literal


class IncomingEmail(BaseModel):
    sender_email: EmailStr
    subject: str
    body: str


class NewTicketEmail(BaseModel):
    message_id: str
    email_from: EmailStr
    subject: str
    body: str
    is_processed: Literal[0, 1]
    received_on: str
