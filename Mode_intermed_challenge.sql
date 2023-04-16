-- Familiarization with tables used
select * from sqlchallenge1.accounts;
select * from sqlchallenge1.sales_reps;
select * from sqlchallenge1.orders;
select * from sqlchallenge1.region;

-- Which region has the lowest proportion of sales reps to accounts?

-- Find number of sales reps, accounts, grouped by region
SELECT reps.region_id,
      count(distinct accounts.sales_rep_id) as sales_reps,
      count(distinct accounts.id) as accounts,
      (count(distinct accounts.sales_rep_id)::float / count(distinct accounts.id)) as proportion
FROM sqlchallenge1.accounts accounts
JOIN sqlchallenge1.sales_reps reps
  ON accounts.sales_rep_id = reps.id
GROUP BY 1;

-- Lowest is region 4
select * from sqlchallenge1.region;

-- Answer is West

-- Among sales reps Tia Amato, Delilah Krum, and Soraya Fulton, which one had accounts
-- with the greatest total quantity ordered (not USD) in September 2016?

-- Find IDs of sales reps
SELECT name,
      id
FROM sqlchallenge1.sales_reps
WHERE name ilike 'tia amato'
    OR name ilike 'Delilah Krum'
    OR name ilike 'Soraya Fulton';

-- Amato==321640, Krum==321760, Fulton==321900

-- Find sales for each rep
SELECT accounts.sales_rep_id,
      sum(orders.total)
FROM sqlchallenge1.accounts accounts
JOIN sqlchallenge1.orders orders
  ON accounts.id = orders.account_id
  AND extract(year from orders.occurred_at) = 2016
  AND extract(month from orders.occurred_at) = 09
  AND accounts.sales_rep_id in('321640', '321760', '321900')
group by 1;

-- Answer is Tia Amato

-- Of accounts served by sales reps in the northeast, one account has never
-- bought any posters. Which company? (Enter 'name')

-- Find accounts never bought posters
SELECT accounts.name
from sqlchallenge1.accounts accounts
join sqlchallenge1.orders orders
  on accounts.id = orders.account_id
where orders.poster_qty = 0;

-- Find sales reps of the northeast
SELECT reps.id
FROM sqlchallenge1.sales_reps reps
JOIN sqlchallenge1.region region
  ON reps.region_id = region.id
WHERE region.name ilike 'northeast';

-- Put them together...

SELECT distinct accounts.name
from sqlchallenge1.accounts accounts
join sqlchallenge1.orders orders
  on accounts.id = orders.account_id
where orders.poster_qty = 0
AND accounts.sales_rep_id in(SELECT reps.id
                          FROM sqlchallenge1.sales_reps reps
                          JOIN sqlchallenge1.region region
                           ON reps.region_id = region.id
                          WHERE region.name ilike 'northeast');
-- Answer is Exxon Mobil

--How many accounts have never ordered Poster?
SELECT accounts.id as account_id,
      sum(orders.poster_qty) as Poster_ordered
FROM sqlchallenge1.accounts accounts
join sqlchallenge1.orders orders
  on accounts.id = orders.account_id
group by 1
order by 2;

-- Answer is 2

-- What is the most common first name for account primary poc's?
SELECT distinct primary_poc,
      count(id)
FROM sqlchallenge1.accounts
GROUP BY 1
ORDER BY 2 desc;

select count(id)
from sqlchallenge1.accounts
where primary_poc ilike 'Jodee%'

-- Answer is Jodee