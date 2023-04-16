-- Find count of salary categories of employees

select sal_cats.category,
	count(*)
from (select first_name, salary,
case
	when salary < 100000 then 'UNDER PAID'
	when salary > 100000 and salary < 160000 then 'PAID WELL'
	when salary > 160000 then 'EXECUTIVE'
	else 'UNPAID'
	end as category
from employees
order by salary desc) as sal_cats
group by 1

-- Transpose this data

select sum(case when salary < 100000 then 1 else 0 end) as under_paid,
		sum(case when salary > 100000 and salary < 160000 then 1 else 0 end) as paid_well,
		sum(case when salary > 160000 then 1 else 0 end) as executive
from employees

