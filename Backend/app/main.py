from fastapi import FastAPI
from starlette.middleware.cors import CORSMiddleware

from starlette.middleware.sessions import SessionMiddleware
from dotenv import load_dotenv
import os

load_dotenv()
SESSION_SECRET_KEY = os.getenv("SESSION_SECRET_KEY")

from app.routes import roles, departments, tickets, users, auth, categories, email

app = FastAPI()

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
app.include_router(email.router)
