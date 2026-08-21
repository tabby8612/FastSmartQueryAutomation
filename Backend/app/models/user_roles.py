from app.database import Base
from sqlalchemy.orm import mapped_column, Mapped
from sqlalchemy import ForeignKey


class User_Roles(Base):
    __tablename__ = "user_roles"

    id: Mapped[int] = mapped_column(primary_key=True)
    role_id: Mapped[int] = mapped_column(ForeignKey("roles.id"))
    user_id: Mapped[int] = mapped_column(ForeignKey("users.id"))
