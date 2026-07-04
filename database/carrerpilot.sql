-- ============================================================
-- CareerPilot AI – Database Schema (MySQL)
-- ============================================================

-- Create database (if not exists)
CREATE DATABASE IF NOT EXISTS careerpilot;
USE careerpilot;

-- ============================================================
-- 1. User table (authentication & role)
-- ============================================================
CREATE TABLE user (
    id INT PRIMARY KEY AUTO_INCREMENT,
    email VARCHAR(255) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    role ENUM('student', 'officer') NOT NULL DEFAULT 'student',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ============================================================
-- 2. Student profile (one‑to‑one with user)
-- ============================================================
CREATE TABLE student_profile (
    id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT UNIQUE NOT NULL,
    full_name VARCHAR(100),
    department VARCHAR(50),
    year VARCHAR(20),
    roll_number VARCHAR(20),
    cgpa DECIMAL(3,2),
    about_me TEXT,
    FOREIGN KEY (user_id) REFERENCES user(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ============================================================
-- 3. Skills (master list)
-- ============================================================
CREATE TABLE skill (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(50) UNIQUE NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ============================================================
-- 4. Student skills (junction with proficiency)
-- ============================================================
CREATE TABLE student_skill (
    id INT PRIMARY KEY AUTO_INCREMENT,
    student_id INT NOT NULL,
    skill_id INT NOT NULL,
    proficiency INT CHECK (proficiency BETWEEN 0 AND 100),
    FOREIGN KEY (student_id) REFERENCES student_profile(id) ON DELETE CASCADE,
    FOREIGN KEY (skill_id) REFERENCES skill(id) ON DELETE CASCADE,
    UNIQUE KEY (student_id, skill_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ============================================================
-- 5. Certifications
-- ============================================================
CREATE TABLE certification (
    id INT PRIMARY KEY AUTO_INCREMENT,
    student_id INT NOT NULL,
    title VARCHAR(200) NOT NULL,
    issuer VARCHAR(100),
    verification_status ENUM('pending', 'verified') DEFAULT 'pending',
    date_earned DATE,
    FOREIGN KEY (student_id) REFERENCES student_profile(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ============================================================
-- 6. Projects
-- ============================================================
CREATE TABLE project (
    id INT PRIMARY KEY AUTO_INCREMENT,
    student_id INT NOT NULL,
    title VARCHAR(200) NOT NULL,
    description TEXT,
    technologies VARCHAR(255),
    link VARCHAR(255),
    year YEAR,
    FOREIGN KEY (student_id) REFERENCES student_profile(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ============================================================
-- 7. Placement drives (created by officer)
-- ============================================================
CREATE TABLE `placement_drive` (
  `id` int(11) NOT NULL,
  `company_id` int(11) NOT NULL,
  `role` varchar(100) NOT NULL,
  `drive_date` date DEFAULT NULL,
  `status` enum('open','closed') DEFAULT 'open',
  `min_cgpa` decimal(3,2) DEFAULT NULL,
  `created_by` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
-- ============================================================
-- 8. Applications (students applying to drives)
-- ============================================================
CREATE TABLE application (
    id INT PRIMARY KEY AUTO_INCREMENT,
    student_id INT NOT NULL,
    drive_id INT NOT NULL,
    applied_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    status ENUM('applied', 'shortlisted', 'rejected', 'selected') DEFAULT 'applied',
    FOREIGN KEY (student_id) REFERENCES user(id) ON DELETE CASCADE,
    FOREIGN KEY (drive_id) REFERENCES placement_drive(id) ON DELETE CASCADE,
    UNIQUE KEY (student_id, drive_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ============================================================
-- 9. Mock interview sessions
-- ============================================================
CREATE TABLE interview_session (
    id INT PRIMARY KEY AUTO_INCREMENT,
    student_id INT NOT NULL,
    type ENUM('technical', 'hr') NOT NULL,
    date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    overall_score DECIMAL(3,1),
    feedback_json JSON,  -- stores per-question feedback as JSON array
    FOREIGN KEY (student_id) REFERENCES user(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ============================================================
-- 10. (Optional) Resume feedback cache
-- ============================================================
CREATE TABLE resume_feedback (
    id INT PRIMARY KEY AUTO_INCREMENT,
    student_id INT NOT NULL,
    generated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    suggestions JSON,
    FOREIGN KEY (student_id) REFERENCES user(id) ON DELETE CASCADE,
    UNIQUE KEY (student_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Table structure for table `company`
--

CREATE TABLE `company` (
  `id` int(11) NOT NULL,
  `company_name` varchar(100) NOT NULL,
  `website` varchar(255) DEFAULT NULL,
  `industry` varchar(100) DEFAULT NULL,
  `headquarters` varchar(100) DEFAULT NULL,
  `description` text DEFAULT NULL,
  `logo` varchar(255) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- ============================================================
-- Indexes for performance
-- ============================================================
CREATE INDEX idx_user_email ON user(email);
CREATE INDEX idx_student_user ON student_profile(user_id);
CREATE INDEX idx_skill_name ON skill(name);
CREATE INDEX idx_student_skill_student ON student_skill(student_id);
CREATE INDEX idx_cert_student ON certification(student_id);
CREATE INDEX idx_project_student ON project(student_id);
CREATE INDEX idx_drive_status ON placement_drive(status);
CREATE INDEX idx_drive_date ON placement_drive(drive_date);
CREATE INDEX idx_app_student ON application(student_id);
CREATE INDEX idx_app_drive ON application(drive_id);
CREATE INDEX idx_interview_student ON interview_session(student_id);


-- ============================================================
-- Optional: Insert a default officer user (password: admin123)
-- ============================================================
-- INSERT INTO user (email, password_hash, role) 
-- VALUES ('officer@college.edu', 'pbkdf2:sha256:260000$...', 'officer');
-- (Generate hash using Flask's generate_password_hash)

INSERT INTO skill (name) VALUES 
('HTML/CSS'), 
('JavaScript'), 
('React'), 
('TypeScript'), 
('Git'), 
('Python'), 
('SQL'), 
('Docker'), 
('REST APIs'), 
('System Design'),
('Data Analysis'),
('Excel'),
('Power BI'),
('Communication'),
('Teamwork'),
('Problem Solving');
