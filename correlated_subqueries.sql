-- Correlated subqueries
-- obtain names of departments that have > 38 employees working				   
select department
from departments
where 38 < (select count(*)
		   from employees e
		   where e.department = departments.department);
		   
-- obtain highest paid salary of those departments
select department, (select max(salary) from employees where department = d.department)
from departments d
where 38 < (select count(*)
		   from employees e
		   where e.department = d.department);
		   
-- return department, first name of employee with highest salary, lowest salary, and label
select distinct e.department
from employees e
where e.salary = (select max(e.salary))
			   		
--or salary = (select min(salary)
			from employees)
		
		


