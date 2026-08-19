from fastapi import FastAPI
from app.routes import roles

app = FastAPI()


@app.get("/")
def health_check():
    return "Site Working Fine"

app.include_router(roles.router)
