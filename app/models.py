from app.extensions import db, login_manager
from flask_login import UserMixin
from datetime import datetime

@login_manager.user_loader
def load_user(user_id):
    return User.query.get(int(user_id))

class User(UserMixin, db.Model):
    __tablename__ = 'user'  # matches your table name

    id = db.Column(db.Integer, primary_key=True)
    email = db.Column(db.String(255), unique=True, nullable=False)
    password_hash = db.Column(db.String(255), nullable=False)
    role = db.Column(db.Enum('student', 'officer'), nullable=False, default='student')
    created_at = db.Column(db.DateTime, default=datetime.utcnow)

    # Relationship to profile (one-to-one)
    profile = db.relationship('StudentProfile', backref='user', uselist=False)

    def set_password(self, password):
        from werkzeug.security import generate_password_hash
        self.password_hash = generate_password_hash(password)

    def check_password(self, password):
        from werkzeug.security import check_password_hash
        return check_password_hash(self.password_hash, password)

class StudentProfile(db.Model):
    __tablename__ = 'student_profile'

    id = db.Column(db.Integer, primary_key=True)
    user_id = db.Column(db.Integer, db.ForeignKey('user.id'), unique=True, nullable=False)
    full_name = db.Column(db.String(100))
    department = db.Column(db.String(50))
    year = db.Column(db.String(20))
    roll_number = db.Column(db.String(20))
    cgpa = db.Column(db.Numeric(3,2))
    about_me = db.Column(db.Text)