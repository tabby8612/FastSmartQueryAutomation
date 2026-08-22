from fastapi import APIRouter, Depends, HTTPException, status
from pydantic import BaseModel
from sqlalchemy.ext.asyncio import AsyncSession

from app.database import get_db
from app.services.email_processing import process_incoming_email
from app.schemas.query import QueryResponse

router = APIRouter(prefix="/email", tags=["email"])


class EmailIncoming(BaseModel):
    sender: str
    subject: str
    body: str


@router.post("/incoming", response_model=QueryResponse, status_code=status.HTTP_201_CREATED)
async def incoming_email(email_data: EmailIncoming, db: AsyncSession = Depends(get_db)):
    query = await process_incoming_email(db, email_data.sender, email_data.subject, email_data.body)
    return query
