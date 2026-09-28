from flask import Blueprint, render_template, request, redirect, url_for, flash, Response
from flask_login import login_required, current_user
from app.extensions import db
from app.models import InterviewSession, StudentProfile, Skill, StudentSkill, Certification, Project
from datetime import datetime
from app.services.readiness import compute_profile_completeness, compute_readiness_score
from app.services.resume_builder import generate_resume_html
import pdfplumber
from docx import Document
import io
import json
from flask import request, jsonify, render_template, Response
from app.models import StudentProfile, Skill, StudentSkill, Certification, Project, PlacementDrive, Company, InterviewSession
from app.models import PlacementDrive
from datetime import datetime
from app.services.gemini_ai import generate_profile_suggestions
from app.services.skill_gap import get_all_roles, get_role_requirements, analyze_skill_gap

# --- NEW: pdfkit (replaces weasyprint) ---
import pdfkit

student_bp = Blueprint('student', __name__)

# ========== DASHBOARD ==========

from app.services.gemini_ai import generate_profile_suggestions

@student_bp.route('/dashboard')
@login_required
def dashboard():
    profile = current_user.profile
    if not profile:
        flash('Profile not found. Please update your profile.')
        return redirect(url_for('student.profile'))

    # Readiness score
    scores = compute_readiness_score(current_user.id)
    readiness = scores['overall']

    # Profile completeness
    completeness = compute_profile_completeness(profile)

    # Counts
    cert_count = Certification.query.filter_by(student_id=profile.id).count()
    project_count = Project.query.filter_by(student_id=profile.id).count()
    interview_count = InterviewSession.query.filter_by(student_id=current_user.id).count()

    # Upcoming drives
    upcoming_drives = PlacementDrive.query.filter(
        PlacementDrive.status == 'open',
        PlacementDrive.drive_date >= datetime.now().date()
    ).order_by(PlacementDrive.drive_date).limit(3).all()

    # Get AI suggestions based on profile
    skills = StudentSkill.query.filter_by(student_id=profile.id).all()
    certs = Certification.query.filter_by(student_id=profile.id).all()
    projects = Project.query.filter_by(student_id=profile.id).all()
    
    # Generate AI suggestions
    ai_data = generate_profile_suggestions(profile, skills, certs, projects)
    
    # Format for template
    ai_suggestions = []
    
    # Skills to add
    for item in ai_data.get('skills_to_add', []):
        ai_suggestions.append({
            "title": f"📚 Learn: {item}",
            "description": f"Add this skill to strengthen your profile."
        })
    
    # Certifications to pursue
    for item in ai_data.get('certifications_to_pursue', []):
        ai_suggestions.append({
            "title": f"🎓 Get Certified: {item}",
            "description": f"Earning this certification will boost your credibility."
        })
    
    # Projects to build
    for item in ai_data.get('projects_to_build', []):
        ai_suggestions.append({
            "title": f"🛠️ Build: {item}",
            "description": f"Building this project will showcase your practical skills."
        })
    
    # Improvement tips
    for item in ai_data.get('improvement_tips', []):
        ai_suggestions.append({
            "title": f"💡 Tip: {item}",
            "description": ""
        })
    
    # Career advice
    if ai_data.get('career_advice'):
        ai_suggestions.append({
            "title": "🎯 Career Advice",
            "description": ai_data['career_advice']
        })

    return render_template('student/dashboard.html',
                           profile=profile,
                           readiness=readiness,
                           scores=scores,
                           completeness=completeness,
                           cert_count=cert_count,
                           project_count=project_count,
                           interview_count=interview_count,
                           upcoming_drives=upcoming_drives,
                           ai_suggestions=ai_suggestions)
    
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

    wkhtmltopdf_path = r'C:\Program Files\wkhtmltopdf\bin\wkhtmltopdf.exe'
    config = pdfkit.configuration(wkhtmltopdf=wkhtmltopdf_path)

    try:
        pdf = pdfkit.from_string(html, False, configuration=config)
    except OSError:
        pdf = pdfkit.from_string(html, False)

    response = Response(pdf, content_type='application/pdf')
    response.headers['Content-Disposition'] = 'attachment; filename=resume.pdf'
    return response


# ========== OTHER PLACEHOLDERS ==========

@student_bp.route('/skillgap')
@login_required
def skillgap():
    roles = get_all_roles()
    
    # Get the first role as default
    selected_role = request.args.get('role', roles[0]['name'] if roles else 'Frontend Developer')
    
    # Get all role requirements for display
    requirements = get_role_requirements(selected_role)
    
    # Get skill gap analysis
    gap_analysis = analyze_skill_gap(current_user.id, selected_role)
    
    # Get student's current skills
    student_skills = StudentSkill.query.filter_by(student_id=current_user.profile.id).all()
    
    return render_template('student/skillgap.html',
                           roles=roles,
                           selected_role=selected_role,
                           requirements=requirements,
                           gap_analysis=gap_analysis,
                           student_skills=student_skills)
    

@student_bp.route('/skillgap/analyze', methods=['POST'])
@login_required
def analyze_skill_gap_route():
    """AJAX endpoint to get skill gap analysis for a role."""
    data = request.get_json()
    role_name = data.get('role_name', 'Frontend Developer')
    
    analysis = analyze_skill_gap(current_user.id, role_name)
    return jsonify(analysis)


from app.services.interview import (
    start_interview, get_current_question, submit_answer,
    complete_session, cancel_session, get_session_history
)

# ========== INTERVIEW DASHBOARD ==========
@student_bp.route('/interview')
@login_required
def interview():
    sessions = get_session_history(current_user.id)
    return render_template('student/interview.html', sessions=sessions)


# ========== START INTERVIEW ==========
@student_bp.route('/interview/start/<category>')
@login_required
def interview_start(category):
    if category not in ['technical', 'hr', 'aptitude']:
        flash('Invalid interview category.')
        return redirect(url_for('student.interview'))

    session = start_interview(current_user.id, category)
    if not session:
        flash('No questions available for this category.')
        return redirect(url_for('student.interview'))

    return redirect(url_for('student.interview_room', session_id=session.id))


# ========== INTERVIEW ROOM ==========
@student_bp.route('/interview/room/<int:session_id>')
@login_required
def interview_room(session_id):
    session = InterviewSession.query.get_or_404(session_id)
    if session.student_id != current_user.id:
        flash('Access denied.')
        return redirect(url_for('student.interview'))
    return render_template('student/interview_room.html', session=session)


# ========== GET QUESTION (AJAX) ==========
@student_bp.route('/interview/question/<int:session_id>/<int:index>')
@login_required
def interview_question(session_id, index):
    session = InterviewSession.query.get_or_404(session_id)
    if session.student_id != current_user.id:
        return jsonify({'error': 'Access denied'}), 403

    question_data = get_current_question(session_id, index)
    if not question_data:
        return jsonify({'error': 'Question not found'}), 404

    return jsonify({
        'question': question_data['question'],
        'index': index,
        'total': len(session.questions)
    })


# ========== SUBMIT ANSWER (AJAX) ==========
@student_bp.route('/interview/submit', methods=['POST'])
@login_required
def interview_submit():
    data = request.get_json()
    session_id = data.get('session_id')
    question_index = data.get('question_index')
    answer = data.get('answer')

    session = InterviewSession.query.get_or_404(session_id)
    if session.student_id != current_user.id:
        return jsonify({'error': 'Access denied'}), 403

    score_data = submit_answer(session_id, question_index, answer)
    return jsonify(score_data)


# ========== COMPLETE INTERVIEW ==========
@student_bp.route('/interview/complete/<int:session_id>')
@login_required
def interview_complete(session_id):
    complete_session(session_id)
    return redirect(url_for('student.interview_result', session_id=session_id))


# ========== CANCEL INTERVIEW (AJAX) ==========
@student_bp.route('/interview/cancel/<int:session_id>')
@login_required
def interview_cancel(session_id):
    cancel_session(session_id)
    return jsonify({'status': 'cancelled'})


# ========== INTERVIEW RESULT ==========
@student_bp.route('/interview/result/<int:session_id>')
@login_required
def interview_result(session_id):
    session = InterviewSession.query.get_or_404(session_id)
    if session.student_id != current_user.id:
        flash('Access denied.')
        return redirect(url_for('student.interview'))
    return render_template('student/interview_result.html', session=session)

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
        text = ""
        target_role = ""

        if 'file' in request.files:
            file = request.files['file']
            if file.filename == '':
                return jsonify({"error": "No file selected."}), 400

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
            data = request.get_json()
            if not data or 'resume_text' not in data:
                return jsonify({"error": "Missing 'resume_text' in JSON payload."}), 400
            text = data['resume_text']
            target_role = data.get('target_role', '')

        if not text or not text.strip():
            return jsonify({"error": "Extracted text is empty. Please provide more content."}), 400

        # 3. Call Gemini analysis
        from app.services.gemini_ai import analyze_ats
        analysis = analyze_ats(text, target_role)

        # 4. Return result as JSON
        return jsonify(analysis)

    except Exception as e:
        return jsonify({"error": f"Internal server error: {str(e)}"}), 500

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
