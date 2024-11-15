# Импорт необходимых библиотек
from typing import Optional, List, Union
from fastapi import FastAPI, HTTPException, File, Form, UploadFile, Depends, status
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy.future import select
from sqlalchemy import delete
import json
import shutil
import uuid
from pathlib import Path
import os
import logging
from datetime import datetime, timedelta
from typing import List
from typing import Optional, List
from fastapi import FastAPI, HTTPException, File, Form, UploadFile, Depends, status
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy.future import select
from sqlalchemy import delete
import json
import shutil
import uuid
from pathlib import Path
from dotenv import load_dotenv
from fastapi import FastAPI, Depends, HTTPException, status
from fastapi.middleware.cors import CORSMiddleware
from fastapi.security import OAuth2PasswordBearer, OAuth2PasswordRequestForm
from fastapi_pagination import Page, add_pagination, paginate
from jose import JWTError, jwt
from passlib.context import CryptContext
from sqlalchemy import Column, Integer, String, ForeignKey
from sqlalchemy.ext.asyncio import AsyncSession, create_async_engine
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.orm import sessionmaker
from sqlalchemy.future import select
from sqlalchemy.exc import SQLAlchemyError
from pydantic import BaseModel
from models import Product

from fastapi import File, UploadFile
from pathlib import Path
from fastapi.responses import FileResponse
from fastapi import FastAPI, HTTPException
from pathlib import Path

import os
import uuid
from fastapi import FastAPI, HTTPException, UploadFile, File
from fastapi.responses import FileResponse
from sqlalchemy.orm import Session
from pathlib import Path
from datetime import datetime
import models, schemas, database

from fastapi import FastAPI, HTTPException, Depends, File, UploadFile, status
from fastapi.responses import FileResponse
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy.exc import SQLAlchemyError
from datetime import datetime
import uuid
from typing import List
from pathlib import Path
import shutil
from models import ProductImage
from schemas import ProductImageResponse

from fastapi import FastAPI, File, UploadFile, Form
from typing import List

import os
import uuid
import shutil
from fastapi import FastAPI, HTTPException, File, UploadFile, Form, Depends, status
from sqlalchemy.future import select
from sqlalchemy.ext.asyncio import AsyncSession
from typing import List
from fastapi.responses import FileResponse
from pathlib import Path

from fastapi import APIRouter, HTTPException, UploadFile, Form, Depends, File
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy.future import select
from models import Product, ProductImage  # Замените на правильный импорт модели
import uuid
import shutil
from typing import List

from fastapi import HTTPException
from sqlalchemy.future import select

from fastapi import FastAPI, HTTPException, Form, File, UploadFile, Depends
from sqlalchemy.orm import Session
from typing import List, Optional
import shutil
import uuid
from pathlib import Path

from sqlalchemy import select, delete

from fastapi import File, Form, HTTPException, UploadFile
from typing import Optional, List
import shutil
import uuid
import os

import json


app = FastAPI()

# Путь для сохранения изображений
IMAGE_DIRECTORY = Path("C:/Users/2903m/Desktop/Универ/SVK_dart/images")
IMAGE_DIRECTORY.mkdir(parents=True, exist_ok=True)

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

# Модель SQLAlchemy для категорий
class Category(Base):
    __tablename__ = "categories"
    __table_args__ = {"schema": "svk"}

    id = Column(Integer, primary_key=True, index=True)
    name = Column(String(100), unique=True, nullable=False)
    parent_id = Column(Integer, ForeignKey("svk.categories.id", ondelete="CASCADE"))

# Pydantic-схемы для категорий
class CategoryBase(BaseModel):
    name: str
    parent_id: int | None = None

class CategoryCreate(CategoryBase):
    pass

class CategoryResponse(CategoryBase):
    id: int

    class Config:
        orm_mode = True

# Pydantic-схемы для товаров
class ProductBase(BaseModel):
    name: str
    description: str | None = None
    price: float
    sale_price: float | None = None
    category_id: int | None = None
    sku: str | None = None
    production_time: int | None = None
    height: float | None = None
    width: float | None = None
    length: float | None = None
    weight: float | None = None
    additional_details: str | None = None

class ProductCreate(ProductBase):
    pass

class ProductResponse(ProductBase):
    id: int

    class Config:
        orm_mode = True


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


async def init_db():
    async with engine.begin() as conn:
        await conn.run_sync(Base.metadata.create_all)


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

@app.get("/users", response_model=Page[UserResponse])
async def read_users(session: AsyncSession = Depends(get_session), current_user: User = Depends(get_current_user)):
    if current_user.role_id != 4:  # Предположим, что роль с ID 4 — это администратор
        raise HTTPException(status_code=403, detail="Not enough permissions")

    result = await session.execute(select(User))
    users = result.scalars().all()

    # Возврат пользователей с пагинацией
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


# CRUD-операции для категорий
@app.get("/categories", response_model=list[CategoryResponse])
async def read_categories(session: AsyncSession = Depends(get_session)):
    """Получение всех категорий"""
    result = await session.execute(select(Category))
    categories = result.scalars().all()
    return categories

@app.post("/categories", response_model=CategoryResponse, status_code=status.HTTP_201_CREATED)
async def create_category(category: CategoryCreate, session: AsyncSession = Depends(get_session)):
    """Создание новой категории"""
    new_category = Category(name=category.name, parent_id=category.parent_id)
    session.add(new_category)
    try:
        await session.commit()
        await session.refresh(new_category)
        return new_category
    except SQLAlchemyError:
        await session.rollback()
        raise HTTPException(status_code=400, detail="Ошибка при создании категории")

@app.put("/categories/{id}", response_model=CategoryResponse)
async def update_category(id: int, category: CategoryCreate, session: AsyncSession = Depends(get_session)):
    """Обновление категории по ID"""
    result = await session.execute(select(Category).where(Category.id == id))
    existing_category = result.scalars().first()
    if not existing_category:
        raise HTTPException(status_code=404, detail="Категория не найдена")
    
    existing_category.name = category.name
    existing_category.parent_id = category.parent_id
    try:
        await session.commit()
        await session.refresh(existing_category)
        return existing_category
    except SQLAlchemyError:
        await session.rollback()
        raise HTTPException(status_code=400, detail="Ошибка при обновлении категории")

@app.delete("/categories/{id}", status_code=status.HTTP_204_NO_CONTENT)
async def delete_category(id: int, session: AsyncSession = Depends(get_session)):
    """Удаление категории по ID"""
    result = await session.execute(select(Category).where(Category.id == id))
    category = result.scalars().first() 
    if not category:
        raise HTTPException(status_code=404, detail="Категория не найдена")

    try:
        await session.delete(category)
        await session.commit()
    except SQLAlchemyError:
        await session.rollback()
        raise HTTPException(status_code=400, detail="Ошибка при удалении категории")

@app.post("/products/")
async def create_product(
    name: str = Form(...),
    description: str = Form(None),
    price: float = Form(...),
    sale_price: float = Form(None),
    category_id: int = Form(...),
    height: float = Form(None),
    width: float = Form(None),
    length: float = Form(None),
    weight: float = Form(None),
    production_time: int = Form(None),
    additional_details: str = Form(None),
    images: List[UploadFile] = File(...),
    session: AsyncSession = Depends(get_session)
):
    image_filenames = []  # Массив для хранения имен файлов

    # Сохранение изображений
    for image in images:
        if not image.filename.endswith(('.jpg', '.jpeg', '.png', '.gif')):
            raise HTTPException(status_code=415, detail=f"File type {image.filename.split('.')[-1]} not supported")
        
        # Генерируем уникальное имя для файла
        unique_filename = f"{uuid.uuid4().hex}_{image.filename}"
        image_path = IMAGE_DIRECTORY / unique_filename

        # Сохраняем файл
        with open(image_path, "wb") as buffer:
            shutil.copyfileobj(image.file, buffer)
        
        image_filenames.append(unique_filename)  # Добавляем имя файла, а не путь

    # Создаем новый продукт в базе данных
    new_product = Product(
        name=name,
        description=description,
        price=price,
        sale_price=sale_price,
        category_id=category_id,
        height=height,
        width=width,
        length=length,
        weight=weight,
        production_time=production_time,
        additional_details=additional_details,
    )

    session.add(new_product)
    await session.commit()
    await session.refresh(new_product)

    # Сохраняем изображения для этого продукта в таблице ProductImage
    for filename in image_filenames:
        product_image = ProductImage(
            product_id=new_product.id,
            image_url=filename,  # Сохраняем только имя файла
        )
        session.add(product_image)

    await session.commit()

    return {"message": "Product created successfully", "product": new_product}


@app.get("/products")
async def read_products(category_id: int = None, session: AsyncSession = Depends(get_session)):
    # Запрос продуктов
    query = select(Product)
    
    # Фильтрация по категории, если указан category_id
    if category_id is not None:
        query = query.where(Product.category_id == category_id)

    result = await session.execute(query)
    products = result.scalars().all()

    # Получаем изображения для каждого продукта
    products_with_images = []
    for product in products:
        # Запрос изображений для текущего продукта
        images_result = await session.execute(select(ProductImage).where(ProductImage.product_id == product.id))
        images = images_result.scalars().all()

        # Формируем данные о продукте с изображениями
        product_data = {
            "id": product.id,
            "name": product.name,
            "description": product.description,
            "price": product.price,
            "sale_price": product.sale_price,
            "category_id": product.category_id,
            "height": product.height,
            "width": product.width,
            "length": product.length,
            "weight": product.weight,
            "production_time": product.production_time,
            "additional_details": product.additional_details,
            "images": [Path(image.image_url).name for image in images]  # Получаем только имя файла изображения
        }
        
        # Добавляем продукт с изображениями в результирующий список
        products_with_images.append(product_data)

    return products_with_images


@app.get("/products/{product_id}")
async def read_product(product_id: int, session: AsyncSession = Depends(get_session)):
    # Запрашиваем продукт с указанным ID
    result = await session.execute(select(Product).where(Product.id == product_id))
    product = result.scalars().first()

    if not product:
        raise HTTPException(status_code=404, detail="Product not found")

    # Получаем связанные изображения продукта
    images_result = await session.execute(select(ProductImage).where(ProductImage.product_id == product_id))
    images = images_result.scalars().all()

    # Преобразуем данные продукта и изображений в удобный формат JSON
    product_data = {
        "id": product.id,
        "name": product.name,
        "description": product.description,
        "price": product.price,
        "sale_price": product.sale_price,
        "category_id": product.category_id,
        "height": product.height,
        "width": product.width,
        "length": product.length,
        "weight": product.weight,
        "production_time": product.production_time,
        "additional_details": product.additional_details,
        "images": [Path(image.image_url).name for image in images]  # Получаем только имя файла
    }

    return product_data


# Эндпоинт для обновления продукта
@app.put("/products/{product_id}")
async def update_product(
    product_id: int,
    name: str = Form(...),
    description: Optional[str] = Form(None),
    price: float = Form(...),
    sale_price: Optional[float] = Form(None),
    category_id: int = Form(...),
    height: Optional[float] = Form(None),
    width: Optional[float] = Form(None),
    length: Optional[float] = Form(None),
    weight: Optional[float] = Form(None),
    production_time: Optional[int] = Form(None),
    additional_details: Optional[str] = Form(None),
    images: Optional[List[UploadFile]] = File(None),  # Загрузка новых изображений
    delete_images: Optional[str] = Form(None),  # Текстовое поле для удаления изображений
    session: AsyncSession = Depends(get_session)
):
    # Проверка наличия продукта
    result = await session.execute(select(Product).where(Product.id == product_id))
    product = result.scalars().first()

    if not product:
        raise HTTPException(status_code=404, detail="Product not found")

    # Обновление основных полей продукта
    product.name = name
    product.description = description
    product.price = price
    product.sale_price = sale_price
    product.category_id = category_id
    product.height = height
    product.width = width
    product.length = length
    product.weight = weight
    product.production_time = production_time
    product.additional_details = additional_details

    # Удаление изображений, если `delete_images` передан
    if delete_images:
        try:
            delete_image_names_list = json.loads(delete_images)  # Преобразуем строку JSON в список
            for image_name in delete_image_names_list:
                await delete_image(image_name=image_name, session=session)  # Вызов функции для удаления изображений
        except json.JSONDecodeError as e:
            raise HTTPException(status_code=400, detail=f"Invalid JSON format for delete_images: {e}")

    # Добавление новых изображений, если `images` передан
    if images:
        for image in images:
            await upload_image(product_id=product_id, image=image, session=session)

    await session.commit()
    return {"message": "Product updated successfully", "product": product}


# Эндпоинт для удаления продукта и связанных изображений
@app.delete("/products/{product_id}", status_code=status.HTTP_204_NO_CONTENT)
async def delete_product(product_id: int, session: AsyncSession = Depends(get_session)):
    result = await session.execute(select(Product).where(Product.id == product_id))
    product = result.scalars().first()
    
    if not product:
        raise HTTPException(status_code=404, detail="Product not found")
    
    # Удаляем связанные изображения
    result_images = await session.execute(select(ProductImage).where(ProductImage.product_id == product_id))
    images = result_images.scalars().all()

    for image in images:
        image_path = IMAGE_DIRECTORY / image.image_url
        if image_path.exists():
            try:
                image_path.unlink()  # Удаляем файл изображения с сервера
            except PermissionError as e:
                raise HTTPException(status_code=500, detail=f"Permission denied when deleting {image.image_url}: {e}")
        else:
            raise HTTPException(status_code=404, detail=f"Image {image.image_url} not found on the server")
        
        await session.delete(image)  # Удаляем запись изображения из БД

    # Удаление самого продукта
    await session.delete(product)
    await session.commit()
    
    return {"message": "Product and associated images deleted successfully"}


# Получение изображения
@app.get("/images/{image_name}")
async def get_image(image_name: str):
    file_path = IMAGE_DIRECTORY / image_name
    if not file_path.exists():
        raise HTTPException(status_code=404, detail="Image not found")
    
    return FileResponse(file_path)



# Эндпоинт для загрузки изображения
@app.post("/upload_image")
async def upload_image(
    product_id: int,
    image: UploadFile = File(...),
    session: AsyncSession = Depends(get_session)
):
    # Проверка типа файла
    if not image.filename.endswith(('.jpg', '.jpeg', '.png', '.gif')):
        raise HTTPException(status_code=415, detail="Unsupported file type")

    # Генерация уникального имени файла
    unique_filename = f"{uuid.uuid4().hex}_{image.filename}"
    image_path = IMAGE_DIRECTORY / unique_filename

    # Сохранение файла на сервере
    try:
        with open(image_path, "wb") as buffer:
            shutil.copyfileobj(image.file, buffer)
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Error saving image: {e}")

    # Сохранение URL изображения в базе данных
    product_image = ProductImage(product_id=product_id, image_url=unique_filename)
    session.add(product_image)
    await session.commit()

    return {"message": "Image uploaded successfully", "image_url": unique_filename}

# Эндпоинт для получения изображений продукта
@app.get("/products/{product_id}/images")
async def get_product_images(product_id: int, session: AsyncSession = Depends(get_session)):
    result = await session.execute(select(ProductImage).where(ProductImage.product_id == product_id))
    images = result.scalars().all()
    return images

# Эндпоинт для обновления изображения
@app.put("/images/{image_name}")
async def update_image(image_name: str, file: UploadFile = File(...)):
    file_path = IMAGE_DIRECTORY / image_name
    if not file_path.exists():
        raise HTTPException(status_code=404, detail="Image not found")
    
    with open(file_path, "wb") as f:
        f.write(await file.read())
    
    return {"url": f"/images/{file.filename}"}


# Эндпоинт для удаления изображения
@app.delete("/images/{image_name}", status_code=status.HTTP_204_NO_CONTENT)
async def delete_image(
    image_name: str,
    session: AsyncSession = Depends(get_session)
):
    file_path = IMAGE_DIRECTORY / image_name

    # Проверка существования файла
    if file_path.exists():
        try:
            # Удаление файла изображения
            file_path.unlink()

            # Удаление записи изображения из базы данных
            await session.execute(delete(ProductImage).where(ProductImage.image_url == image_name))
            await session.commit()
        except PermissionError as e:
            raise HTTPException(status_code=500, detail=f"Permission denied when deleting {image_name}: {e}")
    else:
        raise HTTPException(status_code=404, detail="Image not found on server")

    return {"message": f"Image '{image_name}' deleted successfully"}

# Добавление пагинации к API
add_pagination(app)
