-- return first name, email address, and division employee works in
SELECT first_name, email, division
FROM employees e, departments d
WHERE e.department = d.department
AND email IS NOT null;

-- add department and country
SELECT first_name, email, e.department, division, country
FROM employees e, departments d, regions r
WHERE e.department = d.department
AND e.region_id = r.region_id
AND email IS NOT null;

-- return country, total employees per country
SELECT country, count(employee_id)
FROM regions r, employees e
WHERE e.region_id = r.region_id
GROUP BY 1;

-- return departments in employees table that are not in departments
SELECT DISTINCT e.department, d.department
FROM employees e 
LEFT JOIN departments d
ON e.department = d.department
WHERE d.department IS NULL;

SELECT DISTINCT department
FROM employees
EXCEPT
SELECT department
from departments;

-- Oracle uses MINUS instead of EXCEPT
-- return department and total number of employees per department, total at end
SELECT department, count(employee_id)
FROM employees
GROUP BY 1
UNION ALL
SELECT 'TOTAL', count(employee_id)
FROM employees;

-- last employee hired
SELECT e.first_name, e.department, hire_date, r.country
FROM employees e
JOIN regions r
ON e.region_id = r.region_id
WHERE hire_date = (SELECT MAX(hire_date) FROM employees)
OR hire_date = (SELECT MIN(hire_date) FROM employees);

-- return report of salary spending fluctuation for each 90 day spending period
SELECT first_name, hire_date, salary,
(SELECT SUM(salary) FROM employees e2
	WHERE e2.hire_date BETWEEN e.hire_date - 90 AND e.hire_date) as spending_pattern
FROM employees e
ORDER BY hire_date;

-- create a view
CREATE VIEW v_employee_information as
SELECT first_name, email, e.department, salary, division, region, country
FROM employees e, departments d, regions r
WHERE e.department = d.department
AND e.region_id = r.region_id;

-- inline view
SELECT *
FROM (SELECT * FROM departments) a;

-- return student's name, courses student is taking, and professor's that 
-- teach that course
SELECT s.student_name, s_e.course_no, p.last_name as professor_name
FROM students s
JOIN student_enrollment s_e
on s.student_no = s_e.student_no
JOIN teach t
ON s_e.course_no = t.course_no
JOIN professors p
ON t.last_name = p.last_name
ORDER BY 1

