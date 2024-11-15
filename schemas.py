from pydantic import BaseModel
from typing import Optional

class RoleBase(BaseModel):
    role_name: str

class RoleCreate(RoleBase):
    pass

class Role(RoleBase):
    id: int

    class Config:
        orm_mode = True


class UserBase(BaseModel):
    name: str
    email: str

class UserCreate(UserBase):
    password: str

class User(UserBase):
    id: int
    role: Role

    class Config:
        orm_mode = True
from pydantic import BaseModel
from typing import Optional

class ProductImageCreate(BaseModel):
    product_id: int
    image_url: str  # URL или путь к изображению

class ProductImageResponse(BaseModel):
    id: int
    product_id: int
    image_url: str

    class Config:
        orm_mode = True  # Это позволяет Pydantic работать с ORM объектами