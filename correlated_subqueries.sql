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
select department,
	first_name,
	salary,
	case when salary = (select max(salary) from employees where department = e.department) then 'HIGHEST SALARY'
	when salary = (select min(salary) from employees where department = e.department) then 'LOWEST SALARY' end as salary_in_department
from employees e
where salary = (select max(salary)
			   	from employees
			   	where department = e.department)
or salary = (select min(salary)
			from employees
			where department = e.department)
group by 1, 2, 3
order by 1, 4;

-- Alternative solution
select department, first_name, salary, 
case when salary = max_by_department then 'HIGHEST SALARY'
	 when salary = min_by_department then 'LOWEST SALARY' 
end as salary_in_department
from(
select department, first_name, salary,
	(select max(salary) from employees e2
	where e1.department = e2.department) as max_by_department,
	(select min(salary) from employees e2
	where e1.department = e2.department) as min_by_department
from employees e1
	) a
where salary = max_by_department 
	or salary = min_by_department
order by 1;

		
select department, first_name, salary,
		(select max(salary) from employees e2
		where e1.department = e2.department) as max_by_department,
		(select min(salary) from employees e2
		where e1.department = e2.department) as min_by_department
from employees e1
order by department

