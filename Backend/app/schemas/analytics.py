from pydantic import BaseModel


class AnalyticsSummary(BaseModel):
    total_tickets: int
    open_tickets: int
    resolved_tickets: int
    escalated_tickets: int


class AnalyticsCount(BaseModel):
    name: str
    count: str


class TicketTrend(BaseModel):
    date: str
    count: str
