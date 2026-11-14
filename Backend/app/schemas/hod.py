from pydantic import BaseModel

from app.Enums.TicketPriorityEnum import TicketPriorityEnum


class HODReassignRequest(BaseModel):
    officer_id: int


class HODPriorityUpdate(BaseModel):
    priority: TicketPriorityEnum


class HODOfficerUpdate(BaseModel):
    officer_id: int
