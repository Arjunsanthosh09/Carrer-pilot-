-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Oct 14, 2026 at 02:41 AM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `careerpilot`
--

-- --------------------------------------------------------

--
-- Table structure for table `application`
--

CREATE TABLE `application` (
  `id` int(11) NOT NULL,
  `student_id` int(11) NOT NULL,
  `drive_id` int(11) NOT NULL,
  `applied_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `status` enum('applied','shortlisted','rejected','selected') DEFAULT 'applied'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `application`
--

INSERT INTO `application` (`id`, `student_id`, `drive_id`, `applied_at`, `status`) VALUES
(1, 2, 2, '2026-10-05 09:01:04', 'applied');

-- --------------------------------------------------------

--
-- Table structure for table `certification`
--

CREATE TABLE `certification` (
  `id` int(11) NOT NULL,
  `student_id` int(11) NOT NULL,
  `title` varchar(200) NOT NULL,
  `issuer` varchar(100) DEFAULT NULL,
  `verification_status` enum('pending','verified') DEFAULT 'verified',
  `date_earned` date DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `certification`
--

INSERT INTO `certification` (`id`, `student_id`, `title`, `issuer`, `verification_status`, `date_earned`) VALUES
(1, 2, 'flutter', 'coursera', 'verified', '2026-07-09'),
(2, 2, 'python flask', 'coursera', 'pending', '2025-02-04'),
(3, 1, 'Full Stack Web Development with React', 'Coursera', 'verified', '2025-03-15'),
(4, 1, 'Machine Learning Specialization', 'DeepLearning.AI', 'verified', '2025-05-20'),
(5, 1, 'Cloud Architecture with AWS', 'Amazon Web Services', 'pending', '2025-07-10'),
(6, 1, 'Data Visualization with Tableau', 'Tableau Academic', 'verified', '2024-11-05'),
(7, 1, 'Python for Data Science', 'IIT Bombay', 'verified', '2024-09-12'),
(10, 2, 'Google Data Analytics Professional Certificate', 'Google / Coursera', 'verified', '2025-02-10'),
(11, 2, 'IBM Data Science Professional Certificate', 'IBM / Coursera', 'verified', '2025-04-15'),
(12, 2, 'AWS Certified Machine Learning – Specialty', 'Amazon Web Services', 'pending', '2025-06-20'),
(13, 2, 'Deep Learning Specialization', 'DeepLearning.AI', 'verified', '2024-11-08'),
(14, 2, 'PostgreSQL for Data Science', 'Udemy', 'verified', '2025-01-25'),
(15, 4, 'Meta Frontend Developer', 'Coursera', 'verified', '2025-03-15'),
(16, 4, 'AWS Cloud Practitioner', 'Amazon Web Services', 'verified', '2025-06-20'),
(17, 4, 'Python for Data Science', 'IIT Bombay', 'verified', '2024-09-12'),
(18, 5, 'Google Data Analytics Professional', 'Google / Coursera', 'verified', '2025-02-10'),
(19, 5, 'IBM Data Science Professional', 'IBM / Coursera', 'verified', '2025-04-15'),
(20, 5, 'Deep Learning Specialization', 'DeepLearning.AI', 'verified', '2024-11-08'),
(21, 5, 'AWS Certified ML Specialty', 'Amazon Web Services', 'pending', '2025-06-20'),
(22, 7, 'Full Stack Web Development', 'Udemy', 'verified', '2025-01-20'),
(23, 7, 'PostgreSQL for Data Science', 'Udemy', 'verified', '2025-01-25'),
(24, 8, 'Docker for Beginners', 'Udemy', 'pending', '2025-08-10');

-- --------------------------------------------------------

--
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

--
-- Dumping data for table `company`
--

INSERT INTO `company` (`id`, `company_name`, `website`, `industry`, `headquarters`, `description`, `logo`, `created_at`) VALUES
(1, 'Zoho Corp', 'https://zoho.com', 'Technology', NULL, NULL, NULL, '2026-09-04 12:33:11'),
(2, 'Infosys', 'https://infosys.com', 'IT Services', NULL, NULL, NULL, '2026-09-04 12:33:11'),
(3, 'Deloitte', 'https://deloitte.com', 'Consulting', NULL, NULL, NULL, '2026-09-04 12:33:11'),
(4, 'Google', 'https://www.google.com', 'Information Technology', 'Mountain View, California, USA', 'Google is a multinational technology company.', NULL, '2026-09-05 14:06:53'),
(5, 'Microsoft', 'https://www.microsoft.com', 'Software & Cloud Computing', 'Redmond, Washington, USA', 'Microsoft develops software, cloud services, and operating systems.', NULL, '2026-09-05 14:06:53'),
(6, 'Amazon', 'https://www.amazon.com', 'E-Commerce & Cloud Computing', 'Seattle, Washington, USA', 'Amazon is a global technology company focusing on e-commerce and cloud computing.', NULL, '2026-09-05 14:06:53');

-- --------------------------------------------------------

--
-- Table structure for table `education`
--

CREATE TABLE `education` (
  `id` int(11) NOT NULL,
  `student_id` int(11) NOT NULL,
  `level` enum('10th','12th','UG','PG','PhD','Diploma','Other') NOT NULL,
  `degree_name` varchar(150) DEFAULT NULL,
  `institution` varchar(200) DEFAULT NULL,
  `field_of_study` varchar(100) DEFAULT NULL,
  `start_year` year(4) DEFAULT NULL,
  `end_year` year(4) DEFAULT NULL,
  `grade_type` enum('CGPA','Percentage') DEFAULT 'CGPA',
  `grade_value` decimal(5,2) DEFAULT NULL,
  `location` varchar(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `education`
--

INSERT INTO `education` (`id`, `student_id`, `level`, `degree_name`, `institution`, `field_of_study`, `start_year`, `end_year`, `grade_type`, `grade_value`, `location`) VALUES
(1, 2, '10th', '', 'Nss hss perunna', '', '2018', '2019', 'Percentage', 93.04, 'chanagancherry'),
(2, 2, '12th', 'Computer Science', 'Nss Hss Perunna', 'Computer Science', '2020', '2022', 'Percentage', 75.00, 'chanagancherry'),
(3, 2, 'UG', 'BCA', 'Kristu Jyoti College of Management and Technology', 'Computer Application', '2022', '2025', 'CGPA', 7.76, 'chanagancherry'),
(4, 2, 'PG', 'MCA', 'Mar Athanasios College For Advanced Studies Tiruvalla (MACFAST)', 'Computer Application', '2025', '2027', 'CGPA', 8.72, 'Tiruvalla ,Kerala'),
(5, 4, 'PG', 'Master of Computer Application', 'Mar Athanasios College for Advanced Studies', 'Computer Science', '2025', NULL, 'CGPA', 8.79, NULL),
(6, 4, 'UG', 'Bachelor of Computer Applications', 'Kristu Jyoti College', 'Computer Science', '2022', '2025', 'CGPA', 7.90, NULL),
(7, 4, '12th', 'Higher Secondary', 'NSS HSS Changanasserry', NULL, '2020', '2022', 'CGPA', 7.50, NULL),
(8, 5, 'PG', 'M.Sc Data Science', 'CUSAT', 'Data Science', '2025', NULL, 'CGPA', 8.92, NULL),
(9, 5, 'UG', 'B.Sc Statistics', 'St. Teresas College', 'Statistics', '2022', '2025', 'CGPA', 8.60, NULL),
(10, 6, 'UG', 'B.Tech ECE', 'Government Engineering College', 'Electronics', '2022', '2026', 'CGPA', 6.20, NULL),
(11, 7, 'UG', 'B.Tech CSE', 'NIT Calicut', 'Computer Science', '2022', '2026', 'CGPA', 9.10, NULL),
(12, 7, '12th', 'Higher Secondary', 'St. Thomas HSS', NULL, '2020', '2022', 'Percentage', 95.00, NULL),
(13, 8, 'UG', 'B.Tech IT', 'CUSAT', 'Information Technology', '2022', '2026', 'CGPA', 7.50, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `experience`
--

CREATE TABLE `experience` (
  `id` int(11) NOT NULL,
  `student_id` int(11) NOT NULL,
  `type` enum('Internship','Full-Time','Part-Time','Freelance','Volunteer') DEFAULT 'Internship',
  `job_title` varchar(150) NOT NULL,
  `company` varchar(200) NOT NULL,
  `location` varchar(100) DEFAULT NULL,
  `start_date` date DEFAULT NULL,
  `end_date` date DEFAULT NULL,
  `is_current` tinyint(1) DEFAULT 0,
  `description` text DEFAULT NULL,
  `technologies` varchar(255) DEFAULT NULL,
  `link` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `experience`
--

INSERT INTO `experience` (`id`, `student_id`, `type`, `job_title`, `company`, `location`, `start_date`, `end_date`, `is_current`, `description`, `technologies`, `link`) VALUES
(1, 4, 'Internship', 'Frontend Developer Intern', 'Zoho Corp', 'Chennai, India', '2025-06-01', '2025-08-31', 0, 'Built responsive React components used across 3 product teams. Improved page load time by 40%.', 'React, TypeScript, Tailwind CSS', NULL),
(2, 5, 'Internship', 'Data Analyst Intern', 'Infosys', 'Bengaluru, India', '2025-05-15', '2025-07-30', 0, 'Analyzed customer behavior data using Python and Tableau. Built dashboards for 5 business teams.', 'Python, Pandas, Tableau, SQL', NULL),
(3, 7, 'Internship', 'Backend Developer Intern', 'Razorpay', 'Bengaluru, India', '2025-06-01', '2025-08-15', 0, 'Developed REST APIs for payment processing. Optimized database queries reducing response time by 60%.', 'Python, Flask, PostgreSQL, Redis', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `interview_question_bank`
--

CREATE TABLE `interview_question_bank` (
  `id` int(11) NOT NULL,
  `category` enum('technical','hr','aptitude') NOT NULL,
  `sub_category` varchar(50) DEFAULT NULL,
  `question` text NOT NULL,
  `sample_answer` text DEFAULT NULL,
  `difficulty` enum('easy','medium','hard') DEFAULT 'medium',
  `expected_duration` int(11) DEFAULT 60
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `interview_question_bank`
--

INSERT INTO `interview_question_bank` (`id`, `category`, `sub_category`, `question`, `sample_answer`, `difficulty`, `expected_duration`) VALUES
(1, 'technical', 'Python', 'What is the difference between a list and a tuple in Python?', 'A list is mutable (can be changed after creation), while a tuple is immutable (cannot be changed). Lists use square brackets [], tuples use parentheses ().', 'easy', 60),
(2, 'technical', 'Python', 'Explain the concept of decorators in Python.', 'Decorators are functions that modify the behavior of another function. They allow you to wrap a function with additional functionality without changing its code.', 'medium', 90),
(3, 'technical', 'React', 'What is the difference between state and props in React?', 'Props are read-only data passed from parent to child components. State is mutable data managed within a component using setState().', 'easy', 60),
(4, 'technical', 'JavaScript', 'What is the difference between == and === in JavaScript?', '== compares values with type coercion, while === compares both value and type without coercion. Always use === for strict equality.', 'easy', 60),
(5, 'technical', 'SQL', 'What is the difference between INNER JOIN and LEFT JOIN?', 'INNER JOIN returns only matching rows from both tables. LEFT JOIN returns all rows from the left table and matching rows from the right table.', 'easy', 60),
(6, 'hr', 'behavioral', 'Tell me about yourself.', 'I am a passionate Computer Science student with strong skills in Python, React, and SQL. I enjoy building full-stack applications and I am looking for an opportunity to apply my skills.', 'easy', 90),
(7, 'hr', 'behavioral', 'Why do you want to work for our company?', 'I am impressed by your company\'s innovative culture. I believe my skills in full-stack development align well with your team\'s needs.', 'medium', 90),
(8, 'hr', 'behavioral', 'Tell me about a time you faced a challenge and how you overcame it.', 'During my placement platform project, I faced challenges integrating the AI API. I solved it by breaking down the problem and reading documentation carefully.', 'medium', 120),
(9, 'hr', 'behavioral', 'Where do you see yourself in 5 years?', 'In 5 years, I see myself as a senior developer leading technical projects. I want to continue learning and contributing to open-source communities.', 'medium', 90),
(10, 'aptitude', 'logical', 'What is the next number in the sequence: 2, 6, 12, 20, 30, ?', '42. The pattern is n*(n+1): 1*2=2, 2*3=6, 3*4=12, 4*5=20, 5*6=30, 6*7=42.', 'easy', 60),
(11, 'technical', 'Python', 'What is the difference between a list and a tuple in Python?', 'A list is mutable (can be changed after creation), while a tuple is immutable (cannot be changed). Lists use square brackets [], tuples use parentheses (). Lists are slower for iteration but faster for modifications.', 'easy', 60),
(12, 'technical', 'Python', 'Explain the concept of decorators in Python.', 'Decorators are functions that modify the behavior of another function. They allow you to wrap a function with additional functionality without changing its code. They are commonly used for logging, authentication, and timing.', 'medium', 90),
(13, 'technical', 'Python', 'What is the Global Interpreter Lock (GIL) in Python?', 'The GIL is a mutex that prevents multiple native threads from executing Python bytecode simultaneously. It ensures thread safety but limits performance on multi-core systems.', 'hard', 90),
(14, 'technical', 'React', 'What is the difference between state and props in React?', 'Props are read-only data passed from parent to child components. State is mutable data managed within a component. Props are immutable; state can be updated using setState().', 'easy', 60),
(15, 'technical', 'React', 'Explain the useEffect hook in React.', 'useEffect is a hook that runs side effects in functional components. It replaces lifecycle methods like componentDidMount, componentDidUpdate, and componentWillUnmount.', 'medium', 90),
(16, 'technical', 'JavaScript', 'What is the difference between == and === in JavaScript?', '== compares values with type coercion (converts types if different). === compares both value and type without coercion. It is recommended to use === for strict equality.', 'easy', 60),
(17, 'technical', 'JavaScript', 'Explain closures in JavaScript.', 'A closure is a function that remembers its lexical scope even when executed outside that scope. It allows a function to access variables from an outer function after the outer function has returned.', 'medium', 90),
(18, 'technical', 'SQL', 'What is the difference between INNER JOIN and LEFT JOIN?', 'INNER JOIN returns only matching rows from both tables. LEFT JOIN returns all rows from the left table and matching rows from the right table, with NULL for non-matching rows.', 'easy', 60),
(19, 'technical', 'SQL', 'Explain the difference between WHERE and HAVING clauses.', 'WHERE filters rows before grouping, HAVING filters groups after GROUP BY. HAVING is used with aggregate functions like COUNT, SUM, AVG.', 'medium', 60),
(20, 'technical', 'SQL', 'What is a subquery and when would you use it?', 'A subquery is a query nested inside another query. It can be used in SELECT, INSERT, UPDATE, DELETE statements. Useful for filtering based on aggregated data or complex conditions.', 'medium', 90),
(21, 'hr', 'behavioral', 'Tell me about yourself.', 'I am a passionate Computer Science student with strong skills in Python, React, and SQL. I enjoy building full-stack applications and have completed several projects. I am looking for an opportunity to apply my skills and grow as a software developer.', 'easy', 90),
(22, 'hr', 'behavioral', 'Why do you want to work for our company?', 'I am impressed by your company\'s innovative culture and commitment to technology. I believe my skills in full-stack development align well with your team\'s needs and I am excited about the opportunity to contribute.', 'medium', 90),
(23, 'hr', 'behavioral', 'Tell me about a time you faced a challenge and how you overcame it.', 'During my placement platform project, I faced challenges integrating the AI API. I solved it by breaking down the problem, reading documentation, and testing with smaller examples. This taught me the importance of patience and systematic debugging.', 'medium', 120),
(24, 'hr', 'behavioral', 'Where do you see yourself in 5 years?', 'In 5 years, I see myself as a senior developer leading technical projects. I want to continue learning and contributing to open-source communities and mentoring junior developers.', 'medium', 90),
(25, 'hr', 'behavioral', 'What are your strengths and weaknesses?', 'My strengths include problem-solving, adaptability, and communication. My weakness is that I can be too focused on details sometimes, but I am working on balancing efficiency with quality.', 'easy', 90),
(26, 'hr', 'communication', 'Describe a time you worked in a team. What was your role?', 'I worked on a team project developing a web application. My role was lead developer, where I coordinated with team members, ensured timely delivery, and focused on backend API development.', 'medium', 90),
(27, 'hr', 'communication', 'How do you handle conflicts in a team?', 'I believe in open communication. I listen to both sides, understand perspectives, and find common ground. I focus on the project goals rather than personal differences.', 'medium', 90),
(28, 'hr', 'leadership', 'Have you ever led a team or a project?', 'Yes, I led a team of 4 developers to build a full-stack application. I was responsible for task allocation, code reviews, and ensuring project milestones were met.', 'medium', 90),
(29, 'aptitude', 'logical', 'If you have 8 balls, one is heavier than the rest. How can you find the heavier ball in 2 weighings?', 'Divide balls into 3,3,2. Weigh 3 vs 3. If balanced, weigh remaining 2. If not balanced, take heavier 3, weigh 1 vs 1. The heavier one is the answer.', 'medium', 90),
(30, 'aptitude', 'logical', 'What is the next number in the sequence: 2, 6, 12, 20, 30, ?', '42. The pattern is n*(n+1): 1*2=2, 2*3=6, 3*4=12, 4*5=20, 5*6=30, 6*7=42.', 'easy', 60),
(31, 'aptitude', 'numerical', 'If a train travels 60 km in 1.5 hours, what is its speed in km/h?', '40 km/h. Speed = Distance/Time = 60/1.5 = 40 km/h.', 'easy', 60),
(32, 'aptitude', 'verbal', 'What is the synonym of \"Benevolent\"?', 'Kind, generous, charitable.', 'easy', 60);

-- --------------------------------------------------------

--
-- Table structure for table `interview_session`
--

CREATE TABLE `interview_session` (
  `id` int(11) NOT NULL,
  `student_id` int(11) NOT NULL,
  `type` enum('technical','hr','aptitude') NOT NULL,
  `date` timestamp NOT NULL DEFAULT current_timestamp(),
  `overall_score` decimal(3,1) DEFAULT NULL,
  `feedback_json` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`feedback_json`)),
  `total_questions` int(11) DEFAULT 0,
  `questions` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`questions`)),
  `status` enum('pending','in_progress','completed','cancelled') DEFAULT 'pending'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `interview_session`
--

INSERT INTO `interview_session` (`id`, `student_id`, `type`, `date`, `overall_score`, `feedback_json`, `total_questions`, `questions`, `status`) VALUES
(1, 2, 'technical', '2026-09-28 07:10:23', NULL, NULL, 5, '[{\"question_id\": 18, \"question\": \"What is the difference between INNER JOIN and LEFT JOIN?\", \"answer\": \"\", \"score\": null, \"feedback\": \"\"}, {\"question_id\": 2, \"question\": \"Explain the concept of decorators in Python.\", \"answer\": \"\", \"score\": null, \"feedback\": \"\"}, {\"question_id\": 17, \"question\": \"Explain closures in JavaScript.\", \"answer\": \"\", \"score\": null, \"feedback\": \"\"}, {\"question_id\": 12, \"question\": \"Explain the concept of decorators in Python.\", \"answer\": \"\", \"score\": null, \"feedback\": \"\"}, {\"question_id\": 19, \"question\": \"Explain the difference between WHERE and HAVING clauses.\", \"answer\": \"\", \"score\": null, \"feedback\": \"\"}]', 'cancelled'),
(2, 2, 'technical', '2026-09-28 07:10:36', NULL, NULL, 5, '[{\"question_id\": 12, \"question\": \"Explain the concept of decorators in Python.\", \"answer\": \"decorators are used to analyze the result of list\", \"score\": 2.0, \"feedback\": \"The answer is inaccurate and overly brief; decorators are not for analyzing list results but for modifying or extending the behavior of functions or methods. A better response would explain that decorators are higher-order functions that wrap another function, often using the @syntax, and give examples of common use cases.\"}, {\"question_id\": 20, \"question\": \"What is a subquery and when would you use it?\", \"answer\": \"\", \"score\": null, \"feedback\": \"\"}, {\"question_id\": 5, \"question\": \"What is the difference between INNER JOIN and LEFT JOIN?\", \"answer\": \"\", \"score\": null, \"feedback\": \"\"}, {\"question_id\": 13, \"question\": \"What is the Global Interpreter Lock (GIL) in Python?\", \"answer\": \"\", \"score\": null, \"feedback\": \"\"}, {\"question_id\": 11, \"question\": \"What is the difference between a list and a tuple in Python?\", \"answer\": \"\", \"score\": null, \"feedback\": \"\"}]', 'in_progress'),
(3, 2, 'aptitude', '2026-09-28 07:15:24', NULL, NULL, 5, '[{\"question_id\": 10, \"question\": \"What is the next number in the sequence: 2, 6, 12, 20, 30, ?\", \"answer\": \"\", \"score\": null, \"feedback\": \"\"}, {\"question_id\": 29, \"question\": \"If you have 8 balls, one is heavier than the rest. How can you find the heavier ball in 2 weighings?\", \"answer\": \"\", \"score\": null, \"feedback\": \"\"}, {\"question_id\": 30, \"question\": \"What is the next number in the sequence: 2, 6, 12, 20, 30, ?\", \"answer\": \"\", \"score\": null, \"feedback\": \"\"}, {\"question_id\": 31, \"question\": \"If a train travels 60 km in 1.5 hours, what is its speed in km/h?\", \"answer\": \"\", \"score\": null, \"feedback\": \"\"}, {\"question_id\": 32, \"question\": \"What is the synonym of \\\"Benevolent\\\"?\", \"answer\": \"\", \"score\": null, \"feedback\": \"\"}]', 'cancelled'),
(4, 2, 'technical', '2026-09-28 07:19:45', NULL, NULL, 5, '[{\"question_id\": 5, \"question\": \"What is the difference between INNER JOIN and LEFT JOIN?\", \"answer\": \"\", \"score\": null, \"feedback\": \"\"}, {\"question_id\": 4, \"question\": \"What is the difference between == and === in JavaScript?\", \"answer\": \"\", \"score\": null, \"feedback\": \"\"}, {\"question_id\": 16, \"question\": \"What is the difference between == and === in JavaScript?\", \"answer\": \"\", \"score\": null, \"feedback\": \"\"}, {\"question_id\": 14, \"question\": \"What is the difference between state and props in React?\", \"answer\": \"\", \"score\": null, \"feedback\": \"\"}, {\"question_id\": 12, \"question\": \"Explain the concept of decorators in Python.\", \"answer\": \"\", \"score\": null, \"feedback\": \"\"}]', 'in_progress'),
(5, 2, 'technical', '2026-09-28 07:19:51', NULL, NULL, 5, '[{\"question_id\": 12, \"question\": \"Explain the concept of decorators in Python.\", \"answer\": \"\", \"score\": null, \"feedback\": \"\"}, {\"question_id\": 4, \"question\": \"What is the difference between == and === in JavaScript?\", \"answer\": \"\", \"score\": null, \"feedback\": \"\"}, {\"question_id\": 19, \"question\": \"Explain the difference between WHERE and HAVING clauses.\", \"answer\": \"\", \"score\": null, \"feedback\": \"\"}, {\"question_id\": 1, \"question\": \"What is the difference between a list and a tuple in Python?\", \"answer\": \"\", \"score\": null, \"feedback\": \"\"}, {\"question_id\": 5, \"question\": \"What is the difference between INNER JOIN and LEFT JOIN?\", \"answer\": \"\", \"score\": null, \"feedback\": \"\"}]', 'in_progress'),
(6, 2, 'technical', '2026-09-28 07:19:55', NULL, NULL, 5, '[{\"question_id\": 1, \"question\": \"What is the difference between a list and a tuple in Python?\", \"answer\": \"\", \"score\": null, \"feedback\": \"\"}, {\"question_id\": 11, \"question\": \"What is the difference between a list and a tuple in Python?\", \"answer\": \"\", \"score\": null, \"feedback\": \"\"}, {\"question_id\": 15, \"question\": \"Explain the useEffect hook in React.\", \"answer\": \"\", \"score\": null, \"feedback\": \"\"}, {\"question_id\": 12, \"question\": \"Explain the concept of decorators in Python.\", \"answer\": \"\", \"score\": null, \"feedback\": \"\"}, {\"question_id\": 5, \"question\": \"What is the difference between INNER JOIN and LEFT JOIN?\", \"answer\": \"\", \"score\": null, \"feedback\": \"\"}]', 'in_progress'),
(7, 2, 'technical', '2026-09-28 07:21:31', NULL, NULL, 5, '[{\"question_id\": 14, \"question\": \"What is the difference between state and props in React?\", \"answer\": \"\", \"score\": null, \"feedback\": \"\"}, {\"question_id\": 18, \"question\": \"What is the difference between INNER JOIN and LEFT JOIN?\", \"answer\": \"\", \"score\": null, \"feedback\": \"\"}, {\"question_id\": 15, \"question\": \"Explain the useEffect hook in React.\", \"answer\": \"\", \"score\": null, \"feedback\": \"\"}, {\"question_id\": 2, \"question\": \"Explain the concept of decorators in Python.\", \"answer\": \"\", \"score\": null, \"feedback\": \"\"}, {\"question_id\": 1, \"question\": \"What is the difference between a list and a tuple in Python?\", \"answer\": \"\", \"score\": null, \"feedback\": \"\"}]', 'cancelled'),
(8, 2, 'hr', '2026-09-28 07:34:41', NULL, NULL, 5, '[{\"question_id\": 27, \"question\": \"How do you handle conflicts in a team?\", \"answer\": \"\", \"score\": null, \"feedback\": \"\"}, {\"question_id\": 23, \"question\": \"Tell me about a time you faced a challenge and how you overcame it.\", \"answer\": \"\", \"score\": null, \"feedback\": \"\"}, {\"question_id\": 22, \"question\": \"Why do you want to work for our company?\", \"answer\": \"\", \"score\": null, \"feedback\": \"\"}, {\"question_id\": 25, \"question\": \"What are your strengths and weaknesses?\", \"answer\": \"\", \"score\": null, \"feedback\": \"\"}, {\"question_id\": 21, \"question\": \"Tell me about yourself.\", \"answer\": \"\", \"score\": null, \"feedback\": \"\"}]', 'in_progress'),
(9, 2, 'technical', '2026-10-04 07:49:28', NULL, NULL, 5, '[{\"question_id\": 2, \"question\": \"Explain the concept of decorators in Python.\", \"answer\": \"\", \"score\": null, \"feedback\": \"\"}, {\"question_id\": 16, \"question\": \"What is the difference between == and === in JavaScript?\", \"answer\": \"\", \"score\": null, \"feedback\": \"\"}, {\"question_id\": 19, \"question\": \"Explain the difference between WHERE and HAVING clauses.\", \"answer\": \"\", \"score\": null, \"feedback\": \"\"}, {\"question_id\": 4, \"question\": \"What is the difference between == and === in JavaScript?\", \"answer\": \"\", \"score\": null, \"feedback\": \"\"}, {\"question_id\": 1, \"question\": \"What is the difference between a list and a tuple in Python?\", \"answer\": \"\", \"score\": null, \"feedback\": \"\"}]', 'cancelled'),
(10, 2, 'technical', '2026-10-04 07:49:53', NULL, NULL, 5, '[{\"question_id\": 11, \"question\": \"What is the difference between a list and a tuple in Python?\", \"answer\": \"\", \"score\": null, \"feedback\": \"\"}, {\"question_id\": 5, \"question\": \"What is the difference between INNER JOIN and LEFT JOIN?\", \"answer\": \"\", \"score\": null, \"feedback\": \"\"}, {\"question_id\": 16, \"question\": \"What is the difference between == and === in JavaScript?\", \"answer\": \"\", \"score\": null, \"feedback\": \"\"}, {\"question_id\": 19, \"question\": \"Explain the difference between WHERE and HAVING clauses.\", \"answer\": \"\", \"score\": null, \"feedback\": \"\"}, {\"question_id\": 2, \"question\": \"Explain the concept of decorators in Python.\", \"answer\": \"\", \"score\": null, \"feedback\": \"\"}]', 'cancelled'),
(11, 2, 'technical', '2026-10-07 08:06:52', NULL, NULL, 5, '[{\"question_id\": 19, \"question\": \"Explain the difference between WHERE and HAVING clauses.\", \"answer\": \"\", \"score\": null, \"feedback\": \"\"}, {\"question_id\": 18, \"question\": \"What is the difference between INNER JOIN and LEFT JOIN?\", \"answer\": \"\", \"score\": null, \"feedback\": \"\"}, {\"question_id\": 14, \"question\": \"What is the difference between state and props in React?\", \"answer\": \"\", \"score\": null, \"feedback\": \"\"}, {\"question_id\": 16, \"question\": \"What is the difference between == and === in JavaScript?\", \"answer\": \"\", \"score\": null, \"feedback\": \"\"}, {\"question_id\": 13, \"question\": \"What is the Global Interpreter Lock (GIL) in Python?\", \"answer\": \"\", \"score\": null, \"feedback\": \"\"}]', 'cancelled'),
(12, 2, 'technical', '2026-10-07 08:07:18', NULL, NULL, 5, '[{\"question_id\": 14, \"question\": \"What is the difference between state and props in React?\", \"answer\": \"\", \"score\": null, \"feedback\": \"\"}, {\"question_id\": 1, \"question\": \"What is the difference between a list and a tuple in Python?\", \"answer\": \"\", \"score\": null, \"feedback\": \"\"}, {\"question_id\": 3, \"question\": \"What is the difference between state and props in React?\", \"answer\": \"\", \"score\": null, \"feedback\": \"\"}, {\"question_id\": 16, \"question\": \"What is the difference between == and === in JavaScript?\", \"answer\": \"\", \"score\": null, \"feedback\": \"\"}, {\"question_id\": 15, \"question\": \"Explain the useEffect hook in React.\", \"answer\": \"\", \"score\": null, \"feedback\": \"\"}]', 'cancelled'),
(13, 100, 'technical', '2026-10-08 03:53:22', 7.8, NULL, 3, '[{\"question_id\": 1, \"question\": \"What is the difference between state and props in React?\", \"answer\": \"Props are read-only data passed from parent to child. State is mutable data managed within a component.\", \"score\": 8, \"feedback\": \"Correct distinction. Consider mentioning re-render triggers.\", \"clarity\": 8, \"correctness\": 8, \"completeness\": 7, \"communication\": 8}, {\"question_id\": 6, \"question\": \"What is the difference between == and === in JavaScript?\", \"answer\": \"== compares with type coercion, === compares both value and type without coercion.\", \"score\": 9, \"feedback\": \"Accurate and concise. Well done.\", \"clarity\": 9, \"correctness\": 9, \"completeness\": 9, \"communication\": 9}, {\"question_id\": 4, \"question\": \"Explain useEffect hook in React.\", \"answer\": \"useEffect runs side effects in functional components. Replaces componentDidMount and others.\", \"score\": 7, \"feedback\": \"Good but could be more detailed on dependency array.\", \"clarity\": 7, \"correctness\": 7, \"completeness\": 6, \"communication\": 8}]', 'completed'),
(14, 100, 'hr', '2026-10-08 03:53:22', 7.2, NULL, 3, '[{\"question_id\": 11, \"question\": \"Tell me about yourself.\", \"answer\": \"I am a full-stack developer passionate about AI-powered web applications.\", \"score\": 7, \"feedback\": \"Good but add more specifics like achievements.\", \"clarity\": 8, \"correctness\": 7, \"completeness\": 6, \"communication\": 8}, {\"question_id\": 14, \"question\": \"Where do you see yourself in 5 years?\", \"answer\": \"As a senior developer leading technical projects and mentoring juniors.\", \"score\": 8, \"feedback\": \"Clear vision. Add specific technologies you want to master.\", \"clarity\": 8, \"correctness\": 8, \"completeness\": 7, \"communication\": 8}, {\"question_id\": 15, \"question\": \"What are your strengths and weaknesses?\", \"answer\": \"Strengths: problem-solving, adaptability. Weakness: too detail-focused sometimes.\", \"score\": 7, \"feedback\": \"Standard answer. Use specific examples from your experience.\", \"clarity\": 7, \"correctness\": 7, \"completeness\": 6, \"communication\": 7}]', 'completed'),
(15, 101, 'technical', '2026-10-08 03:53:22', 8.2, NULL, 2, '[{\"question_id\": 2, \"question\": \"Explain decorators in Python.\", \"answer\": \"Decorators modify function behavior without changing the code. Used for logging and authentication.\", \"score\": 8, \"feedback\": \"Solid answer with practical uses mentioned.\", \"clarity\": 8, \"correctness\": 8, \"completeness\": 7, \"communication\": 8}, {\"question_id\": 3, \"question\": \"What is the GIL in Python?\", \"answer\": \"GIL is a mutex preventing multiple threads from executing Python bytecode simultaneously.\", \"score\": 9, \"feedback\": \"Excellent, accurate explanation.\", \"clarity\": 9, \"correctness\": 9, \"completeness\": 9, \"communication\": 9}]', 'completed'),
(16, 102, 'technical', '2026-10-08 03:53:22', 4.5, NULL, 2, '[{\"question_id\": 1, \"question\": \"What is the difference between a list and a tuple?\", \"answer\": \"List is like an array, tuple is also like an array.\", \"score\": 3, \"feedback\": \"Incomplete answer. Mention mutability and syntax differences.\", \"clarity\": 5, \"correctness\": 3, \"completeness\": 2, \"communication\": 5}, {\"question_id\": 7, \"question\": \"Explain closures in JavaScript.\", \"answer\": \"Closures are functions inside functions.\", \"score\": 3, \"feedback\": \"Too brief. Explain lexical scope and practical use cases.\", \"clarity\": 4, \"correctness\": 3, \"completeness\": 3, \"communication\": 5}]', 'completed'),
(17, 104, 'aptitude', '2026-10-08 03:53:22', 6.5, NULL, 2, '[{\"question_id\": 19, \"question\": \"Sequence: 2, 6, 12, 20, 30, ?\", \"answer\": \"42. The pattern is n*(n+1).\", \"score\": 9, \"feedback\": \"Correct with clear reasoning.\", \"clarity\": 9, \"correctness\": 10, \"completeness\": 9, \"communication\": 9}, {\"question_id\": 21, \"question\": \"Train speed: 60 km in 1.5 hours\", \"answer\": \"40 km/h.\", \"score\": 4, \"feedback\": \"Correct answer but missing calculation steps.\", \"clarity\": 5, \"correctness\": 6, \"completeness\": 2, \"communication\": 5}]', 'completed'),
(18, 2, 'aptitude', '2026-10-08 03:57:36', 8.2, NULL, 3, '[{\"question_id\": 20, \"question\": \"If you have 8 balls, one is heavier than the rest. How can you find it in 2 weighings?\", \"answer\": \"Divide balls into 3,3,2. Weigh 3 vs 3. If balanced, weigh remaining 2. If not, take heavier 3, weigh 1 vs 1.\", \"score\": 9, \"feedback\": \"Excellent logical reasoning with step-by-step approach.\", \"clarity\": 9, \"correctness\": 10, \"completeness\": 9, \"communication\": 8}, {\"question_id\": 21, \"question\": \"What is the next number in the sequence: 2, 6, 12, 20, 30, ?\", \"answer\": \"42. The pattern is n*(n+1).\", \"score\": 9, \"feedback\": \"Correct answer with clear pattern explanation.\", \"clarity\": 9, \"correctness\": 9, \"completeness\": 9, \"communication\": 9}, {\"question_id\": 22, \"question\": \"If a train travels 60 km in 1.5 hours, what is its speed in km/h?\", \"answer\": \"40 km/h. Speed = Distance/Time = 60/1.5 = 40 km/h.\", \"score\": 7, \"feedback\": \"Correct answer with proper formula.\", \"clarity\": 8, \"correctness\": 8, \"completeness\": 6, \"communication\": 7}]', 'completed'),
(19, 2, 'aptitude', '2026-10-08 03:57:36', 7.5, NULL, 2, '[{\"question_id\": 23, \"question\": \"What is the synonym of \\\"Benevolent\\\"?\", \"answer\": \"Kind, generous, charitable.\", \"score\": 8, \"feedback\": \"Accurate response.\", \"clarity\": 8, \"correctness\": 9, \"completeness\": 7, \"communication\": 8}, {\"question_id\": 21, \"question\": \"What is the next number in the sequence: 2, 6, 12, 20, 30, ?\", \"answer\": \"It should be around 40 based on the increasing pattern.\", \"score\": 7, \"feedback\": \"Close answer but not precise. The exact answer is 42.\", \"clarity\": 7, \"correctness\": 6, \"completeness\": 7, \"communication\": 8}]', 'completed'),
(20, 2, 'hr', '2026-10-08 03:57:36', 8.5, NULL, 4, '[{\"question_id\": 11, \"question\": \"Tell me about yourself.\", \"answer\": \"I am a final-year Data Science student with strong skills in Python, SQL, and machine learning. I have built end-to-end ML pipelines and won a state-level hackathon. I am passionate about building AI-powered solutions that solve real problems.\", \"score\": 9, \"feedback\": \"Excellent structure with skills, achievements, and motivation.\", \"clarity\": 9, \"correctness\": 9, \"completeness\": 9, \"communication\": 10}, {\"question_id\": 12, \"question\": \"Why do you want to work for our company?\", \"answer\": \"Your company leads in data-driven innovation, and I want to contribute to projects that impact millions. My skills in ML and data pipelines align perfectly with your data team.\", \"score\": 8, \"feedback\": \"Good alignment with company values. Could mention specific products.\", \"clarity\": 8, \"correctness\": 8, \"completeness\": 7, \"communication\": 9}, {\"question_id\": 13, \"question\": \"Tell me about a time you faced a challenge and how you overcame it.\", \"answer\": \"During my final-year project, our ML model had low accuracy. I analyzed the data, applied feature engineering, and switched to XGBoost. The accuracy improved from 68% to 87%, and we presented the project at an international conference.\", \"score\": 9, \"feedback\": \"Excellent use of STAR method with quantifiable results.\", \"clarity\": 9, \"correctness\": 9, \"completeness\": 10, \"communication\": 9}, {\"question_id\": 17, \"question\": \"How do you handle conflicts in a team?\", \"answer\": \"I believe in open communication. I listen to both perspectives, focus on the project goals, and find common ground. In my last team project, this approach helped us resolve a disagreement about tech stack choices within a day.\", \"score\": 8, \"feedback\": \"Good framework with real example. Keep it up.\", \"clarity\": 8, \"correctness\": 8, \"completeness\": 8, \"communication\": 9}]', 'completed'),
(21, 2, 'hr', '2026-10-08 03:57:36', 7.0, NULL, 2, '[{\"question_id\": 14, \"question\": \"Where do you see yourself in 5 years?\", \"answer\": \"I want to become a senior data scientist leading ML projects and mentoring junior team members.\", \"score\": 7, \"feedback\": \"Clear goal. Add specific technologies or industries you want to specialize in.\", \"clarity\": 8, \"correctness\": 7, \"completeness\": 6, \"communication\": 7}, {\"question_id\": 15, \"question\": \"What are your strengths and weaknesses?\", \"answer\": \"My strengths are analytical thinking and problem-solving. My weakness is that I can be too focused on details, but I am learning to prioritize.\", \"score\": 7, \"feedback\": \"Standard answer. Use specific examples from your projects.\", \"clarity\": 7, \"correctness\": 7, \"completeness\": 6, \"communication\": 7}]', 'completed'),
(22, 2, 'technical', '2026-10-08 03:57:36', 8.0, NULL, 2, '[{\"question_id\": 1, \"question\": \"What is the difference between a list and a tuple in Python?\", \"answer\": \"Lists are mutable, tuples are immutable. Lists use brackets, tuples use parentheses.\", \"score\": 8, \"feedback\": \"Correct and concise.\", \"clarity\": 9, \"correctness\": 8, \"completeness\": 7, \"communication\": 8}, {\"question_id\": 8, \"question\": \"What is the difference between INNER JOIN and LEFT JOIN?\", \"answer\": \"INNER JOIN returns matching rows only. LEFT JOIN returns all rows from left table plus matching from right, with NULLs for non-matches.\", \"score\": 9, \"feedback\": \"Perfect explanation with edge case mentioned.\", \"clarity\": 9, \"correctness\": 9, \"completeness\": 9, \"communication\": 9}]', 'completed');

-- --------------------------------------------------------

--
-- Table structure for table `placement_drive`
--

CREATE TABLE `placement_drive` (
  `id` int(11) NOT NULL,
  `company_id` int(11) NOT NULL,
  `role` varchar(100) NOT NULL,
  `drive_date` date DEFAULT NULL,
  `status` enum('open','closed') DEFAULT 'open',
  `min_cgpa` decimal(3,2) DEFAULT NULL,
  `created_by` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `placement_drive`
--

INSERT INTO `placement_drive` (`id`, `company_id`, `role`, `drive_date`, `status`, `min_cgpa`, `created_by`) VALUES
(1, 1, 'Frontend Developer', '2026-07-22', 'open', 7.00, 6),
(2, 2, 'Software Engineer', '2026-07-14', 'open', 6.50, 6),
(3, 3, 'Analyst', '2026-08-02', 'open', 7.50, 6),
(4, 1, 'Software Engineer', '2026-07-29', 'open', 6.50, 7),
(5, 2, 'Assistant System Engineer', '2027-05-20', 'open', 5.97, 7),
(6, 3, 'Project Engineer', '2026-07-02', 'closed', 6.47, 7);

-- --------------------------------------------------------

--
-- Table structure for table `placement_officer`
--

CREATE TABLE `placement_officer` (
  `user_id` int(11) NOT NULL,
  `full_name` varchar(100) NOT NULL,
  `designation` varchar(100) DEFAULT 'Placement Officer',
  `phone` varchar(20) DEFAULT NULL,
  `profile_photo` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `placement_officer`
--

INSERT INTO `placement_officer` (`user_id`, `full_name`, `designation`, `phone`, `profile_photo`) VALUES
(6, 'karthik', 'Placement Officer', '8590939674', NULL),
(7, 'Aparna S Nair', 'Placement Officer', '+918590939674', NULL),
(105, 'Dr. Rajesh Kumar', 'Head - Training & Placement', '+91 98765 11111', NULL),
(106, 'Prof. Meera Suresh', 'Placement Coordinator', '+91 98765 22222', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `project`
--

CREATE TABLE `project` (
  `id` int(11) NOT NULL,
  `student_id` int(11) NOT NULL,
  `title` varchar(200) NOT NULL,
  `description` text DEFAULT NULL,
  `technologies` varchar(255) DEFAULT NULL,
  `link` varchar(255) DEFAULT NULL,
  `year` year(4) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `project`
--

INSERT INTO `project` (`id`, `student_id`, `title`, `description`, `technologies`, `link`, `year`) VALUES
(1, 2, 'Carrerpilot ai', 'a website for placement readiness', 'Html css , python flask and mysql', 'https://github.com/Arjunsanthosh09/Carrer-pilot-', '2026'),
(2, 1, 'Blood Donation Management System', 'Online platform connecting blood donors with recipients. Enabled users to search for donors based on blood group and location. Implemented donor registration, request management, and real‑time availability tracking. Reduced search time by 40%.', 'HTML5, CSS3, JavaScript, Bootstrap, PHP, MySQL', 'https://github.com/yourusername/blood-donation', '2024'),
(3, 1, 'RESQAI – AI Accident Detection System', 'Accident detection and ambulance route optimization system using machine learning to detect incidents in real time. Integrated route optimization to minimize emergency response time. Achieved 92% detection accuracy on test dataset.', 'AI/ML, Flask, MySQL, HTML5, CSS3, JavaScript', 'https://github.com/yourusername/resqai', '2025'),
(4, 1, 'CART GEN – Bulk Certificate Generator', 'Built a bulk certificate generation system for event‑based use cases. Automated certificate creation with dynamic data input. Reduced manual effort by 90% enabling batch processing and downloads. Designed simple UI for quick data upload and generation.', 'Python Flask, HTML, CSS, JavaScript', 'https://github.com/yourusername/cartgen', '2024'),
(5, 1, 'Portfolio Website with Admin Dashboard', 'Developed a personal portfolio website with a custom admin dashboard for managing projects, blog posts, and contact form. Integrated Google Analytics and SEO optimization. Serves as a professional showcase of work.', 'React.js, Node.js, MongoDB, Express.js, Tailwind CSS', 'https://yourportfolio.com', '2025'),
(9, 2, 'Sales Forecasting Dashboard', 'Built a predictive dashboard for retail sales using historical data. Implemented time‑series forecasting with ARIMA and Prophet. Created interactive visualizations with Plotly and Tableau. Improved forecast accuracy by 15%.', 'Python, Pandas, Scikit-learn, Tableau, Plotly, PostgreSQL', 'https://github.com/yourusername/sales-forecast', '2024'),
(10, 2, 'AI Chatbot for Customer Support', 'Developed a retrieval‑augmented generation (RAG) chatbot using LangChain and Pinecone. Integrated with Slack API for live support. Reduced average response time by 60%.', 'Python, LangChain, Pinecone, FastAPI, Docker, AWS Lambda', 'https://github.com/yourusername/chatbot-rag', '2025'),
(11, 2, 'Real‑Time E‑Commerce Analytics Pipeline', 'Built a streaming data pipeline using Kafka, Spark, and ClickHouse to process user activity events. Developed dashboards for product performance and user retention.', 'Python, Kafka, Spark, ClickHouse, Docker, Kubernetes, Grafana', 'https://github.com/yourusername/ecommerce-pipeline', '2025'),
(12, 2, 'Personal Finance Tracker with AI Insights', 'Designed a full‑stack finance tracker that categorises transactions and provides AI‑powered savings suggestions. Used Flask backend, React frontend, and PostgreSQL for storage.', 'Flask, React, PostgreSQL, Scikit-learn, Docker, Tailwind CSS', 'https://github.com/yourusername/finance-tracker', '2024'),
(13, 4, 'CareerPilot AI', 'Full-stack AI-powered placement readiness platform with resume builder, ATS analysis, skill gap detection, and proctored mock interviews.', 'Flask, MySQL, Groq AI, TensorFlow.js, Web Speech API', 'https://github.com/arjunsanthosh/careerpilot', '2026'),
(14, 4, 'Campus Event Manager', 'Full-stack event registration system used by 1,200+ students with real-time dashboard.', 'React, Node.js, MongoDB', 'https://github.com/arjunsanthosh/campus-events', '2025'),
(15, 4, 'Blood Donation Management', 'Online platform connecting blood donors with recipients based on blood group and location.', 'HTML, CSS, JavaScript, PHP, MySQL', 'https://github.com/arjunsanthosh/blood-donation', '2024'),
(16, 5, 'Sales Forecasting Dashboard', 'Predictive dashboard for retail sales using ARIMA and Prophet time-series models. Improved forecast accuracy by 15%.', 'Python, Pandas, Scikit-learn, Tableau, Plotly', 'https://github.com/anjalinai/sales-forecast', '2025'),
(17, 5, 'AI Chatbot for Customer Support', 'RAG-based chatbot using LangChain and Pinecone. Reduced average response time by 60%.', 'Python, LangChain, Pinecone, FastAPI, AWS Lambda', 'https://github.com/anjalinai/chatbot-rag', '2025'),
(18, 7, 'E-Commerce Backend API', 'RESTful backend with authentication, payments, and order management. Handles 1000+ requests/min.', 'Flask, PostgreSQL, Redis, Docker', 'https://github.com/snehapillai/ecommerce-api', '2025'),
(19, 7, 'Real-Time Analytics Pipeline', 'Streaming data pipeline using Kafka, Spark, and ClickHouse for user activity events.', 'Python, Kafka, Spark, ClickHouse, Kubernetes', 'https://github.com/snehapillai/analytics-pipeline', '2024'),
(20, 8, 'Portfolio Website', 'Personal portfolio with dark mode, blog, and contact form. Deployed on AWS.', 'React, Tailwind CSS, AWS S3', 'https://vishnuprasad.dev', '2025');

-- --------------------------------------------------------

--
-- Table structure for table `resume_feedback`
--

CREATE TABLE `resume_feedback` (
  `id` int(11) NOT NULL,
  `student_id` int(11) NOT NULL,
  `generated_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `suggestions` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`suggestions`))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `role_requirement`
--

CREATE TABLE `role_requirement` (
  `id` int(11) NOT NULL,
  `role_name` varchar(100) NOT NULL,
  `skill_name` varchar(50) NOT NULL,
  `required_proficiency` int(11) DEFAULT 70,
  `category` varchar(50) DEFAULT 'Technical'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `role_requirement`
--

INSERT INTO `role_requirement` (`id`, `role_name`, `skill_name`, `required_proficiency`, `category`) VALUES
(1, 'Frontend Developer', 'HTML/CSS', 80, 'Technical'),
(2, 'Frontend Developer', 'JavaScript', 85, 'Technical'),
(3, 'Frontend Developer', 'React', 80, 'Technical'),
(4, 'Frontend Developer', 'TypeScript', 60, 'Technical'),
(5, 'Frontend Developer', 'Git', 70, 'Technical'),
(6, 'Frontend Developer', 'Communication', 60, 'Soft'),
(7, 'Frontend Developer', 'Problem Solving', 65, 'Soft'),
(8, 'Backend Developer', 'Python/Flask', 80, 'Technical'),
(9, 'Backend Developer', 'SQL', 80, 'Technical'),
(10, 'Backend Developer', 'REST APIs', 85, 'Technical'),
(11, 'Backend Developer', 'Docker', 55, 'Technical'),
(12, 'Backend Developer', 'System Design', 60, 'Technical'),
(13, 'Backend Developer', 'Git', 70, 'Technical'),
(14, 'Backend Developer', 'Problem Solving', 70, 'Soft'),
(15, 'Data Analyst', 'SQL', 85, 'Technical'),
(16, 'Data Analyst', 'Python', 80, 'Technical'),
(17, 'Data Analyst', 'Excel', 60, 'Technical'),
(18, 'Data Analyst', 'Power BI', 65, 'Technical'),
(19, 'Data Analyst', 'Statistics', 70, 'Technical'),
(20, 'Data Analyst', 'Communication', 70, 'Soft'),
(21, 'Data Analyst', 'Data Visualization', 75, 'Technical'),
(22, 'DevOps Engineer', 'Docker', 85, 'Technical'),
(23, 'DevOps Engineer', 'Kubernetes', 80, 'Technical'),
(24, 'DevOps Engineer', 'AWS', 80, 'Technical'),
(25, 'DevOps Engineer', 'Linux', 70, 'Technical'),
(26, 'DevOps Engineer', 'CI/CD', 75, 'Technical'),
(27, 'DevOps Engineer', 'Git', 80, 'Technical'),
(28, 'DevOps Engineer', 'System Design', 65, 'Technical'),
(29, 'Machine Learning Engineer', 'Python', 90, 'Technical'),
(30, 'Machine Learning Engineer', 'TensorFlow', 85, 'Technical'),
(31, 'Machine Learning Engineer', 'PyTorch', 80, 'Technical'),
(32, 'Machine Learning Engineer', 'SQL', 70, 'Technical'),
(33, 'Machine Learning Engineer', 'Statistics', 80, 'Technical'),
(34, 'Machine Learning Engineer', 'Data Visualization', 65, 'Technical'),
(35, 'Machine Learning Engineer', 'Communication', 60, 'Soft'),
(36, 'Full Stack Developer', 'JavaScript', 85, 'Technical'),
(37, 'Full Stack Developer', 'React', 80, 'Technical'),
(38, 'Full Stack Developer', 'Python/Flask', 80, 'Technical'),
(39, 'Full Stack Developer', 'SQL', 80, 'Technical'),
(40, 'Full Stack Developer', 'REST APIs', 85, 'Technical'),
(41, 'Full Stack Developer', 'Git', 75, 'Technical'),
(42, 'Full Stack Developer', 'Docker', 60, 'Technical');

-- --------------------------------------------------------

--
-- Table structure for table `skill`
--

CREATE TABLE `skill` (
  `id` int(11) NOT NULL,
  `name` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `skill`
--

INSERT INTO `skill` (`id`, `name`) VALUES
(50, 'Angular'),
(53, 'AWS'),
(54, 'Azure'),
(34, 'Bootstrap'),
(14, 'Communication'),
(61, 'Computer Vision'),
(28, 'Dart'),
(11, 'Data Analysis'),
(89, 'Data Visualization'),
(59, 'Deep Learning'),
(91, 'Django'),
(8, 'Docker'),
(87, 'Elasticsearch'),
(12, 'Excel'),
(52, 'Express.js'),
(92, 'FastAPI'),
(63, 'Figma'),
(32, 'Firebase'),
(90, 'Flask'),
(17, 'flutter'),
(55, 'GCP'),
(5, 'Git'),
(93, 'GraphQL'),
(1, 'HTML/CSS'),
(2, 'JavaScript'),
(57, 'Jenkins'),
(83, 'Keras'),
(56, 'Kubernetes'),
(30, 'Laravel'),
(58, 'Machine Learning'),
(79, 'Matplotlib'),
(31, 'MongoDB'),
(85, 'MySQL'),
(60, 'NLP'),
(51, 'Node.js'),
(78, 'NumPy'),
(77, 'Pandas'),
(64, 'Photoshop'),
(29, 'PHP'),
(35, 'PostgreSQL'),
(13, 'Power BI'),
(16, 'Problem Solving'),
(6, 'Python'),
(82, 'PyTorch'),
(88, 'R'),
(3, 'React'),
(86, 'Redis'),
(9, 'REST APIs'),
(80, 'Scikit-learn'),
(7, 'SQL'),
(84, 'SQLite'),
(10, 'System Design'),
(62, 'Tableau'),
(33, 'Tailwind CSS'),
(15, 'Teamwork'),
(81, 'TensorFlow'),
(4, 'TypeScript'),
(49, 'Vue.js');

-- --------------------------------------------------------

--
-- Table structure for table `student_profile`
--

CREATE TABLE `student_profile` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `full_name` varchar(100) DEFAULT NULL,
  `department` varchar(50) DEFAULT NULL,
  `year` varchar(20) DEFAULT NULL,
  `roll_number` varchar(20) DEFAULT NULL,
  `cgpa` decimal(3,2) DEFAULT NULL,
  `about_me` text DEFAULT NULL,
  `phone` varchar(20) DEFAULT NULL,
  `location` varchar(100) DEFAULT NULL,
  `linkedin` varchar(255) DEFAULT NULL,
  `github` varchar(255) DEFAULT NULL,
  `portfolio` varchar(255) DEFAULT NULL,
  `soft_skills` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `student_profile`
--

INSERT INTO `student_profile` (`id`, `user_id`, `full_name`, `department`, `year`, `roll_number`, `cgpa`, `about_me`, `phone`, `location`, `linkedin`, `github`, `portfolio`, `soft_skills`) VALUES
(1, 1, 'Arjun Santhosh', 'Computer Science', '1st Year', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(2, 2, 'Arjun Santhosh', 'Data Science', 'Final Year', 'DS2022-18', 8.92, 'Passionate Data Science student with strong analytical and machine learning skills. Experienced in building end‑to‑end data solutions, from data engineering to visualisation. Seeking opportunities to apply AI and data-driven insights to real‑world problems.', '+91 87654 32109', 'Thiruvananthapuram, Kerala, India', 'https://linkedin.com/in/anjalinai', 'https://github.com/anjalinai', 'https://anjalinai.dev', 'Analytical Thinking, Problem Solving, Communication, Collaboration, Time Management, Adaptability, Critical Thinking'),
(3, 3, 'Arjun Santhosh', 'Computer Science', 'Final Year', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(4, 100, 'Arjun Santhosh', 'Computer Science', 'Final Year', 'CS2022-001', 8.79, 'Passionate full-stack developer with expertise in Python Flask and React. Experienced in building scalable web applications with AI integration.', '+91 98765 43210', 'Kottayam, Kerala, India', 'https://linkedin.com/in/arjunsanthosh', 'https://github.com/arjunsanthosh', 'https://arjunsanthosh.dev', 'Analytical Thinking, Problem Solving, Leadership, Communication, Time Management'),
(5, 101, 'Anjali Nair', 'Data Science', 'Final Year', 'DS2022-018', 8.92, 'Data Science enthusiast with strong analytical skills. Experienced in building end-to-end ML pipelines and data-driven solutions.', '+91 87654 32109', 'Thiruvananthapuram, Kerala, India', 'https://linkedin.com/in/anjalinai', 'https://github.com/anjalinai', 'https://anjalinai.dev', 'Analytical Thinking, Problem Solving, Communication, Collaboration, Adaptability'),
(6, 102, 'Rahul Menon', 'Electronics & Communication', 'Final Year', 'EC2022-042', 6.20, 'ECE student with interest in embedded systems and IoT. Currently improving programming skills for software roles.', '+91 76543 21098', 'Kochi, Kerala, India', NULL, 'https://github.com/rahulmenon', NULL, 'Teamwork, Adaptability'),
(7, 103, 'Sneha Pillai', 'Computer Science', 'Final Year', 'CS2022-055', 9.10, 'Top-performing CS student with strong backend and database skills. Passionate about building scalable APIs and system design.', '+91 65432 10987', 'Thrissur, Kerala, India', 'https://linkedin.com/in/snehapillai', 'https://github.com/snehapillai', 'https://snehapillai.dev', 'Leadership, Communication, Problem Solving, Critical Thinking, Time Management'),
(8, 104, 'Vishnu Prasad', 'Information Technology', 'Final Year', 'IT2022-071', 7.50, 'IT student focused on cloud computing and DevOps. Learning Docker, Kubernetes, and AWS.', '+91 54321 09876', 'Kozhikode, Kerala, India', NULL, 'https://github.com/vishnuprasad', NULL, 'Teamwork, Problem Solving');

-- --------------------------------------------------------

--
-- Table structure for table `student_skill`
--

CREATE TABLE `student_skill` (
  `id` int(11) NOT NULL,
  `student_id` int(11) NOT NULL,
  `skill_id` int(11) NOT NULL,
  `proficiency` int(11) DEFAULT NULL CHECK (`proficiency` between 0 and 100)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `student_skill`
--

INSERT INTO `student_skill` (`id`, `student_id`, `skill_id`, `proficiency`) VALUES
(1, 2, 17, 73),
(2, 1, 53, 67),
(3, 1, 34, 88),
(4, 1, 28, 86),
(5, 1, 8, 69),
(6, 1, 52, 84),
(7, 1, 63, 87),
(8, 1, 32, 88),
(9, 1, 17, 86),
(10, 1, 56, 69),
(11, 1, 30, 86),
(12, 1, 58, 68),
(13, 1, 31, 76),
(14, 1, 51, 84),
(15, 1, 29, 65),
(16, 1, 35, 68),
(17, 1, 62, 84),
(18, 1, 33, 88),
(19, 1, 4, 93),
(20, 1, 49, 78),
(33, 2, 53, 71),
(34, 2, 89, 76),
(35, 2, 8, 71),
(36, 2, 12, 84),
(37, 2, 90, 82),
(38, 2, 5, 90),
(39, 2, 79, 76),
(40, 2, 31, 97),
(41, 2, 85, 75),
(42, 2, 60, 71),
(43, 2, 78, 88),
(44, 2, 77, 72),
(45, 2, 35, 85),
(46, 2, 13, 84),
(47, 2, 6, 97),
(48, 2, 9, 76),
(49, 2, 80, 77),
(50, 2, 84, 89),
(51, 2, 62, 87),
(52, 2, 81, 72),
(53, 4, 1, 90),
(54, 4, 2, 85),
(55, 4, 3, 80),
(56, 4, 6, 88),
(57, 4, 90, 85),
(58, 4, 7, 78),
(59, 4, 5, 82),
(60, 4, 8, 55),
(61, 4, 9, 80),
(62, 5, 6, 95),
(63, 5, 77, 88),
(64, 5, 78, 85),
(65, 5, 80, 82),
(66, 5, 81, 75),
(67, 5, 7, 80),
(68, 5, 62, 78),
(69, 5, 13, 72),
(70, 5, 58, 80),
(71, 6, 6, 45),
(72, 6, 7, 40),
(73, 6, 5, 35),
(74, 7, 6, 92),
(75, 7, 90, 90),
(76, 7, 7, 92),
(77, 7, 9, 88),
(78, 7, 8, 80),
(79, 7, 10, 75),
(80, 7, 35, 85),
(81, 7, 5, 88),
(82, 8, 6, 72),
(83, 8, 8, 70),
(84, 8, 56, 55),
(85, 8, 53, 65),
(86, 8, 5, 78),
(87, 8, 7, 60);

-- --------------------------------------------------------

--
-- Table structure for table `user`
--

CREATE TABLE `user` (
  `id` int(11) NOT NULL,
  `email` varchar(255) NOT NULL,
  `password_hash` varchar(255) NOT NULL,
  `role` enum('student','officer') NOT NULL DEFAULT 'student',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `user`
--

INSERT INTO `user` (`id`, `email`, `password_hash`, `role`, `created_at`) VALUES
(1, 'arjunsanthosh440@gmail.com', 'scrypt:32768:8:1$6uIsy7fSdMxERxIV$c841d6d0c42307fd2002e539526be82ed7526dd2f070623ddd1395784ceef1fcb9e6a3973e1b353294844db97a98444c8ea81b1eea493fb52c4389d800ab6b42', 'student', '2026-06-24 23:47:14'),
(2, 'arjunsanthosh@gmail.com', 'scrypt:32768:8:1$D9aBMnNX55GEj1B1$5b76506f4c781fe0393f3737c857b9bae368b0592ba60e3983ab616a4f54b68eed5b243bc4400de5eff670549573ea26d53680f287a914568209cc6d6510d643', 'student', '2026-07-02 02:57:55'),
(3, 'arjun@gmail.com', 'scrypt:32768:8:1$dYa8FA7J87gnC4JT$8db84d8ea3eafd3901ca78ab7e0776164d60c7ac530dfe14b088bc16f33e02a317b247403d1bb22f9e84d1032c91f0e23ea75063462e9d0220278ec70fc5452a', 'student', '2026-07-02 02:58:33'),
(4, 'arun@gmail.com', 'scrypt:32768:8:1$hNntSffBLitwKIE7$3c585c89b09364e7c4b821de571cdcc2ed5491b56918ff7fd73625a72c829cae171d9469cdf23b4015a4f4e01dee7bcc30e745e2d92e673ef9598fa00830c720', 'officer', '2026-07-02 02:59:11'),
(5, 'gowtham@gmail.com', 'scrypt:32768:8:1$beBnyZVD2hmPkRXj$b06506b7ca45138580527f8eea1a1db320a1fdcc72e3c6c074533206424c6f66c53c4c68184cb3120b2564d88dabf6a234b5df66c3c564baf455cef7ba44ba16', 'officer', '2026-07-17 23:39:31'),
(6, 'karthik@gmail.com', 'scrypt:32768:8:1$jI9i8N4nSMrPsn0d$d324881717e586231e858eb8160e085c199b4a151cf0dea0fdb2eb2d33459a307a051e87dee67f4c43249aadca3a8d359df87ee0d59e3db9e2e718e5e64c8c07', 'officer', '2026-07-17 23:41:15'),
(7, 'aparna@gmail.com', 'scrypt:32768:8:1$0kU0aHdzzYGKH6Sg$ed31ac329cb30cbc6a4005521c43aec38878c847d7236d3a60ac2df60bc0401436005c14e9e87e1fbf91ca9d4fc118112666bf0a7afbaf78e8614cc18acb97ff', 'officer', '2026-09-05 08:20:13'),
(100, 'arjun.demo@college.edu', 'scrypt:32768:8:1$G6Rhes599BbUEJlQ$372b787331d8ccb6ff4a8a18c6234557de0e0775276b6953d69fb426700bc1e05cdb6abd70bacbf762a079af818f583654b61f69e3fb1c58eb3bcf02668db6a8', 'student', '2026-10-08 03:45:05'),
(101, 'anjali.demo@college.edu', 'scrypt:32768:8:1$G6Rhes599BbUEJlQ$372b787331d8ccb6ff4a8a18c6234557de0e0775276b6953d69fb426700bc1e05cdb6abd70bacbf762a079af818f583654b61f69e3fb1c58eb3bcf02668db6a8', 'student', '2026-10-08 03:45:05'),
(102, 'rahul.demo@college.edu', 'scrypt:32768:8:1$G6Rhes599BbUEJlQ$372b787331d8ccb6ff4a8a18c6234557de0e0775276b6953d69fb426700bc1e05cdb6abd70bacbf762a079af818f583654b61f69e3fb1c58eb3bcf02668db6a8', 'student', '2026-10-08 03:45:05'),
(103, 'sneha.demo@college.edu', 'scrypt:32768:8:1$G6Rhes599BbUEJlQ$372b787331d8ccb6ff4a8a18c6234557de0e0775276b6953d69fb426700bc1e05cdb6abd70bacbf762a079af818f583654b61f69e3fb1c58eb3bcf02668db6a8', 'student', '2026-10-08 03:45:05'),
(104, 'vishnu.demo@college.edu', 'scrypt:32768:8:1$G6Rhes599BbUEJlQ$372b787331d8ccb6ff4a8a18c6234557de0e0775276b6953d69fb426700bc1e05cdb6abd70bacbf762a079af818f583654b61f69e3fb1c58eb3bcf02668db6a8', 'student', '2026-10-08 03:45:05'),
(105, 'officer1.demo@college.edu', 'scrypt:32768:8:1$G6Rhes599BbUEJlQ$372b787331d8ccb6ff4a8a18c6234557de0e0775276b6953d69fb426700bc1e05cdb6abd70bacbf762a079af818f583654b61f69e3fb1c58eb3bcf02668db6a8', 'officer', '2026-10-08 03:45:05'),
(106, 'officer2.demo@college.edu', 'scrypt:32768:8:1$G6Rhes599BbUEJlQ$372b787331d8ccb6ff4a8a18c6234557de0e0775276b6953d69fb426700bc1e05cdb6abd70bacbf762a079af818f583654b61f69e3fb1c58eb3bcf02668db6a8', 'officer', '2026-10-08 03:45:05');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `application`
--
ALTER TABLE `application`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `student_id` (`student_id`,`drive_id`),
  ADD KEY `idx_app_student` (`student_id`),
  ADD KEY `idx_app_drive` (`drive_id`);

--
-- Indexes for table `certification`
--
ALTER TABLE `certification`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_cert_student` (`student_id`);

--
-- Indexes for table `company`
--
ALTER TABLE `company`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `company_name` (`company_name`);

--
-- Indexes for table `education`
--
ALTER TABLE `education`
  ADD PRIMARY KEY (`id`),
  ADD KEY `student_id` (`student_id`);

--
-- Indexes for table `experience`
--
ALTER TABLE `experience`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_exp_student` (`student_id`);

--
-- Indexes for table `interview_question_bank`
--
ALTER TABLE `interview_question_bank`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `interview_session`
--
ALTER TABLE `interview_session`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_interview_student` (`student_id`);

--
-- Indexes for table `placement_drive`
--
ALTER TABLE `placement_drive`
  ADD PRIMARY KEY (`id`),
  ADD KEY `created_by` (`created_by`),
  ADD KEY `idx_drive_status` (`status`),
  ADD KEY `idx_drive_date` (`drive_date`),
  ADD KEY `fk_placement_company` (`company_id`);

--
-- Indexes for table `placement_officer`
--
ALTER TABLE `placement_officer`
  ADD PRIMARY KEY (`user_id`);

--
-- Indexes for table `project`
--
ALTER TABLE `project`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_project_student` (`student_id`);

--
-- Indexes for table `resume_feedback`
--
ALTER TABLE `resume_feedback`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `student_id` (`student_id`);

--
-- Indexes for table `role_requirement`
--
ALTER TABLE `role_requirement`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `unique_role_skill` (`role_name`,`skill_name`);

--
-- Indexes for table `skill`
--
ALTER TABLE `skill`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `name` (`name`),
  ADD KEY `idx_skill_name` (`name`);

--
-- Indexes for table `student_profile`
--
ALTER TABLE `student_profile`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `user_id` (`user_id`),
  ADD KEY `idx_student_user` (`user_id`);

--
-- Indexes for table `student_skill`
--
ALTER TABLE `student_skill`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `student_id` (`student_id`,`skill_id`),
  ADD KEY `skill_id` (`skill_id`),
  ADD KEY `idx_student_skill_student` (`student_id`);

--
-- Indexes for table `user`
--
ALTER TABLE `user`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `email` (`email`),
  ADD KEY `idx_user_email` (`email`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `application`
--
ALTER TABLE `application`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `certification`
--
ALTER TABLE `certification`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=25;

--
-- AUTO_INCREMENT for table `company`
--
ALTER TABLE `company`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT for table `education`
--
ALTER TABLE `education`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=14;

--
-- AUTO_INCREMENT for table `experience`
--
ALTER TABLE `experience`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `interview_question_bank`
--
ALTER TABLE `interview_question_bank`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=33;

--
-- AUTO_INCREMENT for table `interview_session`
--
ALTER TABLE `interview_session`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=23;

--
-- AUTO_INCREMENT for table `placement_drive`
--
ALTER TABLE `placement_drive`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--
-- AUTO_INCREMENT for table `project`
--
ALTER TABLE `project`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=21;

--
-- AUTO_INCREMENT for table `resume_feedback`
--
ALTER TABLE `resume_feedback`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `role_requirement`
--
ALTER TABLE `role_requirement`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=44;

--
-- AUTO_INCREMENT for table `skill`
--
ALTER TABLE `skill`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=94;

--
-- AUTO_INCREMENT for table `student_profile`
--
ALTER TABLE `student_profile`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT for table `student_skill`
--
ALTER TABLE `student_skill`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=88;

--
-- AUTO_INCREMENT for table `user`
--
ALTER TABLE `user`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=107;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `application`
--
ALTER TABLE `application`
  ADD CONSTRAINT `application_ibfk_1` FOREIGN KEY (`student_id`) REFERENCES `user` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `application_ibfk_2` FOREIGN KEY (`drive_id`) REFERENCES `placement_drive` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `certification`
--
ALTER TABLE `certification`
  ADD CONSTRAINT `certification_ibfk_1` FOREIGN KEY (`student_id`) REFERENCES `student_profile` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `education`
--
ALTER TABLE `education`
  ADD CONSTRAINT `education_ibfk_1` FOREIGN KEY (`student_id`) REFERENCES `student_profile` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `experience`
--
ALTER TABLE `experience`
  ADD CONSTRAINT `experience_ibfk_1` FOREIGN KEY (`student_id`) REFERENCES `student_profile` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `interview_session`
--
ALTER TABLE `interview_session`
  ADD CONSTRAINT `interview_session_ibfk_1` FOREIGN KEY (`student_id`) REFERENCES `user` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `placement_drive`
--
ALTER TABLE `placement_drive`
  ADD CONSTRAINT `fk_company` FOREIGN KEY (`company_id`) REFERENCES `company` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_placement_company` FOREIGN KEY (`company_id`) REFERENCES `company` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `placement_drive_ibfk_1` FOREIGN KEY (`created_by`) REFERENCES `user` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `placement_officer`
--
ALTER TABLE `placement_officer`
  ADD CONSTRAINT `fk_officer_user` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `project`
--
ALTER TABLE `project`
  ADD CONSTRAINT `project_ibfk_1` FOREIGN KEY (`student_id`) REFERENCES `student_profile` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `resume_feedback`
--
ALTER TABLE `resume_feedback`
  ADD CONSTRAINT `resume_feedback_ibfk_1` FOREIGN KEY (`student_id`) REFERENCES `user` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `student_profile`
--
ALTER TABLE `student_profile`
  ADD CONSTRAINT `student_profile_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `student_skill`
--
ALTER TABLE `student_skill`
  ADD CONSTRAINT `student_skill_ibfk_1` FOREIGN KEY (`student_id`) REFERENCES `student_profile` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `student_skill_ibfk_2` FOREIGN KEY (`skill_id`) REFERENCES `skill` (`id`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
