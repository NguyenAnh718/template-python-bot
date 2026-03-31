#!/bin/bash
# Восстановление БД из бэкапа
# Использование: ./scripts/restore.sh /path/to/backup.dump
set -e

BACKUP_FILE="$1"

if [ -z "$BACKUP_FILE" ]; then
  echo "❌ Укажи файл бэкапа:"
  echo "   ./scripts/restore.sh /var/backups/myproject/db_20240101_120000.dump"
  echo ""
  echo "Доступные бэкапы:"
  ls -lt "/var/backups/$(basename "$(pwd)")"/*.dump 2>/dev/null | head -10
  exit 1
fi

if [ ! -f "$BACKUP_FILE" ]; then
  echo "❌ Файл не найден: $BACKUP_FILE"
  exit 1
fi

# Загружаем переменные
if [ -f .env ]; then
  export $(grep -v '^#' .env | grep -v '^\s*$' | xargs)
fi

echo "⚠️  ВНИМАНИЕ: это перезапишет текущую БД ${DB_NAME}!"
echo "   Бэкап: $BACKUP_FILE"
read -p "   Продолжить? (yes/no): " CONFIRM

if [ "$CONFIRM" != "yes" ]; then
  echo "Отменено."
  exit 0
fi

echo "🔄 Восстанавливаем БД..."

# Дропаем и пересоздаём БД
docker compose exec -T postgres psql -U "${DB_USER}" -c "DROP DATABASE IF EXISTS ${DB_NAME};"
docker compose exec -T postgres psql -U "${DB_USER}" -c "CREATE DATABASE ${DB_NAME};"

# Восстанавливаем
docker compose exec -T postgres pg_restore \
  -U "${DB_USER}" \
  -d "${DB_NAME}" \
  --no-owner \
  --no-privileges < "$BACKUP_FILE"

echo "✅ БД восстановлена из $BACKUP_FILE"
