from flask import Blueprint, render_template, request, redirect, url_for, flash
from flask_login import login_user, logout_user, login_required
from app.extensions import db
from app.models import User, StudentProfile

auth_bp = Blueprint('auth', __name__)

@auth_bp.route('/login', methods=['GET', 'POST'])
def login():
    if request.method == 'POST':
        email = request.form.get('email')
        password = request.form.get('password')
        role = request.form.get('role')

        user = User.query.filter_by(email=email).first()
        if user and user.check_password(password) and user.role == role:
            login_user(user)
            if role == 'student':
                return redirect(url_for('student.dashboard'))
            else:
                return redirect(url_for('officer.dashboard'))
        flash('Invalid credentials or role mismatch.')
    return render_template('auth/login.html')

@auth_bp.route('/signup', methods=['GET', 'POST'])
def signup():
    if request.method == 'POST':
        email = request.form.get('email')
        password = request.form.get('password')
        role = request.form.get('role')
        full_name = request.form.get('full_name')
        department = request.form.get('department')
        year = request.form.get('year')

        # Check if user already exists
        if User.query.filter_by(email=email).first():
            flash('Email already registered.')
            return redirect(url_for('auth.signup'))

        # Create user
        user = User(email=email, role=role)
        user.set_password(password)
        db.session.add(user)
        db.session.commit()  # need user.id for profile

        # Create student profile (for students)
        if role == 'student':
            profile = StudentProfile(
                user_id=user.id,
                full_name=full_name,
                department=department,
                year=year
            )
            db.session.add(profile)
            db.session.commit()

        # Log them in
        login_user(user)
        if role == 'student':
            return redirect(url_for('student.dashboard'))
        else:
            return redirect(url_for('officer.dashboard'))

    return render_template('auth/signup.html')

@auth_bp.route('/logout')
@login_required
def logout():
    logout_user()
    return redirect(url_for('auth.login'))