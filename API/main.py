from fastapi import FastAPI, Depends, HTTPException, status
from sqlalchemy.ext.asyncio import AsyncSession, create_async_engine
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.orm import sessionmaker
from sqlalchemy import Column, Integer, String
from sqlalchemy.future import select
from pydantic import BaseModel
import os
from dotenv import load_dotenv
from sqlalchemy.exc import SQLAlchemyError
import logging
from jose import JWTError, jwt
from passlib.context import CryptContext
from fastapi.security import OAuth2PasswordBearer, OAuth2PasswordRequestForm
from fastapi_pagination import Page, add_pagination, paginate
from datetime import datetime, timedelta
from fastapi.middleware.cors import CORSMiddleware

app = FastAPI()

# Настройка CORS
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # Или замените "*" на конкретные источники, если необходимо
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Логирование
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

# Загрузка переменных окружения
load_dotenv()

# JWT настройки
SECRET_KEY = os.getenv("SECRET_KEY", "your_secret_key")
ALGORITHM = "HS256"
ACCESS_TOKEN_EXPIRE_MINUTES = 30

# Настройки для хеширования пароля
pwd_context = CryptContext(schemes=["bcrypt"], deprecated="auto")

# Настройки OAuth2 для получения токенов
oauth2_scheme = OAuth2PasswordBearer(tokenUrl="token")

# Подключение к базе данных
DB_USER = os.getenv("DB_USER")
DB_PASSWORD = os.getenv("DB_PASSWORD")
DB_HOST = os.getenv("DB_HOST")
DB_NAME = os.getenv("DB_NAME")

DATABASE_URL = f"postgresql+asyncpg://{DB_USER}:{DB_PASSWORD}@{DB_HOST}/{DB_NAME}"

# Настройка движка и сессии
engine = create_async_engine(DATABASE_URL, echo=True)
AsyncSessionLocal = sessionmaker(bind=engine, class_=AsyncSession, expire_on_commit=False)

Base = declarative_base()

# Модели базы данных
class User(Base):
    __tablename__ = "users"
    __table_args__ = {"schema": "svk"}

    id = Column(Integer, primary_key=True, index=True)
    name = Column(String, nullable=False)
    email = Column(String, unique=True, nullable=False)
    password_hash = Column(String, nullable=False)
    role_id = Column(Integer, nullable=True)

class Roles(Base):
    __tablename__ = "roles"
    __table_args__ = {"schema": "svk"}

    id = Column(Integer, primary_key=True, index=True)
    role_name = Column(String, unique=True, nullable=False)

# Pydantic модели
class UserCreate(BaseModel):
    name: str
    email: str
    password: str
    role_id: int

class UserResponse(BaseModel):
    id: int
    name: str
    email: str
    role_id: int

class Token(BaseModel):
    access_token: str
    token_type: str

class TokenData(BaseModel):
    email: str | None = None
    name: str | None = None
    role_id: int | None = None
    user_id: int | None = None  # Добавляем user_id




# Функция для создания JWT токена
def create_access_token(user: User, expires_delta: timedelta | None = None):
    to_encode = {
        "sub": user.email,
        "user_id": user.id,  # Сохраняем user_id для идентификации
        "role_id": user.role_id,
    }
    if expires_delta:
        expire = datetime.utcnow() + expires_delta
    else:
        expire = datetime.utcnow() + timedelta(minutes=ACCESS_TOKEN_EXPIRE_MINUTES)
    to_encode.update({"exp": expire})
    
    # Сохраняем дополнительные данные о пользователе
    store_user_data(user.id, user.name, user.email, user.role_id)
    
    encoded_jwt = jwt.encode(to_encode, SECRET_KEY, algorithm=ALGORITHM)
    return encoded_jwt


# Функция для проверки пароля
def verify_password(plain_password, hashed_password):
    return pwd_context.verify(plain_password, hashed_password)

# Функция для хеширования пароля
def get_password_hash(password):
    return pwd_context.hash(password)

# Создание базы данных
async def init_db():
    async with engine.begin() as conn:
        await conn.run_sync(Base.metadata.create_all)

# Получение сессии
async def get_session() -> AsyncSession:
    async with AsyncSessionLocal() as session:
        yield session

# Получение пользователя по email
async def get_user_by_email(email: str, session: AsyncSession):
    result = await session.execute(select(User).where(User.email == email))
    return result.scalars().first()

# Проверка аутентификации
async def authenticate_user(email: str, password: str, session: AsyncSession):
    user = await get_user_by_email(email, session)
    if not user or not verify_password(password, user.password_hash):
        return False
    return user

# Декодирование токена
async def get_current_user(token: str = Depends(oauth2_scheme), session: AsyncSession = Depends(get_session)):
    try:
        payload = jwt.decode(token, SECRET_KEY, algorithms=[ALGORITHM])
        email: str = payload.get("sub")
        name: str = payload.get("name")
        role_id: int = payload.get("role_id")  # Убедитесь, что role_id извлекается правильно
        if email is None:
            raise HTTPException(status_code=401, detail="Invalid credentials")
        token_data = TokenData(email=email, name=name, role_id=role_id)
    except JWTError:
        raise HTTPException(status_code=401, detail="Invalid credentials")
    
    user = await get_user_by_email(token_data.email, session)
    
    if user is None:
        raise HTTPException(status_code=401, detail="User not found")
    
    return user


async def get_user_from_db(user_id: int, session: AsyncSession):
    result = await session.execute(select(User).where(User.id == user_id))
    return result.scalars().first()

user_cache = {}  # Словарь для хранения данных (в реальном приложении замените на базу данных или другой персистентный хранилище)

def store_user_data(user_id: int, name: str, email: str, role_id: int):
    user_cache[user_id] = {
        "name": name,
        "email": email,
        "role_id": role_id,
    }


@app.get("/me")
async def get_current_user_data(token: str = Depends(oauth2_scheme)):
    try:
        # Декодирование JWT токена
        payload = jwt.decode(token, SECRET_KEY, algorithms=[ALGORITHM])
        user_id: int = payload.get("user_id")  # Убедитесь, что вы используете правильный ключ

        if user_id is None:
            raise HTTPException(status_code=401, detail="Invalid credentials")

        # Получаем данные пользователя из кэша
        user_data = user_cache.get(user_id)
        if not user_data:
            # Если данные не найдены в кэше, можно добавить логику для получения их из базы данных
            raise HTTPException(status_code=404, detail="User data not found")

        return user_data

    except JWTError:
        raise HTTPException(status_code=401, detail="Invalid credentials")



@app.on_event("startup")
async def on_startup():
    try:
        await init_db()
        logger.info("Database initialized successfully.")
    except Exception as e:
        logger.error(f"Error during database initialization: {str(e)}")

# Эндпоинт для получения токена
@app.post("/token", response_model=Token)
async def login_for_access_token(form_data: OAuth2PasswordRequestForm = Depends(), session: AsyncSession = Depends(get_session)):
    user = await authenticate_user(form_data.username, form_data.password, session)

    if not user:
        raise HTTPException(status_code=401, detail="Incorrect email or password")
    
    access_token = create_access_token(user=user)
    
    # Возвращаем ID пользователя с токеном
    return {
        "access_token": access_token,
        "token_type": "bearer",
        "user_id": user.id  # Теперь ID возвращается в ответе
    }


# Эндпоинт для создания пользователя
@app.post("/users", response_model=UserResponse)
async def create_user(user: UserCreate, session: AsyncSession = Depends(get_session)):
    logger.info(f"Creating user: {user.email}")
    
    try:
        existing_user = await session.execute(select(User).where(User.email == user.email))
        
        if existing_user.scalars().first():
            logger.warning(f"Email {user.email} is already registered.")
            raise HTTPException(status_code=400, detail="Email already registered")

        if len(user.password) < 8:
            logger.warning(f"Password for {user.email} is too short.")
            raise HTTPException(status_code=400, detail="Password must be at least 8 characters long")

        hashed_password = get_password_hash(user.password)

        new_user = User(
            name=user.name,
            email=user.email,
            password_hash=hashed_password,
            role_id=user.role_id,
        )
        
        session.add(new_user)
        await session.commit()
        
        logger.info(f"User {user.email} created successfully.")
        
        return UserResponse(id=new_user.id, name=new_user.name,
                            email=new_user.email,
                            role_id=new_user.role_id)

    except SQLAlchemyError as e:
        logger.error(f"Error creating user {user.email}: {str(e)}")
        await session.rollback()
        raise HTTPException(status_code=500, detail="Database error")

# Эндпоинт для получения списка пользователей с пагинацией.
@app.get("/users", response_model=Page[UserResponse])
async def read_users(session: AsyncSession = Depends(get_session), current_user: User = Depends(get_current_user)):
    result = await session.execute(select(User))
    users = result.scalars().all()
    return paginate(users)

# Эндпоинт для получения информации о пользователе по ID
@app.get("/users/{user_id}", response_model=UserResponse)
async def get_user(user_id: int, session: AsyncSession = Depends(get_session)):
    result = await session.execute(select(User).where(User.id == user_id))
    user = result.scalars().first()
    if not user:
        raise HTTPException(status_code=404, detail="User not found")
    return UserResponse(id=user.id, name=user.name, email=user.email, role_id=user.role_id)

# Эндпоинт для редактирования пользователя
@app.put("/users/{user_id}", response_model=UserResponse)
async def update_user(user_id: int, user: UserCreate, session: AsyncSession = Depends(get_session)):
    result = await session.execute(select(User).where(User.id == user_id))
    existing_user = result.scalars().first()
    
    if not existing_user:
        raise HTTPException(status_code=404, detail="User not found")
    
    existing_user.name = user.name
    existing_user.email = user.email
    if user.password:
        existing_user.password_hash = get_password_hash(user.password)
    existing_user.role_id = user.role_id

    await session.commit()
    
    return UserResponse(id=existing_user.id, name=existing_user.name, email=existing_user.email, role_id=existing_user.role_id)

# Эндпоинт для удаления пользователя
@app.delete("/users/{user_id}", status_code=status.HTTP_204_NO_CONTENT)
async def delete_user(user_id: int, session: AsyncSession = Depends(get_session)):
    result = await session.execute(select(User).where(User.id == user_id))
    user = result.scalars().first()
    
    if not user:
        raise HTTPException(status_code=404, detail="User not found")
    
    await session.delete(user)
    await session.commit()

# Добавление пагинации к API
add_pagination(app)
