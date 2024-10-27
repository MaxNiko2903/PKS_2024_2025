<p align="center">
  <img src="https://www.mirea.ru/upload/medialibrary/c1a/MIREA_Gerb_Colour.jpg" alt="MIREA" width="80"/>
  <img src="https://www.mirea.ru/upload/medialibrary/26c/FTI_colour.jpg" alt="IPTIP" width="137"/> 
</p>

# Отчёт по практике №1

## Программирование корпоративных систем

### Студент - **Николаев Максим Дмитриевич**

### Группа - **ЭФБО-07-22**

### Шифр - **22Т0111**

### Преподаватель - **Адышкин Сергей Сергеевич**

### Семестр - 5 семестр, 2024-2025 гг.

---
Я сделал не совсем то. Я реализовал вход и регстрацию через API с добавлением в базу данных. Также есть небольшой адаптив под телефоны.



# Проект: Система Входа и Регистрации через API

## Описание
Данный проект реализует систему входа и регистрации через API с добавлением пользователей в базу данных. Также предусмотрена адаптивная версия для мобильных устройств.

## Главная страница
- **Компьютер**  
  ![Главная страница (Компьютер)](https://github.com/user-attachments/assets/fbc8e274-89d3-4115-b33e-2ef8eb1c1222)

- **Телефон**  
  ![Главная страница (Телефон)](https://github.com/user-attachments/assets/0e00cac7-7be6-4f77-ab05-0fd47607e61e)

## Мобильная версия
В мобильной версии реализовано меню как справа, так и снизу.  
![Мобильное меню](https://github.com/user-attachments/assets/a1570d5a-b29c-460b-9fbe-01c3049a0216)

## Страницы приложения
- **Страница авторизации**  
  ![Страница авторизации](https://github.com/user-attachments/assets/ee6ad9a5-2ea8-498d-b2df-f68d2b3c24f5)

- **Неверно введённые данные**  
  ![Ошибка ввода](https://github.com/user-attachments/assets/824bc93a-57d6-45e4-b670-6042517c2ebf)

- **Регистрация**  
  ![Регистрация](https://github.com/user-attachments/assets/537e4ac8-9d11-4e68-8f71-b7ce5e44517b)

## Профили пользователей
- **Профиль администратора**  
  ![Профиль администратора](https://github.com/user-attachments/assets/e4cf9156-aea8-44b8-83f2-38346a75aa54)

- **Админ панель (часть 1)**  
  ![Админ панель часть 1](https://github.com/user-attachments/assets/4aa4e964-2fef-4506-9c4d-744ade89fa87)

- **Админ панель (часть 2)**  
  ![Админ панель часть 2](https://github.com/user-attachments/assets/414d7963-8afc-4351-808d-824c6702acf0)

- **Профиль обычного пользователя**  
  ![Профиль пользователя](https://github.com/user-attachments/assets/fea5378a-acf7-481e-9202-d7ea37acf3ab)

## Архитектура базы данных
![Архитектура БД](https://github.com/user-attachments/assets/fd3ccfe6-cd56-4a22-8d70-ab2c219773e1)

### Таблицы базы данных
![Таблица пользователи](https://github.com/user-attachments/assets/65d8f6f9-d883-48e9-9d5f-7c99b86349d6)
![Таблица роли](https://github.com/user-attachments/assets/911fa870-c8d2-47b5-98bf-20f9cba4537e)

## API сервер
Сервер выполнен на **FAST API**. Пароли шифруются с помощью **JWT**. Выход из аккаунта возможен только после нажатия кнопки "Выход".

### Примеры SQL для создания таблиц
```sql
-- Создание таблицы для ролей
CREATE TABLE svk.roles (
    id SERIAL PRIMARY KEY,
    role_name VARCHAR(50) NOT NULL UNIQUE
);

-- Создание таблицы для пользователей
CREATE TABLE svk.users (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    role_id INTEGER REFERENCES svk.roles(id) ON DELETE SET NULL
);

-- Создание таблицы для разделов каталога
CREATE TABLE svk.categories (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL UNIQUE,
    parent_id INTEGER REFERENCES svk.categories(id) ON DELETE CASCADE
);

-- Создание таблицы для товаров
CREATE TABLE svk.products (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    description TEXT,
    price DECIMAL(10, 2) NOT NULL,
    sale_price DECIMAL(10, 2),
    category_id INTEGER REFERENCES svk.categories(id) ON DELETE SET NULL,
    sku VARCHAR(50) UNIQUE,
    production_time INTEGER,  -- Срок изготовления в днях
    height DECIMAL(10, 2),    -- Высота
    width DECIMAL(10, 2),     -- Ширина
    length DECIMAL(10, 2),    -- Длина
    weight DECIMAL(10, 2),     -- Вес
    additional_details TEXT     -- Дополнительные детали
);

-- Создание таблицы для фотографий товаров
CREATE TABLE svk.product_images (
    id SERIAL PRIMARY KEY,
    product_id INTEGER REFERENCES svk.products(id) ON DELETE CASCADE,
    image_url VARCHAR(255) NOT NULL
);

-- Создание таблицы для заказов
CREATE TABLE svk.orders (
    id SERIAL PRIMARY KEY,
    user_id INTEGER REFERENCES svk.users(id) ON DELETE CASCADE,
    status VARCHAR(50),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    total_price DECIMAL(10, 2) NOT NULL,  -- Итоговая стоимость
    address VARCHAR(255),                   -- Адрес доставки
    comments TEXT,                          -- Комментарии
    contact_phone VARCHAR(20),              -- Телефон для связи
    contact_method VARCHAR(50)               -- Способ связи
);

-- Создание таблицы для элементов заказа
CREATE TABLE svk.order_items (
    id SERIAL PRIMARY KEY,
    order_id INTEGER REFERENCES svk.orders(id) ON DELETE CASCADE,
    product_id INTEGER REFERENCES svk.products(id) ON DELETE CASCADE,
    quantity INTEGER NOT NULL               -- Количество заказанного товара
);

-- Создание таблицы для промокодов
CREATE TABLE svk.promocodes (
    id SERIAL PRIMARY KEY,
    code VARCHAR(50) NOT NULL UNIQUE,
    discount DECIMAL(5, 2) NOT NULL,
    expiration_date DATE
);

-- Создание таблицы для баннеров
CREATE TABLE svk.banners (
    id SERIAL PRIMARY KEY,
    image_url VARCHAR(255) NOT NULL,
    link VARCHAR(255),
    is_active BOOLEAN DEFAULT TRUE
);
```
## Основные функции

### Модератор
Модератор может:
1. Создавать, редактировать и удалять разделы каталога (при разрешении администратора).
2. Управлять карточками товаров.
3. Просматривать и изменять статусы заказов.
4. Создавать и редактировать промокоды.
5. Управлять баннерами на главной странице.
6. Просматривать и изменять все данные, включая роли пользователей (при разрешении администратора).
7. Назначать функционал доступный модераторам отдельно каждому (при разрешении администратора).

### Администратор
Администратор имеет все права модератора, а также может:
1. Генерировать отчеты по продажам, активности пользователей и использованию промокодов.

### Карточка товара
- **Фото** (несколько штук) (в виде ссылок)
- **Название**
- **Описание**
- **Стоимость**
- **Стоимость по акции**
- **Раздел** (может быть в нескольких: основной, акции)
- **Артикул**
- **Срок изготовления** (в днях)
- **Размеры**
- **Вес**
- **Дополнительные детали**

## Планируемые API

### API для управления пользователями и ролями:
- **Пользователи:**
```http
POST /api/users/register   # Регистрация нового пользователя
POST /api/users/login      # Авторизация пользователя
GET /api/users/{id}       # Получение информации о пользователе
PUT /api/users/{id}       # Редактирование пользователя
DELETE /api/users/{id}    # Удаление пользователя
```
- **Управление товарами:**
```http
GET /api/products          # Получение всех товаров
POST /api/products         # Создание нового товара
PUT /api/products/{id}     # Редактирование товара
DELETE /api/products/{id}   # Удаление товара
GET /api/products/{id}   # Для получения информации о товаре.
POST /api/products/{id}/images   # Для добавления изображений к товару.
DELETE /api/products/{product_id}/images/{image_id}   # Для удаления изображения товара.
```
- **API для управления ролями и правами:**
```http
POST /api/roles        # Для создания новой роли.
PUT /api/roles/{id}         # Для редактирования существующей роли.
DELETE /api/roles/{id}     # Для удаления роли.
POST /api/roles/{role_id}/permissions   # Для назначения прав роли.
PUT /api/users/{id}/role   # Для изменения роли пользователя.
```
- **API для управления категориями:**
```http
GET /api/categories        # Для получения списка всех категорий.
POST /api/categories         # Для создания новой категории.
PUT /api/categories/{id}     # Для редактирования категории.
DELETE /api/categories/{id}   # Для удаления категории.
```
- **API для управления заказами:**
```http
POST /api/orders        # Для создания нового заказа.
GET /api/orders         # Для получения списка всех заказов.
GET /api/orders/{id}     # Для изменения статуса заказа.
DELETE /api/orders/{id}   # Для удаления категории.Для удаления заказа.
```
- **API для управления промокодами:**
```http
POST /api/promocodes        # Для создания нового промокода.
GET /api/promocodes         # Для получения списка промокодов.
PUT /api/promocodes/{id}     # Для редактирования существующего промокода.
DELETE /api/promocodes/{id}   # Для удаления промокода.
```
- **API для управления баннерами:**
```http
POST /api/banners        # Для добавления нового баннера.
GET /api/banners         # Для получения списка всех баннеров.
PUT /api/banners/{id}     # Для редактирования существующего баннера.
DELETE /api/banners/{id}   # Для удаления баннера.
```
- **API для статистики и отчетов:**
```http
GET /api/reports        # Для получения всех отчетов.
POST /api/reports/generate         # Для генерации нового отчета.
GET /api/reports/{id}     # Для получения конкретного отчета по ID.
DELETE /api/reports/{id}   # Для удаления конкретного отчета по ID.
```
