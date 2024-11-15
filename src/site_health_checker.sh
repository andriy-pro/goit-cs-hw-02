#!/bin/bash

# Визначаємо шлях до файлу зі списком сайтів
SITES=${1:-"sitest.txt"}

# Створюємо назву лог файлу з поточною датою та часом
LOG_FILE="${SITES%.*}_$(date '+%Y-%m-%d_%H-%M-%S').log"

# Функція для логування повідомлень
log() {
    local message="$1"
    local level="$2"
    local color="$3"
    local timestamp
    timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    log_message="[${timestamp}] [${level}] ${message}"
    echo -e "${color}${log_message}\033[0m"
    echo "${log_message}" >> "$LOG_FILE"
}

# Кольори для повідомлень
RED="\033[0;31m"
GREEN="\033[0;32m"
YELLOW="\033[0;33m"

# Перевіряємо чи існує файл зі списком сайтів
if [ ! -f "$SITES" ]; then
    log "Помилка: Файл $SITES не знайдено" "ERROR" "$RED"
    exit 1
fi

# Функція для перевірки доступності сайту
check_site() {
    local site="$1"
    # Використовуємо curl для перевірки доступності з опрацюванням переадресацій
    local status_code=$(curl -s -o /dev/null -w '%{http_code}' -L --connect-timeout 10 "$site")
   
    if [ "$status_code" -eq 200 ]; then
        log "$site is UP" "INFO" "$GREEN"
    else
        log "$site is DOWN (Status: $status_code)" "WARNING" "$YELLOW"
    fi
}

# Додаємо заголовок з датою перевірки
log "Перевірка сайтів виконана: $(date '+%Y-%m-%d %H:%M:%S')" "INFO" "$GREEN"
log "----------------------------------------" "INFO" "$GREEN"

# Читаємо сайти з файлу та перевіряємо кожен
while IFS= read -r site; do
    [ -z "$site" ] && continue  # Пропускаємо пусті рядки
    check_site "$site"
done < "$SITES"

log "Результати збережено у файл: $LOG_FILE" "INFO" "$GREEN"
