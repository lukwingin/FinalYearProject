from datetime import timedelta


SECRET_KEY = "test_key"

# MySQL
MYSQL_USERNAME = "root"
MYSQL_PASSWORD = "cityuwiluk6"
MYSQL_HOST = "127.0.0.1"
MYSQL_PORT = 3306
MYSQL_DBNAME = "attendance"

# Sqlalchemy
SQLALCHEMY_ECHO = False
SQLALCHEMY_POOL_RECYCLE = 8
SQLALCHEMY_TRACK_MODIFICATIONS = True
SQLALCHEMY_DATABASE_URI = f"mysql+pymysql://{MYSQL_USERNAME}:{MYSQL_PASSWORD}@{MYSQL_HOST}:{MYSQL_PORT}/{MYSQL_DBNAME}"

PERMANENT_SESSION_LIFETIME = timedelta(minutes=15)
