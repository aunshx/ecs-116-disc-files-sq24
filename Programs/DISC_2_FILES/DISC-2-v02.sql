-- Basics

set search_path to company;

-- STEP 1: SIMPLE QUERIES

-- 1. Retrieve all data from the employee table

SELECT * FROM employee;

-- 2. Get the names and birth dates of all dependents

SELECT dependent_name, bdate FROM dependent;

-- 3. Find all locations of the 'Research' department

SELECT dlocation FROM dept_locations
WHERE dnumber = (
SELECT dnumber FROM department
WHERE dname = 'Research'
);

-- STEP 2: ADDING TABLES, INSERT, DELETE

-- 1. Creating an employee feedback table

CREATE TABLE employee_feedback (
feedback_id SERIAL PRIMARY KEY,
employee_ssn CHAR(9),
feedback_date DATE,
feedback_text TEXT
);

-- 2. Inserting data into the table

INSERT INTO employee_feedback (employee_ssn, feedback_date, feedback_text)
VALUES
('123456789', '2023-04-01', 'Shows excellent leadership skills and
initiative.'),
('987654321', '2023-04-02', 'Needs to improve on time management and
deadlines.'),
('555666777', '2023-04-03', 'Consistently exceeds expectations in project
delivery.');

-- 3. Change the feedback for one employee

UPDATE employee_feedback
SET feedback_text = 'Needs to be FIRED'
WHERE employee_ssn = '123456789'
returning employee_ssn;

-- 4. Delete one employee from the table

DELETE FROM employee_feedback
WHERE employee_ssn = '123456789';

-- 5. Change column name

ALTER TABLE employee_feedback
RENAME COLUMN feedback_text TO feedback;

-- 6. Insert new employee

INSERT INTO employee_feedback (employee_ssn, feedback_date, feedback)
VALUES ('112233435', '2023-04-10', 'Make him the CEO');

-- 7. Make employee_ssn unique

ALTER TABLE employee_feedback
ADD CONSTRAINT unique_employee_ssn UNIQUE (employee_ssn);

-- 8. Delete data from table

DELETE FROM employee_feedback;

----- STEP 3: QUERIES WITH MULTIPLE RELATIONS

-- 1. List all employees and their department names

SELECT E.fname, E.lname, D.dname
FROM employee E
JOIN department D ON E.dno = D.dnumber;

-- 2. Find employees and their dependents

SELECT E.fname, E.lname, Dep.dependent_name
FROM employee E
JOIN dependent Dep ON E.ssn = Dep.essn;

-- 3. Get all projects along with department names

SELECT P.pname, D.dname
FROM project P
JOIN department D ON P.dnum = D.dnumber;

----- STEP 4: COMPLEX QUERIES

-- 1. Find pairs of employees who work in the same department

SELECT E1.fname AS Employee1, E2.fname AS Employee2, D.dname
FROM employee E1
JOIN employee E2 ON E1.dno = E2.dno AND E1.ssn != E2.ssn
JOIN department D ON E1.dno = D.dnumber;

-- 2. Finding pairs of employees who report to the same supervisor

SELECT A.fname AS Employee1, B.fname AS Employee2, A.super_ssn AS
SupervisorSSN
FROM employee A, employee B
WHERE A.super_ssn = B.super_ssn
AND A.ssn != B.ssn;

-- 3. Listing employees along with their direct supervisors' names

SELECT E.fname AS Employee, S.fname AS Supervisor
FROM employee E
JOIN employee S ON E.super_ssn = S.ssn
WHERE E.super_ssn IS NOT NULL;

-- 4. Comparing salaries of employees within the same department

SELECT A.fname AS Employee1, A.salary AS Salary1, B.fname AS Employee2,
B.salary AS Salary2
FROM employee A
JOIN employee B ON A.dno = B.dno AND A.ssn != B.ssn
WHERE A.salary > B.salary;

-- STEP 5: AGGREGATE QUERIES

-- 1. Count the number of employees in each department

SELECT D.dname, COUNT(*) AS Num_Employees
FROM employee E
JOIN department D ON E.dno = D.dnumber
GROUP BY D.dname;

-- 2. Calculate the average salary of employees in each department

SELECT D.dname, AVG(E.salary) AS Avg_Salary
FROM employee E
JOIN department D ON E.dno = D.dnumber
GROUP BY D.dname;

-- 3. List departments and the number of projects they have

SELECT D.dname, COUNT(P.pnumber) AS Num_Projects
FROM department D
JOIN project P ON D.dnumber = P.dnum
GROUP BY D.dname;

-- STEP 6: STRING OPERATIONS 

--1. Department Names Containing 'a' 

SELECT dname FROM department WHERE dname LIKE '%a%';

-- 2 . Employee Names Starting With 'J'

SELECT fname, minit, lname FROM employee WHERE fname LIKE 'J%';

--3. Project locations with departments

SELECT p.pname, p.plocation, d.dname
FROM project p
JOIN department d ON p.dnum = d.dnumber
WHERE p.plocation LIKE '%Stafford%';

--4. Find Employees Whose Names Contain 'a' and Manage Departments in Multiple Cities

SELECT e.fname, e.lname, d.dname, COUNT(DISTINCT dl.dlocation) AS
location_count
FROM employee e
JOIN department d ON e.ssn = d.mgr_ssn
JOIN dept_locations dl ON d.dnumber = dl.dnumber
WHERE e.fname LIKE '%a%' OR e.lname LIKE '%a%'
GROUP BY e.fname, e.lname, d.dname
HAVING COUNT(DISTINCT dl.dlocation) > 1;

-- STEP 7: ADDITIONAL QUERIES

-- 1. List employees who work on a project located in 'Houston' ordered by last name

SELECT DISTINCT E.lname, E.fname
FROM employee E
JOIN works_on W ON E.ssn = W.essn
JOIN project P ON W.pno = P.pnumber
WHERE P.plocation = 'Houston'
ORDER BY E.lname;

-- 2. Find departments with more than three employees

SELECT D.dname, COUNT(E.ssn) AS Num_Employees
FROM department D
JOIN employee E ON D.dnumber = E.dno
GROUP BY D.dname
HAVING COUNT(E.ssn) > 3;

-- 3. List all projects along with the number of employees working on each, ordered by project number

SELECT P.pname, COUNT(W.essn) AS Num_Employees
FROM project P
LEFT JOIN works_on W ON P.pnumber = W.pno
GROUP BY P.pname, P.pnumber
ORDER BY P.pnumber;

-- STEP 8: USING ORDER BY WITH AGGREGATION 

-- 1. Show the average salary of employees in each department, sorted by average salary in descending order

SELECT D.dname, AVG(E.salary) AS Avg_Salary
FROM employee E
JOIN department D ON E.dno = D.dnumber
GROUP BY D.dname
ORDER BY AVG(E.salary) DESC;

-- 2. List departments and their total number of projects, sorted by the total number of projects ascending

SELECT D.dname, COUNT(P.pnumber) AS Num_Projects
FROM department D
JOIN project P ON D.dnumber = P.dnum
GROUP BY D.dname
ORDER BY COUNT(P.pnumber);
