from fastapi import FastAPI
from starlette.middleware.cors import CORSMiddleware

from app.routes import roles, departments, users, auth, categories, queries, email

app = FastAPI()

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
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
app.include_router(queries.router)
app.include_router(email.router)
