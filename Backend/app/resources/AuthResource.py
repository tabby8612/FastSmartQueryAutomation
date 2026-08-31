from app.models.user import User


class AuthResource:
    @staticmethod
    def userResource(data: User):
        return {
            "id": data.id,
            "name": data.full_name,
            "email": data.email,
            "department": (
                {"id": data.department.id, "name": data.department.name}
                if data.department_id
                else None
            ),
            "roles": data.roles,
            "rolename": data.roles[0].name if data.roles else None,
        }
