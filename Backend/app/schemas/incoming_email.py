from pydantic import BaseModel, EmailStr


class IncomingEmail(BaseModel):
    sender_email: EmailStr
    subject: str
    body: str
