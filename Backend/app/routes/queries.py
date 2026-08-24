from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.ext.asyncio import AsyncSession

from app.database import get_db
from app.schemas.query import QueryCreate, QueryResponse, QueryUpdate
from app.services.query import QueryService
from app.helpers.security import get_current_user
from app.models.user import User
from app.Enums.ChannelEnum import ChannelEnum
from ml.train import classify_issue

router = APIRouter(prefix="/queries", tags=["queries"])


def has_role(user: User, role_names: list[str]) -> bool:
    return any(role.name in role_names for role in user.roles)


def require_roles(*role_names: str):
    def checker(current_user: User = Depends(get_current_user)):
        if not has_role(current_user, list(role_names)):
            raise HTTPException(
                status_code=status.HTTP_403_FORBIDDEN,
                detail="You do not have permission to access this resource",
            )
        return current_user

    return checker


@router.post("/", response_model=None, status_code=status.HTTP_201_CREATED)
async def create_query(
    query: QueryCreate,
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(get_current_user),
):

    return await QueryService.create(
        db=db,
        student_id=current_user.id,
        subject=query.subject,
        body=query.body,
        channel=ChannelEnum.WEB_FORM,
    )


@router.get("/", response_model=list[QueryResponse])
async def get_queries(
    db: AsyncSession = Depends(get_db), current_user: User = Depends(get_current_user)
):
    if has_role(current_user, ["admin"]):
        return await QueryService.get_all(db)
    if has_role(current_user, ["staff", "hod", "officer"]):
        return await QueryService.get_all(db, assigned_id=current_user.id)
    return await QueryService.get_all(db, student_id=current_user.id)


@router.get("/{query_id}", response_model=QueryResponse)
async def get_query(
    query_id: int,
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(get_current_user),
):
    query = await QueryService.get_by_id(db, query_id)
    if not query:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND, detail="Query not found"
        )
    if has_role(current_user, ["admin"]):
        return query
    if (
        has_role(current_user, ["staff", "hod"])
        and query.assigned_id == current_user.id
    ):
        return query
    if query.student_id == current_user.id:
        return query
    raise HTTPException(
        status_code=status.HTTP_403_FORBIDDEN,
        detail="You do not have permission to access this query",
    )


@router.put("/{query_id}", response_model=QueryResponse)
async def update_query(
    query_id: int,
    query_update: QueryUpdate,
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(get_current_user),
):
    query = await QueryService.get_by_id(db, query_id)
    if not query:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND, detail="Query not found"
        )
    if has_role(current_user, ["admin"]):
        return await QueryService.update(
            db=db,
            query=query,
            assigned_id=query_update.assigned_id,
            channel=query_update.channel,
            subject=query_update.subject,
            body=query_update.body,
            intent=query_update.intent,
            confidence_level=query_update.confidence_level,
            status=query_update.status,
            escalation_level=query_update.escalation_level,
            awaiting_student_input=query_update.awaiting_student_input,
            resolved_at=query_update.resolved_at,
        )
    if (
        has_role(current_user, ["staff", "hod"])
        and query.assigned_id == current_user.id
    ):
        return await QueryService.update(
            db=db,
            query=query,
            assigned_id=query_update.assigned_id,
            channel=query_update.channel,
            subject=query_update.subject,
            body=query_update.body,
            intent=query_update.intent,
            confidence_level=query_update.confidence_level,
            status=query_update.status,
            escalation_level=query_update.escalation_level,
            awaiting_student_input=query_update.awaiting_student_input,
            resolved_at=query_update.resolved_at,
        )
    raise HTTPException(
        status_code=status.HTTP_403_FORBIDDEN,
        detail="You do not have permission to update this query",
    )


@router.put("/{query_id}/assign", response_model=QueryResponse)
async def assign_query(
    query_id: int,
    query_update: QueryUpdate,
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(require_roles("admin")),
):
    query = await QueryService.get_by_id(db, query_id)
    if not query:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND, detail="Query not found"
        )
    return await QueryService.update(
        db=db,
        query=query,
        assigned_id=query_update.assigned_id,
        channel=None,
        subject=None,
        body=None,
        intent=None,
        confidence_level=None,
        status=None,
        escalation_level=None,
        awaiting_student_input=None,
        resolved_at=None,
    )


@router.put("/{query_id}/status", response_model=QueryResponse)
async def change_query_status(
    query_id: int,
    query_update: QueryUpdate,
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(get_current_user),
):
    query = await QueryService.get_by_id(db, query_id)
    if not query:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND, detail="Query not found"
        )
    if has_role(current_user, ["admin"]):
        return await QueryService.update(
            db=db,
            query=query,
            assigned_id=None,
            channel=None,
            subject=None,
            body=None,
            intent=None,
            confidence_level=None,
            status=query_update.status,
            escalation_level=query_update.escalation_level,
            awaiting_student_input=query_update.awaiting_student_input,
            resolved_at=query_update.resolved_at,
        )
    if (
        has_role(current_user, ["staff", "hod"])
        and query.assigned_id == current_user.id
    ):
        return await QueryService.update(
            db=db,
            query=query,
            assigned_id=None,
            channel=None,
            subject=None,
            body=None,
            intent=None,
            confidence_level=None,
            status=query_update.status,
            escalation_level=query_update.escalation_level,
            awaiting_student_input=query_update.awaiting_student_input,
            resolved_at=query_update.resolved_at,
        )
    raise HTTPException(
        status_code=status.HTTP_403_FORBIDDEN,
        detail="You do not have permission to change this query status",
    )


@router.delete("/{query_id}", status_code=status.HTTP_204_NO_CONTENT)
async def delete_query(
    query_id: int,
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(require_roles("admin")),
):
    query = await QueryService.get_by_id(db, query_id)
    if not query:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND, detail="Query not found"
        )
    await QueryService.delete(db, query)
