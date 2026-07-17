from flask import render_template
from app import db
from app.models import StudentProfile, StudentSkill, Certification, Project
from app.services.gemini_ai import generate_summary, generate_project_bullets

def generate_resume_html(student_id):
    profile = StudentProfile.query.filter_by(user_id=student_id).first()
    if not profile:
        return "<p>Profile not found.</p>"

    skills = StudentSkill.query.filter_by(student_id=profile.id).all()
    certs = Certification.query.filter_by(student_id=profile.id).all()
    projects = Project.query.filter_by(student_id=profile.id).all()

    # Generate AI summary
    summary = generate_summary(profile, skills, projects)

    # Generate AI bullet points for each project
    for project in projects:
        project.bullets = generate_project_bullets(project)

    # Categorise skills (example: split into frontend/backend based on keywords)
    frontend_keywords = ['HTML', 'CSS', 'JavaScript', 'React', 'Angular', 'Vue', 'Flutter', 'Dart']
    backend_keywords = ['Python', 'Java', 'PHP', 'Node', 'SQL', 'MySQL', 'PostgreSQL', 'MongoDB', 'Firebase', 'Docker']
    frontend = []
    backend = []
    other = []
    for ss in skills:
        skill_name = ss.skill.name
        if any(kw in skill_name for kw in frontend_keywords):
            frontend.append(ss)
        elif any(kw in skill_name for kw in backend_keywords):
            backend.append(ss)
        else:
            other.append(ss)

    context = {
        'profile': profile,
        'skills': skills,
        'frontend_skills': frontend,
        'backend_skills': backend,
        'other_skills': other,
        'certs': certs,
        'projects': projects,
        'summary': summary,
        'soft_skills': profile.soft_skills.split(',') if profile.soft_skills else [],
        'contact': {
            'email': profile.user.email,  # assuming user has email
            'phone': profile.phone or '',
            'location': profile.location or '',
            'linkedin': profile.linkedin or '',
            'github': profile.github or '',
            'portfolio': profile.portfolio or '',
        }
    }

    html = render_template('student/resume_content.html', **context)
    return html