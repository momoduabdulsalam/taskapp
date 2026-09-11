from flask import Flask
from flask_sqlalchemy import SQLAlchemy
from flask_cors import CORS
import os

db = SQLAlchemy()


def create_app():
    app = Flask(__name__)

    app.config['SQLALCHEMY_DATABASE_URI'] = os.getenv(
        'DATABASE_URL',
        'postgresql://taskuser:taskpassword@localhost:5432/taskmanager'
    )
    app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False
    app.config['SECRET_KEY'] = os.getenv(
        'SECRET_KEY',
        'dev-secret-key-change-in-production'
    )

    db.init_app(app)
    CORS(app)

    from app.routes import api_bp
    app.register_blueprint(api_bp, url_prefix='/api')

    return app
