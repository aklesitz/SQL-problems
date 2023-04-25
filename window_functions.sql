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

-- return employees with eighth highest salaries by department
SELECT * FROM (
SELECT first_name, email, department, salary,
RANK() OVER(PARTITION BY department ORDER BY salary desc)
FROM employees
	) a
WHERE rank = 8;

-- seperate salaries by brackets (5 per department)
SELECT first_name, email, department, salary,
NTILE(5) OVER(PARTITION BY department ORDER BY salary desc) salary_bracket
FROM employees;

-- return first value for each department
SELECT first_name, email, department, salary,
first_value(salary) OVER(PARTITION BY department ORDER BY salary desc) first_value
FROM employees;

-- return 5th value for each department
SELECT first_name, email, department, salary,
nth_value(salary, 5) OVER(PARTITION BY department ORDER BY first_name asc) nth_value
FROM employees;

-- show salary in next row
SELECT first_name, last_name, salary,
LEAD(salary) OVER() next_salary
FROM employees;

-- show salary from previous row
SELECT first_name, last_name, salary,
LAG(salary) OVER() previous_salary
FROM employees;

-- create sales table
CREATE TABLE sales
(
	continent varchar(20),
	country varchar(20),
	city varchar(20),
	units_sold integer
);

INSERT INTO sales VALUES ('North America', 'Canada', 'Toronto', 10000);
INSERT INTO sales VALUES ('North America', 'Canada', 'Montreal', 5000);
INSERT INTO sales VALUES ('North America', 'Canada', 'Vancouver', 15000);
INSERT INTO sales VALUES ('Asia', 'China', 'Hong Kong', 7000);
INSERT INTO sales VALUES ('Asia', 'China', 'Shanghai', 3000);
INSERT INTO sales VALUES ('Asia', 'Japan', 'Tokyo', 5000);
INSERT INTO sales VALUES ('Europe', 'UK', 'London', 6000);
INSERT INTO sales VALUES ('Europe', 'UK', 'Manchester', 12000);
INSERT INTO sales VALUES ('Europe', 'France', 'Paris', 5000);

-- group total units sold by continent, country, and city
SELECT continent, country, city, sum(units_sold)
FROM sales
GROUP BY GROUPING SETS(continent, country, city, ());

-- alternatively
SELECT continent, country, city, sum(units_sold)
FROM sales
GROUP BY ROLLUP(continent, country, city);

-- all possible combinations
SELECT continent, country, city, sum(units_sold)
FROM sales
GROUP BY CUBE(continent, country, city);