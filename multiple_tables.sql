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



