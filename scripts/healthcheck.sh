#!/bin/bash
# Проверка состояния сервисов после деплоя
set -e

echo "🔍 Проверяем сервисы..."

# Ждём поднятия контейнеров
sleep 5

# Статус контейнеров
echo ""
echo "📦 Статус контейнеров:"
docker compose ps

# Проверяем что всё running
UNHEALTHY=$(docker compose ps --format json 2>/dev/null | \
  python3 -c "import sys,json; data=[json.loads(l) for l in sys.stdin if l.strip()]; \
  unhealthy=[s['Name'] for s in data if s.get('Health','') in ('unhealthy','') and s.get('State','') != 'running']; \
  print('\n'.join(unhealthy))" 2>/dev/null || true)

if [ -n "$UNHEALTHY" ]; then
  echo ""
  echo "❌ Нездоровые сервисы:"
  echo "$UNHEALTHY"
  echo ""
  echo "Логи:"
  docker compose logs --tail=50
  exit 1
fi

echo ""
echo "✅ Все сервисы работают"
