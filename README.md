<div align="center">

<h1>✈️ CareerPilot AI</h1>

<p><strong>Student Placement Readiness & Career Development Platform</strong></p>

<p>
  <img src="https://img.shields.io/badge/Python-3.11+-3776AB?style=for-the-badge&logo=python&logoColor=white"/>
  <img src="https://img.shields.io/badge/Flask-3.x-000000?style=for-the-badge&logo=flask&logoColor=white"/>
  <img src="https://img.shields.io/badge/MySQL-8.0-4479A1?style=for-the-badge&logo=mysql&logoColor=white"/>
  <img src="https://img.shields.io/badge/Gemini_API-AI_Powered-8E75B2?style=for-the-badge&logo=google&logoColor=white"/>
  <img src="https://img.shields.io/badge/Status-In_Development-F59E0B?style=for-the-badge"/>
</p>

<p>A web application that helps students prepare for placements from day one — with AI-powered resume analysis, skill gap detection, mock interviews, and real-time readiness scoring.</p>

</div>

---

## 📋 Table of contents

- [Overview](#overview)
- [Features](#features)
- [Tech stack](#tech-stack)
- [Project structure](#project-structure)
- [Getting started](#getting-started)
- [Environment variables](#environment-variables)
- [Database setup](#database-setup)
- [Running the application](#running-the-application)
- [Team](#team)

---

## Overview

Most students begin placement preparation only in their final semester — too late to close skill gaps, build a strong profile, or practice interviews meaningfully. CareerPilot AI solves this by acting as a centralized career development companion throughout a student's academic journey.

The platform serves two roles:

- **Students** — build profiles, generate resumes, identify skill gaps, practice mock interviews, and track a real-time placement readiness score.
- **Placement officers** — monitor cohort-wide readiness, manage companies and placement drives, define eligibility criteria, and export analytical reports.

AI features are powered by the **Google Gemini API** and are embedded directly into the student workflow — not bolted on as an afterthought.

---

## Features

### Student-facing

| Feature | Description |
|---|---|
| **Profile management** | Add academic info, skills, certifications, and project portfolio in one place |
| **Resume builder** | Auto-generates a professional resume from the profile; supports custom templates |
| **AI resume analysis** | Gemini-powered feedback on resume quality, keyword gaps, and improvement areas |
| **Skill gap analysis** | Compares current skills against real job role requirements and highlights gaps |
| **Placement readiness score** | A single score (0–100) calculated from skills, projects, certifications, aptitude, and CGPA |
| **AI mock interviews** | Simulated technical and HR interviews with question-by-question AI feedback |
| **Career recommendations** | Suggests suitable roles based on skills, interests, and project history |
| **Placement drives** | Browse upcoming drives, check eligibility, and apply directly |

### Placement officer-facing

| Feature | Description |
|---|---|
| **Student monitoring** | View readiness scores, skill gap reports, and progress for every student |
| **Company management** | Maintain a directory of partner companies and hiring history |
| **Drive management** | Create placement drives, set eligibility criteria, and track applicants |
| **Reports & analytics** | Department-wise readiness trends, common skill gaps, exportable reports |

---

## Tech stack

| Layer | Technology |
|---|---|
| **Frontend** | HTML5, CSS3, JavaScript, Chart.js |
| **Backend** | Python, Flask |
| **Database** | MySQL 8.0 (via SQLAlchemy + PyMySQL) |
| **AI / Intelligence** | Google Gemini API (`google-generativeai`) |
| **Auth** | Flask-Login, session-based |
| **Migrations** | Flask-Migrate (Alembic) |
| **Dev tools** | Git, GitHub, python-dotenv |

---

## Project structure

```
CareerPilot-AI/
│
├── app/
│   ├── __init__.py                 # Flask app factory, extension init
│   ├── models.py                   # SQLAlchemy models (User, StudentProfile, Skill, etc.)
│   ├── extensions.py               # db, login_manager, migrate instances
│   │
│   ├── services/                   # Reusable business logic (no route decorators)
│   │   ├── readiness.py            # Computes placement readiness score
│   │   ├── gemini_ai.py            # Gemini API wrappers (resume, skill gap, interview)
│   │   └── resume_builder.py       # Generates resume HTML from profile data
│   │
│   ├── auth/                       # Authentication blueprints
│   │   ├── __init__.py
│   │   └── routes.py               # /login, /signup, /logout
│   │
│   ├── student/                    # Student-facing pages
│   │   ├── __init__.py
│   │   ├── routes.py               # /dashboard, /profile, /resume, /skillgap, /interview, /career, /drives
│   │   └── ajax.py                 # POST endpoints returning JSON for AI calls
│   │                               # /ajax/analyze-resume, /ajax/interview-feedback, /ajax/skill-gap
│   │
│   ├── officer/                    # Placement officer panel
│   │   ├── __init__.py
│   │   └── routes.py               # /dashboard, /students, /companies, /drives, /reports
│   │
│   ├── static/
│   │   ├── css/
│   │   │   └── style.css
│   │   ├── js/
│   │   │   ├── main.js             # Global functions and AJAX calls
│   │   │   ├── dashboard.js
│   │   │   ├── resume.js
│   │   │   └── interview.js
│   │   └── lib/
│   │       └── chart.js
│   │
│   └── templates/                  # Jinja2 templates
│       ├── base.html               # Shared layout with nav and flash messages
│       ├── auth/
│       │   ├── login.html
│       │   └── signup.html
│       ├── student/
│       │   ├── dashboard.html
│       │   ├── profile.html
│       │   ├── resume.html
│       │   ├── skillgap.html
│       │   ├── interview.html
│       │   ├── career.html
│       │   ├── drives.html
│       │   └── sidebar.html
│       └── officer/
│           ├── dashboard.html
│           ├── students.html
│           ├── companies.html
│           ├── drives.html
│           └── reports.html
│
├── migrations/                     # Alembic auto-generated migration files
├── tests/                          # Unit tests
├── instance/                       # Local config / SQLite fallback (not committed)
├── .env                            # Environment variables — do not commit
├── .env.example                    # Template for .env (safe to commit)
├── config.py                       # Dev, Prod, and Test configuration classes
├── requirements.txt
├── run.py                          # Application entry point
└── README.md
```

---

## Getting started

### Prerequisites

- Python 3.11 or higher
- MySQL 8.0 running locally or on a server
- A [Google Gemini API key](https://aistudio.google.com/app/apikey)
- Git

### 1. Clone the repository

```bash
git clone https://github.com/your-username/CareerPilot-AI.git
cd CareerPilot-AI
```

### 2. Create and activate a virtual environment

```bash
python -m venv venv

# macOS / Linux
source venv/bin/activate

# Windows
venv\Scripts\activate
```

### 3. Install dependencies

```bash
pip install -r requirements.txt
```

### 4. Set up environment variables

```bash
cp .env.example .env
```

Then open `.env` and fill in your values (see [Environment variables](#environment-variables) below).

---

## Environment variables

Create a `.env` file in the project root. Never commit this file.

```env
# Flask
SECRET_KEY=your_secret_key_here
FLASK_ENV=development

# MySQL database
DB_HOST=localhost
DB_PORT=3306
DB_NAME=careerpilot
DB_USER=root
DB_PASSWORD=your_mysql_password

# Assembled connection URL (used by SQLAlchemy)
DATABASE_URL=mysql+pymysql://${DB_USER}:${DB_PASSWORD}@${DB_HOST}:${DB_PORT}/${DB_NAME}

# Google Gemini API
GEMINI_API_KEY=your_gemini_api_key_here
```

A `.env.example` file with empty values is included in the repository as a reference.

---

## Database setup

### 1. Create the MySQL database

Log in to MySQL and run:

```sql
CREATE DATABASE careerpilot CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
```

### 2. Run migrations

```bash
flask db init        # Only needed the first time
flask db migrate -m "Initial schema"
flask db upgrade
```

The database schema is managed with Flask-Migrate (Alembic). Any future model changes should be followed by `flask db migrate` and `flask db upgrade`.

---

## Running the application

```bash
flask run
```

The app will be available at `http://127.0.0.1:5000`.

For development with auto-reload:

```bash
flask run --debug
```

---

## Team

This project was developed as a mini project at **[Your College Name]**, Department of Computer Science.

| Name | Roll no | Role |
|---|---|---|
| Arjun Santhosh | 19 | Developer |
| Aparna S Nair | 17 | Developer |

**Project coordinator:** Ms. Aswathy Chandran  
**Guide:** Ms. Josy Jose

---

<div align="center">
  <sub>Built with Flask, MySQL, and the Google Gemini API · CareerPilot AI © 2026</sub>
</div>
