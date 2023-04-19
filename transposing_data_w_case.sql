-- Initial query
select department,
		count(*)
from employees
where department in ('Sports', 'Tools', 'Clothing', 'Computers')
group by department;

-- Transpose this data
select sum(case when department ilike 'sports' then 1 else 0 end) as sports_employees,
		sum(case when department ilike 'tools' then 1 else 0 end) as tools_employees,
		sum(case when department ilike 'clothing' then 1 else 0 end) as clothing_employees,
		sum(case when department ilike 'computers' then 1 else 0 end) as computers_employees
from employees;

-- Transpose employees' regions
select first_name,
		case when region_id = 1 then (select country from regions where region_id = 1) else null end as region_1,
		case when region_id = 2 then (select country from regions where region_id = 2) else null end as region_2,
		case when region_id = 3 then (select country from regions where region_id = 3) else null end as region_3,
		case when region_id = 4 then (select country from regions where region_id = 4) else null end as region_4,
		case when region_id = 5 then (select country from regions where region_id = 5) else null end as region_5,
		case when region_id = 6 then (select country from regions where region_id = 6) else null end as region_6,
		case when region_id = 7 then (select country from regions where region_id = 7) else null end as region_7
from employees;

-- Produce count of total employees in each area (transposed)
select sum(case when region_id in(1,2,3) then 1 else 0 end) as united_states,
		sum(case when region_id in (4,5) then 1 else 0 end) as asia,
		sum(case when region_id in (6,7) then 1 else 0 end) as canada
from employees;

-- Display 3 columns: fruit, total supply, category
select name,
		total_supply,
		case when total_supply < 20000 then 'low' 
		when total_supply >= 20000 and total_supply <= 50000 then 'enough'
		when total_supply > 50000 then 'full' end as category
from (
select name, sum(supply) total_supply
from fruit_imports
group by name
)a;

-- tabulate total cost to import fruits by each season
select distinct season,
		total_cost
from (
select season, sum(supply * cost_per_unit) total_cost
from fruit_imports
group by season) a;

-- transpose this data
select sum(case when season ilike 'winter' then total_cost end) as winter,
		sum(case when season ilike 'summer' then total_cost end) as summer,
		sum(case when season ilike 'all year' then total_cost end) as all_year,
		sum(case when season ilike 'spring' then total_cost end) as spring,
		sum(case when season ilike 'fall' then total_cost end) as fall
from (
select season, sum(supply * cost_per_unit) total_cost
from fruit_imports
group by season
) a;