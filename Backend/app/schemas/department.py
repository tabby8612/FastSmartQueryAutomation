from pydantic import BaseModel, ConfigDict


class DepartmentBase(BaseModel):
    name: str
    description: str | None = None
    hod_id: int | None = None
    is_active: bool = True


class DepartmentCreate(DepartmentBase):
    pass


class DepartmentUpdate(BaseModel):
    name: str | None = None
    description: str | None = None
    hod_id: int | None = None
    is_active: bool | None = None


class DepartmentResponse(DepartmentBase):
    id: int
    ticket_count: int

    model_config = ConfigDict(from_attributes=True)
