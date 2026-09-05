from dotenv import load_dotenv
from openai import OpenAI
import os

from app.models.ticket import Ticket
from app.Enums.TicketPriorityEnum import TicketPriorityEnum

load_dotenv()

HF_TOKEN = os.getenv("HF_TOKEN")
OPEN_AI_MODEL = os.getenv("OPEN_AI_MODEL")
HF_BASE_URL = os.getenv("HF_BASE_URL")


def build_ticket_context(ticket: Ticket) -> str:
    return f"""
    Ticket Tracking ID:
        {getattr(ticket, "tracking_id")}
    
        Student Name:
        {getattr(ticket.student, "full_name") if ticket.student else "Student"}
    
        Priority:
        {TicketPriorityEnum.to_label(getattr(ticket, "escalation_level", 0))}
    
        Department:
        {getattr(ticket.department, "name") if ticket.department else "General Administration"}
    
        Subject:
        {getattr(ticket, "subject")}
    
        Student Ticket Query:
        {getattr(ticket, "body")}
    
        Category:
        {getattr(ticket, "intent")}
    
        Conversation History:
        Original Ticket Query:
        {getattr(ticket, "body")}

        Replies: 
        {generate_replies(ticket.replies) if ticket.replies else "No Replies Yet"}
    """


def generate_replies(replies):
    if replies is None:
        return ""

    replies_string = ""

    for reply in replies:
        reply_text = f"""
        {"Student:" if reply.creator.is_student else "Officer:"}
        
        {reply.text}

        """
        replies_string += reply_text

    return replies_string


def ai_reply_generator(context: str):

    prompt = f"""
    You are an AI assistant for a university student support system.

    Your task is to create a draft response for a staff member responding to a student ticket.

    Rules:
    - Write Professionally and politely.
    - Keep replies concise
    - Address the student's actual issue
    - Never invent university policies, deadlines, fees, approvals, payment status, or actions that are not provided.
    - Never claim an action has been completed unless the context explicitly confirms it.
    - If information is missing, say that the relevant staff member will review or request the required information.
    - Do not tell the student that you are an AI.
    - Do not include internal system information.
    - Produce only draft only.
    - Use all the information about student ticket provided below.
    - Go through conversation history in the ticket (if available) before creating reply

    Here is the context of the ticket
    {context}
    """

    client = OpenAI(
        base_url=HF_BASE_URL,
        api_key=HF_TOKEN,
    )

    generated_text = client.chat.completions.create(
        model=OPEN_AI_MODEL,
        messages=[{"role": "user", "content": prompt}],
    )

    return generated_text.choices[0].message
