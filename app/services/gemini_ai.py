import json
import os
from config import Config
from groq import Groq

# --- Initialize the Groq client ---
client = Groq(api_key=Config.GROQ_API_KEY)
def call_llm(prompt):
    """
    Call the Groq API and return the response text.
    Uses available models from your Groq account.
    """
    if not Config.GROQ_API_KEY:
        print("⚠️ No Groq API key found – using fallback.")
        return None

    # Models available in your Groq account
    # Based on your dashboard: https://console.groq.com
    models_to_try = [
        'openai/gpt-oss-120b',      # Best quality, larger model
        'openai/gpt-oss-20b',       # Good quality, faster
        'qwen/qwen3.8-27b',         # Qwen model (multilingual)
        'qwen/qwen3.6-27b',         # Qwen earlier version
    ]
    
    for model_name in models_to_try:
        try:
            response = client.chat.completions.create(
                model=model_name,
                messages=[{"role": "user", "content": prompt}],
                temperature=0.7,
                max_tokens=2048,  # Increased for better responses
            )
            return response.choices[0].message.content
        except Exception as e:
            print(f"⚠️ Model {model_name} failed: {e}")
            continue
    
    print("⚠️ All models failed.")
    return None
# --- Keep all your existing functions, but replace call_gemini with call_llm ---

def generate_summary(profile, skills, projects):
    """
    Generate a professional summary using Groq.
    """
    skills_str = ', '.join([s.skill.name for s in skills])
    projects_str = ', '.join([p.title for p in projects])
    about = profile.about_me or ''

    prompt = f"""
    You are a professional resume writer. Based on the following student data, write a concise, compelling professional summary (3-4 sentences) for a resume.

    Student's self-description: {about}
    Skills: {skills_str}
    Projects: {projects_str}

    The summary should highlight their technical skills, experience, and career goals. Be confident and use strong action words.
    Return ONLY the summary text, no extra formatting.
    """
    result = call_llm(prompt)
    if result:
        return result.strip()

    # Fallback
    summary = f"Student with skills in {skills_str}. "
    if projects:
        summary += f"Worked on projects including {projects_str}. "
    summary += "Seeking opportunities to apply technical skills and grow professionally."
    return summary

def generate_project_bullets(project):
    """
    Generate bullet points for a project using Groq.
    """
    prompt = f"""
    You are a technical resume writer. For the following project, generate 3 bullet points that highlight the key achievements, technologies used, and outcomes.

    Project Title: {project.title}
    Description: {project.description or ''}
    Technologies: {project.technologies or ''}

    Each bullet point should start with a strong action verb and focus on measurable results or specific contributions.
    Return the bullet points as a Python list of strings, e.g. ['Built a ...', 'Implemented ...'].
    Return ONLY the list, no extra text.
    """
    result = call_llm(prompt)
    if result:
        try:
            bullet_list = eval(result)
            if isinstance(bullet_list, list) and len(bullet_list) > 0:
                return bullet_list
        except:
            lines = [line.strip().lstrip('- ').lstrip('• ') for line in result.split('\n') if line.strip()]
            if lines:
                return lines

    if project.description:
        return [project.description]
    return [f"Developed {project.title} using relevant technologies."]

def analyze_ats(resume_text, target_role=""):
    """
    Analyze a resume for ATS compatibility using Groq.
    Returns a dict with:
        score: int (0-100)
        missing_keywords: list
        suggestions: list (detailed, actionable)
        recommended_roles: list
    """
    if not resume_text.strip():
        return {
            "score": 0,
            "missing_keywords": [],
            "suggestions": ["Resume text is empty. Please provide content."],
            "recommended_roles": []
        }

    role_specific = f"for the role of {target_role}" if target_role else "for any tech role"

    prompt = f"""
    You are an expert ATS and career coach. Analyze the following resume {role_specific}. Provide a **detailed, actionable** report.

    Resume:
    {resume_text}

    Return a JSON object with exactly these keys:

    1. "score": integer 0-100 (based on ATS compatibility – keyword density, formatting, achievements, length).

    2. "missing_keywords": list of **specific** skills, tools, certifications, or technologies that are missing **for this role** (or in general if no role specified). Give 5-10 items.

    3. "suggestions": list of **10+ specific, actionable improvements**. Must include:
       - **Certifications**: name 2-3 certifications that would boost the resume for this role (e.g., AWS Certified, Google Analytics, etc.).
       - **Projects**: suggest 2-3 specific project types or ideas that would strengthen the resume (e.g., "Build a real‑time dashboard using React and D3").
       - **Skills**: list missing technical or soft skills with a reason why they matter.
       - **Formatting/Content**: advice on bullet points, quantification, summary, etc.
       - **Quantifiable achievements**: encourage adding metrics.

    4. "recommended_roles": list of 3-5 job titles that best match the resume.

    Make suggestions practical – the student should be able to act on them immediately.
    Return ONLY valid JSON.
    """

    result = call_llm(prompt)
    if not result:
        return {
            "score": 50,
            "missing_keywords": [
                "Action verbs", "Quantifiable achievements", "Industry-specific keywords",
                "Cloud certifications", "Agile/Scrum", "Version control (Git)"
            ],
            "suggestions": [
                "Add a professional summary at the top.",
                "Quantify your achievements: 'Improved load time by 30%'.",
                "Include a GitHub or portfolio link.",
                "Add 2-3 more projects with clear tech stacks.",
                "Earn a relevant certification (e.g., AWS, Google Cloud).",
                "List specific tools/technologies under each project.",
                "Use consistent bullet points with strong action verbs.",
                "Add metrics to project descriptions (users, performance gains).",
                "Consider an internship or volunteer experience.",
                "Tailor your summary to the target role."
            ],
            "recommended_roles": ["Software Engineer", "Data Analyst", "Project Manager", "DevOps Engineer"]
        }

    try:
        cleaned = result.strip()
        if cleaned.startswith('```json'):
            cleaned = cleaned[7:]
        if cleaned.endswith('```'):
            cleaned = cleaned[:-3]
        data = json.loads(cleaned)
        required_keys = ["score", "missing_keywords", "suggestions", "recommended_roles"]
        for key in required_keys:
            if key not in data:
                data[key] = [] if key != "score" else 0
        return data
    except json.JSONDecodeError:
        return {
            "score": 50,
            "missing_keywords": [],
            "suggestions": ["We encountered an error parsing the AI response. Please try again."],
            "recommended_roles": []
        }

def generate_profile_suggestions(profile, skills, certs, projects):
    """
    Generate personalized AI suggestions based on student's profile.
    Returns a dict with:
        skills_to_add: list of skills the student should learn
        certifications_to_pursue: list of recommended certifications
        projects_to_build: list of project ideas
        improvement_tips: list of general improvement suggestions
        career_advice: specific career advice
    """
    # Prepare data for AI
    skills_str = ', '.join([f"{s.skill.name} ({s.proficiency}%)" for s in skills]) if skills else 'No skills added yet'
    certs_str = ', '.join([f"{c.title} ({c.issuer})" for c in certs]) if certs else 'No certifications added yet'
    projects_str = ', '.join([p.title for p in projects]) if projects else 'No projects added yet'
    cgpa = profile.cgpa or 'Not provided'
    department = profile.department or 'Not specified'
    year = profile.year or 'Not specified'
    about = profile.about_me or 'Not provided'

    # Counts for basic analysis
    skill_count = len(skills)
    cert_count = len(certs)
    project_count = len(projects)

    # Determine if student is technical or non-technical
    tech_keywords = ['computer', 'science', 'engineering', 'technology', 'it', 'software', 'data', 'ai', 'ml', 'cs', 'ece', 'eee', 'mechanical', 'civil']
    is_technical = any(kw in department.lower() for kw in tech_keywords) if department else True

    role_type = "technical" if is_technical else "non-technical"
    role_instruction = f"for a {role_type} student" if is_technical else "for a non-technical student"

    prompt = f"""
    You are a career counselor and placement expert. Analyze this student's profile and provide **personalized, actionable recommendations**.

    Student Profile:
    - Department: {department}
    - Year: {year}
    - CGPA: {cgpa}
    - About: {about}
    - Role Type: {role_type}

    Current Skills ({skill_count}): {skills_str}
    Current Certifications ({cert_count}): {certs_str}
    Current Projects ({project_count}): {projects_str}

    Based on this data, provide a JSON object with exactly these keys:

    1. "skills_to_add": list of 2-3 specific skills the student should learn (with brief reason why).
    2. "certifications_to_pursue": list of 2-3 recommended certifications (with brief reason why).
    3. "projects_to_build": list of 2-3 specific project ideas (with brief description).
    4. "improvement_tips": list of 3-4 general improvement suggestions.
    5. "career_advice": 1-2 sentences of specific career advice.

    Make suggestions practical and tailored to their current profile. If they already have many skills/certs/projects, suggest more advanced options.
    Return ONLY valid JSON, no extra text.
    """

    result = call_llm(prompt)
    if not result:
        # Fallback – smart fallback based on actual data
        return get_fallback_suggestions(skills, certs, projects, department)

    try:
        cleaned = result.strip()
        if cleaned.startswith('```json'):
            cleaned = cleaned[7:]
        if cleaned.endswith('```'):
            cleaned = cleaned[:-3]
        data = json.loads(cleaned)
        # Ensure all keys exist
        required_keys = ["skills_to_add", "certifications_to_pursue", "projects_to_build", "improvement_tips", "career_advice"]
        for key in required_keys:
            if key not in data:
                data[key] = [] if key != "career_advice" else ""
        return data
    except json.JSONDecodeError:
        return get_fallback_suggestions(skills, certs, projects, department)

def get_fallback_suggestions(skills, certs, projects, department=""):
    """
    Smart fallback suggestions when AI is unavailable.
    Generates recommendations based on actual profile data.
    """
    suggestions = {
        "skills_to_add": [],
        "certifications_to_pursue": [],
        "projects_to_build": [],
        "improvement_tips": [],
        "career_advice": ""
    }

    skill_count = len(skills)
    cert_count = len(certs)
    project_count = len(projects)

    # --- Skills suggestions ---
    if skill_count == 0:
        suggestions["skills_to_add"].append("Add foundational programming skills (Python, Java, or JavaScript)")
        suggestions["skills_to_add"].append("Add web development skills (HTML, CSS, React)")
    elif skill_count < 3:
        suggestions["skills_to_add"].append("Add more in-demand skills like SQL or cloud computing")
        suggestions["skills_to_add"].append("Consider adding soft skills like communication and teamwork")
    elif skill_count < 6:
        suggestions["skills_to_add"].append("Add advanced skills in your domain (e.g., Machine Learning, DevOps)")
        suggestions["skills_to_add"].append("Consider learning tools like Docker, Git, or AWS")
    else:
        suggestions["skills_to_add"].append("You have a good number of skills. Consider specializing in one area.")
        suggestions["skills_to_add"].append("Add leadership or project management skills for senior roles")

    # --- Certifications suggestions ---
    if cert_count == 0:
        suggestions["certifications_to_pursue"].append("Earn your first certification (e.g., AWS Cloud Practitioner, Google Analytics)")
        suggestions["certifications_to_pursue"].append("Consider Coursera or Udemy certifications in your domain")
    elif cert_count < 2:
        suggestions["certifications_to_pursue"].append("Add 1-2 more certifications to build credibility (e.g., AWS, Google, Microsoft)")
        suggestions["certifications_to_pursue"].append("Consider industry-recognized certifications for your target role")
    else:
        suggestions["certifications_to_pursue"].append("You have good certifications. Consider advanced or specialized ones.")
        suggestions["certifications_to_pursue"].append("Look for certifications that are highly valued in your target industry")

    # --- Projects suggestions ---
    if project_count == 0:
        suggestions["projects_to_build"].append("Build a portfolio project that showcases your core skills")
        suggestions["projects_to_build"].append("Create a personal website or GitHub repository")
    elif project_count < 2:
        suggestions["projects_to_build"].append("Add at least 2 more projects with different technologies")
        suggestions["projects_to_build"].append("Build a full-stack application to demonstrate end-to-end skills")
    elif project_count < 4:
        suggestions["projects_to_build"].append("Build a project with real-world impact (e.g., solve a problem in your community)")
        suggestions["projects_to_build"].append("Create a project that showcases your best skills in depth")
    else:
        suggestions["projects_to_build"].append("You have good projects. Consider contributing to open-source or building a complex system.")
        suggestions["projects_to_build"].append("Document your projects well – add detailed README and live demos")

    # --- Improvement tips ---
    suggestions["improvement_tips"].append("Add a professional summary to your profile (if not already added)")
    if skill_count > 0:
        low_skills = [s for s in skills if s.proficiency < 60]
        if low_skills:
            suggestions["improvement_tips"].append(f"Improve proficiency in {low_skills[0].skill.name} – aim for 70%+")
    suggestions["improvement_tips"].append("Keep your skills and projects updated regularly")
    suggestions["improvement_tips"].append("Practice mock interviews to improve communication and confidence")

    # --- Career advice ---
    if "computer" in department.lower() or "it" in department.lower() or "cse" in department.lower():
        suggestions["career_advice"] = "Focus on building a strong technical portfolio and consider internships at tech companies. Stay updated with industry trends and practice coding regularly."
    elif "data" in department.lower() or "ai" in department.lower():
        suggestions["career_advice"] = "Focus on building data science projects and earning certifications. Consider participating in Kaggle competitions to build your portfolio."
    elif "ece" in department.lower() or "electronics" in department.lower():
        suggestions["career_advice"] = "Build a strong foundation in both hardware and software. Consider roles in embedded systems, IoT, or VLSI design."
    else:
        suggestions["career_advice"] = "Focus on building a strong portfolio of projects and certifications that align with your target role. Network with professionals in your field."

    return suggestions

def analyze_skill_gap_ai(role_name, gaps, student_skills):
    """
    Generate AI-powered recommendations for skill gaps.
    """
    # Prepare data for AI
    gaps_str = '\n'.join([
        f"- {g['skill_name']}: Current {g['current']}% / Required {g['required']}%"
        for g in gaps if g['gap'] > 0
    ])
    strengths_str = '\n'.join([
        f"- {g['skill_name']}: Current {g['current']}% / Required {g['required']}%"
        for g in gaps if g['is_matched']
    ])
    
    if not gaps_str:
        return {
            'summary': f"You have all the required skills for {role_name}! 🎉",
            'improvements': [],
            'learning_paths': [],
            'priority_skills': []
        }
    
    prompt = f"""
    You are a career counselor and skill development expert. Analyze the following skill gaps for a student aiming to become a {role_name}.
    
    STUDENT'S SKILL GAPS:
    {gaps_str}
    
    STRENGTHS (already meeting requirements):
    {strengths_str}
    
    Provide a JSON response with:
    1. "summary": A 2-3 sentence overview of their skill gap situation.
    2. "improvements": List of 3-4 specific, actionable recommendations (courses, certifications, projects).
    3. "learning_paths": List of 2-3 learning paths (e.g., "Take a TypeScript course on Udemy").
    4. "priority_skills": List of skills that need the most immediate attention (2-3 skills).
    
    Make recommendations practical and actionable. Include specific course names, certification names, or project ideas.
    Return ONLY valid JSON.
    """
    
    result = call_llm(prompt)
    if not result:
        return get_fallback_recommendations(role_name, gaps)
    
    try:
        cleaned = result.strip()
        if cleaned.startswith('```json'):
            cleaned = cleaned[7:]
        if cleaned.endswith('```'):
            cleaned = cleaned[:-3]
        data = json.loads(cleaned)
        return data
    except:
        return get_fallback_recommendations(role_name, gaps)

def get_fallback_recommendations(role_name, gaps):
    """Fallback recommendations when AI is unavailable."""
    recommendations = {
        'summary': f"Based on your skills, you need to work on {len([g for g in gaps if g['gap'] > 0])} skills for {role_name}.",
        'improvements': [],
        'learning_paths': [],
        'priority_skills': []
    }
    
    # Find top 3 gaps
    top_gaps = sorted([g for g in gaps if g['gap'] > 0], key=lambda x: x['gap'], reverse=True)[:3]
    
    for gap in top_gaps:
        skill = gap['skill_name']
        recommendations['priority_skills'].append(skill)
        recommendations['learning_paths'].append(f"Complete a course on {skill}")
        recommendations['improvements'].append(f"Improve your {skill} skills by building a small project")
    
    # Add general recommendations
    recommendations['improvements'].append("Practice coding problems regularly")
    recommendations['improvements'].append("Join online communities for your target role")
    recommendations['learning_paths'].append(f"Build a portfolio project for {role_name}")
    
    return recommendations