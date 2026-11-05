from fastapi import APIRouter, Depends, HTTPException, status, UploadFile

from sqlalchemy.ext.asyncio import AsyncSession

from app.helpers.security import verify_password


from app.resources.ProfileResource import ProfileResource

from app.models.user import User

from app.schemas.profile import PersonalDetailUpdate, ChangePassword

from app.services.profile_service import ProfileService

from app.helpers.security import get_current_user, get_db

router = APIRouter(prefix="/profile", tags=["profile"])


@router.get("/me", response_model=None)
async def current_user_profile(
    db: AsyncSession = Depends(get_db), current_user: User = Depends(get_current_user)
):
    user = await ProfileService.get_user(db, current_user.id)

    if not user:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND, detail="User Not Found"
        )

    return ProfileResource.profile(user)


@router.put("/personal-details", response_model=None)
async def update_user_profile(
    user_update: PersonalDetailUpdate,
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(get_current_user),
):
    updated_user = await ProfileService.update_personal_detail(
        db, current_user, user_update.email, user_update.full_name
    )

    return ProfileResource.profile(updated_user)


@router.put("/change-password", response_model=None)
async def change_password(
    data: ChangePassword,
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(get_current_user),
):
    if not verify_password(data.old_password, current_user.password):
        raise HTTPException(status.HTTP_400_BAD_REQUEST, "Old Password doesn't match")

    if data.new_password != data.password_confirmation:
        raise HTTPException(
            status.HTTP_409_CONFLICT,
            detail="New Password and password confirmation do not match",
        )

    updated_user = await ProfileService.update_password(
        db, current_user, data.new_password
    )

    return ProfileResource.profile(updated_user)


@router.post("/upload-image", response_model=None)
async def upload_image(
    file: UploadFile,
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(get_current_user),
):
    content = await file.read()

    new_filename = await ProfileService.upload_profile_image(content, current_user, db)

    return ProfileResource.profile(current_user)


@router.delete("/upload-image")
async def delete_profile_image(
    current_user: User = Depends(get_current_user), db: AsyncSession = Depends(get_db)
):
    await ProfileService.delete_profile_image(current_user, db)

    return ProfileResource.profile(current_user)
