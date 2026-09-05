import os
from fastapi import FastAPI
from dotenv import load_dotenv

from contextlib import asynccontextmanager

from starlette.middleware.cors import CORSMiddleware
from starlette.middleware.sessions import SessionMiddleware

from app.routes import roles, departments, tickets, users, auth, categories, email, replies
from app.scheduler.scheduler import scheduler, start_scheduler


@asynccontextmanager
async def lifespan(app: FastAPI):
    start_scheduler()
    yield
    scheduler.shutdown()


load_dotenv()
SESSION_SECRET_KEY = os.getenv("SESSION_SECRET_KEY")

app = FastAPI(lifespan=lifespan)

app.add_middleware(SessionMiddleware, secret_key=SESSION_SECRET_KEY)

app.add_middleware(
    CORSMiddleware,
    allow_origins=["http://localhost:5173", "http://127.0.0.1:5173"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)


@app.get("/")
def health_check():
    return "Site Working Fine"


app.include_router(roles.router)
app.include_router(departments.router)
app.include_router(users.router)
app.include_router(auth.router)
app.include_router(categories.router)
app.include_router(tickets.router)
app.include_router(replies.router)
app.include_router(replies.send_router)
app.include_router(email.router)
