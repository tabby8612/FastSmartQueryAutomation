from sklearn.feature_extraction.text import TfidfVectorizer
from .training_data import texts, categories
from sklearn.linear_model import LogisticRegression
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy.future import select
from app.models.category import Category

vectorizer = TfidfVectorizer()
X = vectorizer.fit_transform(texts)

model = LogisticRegression()
model.fit(X, categories)

CONFIDENCE_THRESHOLD = 0.4
DEFAULT_CATEGORY = "general"


async def classify_issue(db: AsyncSession, text: str) -> dict:
    X_new = vectorizer.transform([text])

    category = model.predict(X_new)[0]
    confidence = model.predict_proba(X_new).max()

    if confidence < CONFIDENCE_THRESHOLD:
        stmt = select(Category).where(Category.name.like(f"%{DEFAULT_CATEGORY}%"))
        result = await db.execute(stmt)
        data = result.scalar_one_or_none()
    else:
        stmt = select(Category).where(Category.name.like(f"%{category}%"))
        result = await db.execute(stmt)
        data = result.scalar_one_or_none()

    if data is None:
        return {
            "category": (
                DEFAULT_CATEGORY if confidence < CONFIDENCE_THRESHOLD else category
            ),
            "confidence_score": confidence,
            "department_id": 3,  # later make it to general department
            "category_id": 3,  # later make it to general category
        }

    return {
        "category": DEFAULT_CATEGORY if confidence < CONFIDENCE_THRESHOLD else category,
        "confidence_score": confidence,
        "department_id": data.department_id,
        "category_id": data.id,
    }
