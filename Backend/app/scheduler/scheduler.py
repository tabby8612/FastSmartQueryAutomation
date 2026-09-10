from apscheduler.schedulers.asyncio import AsyncIOScheduler
from app.services.gmail_service import poll_university_email
from app.services.escalation_service import run_escalation_job

scheduler = AsyncIOScheduler()


def start_scheduler():
    scheduler.add_job(
        poll_university_email,
        "interval",
        seconds=3 * 60,
        id="university_email_polling",
        replace_existing=True,
        max_instances=1,
    )

    scheduler.add_job(
        run_escalation_job,
        "interval",
        minutes=15,
        id="ticket_escalation_job",
        replace_existing=True,
        max_instances=1,
    )

    scheduler.start()
