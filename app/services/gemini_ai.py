import json
import os
from config import Config
from groq import Groq

# --- Initialize the Groq client ---
client = Groq(api_key=Config.GROQ_API_KEY)

def call_llm(prompt):
    """
    Call the Groq API and return the response text.
    Uses llama-3.3-70b-versatile (free tier).
    """
    if not Config.GROQ_API_KEY:
        print("⚠️ No Groq API key found – using fallback.")
        return None

    model = 'llama-3.3-70b-versatile'  # or 'mixtral-8x7b-32768', 'llama3-8b-8192'

    try:
        response = client.chat.completions.create(
            model=model,
            messages=[{"role": "user", "content": prompt}],
            temperature=0.7,
            max_tokens=1024,
        )
        return response.choices[0].message.content
    except Exception as e:
        print(f"⚠️ Groq API error: {e}")
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