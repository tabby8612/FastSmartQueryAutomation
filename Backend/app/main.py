import os
from fastapi import FastAPI, Depends
from fastapi.staticfiles import StaticFiles
from dotenv import load_dotenv

from contextlib import asynccontextmanager

from starlette.middleware.cors import CORSMiddleware
from starlette.middleware.sessions import SessionMiddleware

from app.routes.api_route import api_router

from sqlalchemy.ext.asyncio import AsyncSession

from app.helpers.security import get_current_user, get_db
from app.scheduler.scheduler import start_scheduler, stop_scheduler
from app.models.user import User
from app.services.search_service import SearchService


@asynccontextmanager
async def lifespan(app: FastAPI):
    print("Application starting")

    start_scheduler()

    yield

    print("Application shutdown started")

    print("Stopping scheduler...")
    stop_scheduler()

    print("Application shutdown completed")


load_dotenv()
SESSION_SECRET_KEY = os.getenv("SESSION_SECRET_KEY")
FRONTEND_URL = os.getenv("FRONTEND_URL")

app = FastAPI(lifespan=lifespan)

app.mount("/api/uploads", StaticFiles(directory="uploads"), name="uploads")

app.add_middleware(SessionMiddleware, secret_key=SESSION_SECRET_KEY)

app.add_middleware(
    CORSMiddleware,
    allow_origins=["http://localhost:5173", "http://127.0.0.1:5173", FRONTEND_URL],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)


app.include_router(api_router)
