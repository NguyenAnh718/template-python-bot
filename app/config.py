from pydantic_settings import BaseSettings, SettingsConfigDict


class Settings(BaseSettings):
    model_config = SettingsConfigDict(env_file=".env", env_file_encoding="utf-8")

    # App
    app_name: str = "myproject"
    debug: bool = False
    secret_key: str

    # Database
    db_host: str = "postgres"
    db_port: int = 5432
    db_name: str
    db_user: str
    db_password: str

    @property
    def database_url(self) -> str:
        return f"postgresql+asyncpg://{self.db_user}:{self.db_password}@{self.db_host}:{self.db_port}/{self.db_name}"

    # Redis
    redis_host: str = "redis"
    redis_port: int = 6379
    redis_password: str = ""

    @property
    def redis_url(self) -> str:
        if self.redis_password:
            return f"redis://:{self.redis_password}@{self.redis_host}:{self.redis_port}/0"
        return f"redis://{self.redis_host}:{self.redis_port}/0"

    # Telegram
    tg_bot_token: str = ""
    tg_admin_chat_id: str = ""

    # Webhook
    webhook_enabled: bool = False
    webhook_host: str = ""
    webhook_path: str = "/webhook"


settings = Settings()
