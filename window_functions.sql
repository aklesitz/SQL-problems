-- window function
SELECT first_name, department,
COUNT(*) OVER(PARTITION BY department)
FROM employees e2;

-- same as
SELECT first_name, department,
(SELECT count(*) FROM employees e2 WHERE e2.department = e1.department)
FROM employees e1
ORDER BY department;

-- return running sum of salaries
SELECT first_name, hire_date, salary,
SUM(salary) OVER(ORDER BY hire_date RANGE BETWEEN UNBOUNDED PRECEDING
				AND CURRENT ROW) as running_total_of_salaries
FROM employees;

-- return sum of adjacent salaries
SELECT first_name, hire_date, salary,
SUM(salary) OVER(ORDER BY hire_date ROWS BETWEEN 1 PRECEDING
				AND CURRENT ROW)
FROM employees;
