from fastapi import APIRouter

from app.routes import (
    roles,
    departments,
    tickets,
    users,
    auth,
    categories,
    email,
    replies,
    ticket_status_history,
    notification,
    hod,
    analytics,
    announcement,
    report,
    instructor,
    audit_logs,
    profile,
    attachment,
    search,
)

api_router = APIRouter(prefix="/api")


@api_router.get("/")
def health_check():
    return "Site Working Fine"


api_router.include_router(search.router)
api_router.include_router(profile.router)
api_router.include_router(roles.router)
api_router.include_router(departments.router)
api_router.include_router(users.router)
api_router.include_router(auth.router)
api_router.include_router(categories.router)
api_router.include_router(tickets.router)
api_router.include_router(replies.router)
api_router.include_router(replies.send_router)
api_router.include_router(email.router)
api_router.include_router(ticket_status_history.router)
api_router.include_router(notification.router)
api_router.include_router(hod.router)
api_router.include_router(analytics.router)
api_router.include_router(announcement.router)
api_router.include_router(report.router)
api_router.include_router(instructor.router)
api_router.include_router(audit_logs.router)
api_router.include_router(attachment.router)
