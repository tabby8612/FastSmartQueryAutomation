from app.models.ticket import Ticket
from app.models.reply import Reply


class NotificationTemplate:
    @staticmethod
    def ticket_created(ticket: Ticket):
        return {
            "subject": f"Ticket with tracking id: {ticket.tracking_id} is being created",
            "body": f"""
Hello,

Your ticket "{ticket.subject}" has been received successfully.

Ticket Tracking ID: {ticket.tracking_id}
Current Status: {ticket.status.capitalize()}

You will be notified when there is an update.

Fast Smart Querying System
""",
        }

    @staticmethod
    def ticket_assigned(ticket: Ticket):
        return {
            "subject": f"New Ticket Assigned - #{ticket.tracking_id}",
            "body": f"""
A new student query is being assigned to you.

Ticket Tracking ID: {ticket.tracking_id}
Subject: {ticket.subject}
Priority: {ticket.priority}
Status: {ticket.status}

Please log in to the portal to review the student query.
""",
        }

    @staticmethod
    def new_reply(ticket: Ticket, reply: Reply):
        return {
            "subject": f"New Reply - Ticket #{ticket.tracking_id}",
            "body": f"""
A new reply has been added to your query.

Ticket Tracking ID: {ticket.tracking_id}
Subject: {ticket.subject}

Reply:
{reply.text}

Please log into the portal for complete details.
""",
        }

    @staticmethod
    def status_changed(ticket: Ticket, old_status, new_status):
        return {
            "subject": f"Ticket {ticket.tracking_id} Status Updated",
            "body": f"""
The status of your ticket query is being updated

Ticket Tracking ID: {ticket.tracking_id}
Subject: {ticket.subject}

Previous Status: {old_status}
New Status: {new_status}

Please log into the portal for more information.
""",
        }

    @staticmethod
    def ticket_escalated(ticket: Ticket):
        return {
            "subject": f"Escalated Ticket No. {ticket.tracking_id}",
            "body": f"""
A student query has been escalated to you.

Ticket Tracking ID: {ticket.tracking_id}
Subject: {ticket.subject}
Priority: {ticket.priority.capitalize()}

The ticket was not solved within the required time period.

Please review it from your dashboard.
""",
        }
