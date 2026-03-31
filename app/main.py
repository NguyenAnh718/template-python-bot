import logging
import asyncio

from app.config import settings

logging.basicConfig(
    level=logging.DEBUG if settings.debug else logging.INFO,
    format="%(asctime)s [%(levelname)s] %(name)s: %(message)s",
)
logger = logging.getLogger(__name__)


async def main():
    logger.info(f"Starting {settings.app_name}...")

    # TODO: инициализировать бота / FastAPI app / etc.
    # Примеры:
    #   bot = Bot(token=settings.tg_bot_token)
    #   dp = Dispatcher()
    #   await dp.start_polling(bot)
    #
    #   app = FastAPI()
    #   uvicorn.run(app, host="0.0.0.0", port=8000)

    logger.info(f"{settings.app_name} started. Waiting for work...")

    # Держим процесс живым пока не реализован реальный бот/API
    while True:
        await asyncio.sleep(3600)


if __name__ == "__main__":
    try:
        asyncio.run(main())
    except KeyboardInterrupt:
        logger.info("Shutting down...")
