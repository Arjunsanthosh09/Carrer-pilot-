import random
import json
from app.models import InterviewQuestion, InterviewSession
from app.services.gemini_ai import call_llm
from app import db
from datetime import datetime


def get_questions(category, count=5):
    """Get random questions for a category."""
    questions = InterviewQuestion.query.filter_by(category=category).all()
    if len(questions) <= count:
        return questions
    return random.sample(questions, count)


def start_interview(student_id, category):
    """Start a new interview session."""
    questions = get_questions(category, 5)
    if not questions:
        return None

    session = InterviewSession(
        student_id=student_id,
        type=category,
        status='in_progress',
        total_questions=len(questions),
        questions=[{
            'question_id': q.id,
            'question': q.question,
            'answer': '',
            'score': None,
            'feedback': ''
        } for q in questions]
    )
    db.session.add(session)
    db.session.commit()
    return session


def get_current_question(session_id, index):
    """Get a specific question from the session."""
    session = InterviewSession.query.get(session_id)
    if not session or index >= len(session.questions):
        return None
    return session.questions[index]


def submit_answer(session_id, question_index, answer):
    """Submit an answer and get AI scoring."""
    session = InterviewSession.query.get(session_id)
    if not session:
        return None

    session.questions[question_index]['answer'] = answer
    question_data = session.questions[question_index]

    score_data = score_interview_answer(question_data['question'], answer)

    session.questions[question_index]['score'] = score_data.get('score', 0)
    session.questions[question_index]['feedback'] = score_data.get('feedback', '')

    # Mark JSON as changed (important for MySQL JSON columns)
    from sqlalchemy.orm.attributes import flag_modified
    flag_modified(session, "questions")

    db.session.commit()
    return score_data


def complete_session(session_id):
    """Complete the interview session."""
    session = InterviewSession.query.get(session_id)
    if not session:
        return None

    scores = [q.get('score', 0) for q in session.questions if q.get('score') is not None]
    session.overall_score = round(sum(scores) / len(scores), 1) if scores else 0
    session.status = 'completed'
    db.session.commit()
    return session


def cancel_session(session_id):
    """Cancel the interview session."""
    session = InterviewSession.query.get(session_id)
    if session:
        session.status = 'cancelled'
        db.session.commit()
    return session


def get_session_history(student_id):
    """Get all sessions for a student."""
    return InterviewSession.query.filter_by(
        student_id=student_id
    ).order_by(InterviewSession.date.desc()).all()


def score_interview_answer(question, answer):
    """Score an interview answer using AI."""
    if not answer or len(answer.strip()) < 5:
        return {
            'score': 0,
            'feedback': 'Please provide a more detailed answer.',
            'clarity': 0, 'correctness': 0, 'completeness': 0, 'communication': 0
        }

    prompt = f"""
    You are an expert interviewer evaluating a candidate's answer.

    Question: {question}
    Answer: {answer}

    Rate this answer on a scale of 0-10 for:
    1. Clarity
    2. Correctness
    3. Completeness
    4. Communication

    Also provide feedback (2-3 sentences) on how to improve.

    Return ONLY valid JSON:
    {{"score": 7.5, "feedback": "Good answer, but...", "clarity": 8, "correctness": 7, "completeness": 7, "communication": 8}}
    """

    try:
        result = call_llm(prompt)
        if result:
            cleaned = result.strip()
            if cleaned.startswith('```json'):
                cleaned = cleaned[7:]
            if cleaned.endswith('```'):
                cleaned = cleaned[:-3]
            return json.loads(cleaned)
    except Exception as e:
        print(f"⚠️ Scoring error: {e}")

    return {
        'score': 5.0,
        'feedback': 'Answer received. Ensure detailed, structured responses.',
        'clarity': 5, 'correctness': 5, 'completeness': 5, 'communication': 5
    }