from apscheduler.schedulers.asyncio import AsyncIOScheduler
from app.services.gmail_service import poll_university_email
from app.services.escalation_service import run_escalation_job
from app.jobs.notification_job import process_pending_notification

scheduler = AsyncIOScheduler()


def start_scheduler():
    # FR-02 - Email ingestion
    scheduler.add_job(
        poll_university_email,
        "interval",
        minutes=3,
        id="university_email_polling",
        replace_existing=True,
        max_instances=1,
    )

    # FR-07 - Escalation of Unsolved Tickets
    scheduler.add_job(
        run_escalation_job,
        "interval",
        minutes=15,
        id="ticket_escalation_job",
        replace_existing=True,
        max_instances=1,
    )

    # FR-08 - Notifications
    scheduler.add_job(
        process_pending_notification,
        "interval",
        minutes=1,
        id="notification_worker",
        max_instances=1,  # prevent multiple instance if previous is running
        replace_existing=True,
        coalesce=True,  # avoid buildup of missed execution
    )

    scheduler.start()
