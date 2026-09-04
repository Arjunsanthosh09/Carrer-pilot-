from app.models import StudentProfile, StudentSkill, Certification, Project, InterviewSession
from app import db

def compute_readiness_score(student_id):
    """
    Compute readiness score (0-100) and sub-scores for a student.
    Returns a dict with overall score and sub-scores.
    """
    profile = StudentProfile.query.filter_by(user_id=student_id).first()
    if not profile:
        return {
            "overall": 0,
            "technical": 0,
            "certifications": 0,
            "projects": 0,
            "aptitude": 0,
            "communication": 0,
            "academics": 0
        }

    # 1. Technical Skills (average proficiency of all skills)
    skills = StudentSkill.query.filter_by(student_id=profile.id).all()
    if skills:
        technical = sum(s.proficiency for s in skills) / len(skills)
    else:
        technical = 0

    # 2. Certifications (0-100 based on count, max 5)
    cert_count = Certification.query.filter_by(student_id=profile.id).count()
    certifications = min(cert_count * 20, 100)  # Each cert = 20%, max 100%

    # 3. Projects (0-100 based on count, max 5)
    project_count = Project.query.filter_by(student_id=profile.id).count()
    projects = min(project_count * 20, 100)  # Each project = 20%, max 100%

    # 4. Aptitude – placeholder (not implemented yet)
    aptitude = 0

    # 5. Communication – placeholder (not implemented yet)
    communication = 0

    # 6. Academics (CGPA out of 10 → percentage)
    if profile.cgpa:
        academics = min((float(profile.cgpa) / 10) * 100, 100)
    else:
        academics = 0

    # Overall readiness (weighted average)
    weights = {
        "technical": 0.25,
        "certifications": 0.20,
        "projects": 0.20,
        "aptitude": 0.10,
        "communication": 0.10,
        "academics": 0.15
    }

    overall = (
        (technical * weights["technical"]) +
        (certifications * weights["certifications"]) +
        (projects * weights["projects"]) +
        (aptitude * weights["aptitude"]) +
        (communication * weights["communication"]) +
        (academics * weights["academics"])
    )

    return {
        "overall": round(overall, 1),
        "technical": round(technical, 1),
        "certifications": round(certifications, 1),
        "projects": round(projects, 1),
        "aptitude": round(aptitude, 1),
        "communication": round(communication, 1),
        "academics": round(academics, 1)
    }

def compute_profile_completeness(profile):
    """
    Calculate profile completeness (0-100%) based on filled fields.
    """
    fields = [
        profile.full_name, profile.department, profile.year,
        profile.roll_number, profile.cgpa, profile.about_me,
        profile.phone, profile.location, profile.linkedin,
        profile.github, profile.portfolio, profile.soft_skills
    ]
    filled = sum(1 for f in fields if f and str(f).strip())
    return int((filled / len(fields)) * 100)