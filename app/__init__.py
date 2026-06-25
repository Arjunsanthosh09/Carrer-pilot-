from flask import Flask, redirect, url_for
from config import Config
from app.extensions import db, login_manager

def create_app(config_class=Config):
    app = Flask(__name__)
    app.config.from_object(config_class)

    db.init_app(app)
    login_manager.init_app(app)

    # Import models so they are registered
    from app import models

    # Register blueprints
    from app.auth.routes import auth_bp
    from app.student.routes import student_bp
    from app.officer.routes import officer_bp

    app.register_blueprint(auth_bp, url_prefix='/auth')
    app.register_blueprint(student_bp, url_prefix='/student')
    app.register_blueprint(officer_bp, url_prefix='/officer')

    @app.route('/')
    def index():
        return redirect(url_for('auth.login'))

    return app