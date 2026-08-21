from app.models.user import User


class AuthResource:
    @staticmethod
    def userResource(data: User):
        # return data
        return {
            "id": data.id,
            "name": data.full_name,
            "email": data.email,
            "department": {"id": data.department.id, "name": data.department.name},
            "role": data.role,
        }
