-- ============================================================
--  Employee Management System - Database Schema & Implementation
--  RDBMS: MySQL
--  Author: Student Project | Blackbuck Engineers Pvt. Ltd.
-- ============================================================

-- Create and use database
CREATE DATABASE IF NOT EXISTS employee_management_db;
USE employee_management_db;

-- ============================================================
-- TABLE 1: departments
-- ============================================================
CREATE TABLE departments (
    department_id   INT AUTO_INCREMENT PRIMARY KEY,
    department_name VARCHAR(100) NOT NULL UNIQUE,
    location        VARCHAR(100),
    created_at      TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ============================================================
-- TABLE 2: designations
-- ============================================================
CREATE TABLE designations (
    designation_id   INT AUTO_INCREMENT PRIMARY KEY,
    designation_name VARCHAR(100) NOT NULL UNIQUE,
    grade            VARCHAR(10),
    created_at       TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ============================================================
-- TABLE 3: employees
-- ============================================================
CREATE TABLE employees (
    employee_id     INT AUTO_INCREMENT PRIMARY KEY,
    first_name      VARCHAR(50)  NOT NULL,
    last_name       VARCHAR(50)  NOT NULL,
    email           VARCHAR(100) NOT NULL UNIQUE,
    phone           VARCHAR(15),
    date_of_birth   DATE,
    gender          ENUM('Male','Female','Other'),
    hire_date       DATE         NOT NULL,
    department_id   INT,
    designation_id  INT,
    manager_id      INT,          -- self-referencing FK
    status          ENUM('Active','Inactive','On Leave') DEFAULT 'Active',
    created_at      TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_emp_dept    FOREIGN KEY (department_id)  REFERENCES departments(department_id) ON DELETE SET NULL,
    CONSTRAINT fk_emp_desig   FOREIGN KEY (designation_id) REFERENCES designations(designation_id) ON DELETE SET NULL,
    CONSTRAINT fk_emp_manager FOREIGN KEY (manager_id)     REFERENCES employees(employee_id) ON DELETE SET NULL
);

-- ============================================================
-- TABLE 4: salaries
-- ============================================================
CREATE TABLE salaries (
    salary_id     INT AUTO_INCREMENT PRIMARY KEY,
    employee_id   INT NOT NULL,
    basic_salary  DECIMAL(12,2) NOT NULL,
    allowances    DECIMAL(12,2) DEFAULT 0.00,
    deductions    DECIMAL(12,2) DEFAULT 0.00,
    net_salary    DECIMAL(12,2) GENERATED ALWAYS AS (basic_salary + allowances - deductions) STORED,
    effective_from DATE NOT NULL,
    effective_to   DATE,
    CONSTRAINT fk_salary_emp FOREIGN KEY (employee_id) REFERENCES employees(employee_id) ON DELETE CASCADE
);

-- ============================================================
-- TABLE 5: attendance
-- ============================================================
CREATE TABLE attendance (
    attendance_id   INT AUTO_INCREMENT PRIMARY KEY,
    employee_id     INT  NOT NULL,
    attendance_date DATE NOT NULL,
    check_in        TIME,
    check_out       TIME,
    status          ENUM('Present','Absent','Half Day','Leave') DEFAULT 'Present',
    remarks         VARCHAR(200),
    UNIQUE KEY uq_emp_date (employee_id, attendance_date),
    CONSTRAINT fk_attend_emp FOREIGN KEY (employee_id) REFERENCES employees(employee_id) ON DELETE CASCADE
);

-- ============================================================
-- TABLE 6: leave_requests
-- ============================================================
CREATE TABLE leave_requests (
    leave_id      INT AUTO_INCREMENT PRIMARY KEY,
    employee_id   INT  NOT NULL,
    leave_type    ENUM('Sick','Casual','Earned','Unpaid') NOT NULL,
    start_date    DATE NOT NULL,
    end_date      DATE NOT NULL,
    total_days    INT  GENERATED ALWAYS AS (DATEDIFF(end_date, start_date) + 1) STORED,
    reason        VARCHAR(300),
    approval_status ENUM('Pending','Approved','Rejected') DEFAULT 'Pending',
    approved_by   INT,
    applied_on    TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_leave_emp      FOREIGN KEY (employee_id) REFERENCES employees(employee_id) ON DELETE CASCADE,
    CONSTRAINT fk_leave_approver FOREIGN KEY (approved_by) REFERENCES employees(employee_id) ON DELETE SET NULL
);

-- ============================================================
-- SAMPLE DATA POPULATION
-- ============================================================

-- Departments (6 entries)
INSERT INTO departments (department_name, location) VALUES
('Human Resources',      'Floor 1'),
('Engineering',          'Floor 2'),
('Finance',              'Floor 3'),
('Marketing',            'Floor 4'),
('Operations',           'Floor 2'),
('Quality Assurance',    'Floor 3');

-- Designations (6 entries)
INSERT INTO designations (designation_name, grade) VALUES
('HR Manager',           'M3'),
('Software Engineer',    'E2'),
('Senior Engineer',      'E3'),
('Finance Analyst',      'A2'),
('Marketing Executive',  'A1'),
('QA Tester',            'E1');

-- Employees (8 entries, including manager self-reference)
INSERT INTO employees (first_name, last_name, email, phone, date_of_birth, gender, hire_date, department_id, designation_id, manager_id) VALUES
('Rajesh',   'Kumar',    'rajesh.kumar@ems.com',   '9000000001', '1980-04-15', 'Male',   '2015-01-10', 1, 1, NULL),
('Priya',    'Sharma',   'priya.sharma@ems.com',   '9000000002', '1990-07-22', 'Female', '2018-03-01', 2, 3, 1),
('Arjun',    'Reddy',    'arjun.reddy@ems.com',    '9000000003', '1992-11-30', 'Male',   '2019-06-15', 2, 2, 2),
('Sneha',    'Patel',    'sneha.patel@ems.com',    '9000000004', '1995-02-18', 'Female', '2020-08-01', 3, 4, 1),
('Vikram',   'Singh',    'vikram.singh@ems.com',   '9000000005', '1988-09-05', 'Male',   '2016-11-20', 4, 5, 1),
('Anjali',   'Rao',      'anjali.rao@ems.com',     '9000000006', '1993-03-12', 'Female', '2021-01-10', 6, 6, 2),
('Kiran',    'Nair',     'kiran.nair@ems.com',     '9000000007', '1991-06-28', 'Male',   '2017-05-14', 5, 5, 1),
('Deepa',    'Menon',    'deepa.menon@ems.com',    '9000000008', '1996-12-01', 'Female', '2022-03-07', 2, 2, 2);

-- Salaries (8 entries)
INSERT INTO salaries (employee_id, basic_salary, allowances, deductions, effective_from) VALUES
(1, 80000.00, 15000.00, 8000.00, '2015-01-10'),
(2, 70000.00, 12000.00, 7000.00, '2018-03-01'),
(3, 55000.00, 10000.00, 5500.00, '2019-06-15'),
(4, 50000.00,  9000.00, 5000.00, '2020-08-01'),
(5, 48000.00,  8000.00, 4800.00, '2016-11-20'),
(6, 42000.00,  7000.00, 4200.00, '2021-01-10'),
(7, 45000.00,  7500.00, 4500.00, '2017-05-14'),
(8, 52000.00,  9500.00, 5200.00, '2022-03-07');

-- Attendance (10 entries)
INSERT INTO attendance (employee_id, attendance_date, check_in, check_out, status) VALUES
(1, '2024-06-03', '09:00:00', '18:00:00', 'Present'),
(2, '2024-06-03', '09:15:00', '18:10:00', 'Present'),
(3, '2024-06-03', '09:05:00', '17:55:00', 'Present'),
(4, '2024-06-03', NULL,       NULL,       'Absent'),
(5, '2024-06-03', '09:30:00', '14:00:00', 'Half Day'),
(1, '2024-06-04', '09:00:00', '18:00:00', 'Present'),
(2, '2024-06-04', NULL,       NULL,       'Leave'),
(3, '2024-06-04', '09:10:00', '18:05:00', 'Present'),
(6, '2024-06-04', '08:55:00', '18:00:00', 'Present'),
(7, '2024-06-04', '09:20:00', '18:15:00', 'Present');

-- Leave Requests (6 entries)
INSERT INTO leave_requests (employee_id, leave_type, start_date, end_date, reason, approval_status, approved_by) VALUES
(3, 'Sick',   '2024-06-10', '2024-06-11', 'Fever and cold',          'Approved',  1),
(4, 'Casual', '2024-06-12', '2024-06-12', 'Personal work',           'Approved',  1),
(2, 'Earned', '2024-06-20', '2024-06-25', 'Family vacation',         'Pending',   NULL),
(5, 'Casual', '2024-06-15', '2024-06-15', 'Bank related work',       'Rejected',  1),
(6, 'Sick',   '2024-06-08', '2024-06-09', 'Hospitalization',         'Approved',  2),
(8, 'Earned', '2024-07-01', '2024-07-05', 'Wedding attendance',      'Pending',   NULL);

-- ============================================================
-- DATA MANIPULATION QUERIES
-- ============================================================

-- INSERT: Add a new employee
INSERT INTO employees (first_name, last_name, email, phone, gender, hire_date, department_id, designation_id, manager_id)
VALUES ('Rohit', 'Verma', 'rohit.verma@ems.com', '9000000009', 'Male', '2024-06-01', 2, 2, 2);

-- UPDATE: Update employee phone number
UPDATE employees SET phone = '9001112233' WHERE employee_id = 3;

-- UPDATE: Change employee status to Inactive
UPDATE employees SET status = 'Inactive' WHERE employee_id = 4;

-- UPDATE: Approve a pending leave request
UPDATE leave_requests SET approval_status = 'Approved', approved_by = 1 WHERE leave_id = 3;

-- DELETE: Remove a rejected leave request
DELETE FROM leave_requests WHERE approval_status = 'Rejected' AND employee_id = 5;

-- ============================================================
-- DATA RETRIEVAL QUERIES
-- ============================================================

-- QUERY 1: List all employees with their department and designation (JOIN)
SELECT 
    e.employee_id,
    CONCAT(e.first_name, ' ', e.last_name) AS employee_name,
    d.department_name,
    dg.designation_name,
    e.status
FROM employees e
LEFT JOIN departments  d  ON e.department_id  = d.department_id
LEFT JOIN designations dg ON e.designation_id = dg.designation_id
ORDER BY d.department_name, e.first_name;

-- QUERY 2: Total and average net salary by department (GROUP BY + JOIN)
SELECT 
    d.department_name,
    COUNT(e.employee_id)    AS total_employees,
    SUM(s.net_salary)       AS total_salary_cost,
    ROUND(AVG(s.net_salary), 2) AS avg_net_salary
FROM employees e
JOIN departments d ON e.department_id = d.department_id
JOIN salaries    s ON e.employee_id   = s.employee_id
GROUP BY d.department_name
ORDER BY total_salary_cost DESC;

-- QUERY 3: Attendance summary per employee for June 2024 (GROUP BY + FILTERING)
SELECT 
    CONCAT(e.first_name, ' ', e.last_name) AS employee_name,
    COUNT(CASE WHEN a.status = 'Present'  THEN 1 END) AS present_days,
    COUNT(CASE WHEN a.status = 'Absent'   THEN 1 END) AS absent_days,
    COUNT(CASE WHEN a.status = 'Half Day' THEN 1 END) AS half_days,
    COUNT(CASE WHEN a.status = 'Leave'    THEN 1 END) AS leave_days
FROM employees e
LEFT JOIN attendance a ON e.employee_id = a.employee_id
    AND a.attendance_date BETWEEN '2024-06-01' AND '2024-06-30'
GROUP BY e.employee_id, employee_name
ORDER BY present_days DESC;

-- QUERY 4: Employee-manager hierarchy (SELF JOIN)
SELECT 
    CONCAT(e.first_name, ' ', e.last_name) AS employee_name,
    CONCAT(m.first_name, ' ', m.last_name) AS manager_name,
    d.department_name
FROM employees e
LEFT JOIN employees   m ON e.manager_id    = m.employee_id
LEFT JOIN departments d ON e.department_id = d.department_id
ORDER BY manager_name, employee_name;

-- QUERY 5: All approved leave requests with employee details (JOIN + ORDER)
SELECT 
    CONCAT(e.first_name, ' ', e.last_name) AS employee_name,
    lr.leave_type,
    lr.start_date,
    lr.end_date,
    lr.total_days,
    lr.approval_status,
    CONCAT(a.first_name, ' ', a.last_name) AS approved_by
FROM leave_requests lr
JOIN employees e ON lr.employee_id = e.employee_id
LEFT JOIN employees a ON lr.approved_by = a.employee_id
WHERE lr.approval_status = 'Approved'
ORDER BY lr.start_date;

-- ============================================================
-- COMPLEX QUERIES
-- ============================================================

-- COMPLEX QUERY 1: Employees earning above average net salary (SUBQUERY)
SELECT 
    CONCAT(e.first_name, ' ', e.last_name) AS employee_name,
    d.department_name,
    s.net_salary
FROM employees e
JOIN salaries    s ON e.employee_id   = s.employee_id
JOIN departments d ON e.department_id = d.department_id
WHERE s.net_salary > (
    SELECT AVG(net_salary) FROM salaries
)
ORDER BY s.net_salary DESC;

-- COMPLEX QUERY 2: Departments with no absent employees on 2024-06-03 (NOT EXISTS / SUBQUERY)
SELECT d.department_name
FROM departments d
WHERE NOT EXISTS (
    SELECT 1
    FROM employees e
    JOIN attendance a ON e.employee_id = a.employee_id
    WHERE e.department_id  = d.department_id
      AND a.attendance_date = '2024-06-03'
      AND a.status          = 'Absent'
);

-- COMPLEX QUERY 3: Top earner per department using window function (CTE + RANK)
WITH ranked_salaries AS (
    SELECT 
        e.employee_id,
        CONCAT(e.first_name, ' ', e.last_name) AS employee_name,
        d.department_name,
        s.net_salary,
        RANK() OVER (PARTITION BY e.department_id ORDER BY s.net_salary DESC) AS salary_rank
    FROM employees e
    JOIN salaries    s ON e.employee_id   = s.employee_id
    JOIN departments d ON e.department_id = d.department_id
)
SELECT department_name, employee_name, net_salary
FROM ranked_salaries
WHERE salary_rank = 1;
