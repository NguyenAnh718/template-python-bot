.PHONY: dev dev-build prod prod-build stop restart logs logs-app \
        shell db-shell redis-shell backup test migrate

# ─── Локальная разработка ─────────────────────────────────────────
dev:                  ## Запустить локально (hot-reload)
	docker compose -f docker-compose.dev.yml up

dev-build:            ## Пересобрать и запустить локально
	docker compose -f docker-compose.dev.yml up --build

dev-stop:             ## Остановить локальное окружение
	docker compose -f docker-compose.dev.yml down

# ─── Продакшн ─────────────────────────────────────────────────────
prod:                 ## Запустить прод (фоном)
	docker compose up -d

prod-build:           ## Пересобрать и запустить прод
	docker compose up -d --build --remove-orphans

stop:                 ## Остановить все контейнеры
	docker compose down

restart:              ## Перезапустить app-контейнер
	docker compose restart app

# ─── Логи ─────────────────────────────────────────────────────────
logs:                 ## Логи всех контейнеров
	docker compose logs -f --tail=100

logs-app:             ## Логи только app
	docker compose logs -f --tail=100 app

# ─── Шеллы ────────────────────────────────────────────────────────
shell:                ## Bash внутри app-контейнера
	docker compose exec app bash

db-shell:             ## psql внутри postgres
	docker compose exec postgres psql -U $${DB_USER} -d $${DB_NAME}

redis-shell:          ## redis-cli
	docker compose exec redis redis-cli

# ─── База данных ──────────────────────────────────────────────────
backup:               ## Бэкап БД (pg_dump)
	./scripts/backup.sh

migrate:              ## Запустить alembic миграции
	docker compose exec app alembic upgrade head

# ─── Тесты ────────────────────────────────────────────────────────
test:                 ## Запустить тесты
	docker compose -f docker-compose.dev.yml exec app pytest -v

# ─── Деплой (ручной) ─────────────────────────────────────────────
deploy:               ## Push в main → запустит GitHub Actions
	git push origin main

help:                 ## Показать все команды
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | \
	awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-15s\033[0m %s\n", $$1, $$2}'
