from sqlalchemy import Column, Integer, String, ForeignKey, DECIMAL
from sqlalchemy.orm import relationship
from database import Base



# Модель Role
class Role(Base):
    __tablename__ = 'roles'
    __table_args__ = {"schema": "svk"}  # Указываем схему для единообразия

    id = Column(Integer, primary_key=True, index=True)
    role_name = Column(String(50), unique=True, nullable=False)
    users = relationship("User", back_populates="role")

# Модель User
class User(Base):
    __tablename__ = 'users'
    __table_args__ = {"schema": "svk"}

    id = Column(Integer, primary_key=True, index=True)
    name = Column(String(100), nullable=False)
    email = Column(String(100), unique=True, nullable=False)
    password_hash = Column(String(255), nullable=False)
    role_id = Column(Integer, ForeignKey("svk.roles.id"))  # Обратите внимание на схему
    role = relationship("Role", back_populates="users")

# Модель Category
class Category(Base):
    __tablename__ = "categories"
    __table_args__ = {"schema": "svk"}

    id = Column(Integer, primary_key=True, index=True)
    name = Column(String(100), unique=True, nullable=False)
    parent_id = Column(Integer, ForeignKey('svk.categories.id', ondelete='CASCADE'), nullable=True)

# Модель Product
class Product(Base):
    __tablename__ = "products"
    __table_args__ = {"schema": "svk"}

    id = Column(Integer, primary_key=True, index=True)
    name = Column(String(100), nullable=False)
    description = Column(String)
    price = Column(DECIMAL(10, 2), nullable=False)
    sale_price = Column(DECIMAL(10, 2), nullable=True)
    category_id = Column(Integer, ForeignKey("svk.categories.id", ondelete="SET NULL"), nullable=True)
    sku = Column(String(50), unique=True, nullable=True)
    production_time = Column(Integer, nullable=True)
    height = Column(DECIMAL(10, 2), nullable=True)
    width = Column(DECIMAL(10, 2), nullable=True)
    length = Column(DECIMAL(10, 2), nullable=True)
    weight = Column(DECIMAL(10, 2), nullable=True)
    additional_details = Column(String, nullable=True)

    # Связь с таблицей изображений
    images = relationship("ProductImage", back_populates="product")

# Модель ProductImage
class ProductImage(Base):
    __tablename__ = 'product_images'
    __table_args__ = {"schema": "svk"}

    id = Column(Integer, primary_key=True, index=True)
    product_id = Column(Integer, ForeignKey("svk.products.id", ondelete="CASCADE"))  # Указываем схему для внешнего ключа
    image_url = Column(String, index=True)

    product = relationship("Product", back_populates="images")

