from sqlalchemy import create_engine
from sqlalchemy.orm import DeclarativeBase, sessionmaker

# Виправлення 'localhost' на 'db', відповідно до імені контейнера в docker-compose
SQLALCHEMY_DATABASE_URL = f"postgresql+psycopg2://postgres:567234@db:5432/hw02"

engine = create_engine(SQLALCHEMY_DATABASE_URL, echo=True, max_overflow=5)
SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)


class Base(DeclarativeBase):
    pass


# Dependency
def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()

