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

    logger.info(f"{settings.app_name} started")


if __name__ == "__main__":
    asyncio.run(main())
