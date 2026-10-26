from datetime import date, datetime, timedelta, timezone

from sqlalchemy import select, func
from sqlalchemy.orm import selectinload
from sqlalchemy.ext.asyncio import AsyncSession

from typing import Any

from app.models.audit_logs import AuditLog
from app.models.user import User


class AuditService:
    async def record_audit(
        db: AsyncSession,
        action: str,
        entity_type: str,
        description: str,
        actor_id: int | None = None,
        entity_id: str | int | None = None,
        actor_name: str | None = None,
        actor_role: str | None = None,
        old_values: dict[str, Any] | None = None,
        new_values: dict[str, Any] | None = None,
        metadata: dict[str, Any] | None = None,
        status: str = "success",
        request_id: str | None = None,
        ip_address: str | None = None,
    ) -> AuditLog:
        log = AuditLog(
            actor_id=actor_id,
            actor_name=actor_name,
            actor_role=actor_role,
            action=action,
            entity_type=entity_type,
            entity_id=(str(entity_id) if entity_id is not None else None),
            description=description,
            old_values=old_values,
            new_values=new_values,
            metadata_=metadata,
            status=status,
            request_id=request_id,
            ip_address=ip_address,
        )

        db.add(log)
        await db.flush()

        return log

    @staticmethod
    def filters(
        start_date: date | None,
        end_date: date | None,
        action: str | None,
        entity: str | None,
        status: str | None,
    ):
        filters = []

        if start_date is not None:
            filters.append(AuditLog.created_at >= start_date)

        if end_date is not None:
            filters.append(
                AuditLog.created_at
                < datetime.combine(
                    end_date + timedelta(days=1), datetime.min.time(), timezone.utc
                )
            )

        if action:
            filters.append(AuditLog.action == action)

        if entity:
            filters.append(AuditLog.entity_type == entity)

        if status:
            filters.append(AuditLog.status == status)

        return filters

    @staticmethod
    async def get_audit_log(db: AsyncSession, filters):
        count_stmt = select(func.count()).select_from(AuditLog).where(*filters)

        total = await db.scalar(count_stmt)

        stmt = (
            select(AuditLog)
            .options(
                selectinload(AuditLog.user).load_only(
                    User.id, User.full_name, User.email
                )
            )
            .where(*filters)
            .order_by(AuditLog.created_at.desc(), AuditLog.id.desc())
        )

        result = await db.scalars(stmt)
        logs = result.all()

        return {
            "items": [
                {
                    "id": log.id,
                    "actor_id": log.actor_id,
                    "actor_name": log.actor_name,
                    "actor_role": log.actor_role,
                    "action": log.action,
                    "entity_type": log.entity_type,
                    "entity_id": log.entity_id,
                    "description": log.description,
                    "old_values": log.old_values,
                    "new_values": log.new_values,
                    "status": log.status,
                    "created_at": log.created_at,
                    "user": (
                        {
                            "id": log.user.id,
                            "full_name": (
                                log.user.full_name if log.user.full_name else ""
                            ),
                            "email": log.user.email if log.user.email else "",
                        }
                        if log.user
                        else None
                    ),
                }
                for log in logs
            ],
            "total": total or 0,
        }
