# Використовуємо офіційний образ Python як базовий
FROM python:3.10-slim

# Оновлення та встановлення залежностей системи для уникнення помилок,
# пов'язаних з відсутністю деяких пакетів (залежності для PostgreSQL такі як libpq-dev)
RUN apt-get update && apt-get install -y \
    build-essential \
    libpq-dev \
    && rm -rf /var/lib/apt/lists/*

# Встановлення залежностей Python
WORKDIR /app
COPY src/Computer-Systems-hw02/requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Копіюємо файли застосунку
COPY src/Computer-Systems-hw02/ .

# Виставляємо порт, на якому працює FastAPI
EXPOSE 8000

# Команда для запуску сервера
CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000"]
