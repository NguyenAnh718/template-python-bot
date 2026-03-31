#!/bin/bash
# Бэкап PostgreSQL перед деплоем
set -e

BACKUP_DIR="${HOME}/backups/$(basename "$(pwd)")"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
BACKUP_FILE="${BACKUP_DIR}/db_${TIMESTAMP}.dump"

mkdir -p "$BACKUP_DIR"

echo "📦 Создаём бэкап: $BACKUP_FILE"

# Загружаем переменные из .env если запускается локально
if [ -f .env ]; then
  export $(grep -v '^#' .env | grep -v '^\s*$' | xargs)
fi

# Пропускаем бэкап если postgres не запущен (первый деплой)
if ! docker compose ps postgres 2>/dev/null | grep -q "running"; then
  echo "⏭️  PostgreSQL не запущен — бэкап пропущен (первый деплой?)"
  exit 0
fi

docker compose exec -T postgres pg_dump \
  -U "${DB_USER}" \
  -d "${DB_NAME}" \
  -Fc > "$BACKUP_FILE"

# Оставляем только последние 10 бэкапов
ls -t "${BACKUP_DIR}"/db_*.dump 2>/dev/null | tail -n +11 | xargs -r rm

echo "✅ Бэкап готов: $BACKUP_FILE"
echo "   Размер: $(du -sh "$BACKUP_FILE" | cut -f1)"
