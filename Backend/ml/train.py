from sklearn.feature_extraction.text import TfidfVectorizer
from sklearn.linear_model import LogisticRegression
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy.future import select
from app.models.category import Category
import pandas as pd
from pathlib import Path

BASE_DIR = Path(__file__).resolve().parent
csv_path = BASE_DIR / "training_data_combined.csv"


df = pd.read_csv(csv_path, encoding="cp1252")

df = df.dropna(subset=["text", "category", "priority"])

texts = df["text"].astype(str)
categories = df["category"].astype(str)
priorities = df["priority"].astype(str)

vectorizer = TfidfVectorizer(lowercase=True, ngram_range=(1, 2))
X = vectorizer.fit_transform(texts)

category_model = LogisticRegression(max_iter=1000)
category_model.fit(X, categories)

priority_model = LogisticRegression(max_iter=1000)
priority_model.fit(X, priorities)


CONFIDENCE_THRESHOLD = 0.35
DEFAULT_CATEGORY = "general"


async def classify_issue(db: AsyncSession, text: str) -> dict:
    X_new = vectorizer.transform([text])

    predicted_category = category_model.predict(X_new)[0]
    category_probabilities = category_model.predict_proba(X_new)[0]
    category_confidence = category_probabilities.max()

    predicted_priority = priority_model.predict(X_new)[0]
    priority_probabilities = priority_model.predict_proba(X_new)[0]
    priority_confidence = priority_probabilities.max()

    if category_confidence < CONFIDENCE_THRESHOLD:
        final_category = DEFAULT_CATEGORY
        stmt = select(Category).where(Category.name.ilike(f"%{DEFAULT_CATEGORY}%"))
    else:
        final_category = predicted_category
        stmt = select(Category).where(Category.name.ilike(f"%{predicted_category}%"))

    result = await db.execute(statement=stmt)
    data = result.scalar_one_or_none()

    final_priority = (
        "medium" if priority_confidence < CONFIDENCE_THRESHOLD else predicted_priority
    )

    if data is None:
        return {
            "category": final_category,
            "category_confidence_score": float(category_confidence),
            "priority": final_priority,
            "priority_confidence_score": float(priority_confidence),
            "department_id": 3,  # later make it to general department
            "category_id": 3,  # later make it to general category
        }

    return {
        "category": final_category,
        "category_confidence_score": float(category_confidence),
        "priority": final_priority,
        "priority_confidence_score": float(priority_confidence),
        "department_id": data.department_id,
        "category_id": data.id,
    }
