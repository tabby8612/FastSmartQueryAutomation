from fastapi import FastAPI
from app.routes import roles, departments, users, auth

app = FastAPI()


@app.get("/")
def health_check():
    return "Site Working Fine"

app.include_router(roles.router)
app.include_router(departments.router)
app.include_router(users.router)
app.include_router(auth.router)
