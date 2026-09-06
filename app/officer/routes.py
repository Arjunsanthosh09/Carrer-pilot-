from flask import Blueprint, render_template, request, redirect, url_for, flash
from flask_login import login_required, current_user
from app.models import Company, PlacementDrive, StudentProfile, User, StudentSkill
from app.extensions import db
from app.services.readiness import compute_readiness_score

import os
from datetime import datetime, timedelta
from werkzeug.utils import secure_filename

officer_bp = Blueprint('officer', __name__)


# ===========================
# DASHBOARD
# ===========================

@officer_bp.route('/dashboard')
@login_required
def dashboard():
    # Get officer details
    officer = current_user.officer_profile
    
    # Total Companies
    total_companies = Company.query.count()
    
    # Total Drives
    total_drives = PlacementDrive.query.count()
    
    # Active Drives
    active_drives = PlacementDrive.query.filter_by(status="open").count()
    
    # Closed Drives (Placements Confirmed)
    placements_confirmed = PlacementDrive.query.filter_by(status="closed").count()
    
    # Total Students
    total_students = User.query.filter_by(role='student').count()
    
    # Calculate average readiness
    students = User.query.filter_by(role='student').all()
    readiness_scores = []
    for student in students:
        score = compute_readiness_score(student.id)
        if score:
            readiness_scores.append(score.get('overall', 0))
    
    avg_readiness = round(sum(readiness_scores) / len(readiness_scores)) if readiness_scores else 0
    
    # Students needing attention (readiness < 45%)
    students_need_attention = sum(1 for s in readiness_scores if s < 45)
    
    # Recent Drives
    recent_drives = PlacementDrive.query.order_by(
        PlacementDrive.drive_date.desc()
    ).limit(5).all()
    
    # Drives closing this week (within 7 days)
    next_week = datetime.now().date() + timedelta(days=7)
    closing_this_week = PlacementDrive.query.filter(
        PlacementDrive.status == 'open',
        PlacementDrive.drive_date <= next_week
    ).count()
    
    return render_template(
        "officer/dashboard.html",
        officer=officer,
        total_companies=total_companies,
        total_drives=total_drives,
        active_drives=active_drives,
        placements_confirmed=placements_confirmed,
        total_students=total_students,
        avg_readiness=avg_readiness,
        students_need_attention=students_need_attention,
        recent_drives=recent_drives,
        closing_this_week=closing_this_week
    )


# ===========================
# COMPANY LIST
# ===========================

@officer_bp.route('/companies')
@login_required
def companies():
    search = request.args.get('search')
    
    if search:
        companies = Company.query.filter(
            Company.company_name.ilike(f'%{search}%')
        ).all()
    else:
        companies = Company.query.all()
    
    # Check whether each company has an OPEN drive
    for company in companies:
        open_drive = PlacementDrive.query.filter_by(
            company_id=company.id,
            status="open"
        ).first()
        company.active_drive = True if open_drive else False
    
    return render_template(
        "officer/companies.html",
        companies=companies
    )


# ===========================
# ADD COMPANY
# ===========================

@officer_bp.route('/companies/add', methods=['GET', 'POST'])
@login_required
def add_company():
    if request.method == 'POST':
        company = Company()
        company.company_name = request.form['company_name']
        company.industry = request.form['industry']
        company.website = request.form['website']
        company.headquarters = request.form['headquarters']
        company.description = request.form['description']
        
        logo = request.files.get('logo')
        if logo and logo.filename != '':
            # Ensure upload directory exists
            upload_dir = os.path.join('app', 'static', 'uploads')
            if not os.path.exists(upload_dir):
                os.makedirs(upload_dir)
            
            filename = secure_filename(logo.filename)
            logo.save(os.path.join(upload_dir, filename))
            company.logo = filename
        
        db.session.add(company)
        db.session.commit()
        flash('Company added successfully!', 'success')
        return redirect(url_for('officer.companies'))
    
    return render_template('officer/add_company.html')


# ===========================
# EDIT COMPANY
# ===========================

@officer_bp.route('/companies/edit/<int:id>', methods=['GET', 'POST'])
@login_required
def edit_company(id):
    company = Company.query.get_or_404(id)
    
    if request.method == 'POST':
        company.company_name = request.form['company_name']
        company.industry = request.form['industry']
        company.website = request.form['website']
        company.headquarters = request.form['headquarters']
        company.description = request.form['description']
        
        logo = request.files.get('logo')
        if logo and logo.filename != '':
            upload_dir = os.path.join('app', 'static', 'uploads')
            if not os.path.exists(upload_dir):
                os.makedirs(upload_dir)
            
            filename = secure_filename(logo.filename)
            logo.save(os.path.join(upload_dir, filename))
            company.logo = filename
        
        db.session.commit()
        flash('Company updated successfully!', 'success')
        return redirect(url_for('officer.companies'))
    
    return render_template('officer/edit_company.html', company=company)


# ===========================
# DELETE COMPANY
# ===========================

@officer_bp.route('/companies/delete/<int:id>')
@login_required
def delete_company(id):
    company = Company.query.get_or_404(id)
    
    # Check if company has drives
    drives = PlacementDrive.query.filter_by(company_id=id).count()
    if drives > 0:
        flash('Cannot delete company with existing placement drives.', 'danger')
        return redirect(url_for('officer.companies'))
    
    db.session.delete(company)
    db.session.commit()
    flash('Company deleted successfully!', 'success')
    return redirect(url_for('officer.companies'))


# ===========================
# COMPANY DETAILS
# ===========================

@officer_bp.route('/companies/<int:id>')
@login_required
def company_details(id):
    company = Company.query.get_or_404(id)
    drives = PlacementDrive.query.filter_by(company_id=id).all()
    return render_template('officer/company_details.html', company=company, drives=drives)


# ===========================
# DRIVE DETAILS
# ===========================

@officer_bp.route('/drives/<int:id>')
@login_required
def drive_details(id):
    drive = PlacementDrive.query.get_or_404(id)
    return render_template('officer/drive_details.html', drive=drive)


# ===========================
# PLACEMENT DRIVE LIST
# ===========================

@officer_bp.route('/drives')
@login_required
def drives():
    drives = PlacementDrive.query.order_by(
        PlacementDrive.drive_date.desc()
    ).all()
    return render_template('officer/drives.html', drives=drives)


# ===========================
# ADD PLACEMENT DRIVE
# ===========================

@officer_bp.route('/drives/add', methods=['GET', 'POST'])
@login_required
def add_drive():
    companies = Company.query.all()
    
    if not companies:
        flash('Please add a company first before creating a drive.', 'warning')
        return redirect(url_for('officer.companies'))
    
    if request.method == 'POST':
        drive = PlacementDrive()
        drive.company_id = request.form['company_id']
        drive.role = request.form['role']
        drive.drive_date = datetime.strptime(request.form['drive_date'], "%Y-%m-%d")
        drive.status = request.form['status']
        drive.min_cgpa = request.form['min_cgpa'] if request.form['min_cgpa'] else None
        drive.created_by = current_user.id
        
        db.session.add(drive)
        db.session.commit()
        flash('Placement drive created successfully!', 'success')
        return redirect(url_for('officer.drives'))
    
    return render_template('officer/add_drive.html', companies=companies)


# ===========================
# EDIT PLACEMENT DRIVE
# ===========================

@officer_bp.route('/drives/edit/<int:id>', methods=['GET', 'POST'])
@login_required
def edit_drive(id):
    drive = PlacementDrive.query.get_or_404(id)
    companies = Company.query.all()
    
    if request.method == 'POST':
        drive.company_id = request.form['company_id']
        drive.role = request.form['role']
        drive.drive_date = datetime.strptime(request.form['drive_date'], "%Y-%m-%d")
        drive.status = request.form['status']
        drive.min_cgpa = request.form['min_cgpa'] if request.form['min_cgpa'] else None
        
        db.session.commit()
        flash('Placement drive updated successfully!', 'success')
        return redirect(url_for('officer.drives'))
    
    return render_template('officer/edit_drive.html', drive=drive, companies=companies)


# ===========================
# DELETE PLACEMENT DRIVE
# ===========================

@officer_bp.route('/drives/delete/<int:id>')
@login_required
def delete_drive(id):
    drive = PlacementDrive.query.get_or_404(id)
    db.session.delete(drive)
    db.session.commit()
    flash('Placement drive deleted successfully!', 'success')
    return redirect(url_for('officer.drives'))


# ===========================
# STUDENT LIST (For Officer)
# ===========================

@officer_bp.route('/students')
@login_required
def students():
    search = request.args.get('search')
    department = request.args.get('department')
    
    query = User.query.filter_by(role='student')
    
    if search:
        query = query.join(StudentProfile).filter(
            StudentProfile.full_name.ilike(f'%{search}%')
        )
    
    students = query.all()
    
    # Add readiness score to each student
    student_data = []
    for student in students:
        profile = student.profile
        if profile:
            readiness = compute_readiness_score(student.id)
            student_data.append({
                'id': student.id,
                'name': profile.full_name or student.email,
                'department': profile.department or 'N/A',
                'year': profile.year or 'N/A',
                'cgpa': float(profile.cgpa) if profile.cgpa else 0,
                'readiness': readiness.get('overall', 0) if readiness else 0,
                'email': student.email
            })
    
    return render_template('officer/students.html', students=student_data)


# ===========================
# STUDENT PROFILE (Officer View)
# ===========================

@officer_bp.route('/students/<int:id>')
@login_required
def student_details(id):
    student = User.query.get_or_404(id)
    if student.role != 'student':
        flash('User is not a student.', 'danger')
        return redirect(url_for('officer.students'))
    
    profile = student.profile
    skills = profile.skills.all() if profile else []
    certs = profile.certifications.all() if profile else []
    projects = profile.projects.all() if profile else []
    
    readiness = compute_readiness_score(student.id)
    
    return render_template('officer/student_details.html',
                         student=student,
                         profile=profile,
                         skills=skills,
                         certs=certs,
                         projects=projects,
                         readiness=readiness)