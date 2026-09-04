from app.models import StudentProfile, StudentSkill, RoleRequirement, Skill
from app.services.gemini_ai import analyze_skill_gap_ai
from app import db

def get_all_roles():
    """Get all distinct role names with skill counts."""
    roles = db.session.query(
        RoleRequirement.role_name,
        db.func.count(RoleRequirement.skill_name).label('skill_count')
    ).group_by(RoleRequirement.role_name).all()
    
    return [{'name': r.role_name, 'skill_count': r.skill_count} for r in roles]

def get_role_requirements(role_name):
    """Get all requirements for a specific role."""
    requirements = RoleRequirement.query.filter_by(role_name=role_name).all()
    return requirements

def get_student_skills(student_id):
    """Get all skills for a student with proficiency."""
    profile = StudentProfile.query.filter_by(user_id=student_id).first()
    if not profile:
        return []
    
    skills = StudentSkill.query.filter_by(student_id=profile.id).all()
    return [{'name': s.skill.name, 'proficiency': s.proficiency} for s in skills]

def analyze_skill_gap(student_id, role_name):
    """Analyze skill gap between student's skills and role requirements."""
    profile = StudentProfile.query.filter_by(user_id=student_id).first()
    if not profile:
        return None
    
    # Get student's current skills
    student_skills = StudentSkill.query.filter_by(student_id=profile.id).all()
    skill_dict = {s.skill.name: s.proficiency for s in student_skills}
    
    # Get all student skill names for display
    student_skill_names = [s.skill.name for s in student_skills]
    
    # Get role requirements
    requirements = RoleRequirement.query.filter_by(role_name=role_name).all()
    
    # Calculate gaps
    gaps = []
    total_required = len(requirements)
    matched_skills = 0
    
    # Get all skill names required for the role
    required_skill_names = [req.skill_name for req in requirements]
    
    # Find skills the student has but aren't required for the role
    extra_skills = [s for s in student_skill_names if s not in required_skill_names]
    
    for req in requirements:
        current_proficiency = skill_dict.get(req.skill_name, 0)
        is_matched = current_proficiency >= req.required_proficiency
        
        if is_matched:
            matched_skills += 1
        
        gaps.append({
            'skill_name': req.skill_name,
            'current': current_proficiency,
            'required': req.required_proficiency,
            'gap': req.required_proficiency - current_proficiency if current_proficiency < req.required_proficiency else 0,
            'is_matched': is_matched,
            'category': req.category,
            'has_skill': current_proficiency > 0
        })
    
    # Sort by gap (largest first)
    gaps.sort(key=lambda x: x['gap'], reverse=True)
    
    # Calculate match percentage
    match_percentage = (matched_skills / total_required * 100) if total_required > 0 else 0
    
    # Get AI recommendations
    ai_recommendations = analyze_skill_gap_ai(role_name, gaps, skill_dict)
    
    return {
        'role_name': role_name,
        'total_skills': total_required,
        'matched_skills': matched_skills,
        'match_percentage': round(match_percentage, 1),
        'gaps': gaps,
        'student_skills': skill_dict,
        'student_skill_names': student_skill_names,
        'required_skill_names': required_skill_names,
        'extra_skills': extra_skills,
        'recommendations': ai_recommendations
    }