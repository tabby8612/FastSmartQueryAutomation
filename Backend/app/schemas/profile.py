from pydantic import BaseModel


class PersonalDetailUpdate(BaseModel):
    email: str | None = None
    full_name: str | None = None


class ChangePassword(BaseModel):
    old_password: str
    new_password: str
    password_confirmation: str
