from pydantic import BaseModel


class HODReassignRequest(BaseModel):
    officer_id: int


class HODPriorityUpdate(BaseModel):
    priority: str


class HODOfficerUpdate(BaseModel):
    officer_id: int
