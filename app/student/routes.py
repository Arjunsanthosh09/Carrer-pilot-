from flask import Blueprint, render_template, request, redirect, url_for, flash, Response
from flask_login import login_required, current_user
from app.extensions import db
from app.models import StudentProfile, Skill, StudentSkill, Certification, Project
from datetime import datetime
from app.services.resume_builder import generate_resume_html
import pdfplumber
from docx import Document
import io
import json
from flask import request, jsonify, render_template, Response



# --- NEW: pdfkit (replaces weasyprint) ---
import pdfkit

student_bp = Blueprint('student', __name__)

# ========== DASHBOARD ==========
@student_bp.route('/dashboard')
@login_required
def dashboard():
    return render_template('student/dashboard.html')


# ========== PROFILE ==========
@student_bp.route('/profile', methods=['GET', 'POST'])
@login_required
def profile():
    profile = current_user.profile
    if not profile:
        flash('Profile not found. Please contact support.')
        return redirect(url_for('student.dashboard'))

    if request.method == 'POST':
        profile.full_name = request.form.get('full_name')
        profile.department = request.form.get('department')
        profile.roll_number = request.form.get('roll_number')
        profile.cgpa = request.form.get('cgpa')
        profile.phone = request.form.get('phone')
        profile.location = request.form.get('location')
        profile.linkedin = request.form.get('linkedin')
        profile.github = request.form.get('github')
        profile.portfolio = request.form.get('portfolio')
        profile.soft_skills = request.form.get('soft_skills')
        profile.about_me = request.form.get('about_me')
        db.session.commit()
        flash('Profile updated successfully.')
        return redirect(url_for('student.profile'))

    skills = StudentSkill.query.filter_by(student_id=profile.id).all()
    certs = Certification.query.filter_by(student_id=profile.id).all()
    projects = Project.query.filter_by(student_id=profile.id).all()
    all_skills = Skill.query.order_by(Skill.name).all()

    return render_template('student/profile.html',
                           profile=profile,
                           skills=skills,
                           certs=certs,
                           projects=projects,
                           all_skills=all_skills)


# ========== SKILLS ==========
@student_bp.route('/add_skill', methods=['POST'])
@login_required
def add_skill():
    skill_name = request.form.get('skill_name')
    proficiency = int(request.form.get('proficiency', 70))
    
    print("📝 Adding skill:", skill_name, "with proficiency:", proficiency)
    
    profile = current_user.profile
    if not profile:
        flash('Profile not found.')
        return redirect(url_for('student.profile'))

    skill = Skill.query.filter_by(name=skill_name).first()
    if not skill:
        skill = Skill(name=skill_name)
        db.session.add(skill)
        db.session.commit()
        print("✅ Created new skill:", skill_name)

    existing = StudentSkill.query.filter_by(student_id=profile.id, skill_id=skill.id).first()
    if existing:
        existing.proficiency = proficiency
        print("✅ Updated existing skill:", skill_name)
    else:
        ss = StudentSkill(student_id=profile.id, skill_id=skill.id, proficiency=proficiency)
        db.session.add(ss)
        print("✅ Added new student skill:", skill_name)
    
    db.session.commit()
    flash('Skill added/updated successfully!')
    return redirect(url_for('student.profile'))


@student_bp.route('/remove_skill/<int:skill_id>', methods=['POST'])
@login_required
def remove_skill(skill_id):
    profile = current_user.profile
    ss = StudentSkill.query.filter_by(student_id=profile.id, skill_id=skill_id).first()
    if ss:
        db.session.delete(ss)
        db.session.commit()
        flash('Skill removed.')
    return redirect(url_for('student.profile'))


# ========== CERTIFICATIONS ==========
@student_bp.route('/add_cert', methods=['POST'])
@login_required
def add_cert():
    title = request.form.get('title')
    issuer = request.form.get('issuer')
    date_earned = request.form.get('date_earned')
    profile = current_user.profile
    if not profile:
        flash('Profile not found.')
        return redirect(url_for('student.profile'))

    cert = Certification(
        student_id=profile.id,
        title=title,
        issuer=issuer,
        date_earned=datetime.strptime(date_earned, '%Y-%m-%d') if date_earned else None
    )
    db.session.add(cert)
    db.session.commit()
    flash('Certification added.')
    return redirect(url_for('student.profile'))


@student_bp.route('/remove_cert/<int:cert_id>', methods=['POST'])
@login_required
def remove_cert(cert_id):
    cert = Certification.query.get_or_404(cert_id)
    if cert.student_id == current_user.profile.id:
        db.session.delete(cert)
        db.session.commit()
        flash('Certification removed.')
    return redirect(url_for('student.profile'))


# ========== PROJECTS ==========
@student_bp.route('/add_project', methods=['POST'])
@login_required
def add_project():
    title = request.form.get('title')
    description = request.form.get('description')
    technologies = request.form.get('technologies')
    link = request.form.get('link')
    year = request.form.get('year')
    profile = current_user.profile
    if not profile:
        flash('Profile not found.')
        return redirect(url_for('student.profile'))

    project = Project(
        student_id=profile.id,
        title=title,
        description=description,
        technologies=technologies,
        link=link,
        year=int(year) if year else None
    )
    db.session.add(project)
    db.session.commit()
    flash('Project added.')
    return redirect(url_for('student.profile'))


@student_bp.route('/remove_project/<int:project_id>', methods=['POST'])
@login_required
def remove_project(project_id):
    project = Project.query.get_or_404(project_id)
    if project.student_id == current_user.profile.id:
        db.session.delete(project)
        db.session.commit()
        flash('Project removed.')
    return redirect(url_for('student.profile'))


# ========== RESUME BUILDER ==========
@student_bp.route('/resume')
@login_required
def resume():
    html = generate_resume_html(current_user.id)
    return render_template('student/resume.html', resume_html=html)


@student_bp.route('/resume/export')
@login_required
def resume_export():
    html = generate_resume_html(current_user.id)

    # Path to wkhtmltopdf – adjust if you installed elsewhere
    # Common path: C:\Program Files\wkhtmltopdf\bin\wkhtmltopdf.exe
    wkhtmltopdf_path = r'C:\Program Files\wkhtmltopdf\bin\wkhtmltopdf.exe'
    config = pdfkit.configuration(wkhtmltopdf=wkhtmltopdf_path)

    try:
        pdf = pdfkit.from_string(html, False, configuration=config)
    except OSError:
        # Fallback if wkhtmltopdf is in PATH
        pdf = pdfkit.from_string(html, False)

    response = Response(pdf, content_type='application/pdf')
    response.headers['Content-Disposition'] = 'attachment; filename=resume.pdf'
    return response


# ========== OTHER PLACEHOLDERS ==========
@student_bp.route('/skillgap')
@login_required
def skillgap():
    return render_template('student/skillgap.html')


@student_bp.route('/interview')
@login_required
def interview():
    return render_template('student/interview.html')


@student_bp.route('/career')
@login_required
def career():
    return render_template('student/career.html')


@student_bp.route('/drives')
@login_required
def drives():
    return render_template('student/drives.html')


# ========== TEST FORM (keep for debugging) ==========
@student_bp.route('/test_form', methods=['GET', 'POST'])
@login_required
def test_form():
    if request.method == 'POST':
        print("✅ Test form submitted:", request.form)
        skill_name = request.form.get('skill_name')
        proficiency = request.form.get('proficiency')
        return f"Received: {skill_name}, {proficiency}"
    return '''
    <form method="POST" action="/student/test_form">
        <input name="skill_name" placeholder="Skill">
        <input name="proficiency" placeholder="%">
        <button type="submit">Add</button>
    </form>
    '''

# ---------- ATS Analysis ----------
@student_bp.route('/ats_analysis', methods=['GET'])
@login_required
def ats_analysis():
    return render_template('student/ats_analysis.html')

@student_bp.route('/ats_analyze', methods=['POST'])
@login_required
def ats_analyze():
    try:
        # 1. Extract text from file or JSON
        text = ""
        target_role = ""

        # Check if file is uploaded
        if 'file' in request.files:
            file = request.files['file']
            if file.filename == '':
                return jsonify({"error": "No file selected."}), 400

            # Read file based on extension
            filename = file.filename.lower()
            try:
                if filename.endswith('.pdf'):
                    text = extract_text_from_pdf(file)
                elif filename.endswith('.docx'):
                    text = extract_text_from_docx(file)
                else:
                    return jsonify({"error": "Unsupported file type. Please upload PDF or DOCX."}), 400
            except Exception as e:
                return jsonify({"error": f"Failed to parse file: {str(e)}"}), 500

            target_role = request.form.get('target_role', '')

        else:
            # Expect JSON payload
            data = request.get_json()
            if not data or 'resume_text' not in data:
                return jsonify({"error": "Missing 'resume_text' in JSON payload."}), 400
            text = data['resume_text']
            target_role = data.get('target_role', '')

        # 2. Validate extracted text
        if not text or not text.strip():
            return jsonify({"error": "Extracted text is empty. Please provide more content."}), 400

        # 3. Call Gemini analysis
        from app.services.gemini_ai import analyze_ats
        analysis = analyze_ats(text, target_role)

        # 4. Return result as JSON
        return jsonify(analysis)

    except Exception as e:
        # Catch-all for any unexpected error
        return jsonify({"error": f"Internal server error: {str(e)}"}), 500

# Helper functions (place them inside the same file, outside the route)
def extract_text_from_pdf(file):
    text = ""
    with pdfplumber.open(file) as pdf:
        for page in pdf.pages:
            page_text = page.extract_text()
            if page_text:
                text += page_text + "\n"
    return text

def extract_text_from_docx(file):
    doc = Document(file)
    text = "\n".join([para.text for para in doc.paragraphs])
    return text
