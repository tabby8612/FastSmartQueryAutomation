import os
import asyncio
import traceback
from datetime import timezone
from pathlib import Path
import base64
from email.utils import parseaddr
from apscheduler.schedulers.asyncio import AsyncIOScheduler
from email.utils import parsedate_to_datetime

from sqlalchemy import select

from googleapiclient.discovery import build
from google.oauth2.credentials import Credentials
from google.auth.transport.requests import Request
from google_auth_oauthlib.flow import InstalledAppFlow

from app.services.email_processing import process_incoming_email
from app.schemas.incoming_email import IncomingEmail as IncomingEmailSchema
from app.database import AsyncSessionLocal
from app.schemas.incoming_email import NewTicketEmail
from app.models.incoming_email import IncomingEmail as IncomingEmailModel

SCOPES = ["https://www.googleapis.com/auth/gmail.modify"]

BASE_DIR = Path(__file__).resolve().parents[2]

CREDENTIALS_FILE = BASE_DIR / "gmail_credentials.json"
TOKEN_FILE = BASE_DIR / "token.json"


def get_gmail_service():
    creds = None

    # If token already exists, load it
    if TOKEN_FILE.exists():
        creds = Credentials.from_authorized_user_file(str(TOKEN_FILE), SCOPES)

    # If credentials don't exist or aren't valid
    if not creds or not creds.valid:

        # Existing token expired → refresh it
        if creds and creds.expired and creds.refresh_token:
            creds.refresh(Request())

        # No token yet → login through browser
        else:
            flow = InstalledAppFlow.from_client_secrets_file(
                str(CREDENTIALS_FILE), SCOPES
            )

            creds = flow.run_local_server(port=0)

        # Save credentials after login/refresh
        with open(TOKEN_FILE, "w") as token:
            token.write(creds.to_json())

    return build("gmail", "v1", credentials=creds)


def get_unread_inbox_messages(service):
    result = (
        service.users()
        .messages()
        .list(userId="me", q="in:inbox is:unread")
        .execute(num_retries=3)
    )

    return result.get("messages", [])


def get_message(service, message_id):
    return (
        service.users()
        .messages()
        .get(
            userId="me",
            id=message_id,
            format="full",
        )
        .execute(num_retries=3)
    )


def get_headers(message, header_name):
    headers = message.get("payload", {}).get("headers", {})

    for header in headers:
        if header["name"].lower() == header_name.lower():
            return header["value"]

    return None


def decode_body(data):
    return base64.urlsafe_b64decode(data).decode(encoding="utf-8", errors="ignore")


def get_email_body(message):
    payload = message.get("payload", {})

    body_data = payload.get("body", {}).get("data")

    if body_data:
        return decode_body(body_data)

    parts = payload.get("parts", {})

    for part in parts:
        if part.get("mimeType") == "text/plain":
            body_data = part.get("body", {}).get("data")

            if body_data:
                return decode_body(body_data)

    return ""


def parse_email(message):
    sender_header = get_headers(message, "From")

    sender_name, sender_email = parseaddr(sender_header)

    return {
        "gmail_message_id": message["id"],
        "thread_id": message["threadId"],
        "sender_name": sender_name,
        "sender_email": sender_email,
        "subject": get_headers(message, "Subject"),
        "body": get_email_body(message),
        "received_on": get_headers(message, "Date"),
    }


def mark_email_as_read(service, message_id):
    service.users().messages().modify(
        userId="me", id=message_id, body={"removeLabelIds": ["UNREAD"]}
    ).execute(num_retries=3)


def parse_email_received_on(received_on: str):
    received_at = parsedate_to_datetime(received_on)

    if received_at.tzinfo is None:
        return received_at

    return received_at.astimezone(timezone.utc).replace(tzinfo=None)


async def store_new_email(db, email_data: NewTicketEmail):
    new_email = IncomingEmailModel(
        message_id=email_data.message_id,
        email_from=email_data.email_from,
        subject=email_data.subject,
        body=email_data.body,
        is_processed=email_data.is_processed,
        received_on=parse_email_received_on(email_data.received_on),
    )

    db.add(new_email)
    await db.flush()
    return new_email


async def get_email_by_message_id(db, message_id):
    stmt = select(IncomingEmailModel).where(IncomingEmailModel.message_id == message_id)
    result = await db.execute(stmt)

    return result.scalar_one_or_none()


async def poll_university_email():
    service = get_gmail_service()
    print("Gmail connected successfully")

    messages = get_unread_inbox_messages(service)

    print(f"Unread inbox messages: {len(messages)}")

    if len(messages) < 1:
        return

    async with AsyncSessionLocal() as db:
        for message in messages:
            print(f"Download Message With ID: {message["id"]}")

            full_message = get_message(service, message["id"])

            parsed_email = parse_email(full_message)

            try:
                print(f"Processing Message with ID: {message["id"]}")
                existing_message = await get_email_by_message_id(db, message["id"])

                if existing_message:
                    print(
                        f"Email {message["id"]} is already processed, making it unread"
                    )

                    mark_email_as_read(service, message["id"])
                    continue

                print(f"Storing New Email with ID: {message["id"]}")
                email_data = NewTicketEmail(
                    message_id=parsed_email["gmail_message_id"],
                    email_from=parsed_email["sender_email"],
                    subject=parsed_email["subject"],
                    body=parsed_email["body"],
                    is_processed=0,
                    received_on=parsed_email["received_on"],
                )

                new_email = await store_new_email(db, email_data)

                print(f"Creating New Ticket with ID: {message["id"]}")

                sender_data = IncomingEmailSchema(
                    sender_email=parsed_email["sender_email"],
                    subject=parsed_email["subject"],
                    body=parsed_email["body"],
                )

                new_ticket = await process_incoming_email(db, sender_data)
                new_email.is_processed = 1
                new_email.ticket_id = new_ticket.id
                new_email.creator_id = new_ticket.student_id

                await db.commit()

                print(f"Marking Email with ID {message["id"]} As Read")
                mark_email_as_read(service, parsed_email["gmail_message_id"])

                print(f"Ticket #{new_ticket.tracking_id} created successfully")
            except Exception as e:
                await db.rollback()
                print(
                    f"Failed to process email"
                    f"{parsed_email['gmail_message_id']}: {e}"
                )
                # traceback.print_exc()
