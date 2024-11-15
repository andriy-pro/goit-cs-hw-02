# Використовуємо офіційний образ Python як базовий
FROM python:3.10-slim

# Встановлення залежностей
WORKDIR /app
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Копіюємо файли застосунку
COPY . .

# Виставляємо порт, на якому працює FastAPI
EXPOSE 8000

# Команда для запуску сервера
CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000"]
