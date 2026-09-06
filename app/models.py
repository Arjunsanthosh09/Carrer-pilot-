from app.extensions import db, login_manager
from flask_login import UserMixin
from datetime import datetime


@login_manager.user_loader
def load_user(user_id):
    return User.query.get(int(user_id))


# ===========================
# USER & AUTHENTICATION
# ===========================

class User(UserMixin, db.Model):
    __tablename__ = 'user'

    id = db.Column(db.Integer, primary_key=True)
    email = db.Column(db.String(255), unique=True, nullable=False)
    password_hash = db.Column(db.String(255), nullable=False)
    role = db.Column(db.Enum('student', 'officer'), nullable=False, default='student')
    created_at = db.Column(db.DateTime, default=datetime.utcnow)

    # Relationships
    profile = db.relationship('StudentProfile', backref='user', uselist=False)
    officer_profile = db.relationship('PlacementOfficer', backref='user', uselist=False)
    interviews = db.relationship('InterviewSession', backref='student', lazy='dynamic')
    created_drives = db.relationship('PlacementDrive', backref='officer', lazy='dynamic')

    def set_password(self, password):
        from werkzeug.security import generate_password_hash
        self.password_hash = generate_password_hash(password)

    def check_password(self, password):
        from werkzeug.security import check_password_hash
        return check_password_hash(self.password_hash, password)


# ===========================
# STUDENT PROFILE
# ===========================

class StudentProfile(db.Model):
    __tablename__ = 'student_profile'

    id = db.Column(db.Integer, primary_key=True)
    user_id = db.Column(db.Integer, db.ForeignKey('user.id'), unique=True, nullable=False)
    full_name = db.Column(db.String(100))
    department = db.Column(db.String(50))
    year = db.Column(db.String(20))
    roll_number = db.Column(db.String(20))
    cgpa = db.Column(db.Numeric(3, 2))
    about_me = db.Column(db.Text)
    phone = db.Column(db.String(20))
    location = db.Column(db.String(100))
    linkedin = db.Column(db.String(255))
    github = db.Column(db.String(255))
    portfolio = db.Column(db.String(255))
    soft_skills = db.Column(db.Text)

    # Relationships (defined after models)
    skills = db.relationship('StudentSkill', backref='profile', lazy='dynamic', cascade='all, delete-orphan')
    certifications = db.relationship('Certification', backref='profile', lazy='dynamic', cascade='all, delete-orphan')
    projects = db.relationship('Project', backref='profile', lazy='dynamic', cascade='all, delete-orphan')


# ===========================
# SKILLS
# ===========================

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


# ===========================
# CERTIFICATIONS
# ===========================

class Certification(db.Model):
    __tablename__ = 'certification'

    id = db.Column(db.Integer, primary_key=True)
    student_id = db.Column(db.Integer, db.ForeignKey('student_profile.id'), nullable=False)
    title = db.Column(db.String(200), nullable=False)
    issuer = db.Column(db.String(100))
    verification_status = db.Column(db.Enum('pending', 'verified'), default='verified')
    date_earned = db.Column(db.Date)


# ===========================
# PROJECTS
# ===========================

class Project(db.Model):
    __tablename__ = 'project'

    id = db.Column(db.Integer, primary_key=True)
    student_id = db.Column(db.Integer, db.ForeignKey('student_profile.id'), nullable=False)
    title = db.Column(db.String(200), nullable=False)
    description = db.Column(db.Text)
    technologies = db.Column(db.String(255))
    link = db.Column(db.String(255))
    year = db.Column(db.Integer)


# ===========================
# PLACEMENT OFFICER
# ===========================

class PlacementOfficer(db.Model):
    __tablename__ = 'placement_officer'

    user_id = db.Column(db.Integer, db.ForeignKey('user.id'), primary_key=True)
    full_name = db.Column(db.String(100), nullable=False)
    designation = db.Column(db.String(100), default='Placement Officer')
    phone = db.Column(db.String(20))
    profile_photo = db.Column(db.String(255))


# ===========================
# COMPANY
# ===========================

class Company(db.Model):
    __tablename__ = 'company'

    id = db.Column(db.Integer, primary_key=True)
    company_name = db.Column(db.String(100), unique=True, nullable=False)
    website = db.Column(db.String(255))
    industry = db.Column(db.String(100))
    headquarters = db.Column(db.String(100))
    description = db.Column(db.Text)
    logo = db.Column(db.String(255))
    created_at = db.Column(db.DateTime, default=datetime.utcnow)

    # Relationships
    drives = db.relationship('PlacementDrive', backref='company', lazy='dynamic')


# ===========================
# PLACEMENT DRIVE
# ===========================

class PlacementDrive(db.Model):
    __tablename__ = 'placement_drive'

    id = db.Column(db.Integer, primary_key=True)
    company_id = db.Column(db.Integer, db.ForeignKey('company.id'), nullable=False)
    role = db.Column(db.String(100), nullable=False)
    drive_date = db.Column(db.Date)
    status = db.Column(db.Enum('open', 'closed'), default='open')
    min_cgpa = db.Column(db.Numeric(3, 2))
    created_by = db.Column(db.Integer, db.ForeignKey('user.id'), nullable=False)

    # Relationships
    applications = db.relationship('Application', backref='drive', lazy='dynamic')


# ===========================
# APPLICATION (Student applies to Drive)
# ===========================

class Application(db.Model):
    __tablename__ = 'application'

    id = db.Column(db.Integer, primary_key=True)
    student_id = db.Column(db.Integer, db.ForeignKey('user.id'), nullable=False)
    drive_id = db.Column(db.Integer, db.ForeignKey('placement_drive.id'), nullable=False)
    applied_at = db.Column(db.DateTime, default=datetime.utcnow)
    status = db.Column(db.Enum('applied', 'shortlisted', 'rejected', 'selected'), default='applied')


# ===========================
# INTERVIEW SESSION (Mock Interview)
# ===========================

class InterviewSession(db.Model):
    __tablename__ = 'interview_session'

    id = db.Column(db.Integer, primary_key=True)
    student_id = db.Column(db.Integer, db.ForeignKey('user.id'), nullable=False)
    type = db.Column(db.Enum('technical', 'hr', 'aptitude'), nullable=False)
    date = db.Column(db.DateTime, default=datetime.utcnow)
    overall_score = db.Column(db.Numeric(3, 1))
    total_questions = db.Column(db.Integer, default=0)
    questions = db.Column(db.JSON)  # [{question_id, question, answer, score, feedback}]
    status = db.Column(db.Enum('pending', 'in_progress', 'completed', 'cancelled'), default='pending')
    feedback_json = db.Column(db.JSON)  # Backup/legacy


# ===========================
# INTERVIEW QUESTION BANK
# ===========================

class InterviewQuestion(db.Model):
    __tablename__ = 'interview_question_bank'

    id = db.Column(db.Integer, primary_key=True)
    category = db.Column(db.Enum('technical', 'hr', 'aptitude'), nullable=False)
    sub_category = db.Column(db.String(50))
    question = db.Column(db.Text, nullable=False)
    sample_answer = db.Column(db.Text)
    difficulty = db.Column(db.Enum('easy', 'medium', 'hard'), default='medium')
    expected_duration = db.Column(db.Integer, default=60)


# ===========================
# ROLE REQUIREMENT (Skill Gap Analysis)
# ===========================

class RoleRequirement(db.Model):
    __tablename__ = 'role_requirement'

    id = db.Column(db.Integer, primary_key=True)
    role_name = db.Column(db.String(100), nullable=False)
    skill_name = db.Column(db.String(50), nullable=False)
    required_proficiency = db.Column(db.Integer, default=70)
    category = db.Column(db.String(50), default='Technical')

    __table_args__ = (db.UniqueConstraint('role_name', 'skill_name', name='unique_role_skill'),)


# ===========================
# RESUME FEEDBACK (Cache for AI)
# ===========================

class ResumeFeedback(db.Model):
    __tablename__ = 'resume_feedback'

    id = db.Column(db.Integer, primary_key=True)
    student_id = db.Column(db.Integer, db.ForeignKey('user.id'), nullable=False)
    generated_at = db.Column(db.DateTime, default=datetime.utcnow)
    suggestions = db.Column(db.JSON)


# ===========================
# ADD ANY ADDITIONAL RELATIONSHIPS BELOW
# ===========================

# User -> applications
User.applications = db.relationship('Application', backref='applicant', lazy='dynamic')

# PlacementDrive -> applications (already defined above)
# Company -> placement_drives (already defined above)