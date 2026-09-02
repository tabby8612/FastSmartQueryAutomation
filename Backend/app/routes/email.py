from fastapi import APIRouter, Depends, HTTPException, status
from pydantic import BaseModel
from sqlalchemy.ext.asyncio import AsyncSession

from app.database import get_db
from app.services.email_processing import process_incoming_email
from app.schemas.ticket import TicketResponse
from app.Enums.ChannelEnum import ChannelEnum
from app.schemas.incoming_email import IncomingEmail

router = APIRouter(prefix="/email", tags=["email"])


@router.post("/incoming", response_model=None, status_code=status.HTTP_201_CREATED)
async def incoming_email(email_data: IncomingEmail, db: AsyncSession = Depends(get_db)):
    new_ticket = await process_incoming_email(db, email_data)

    return {
        "message": f"Your Ticket is Successfully Created. Use Tracking Id {new_ticket.tracking_id} to track your ticket",
        "tracking_id": new_ticket.tracking_id,
        "success": True,
        "channel": ChannelEnum.EMAIL.lower(),
    }
