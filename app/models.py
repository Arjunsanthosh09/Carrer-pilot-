from app.extensions import db, login_manager
from flask_login import UserMixin
from datetime import datetime

@login_manager.user_loader
def load_user(user_id):
    return User.query.get(int(user_id))

class User(UserMixin, db.Model):
    __tablename__ = 'user'  

    id = db.Column(db.Integer, primary_key=True)
    email = db.Column(db.String(255), unique=True, nullable=False)
    password_hash = db.Column(db.String(255), nullable=False)
    role = db.Column(db.Enum('student', 'officer'), nullable=False, default='student')
    created_at = db.Column(db.DateTime, default=datetime.utcnow)

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
    phone = db.Column(db.String(20))
    location = db.Column(db.String(100))
    linkedin = db.Column(db.String(255))
    github = db.Column(db.String(255))
    portfolio = db.Column(db.String(255))
    soft_skills = db.Column(db.Text)
    

class Skill(db.Model):
    __tablename__ = 'skill'
    id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String(50), unique=True, nullable=False)

class StudentSkill(db.Model):
    __tablename__ = 'student_skill'
    id = db.Column(db.Integer, primary_key=True)
    student_id = db.Column(db.Integer, db.ForeignKey('student_profile.id'), nullable=False)
    skill_id = db.Column(db.Integer, db.ForeignKey('skill.id'), nullable=False)
    proficiency = db.Column(db.Integer)  # 0-100

    skill = db.relationship('Skill')

class Certification(db.Model):
    __tablename__ = 'certification'
    id = db.Column(db.Integer, primary_key=True)
    student_id = db.Column(db.Integer, db.ForeignKey('student_profile.id'), nullable=False)
    title = db.Column(db.String(200), nullable=False)
    issuer = db.Column(db.String(100))
    verification_status = db.Column(db.Enum('pending', 'verified'), default='verified')
    date_earned = db.Column(db.Date)

class Project(db.Model):
    __tablename__ = 'project'
    id = db.Column(db.Integer, primary_key=True)
    student_id = db.Column(db.Integer, db.ForeignKey('student_profile.id'), nullable=False)
    title = db.Column(db.String(200), nullable=False)
    description = db.Column(db.Text)
    technologies = db.Column(db.String(255))
    link = db.Column(db.String(255))
    year = db.Column(db.Integer)

StudentProfile.skills = db.relationship('StudentSkill', backref='profile', lazy='dynamic', cascade='all, delete-orphan')
StudentProfile.certifications = db.relationship('Certification', backref='profile', lazy='dynamic', cascade='all, delete-orphan')
StudentProfile.projects = db.relationship('Project', backref='profile', lazy='dynamic', cascade='all, delete-orphan')
    