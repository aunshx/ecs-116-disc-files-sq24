set search_path to company_2;

show search_path;

-- Calculate the total number of employees per department
SELECT d.dname AS department_name, COUNT(e.ssn) AS count
FROM employee_with_comments e
JOIN department d ON e.dno = d.dnumber
GROUP BY d.dname
ORDER BY count DESC;

-- Average Salary by Department
SELECT d.dname AS departmentName, AVG(e.salary) AS averageSalary
FROM employee_with_comments  e
JOIN department d ON e.dno = d.dnumber
GROUP BY d.dname;

-- Average Project Hours by Employee with Comments
SELECT d.dname AS departmentName, AVG(e.salary) AS averageSalary, COUNT(e.ssn) AS employeeCount
FROM employee_with_comments e
JOIN department d ON e.dno = d.dnumber
GROUP BY d.dname;

-- Total Hours Worked by Each Employee on Each Project
SELECT CONCAT(e.fname, ' ', e.lname) AS employeeName, p.pname AS projectName, SUM(w.hours) AS totalHours
FROM works_on w
JOIN employee_with_comments e ON w.essn = e.ssn
JOIN project p ON w.pno = p.pnumber
GROUP BY e.fname, e.lname, p.pname;

-- Find Employees with Positive Comments
SELECT fname, lname, comments
FROM employee_with_comments
WHERE comments LIKE '%good%' OR comments LIKE '%nice%' OR comments LIKE '%amazing%';

-- Find Employees with Negative Comments
SELECT fname, lname, comments
FROM employee_with_comments
WHERE comments LIKE '%bad%' OR comments LIKE '%worse%';


