-- Convert funding_total and founded_at_clean columns to strings
-- Use different formatting function for each 
SELECT funding_total_usd::varchar, 
      CAST(founded_at_clean AS varchar) 
FROM tutorial.crunchbase_companies_clean_date;

-- How has web traffic changed oveer time?
SELECT DATE_TRUNC('month', occurred_at) AS month,
      channel,
      COUNT(id) AS visits
FROM demo.web_events
WHERE occurred_at BETWEEN '2015-01-01' AND '2015-12-31 23:59:59'
GROUP BY 1, 2
ORDER BY 1, 2;

-- Return orders placed on this day 7 years ago
SELECT *
FROM demo.orders
WHERE occurred_at >= NOW() - interval '7 years';

-- What hours have the most orders?
SELECT EXTRACT(hour from occurred_at) AS hour,
      COUNT(*) AS orders
FROM demo.orders
GROUP BY 1
ORDER BY 1;

-- What's the average weekday order volume?
SELECT AVG(orders) AS avg_orders_weekday
FROM (
SELECT EXTRACT(dow from occurred_at) AS dow,
      DATE_TRUNC('day', occurred_at) AS day,
      COUNT(id) AS orders
FROM demo.orders
GROUP BY 1, 2) a
WHERE dow NOT IN (0,6);

-- How old is a customer account?
SELECT name, 
      AGE(created) AS account_age
FROM modeanalytics.customer_accounts
ORDER BY 2 desc;

-- How long does it take users to complete their profile each
-- month, on average?
SELECT DATE_TRUNC('month', started_at) AS month,
      EXTRACT(EPOCH FROM AVG(AGE(ended_at, started_at))) time_to_complete
FROM modeanalytics.profile_creation_events
GROUP BY 1
ORDER BY 1;

-- Return number of companies acquired within 3 years, 5 years, and 10 years
-- of being founded. Include column for total companies. Group by category and
-- limit to only rows with a founding date
SELECT companies.category_code,
      COUNT(CASE WHEN acquisitions.acquired_at_cleaned <= companies.founded_at_clean::timestamp + INTERVAL '3 years'
                  THEN 1 ELSE NULL END) AS acquired_3_yrs,
      COUNT(CASE WHEN acquisitions.acquired_at_cleaned <= companies.founded_at_clean::timestamp + INTERVAL '5 years'
                  THEN 1 ELSE NULL END) AS acquired_5_yrs,
      COUNT(CASE WHEN acquisitions.acquired_at_cleaned <= companies.founded_at_clean::timestamp + INTERVAL '10 years'
                  THEN 1 ELSE NULL END) AS acquired_10_yrs,
      COUNT(1) AS total
FROM tutorial.crunchbase_companies_clean_date companies
JOIN tutorial.crunchbase_acquisitions_clean_date acquisitions
ON acquisitions.company_permalink = companies.permalink
WHERE founded_at_clean IS NOT NULL
GROUP BY 1
ORDER BY 5 DESC;

-- Use left and right functions to clean date and time
SELECT incidnt_num,
    date,
    LEFT(date, 10) AS cleaned_date,
    RIGHT(date, LENGTH(date) - 11) AS cleaned_time
FROM tutorial.sf_crime_incidents_2014_01;

-- Use trim to remove () from location
SELECT location,
    TRIM(both '()' FROM location)
FROM tutorial.sf_crime_incidents_2014_01;

-- Use substring to find the day from date
SELECT incidnt_num,
      date,
      SUBSTR(date, 4, 2) AS day
FROM tutorial.sf_crime_incidents_2014_01;

-- Seperate the location field into seperate fields for lat and long
SELECT location,
      TRIM(leading '(' FROM LEFT(location, POSITION(',' IN location) -1)) AS latitude,
      TRIM(trailing ')' FROM RIGHT(location, LENGTH(location) - POSITION(',' IN location))) AS longtitude
FROM tutorial.sf_crime_incidents_2014_01;

-- Concat day and date 
SELECT incidnt_num,
      day_of_week,
      LEFT(date, 10) AS cleaned_date,
      CONCAT(day_of_week, ', ', LEFT(date, 10)) AS day_and_date
FROM tutorial.sf_crime_incidents_2014_01;

-- Concat lat and lon fields to form field eqivalent to location field
SELECT CONCAT(lat, ', ', lon),
      location
FROM tutorial.sf_crime_incidents_2014_01;

-- Or use || for concat
SELECT '(' || lat || ', ' || lon || ')',
      location
FROM tutorial.sf_crime_incidents_2014_01;

-- format date as YYYY-MM-DD
SELECT date, 
      SUBSTR(date, 7, 4) || '-' || LEFT(date, 2) || '-' || SUBSTR(date, 4, 2) as format_date 
FROM tutorial.sf_crime_incidents_2014_01;

-- Capitalize first letter of category field
SELECT UPPER(LEFT(category, 1)) || LOWER(RIGHT(category, -1)) as cap_cat
FROM tutorial.sf_crime_incidents_2014_01;

-- Create accurate timestamp using date and time
-- Include field exactly 1 week later
SELECT incidnt_num,
       (SUBSTR(date, 7, 4) || '-' || LEFT(date, 2) ||
        '-' || SUBSTR(date, 4, 2) || ' ' || time || ':00')::timestamp AS timestamp,
       (SUBSTR(date, 7, 4) || '-' || LEFT(date, 2) ||
        '-' || SUBSTR(date, 4, 2) || ' ' || time || ':00')::timestamp
        + INTERVAL '1 week' AS timestamp_plus_interval
FROM tutorial.sf_crime_incidents_2014_01;

-- Return number of incidents reported by week
SELECT DATE_TRUNC('week', cleaned_date)::date as week,
      COUNT(*) as incidents
FROM tutorial.sf_crime_incidents_cleandate
GROUP BY 1
ORDER BY 1;

-- Show how long ago each incident was reported
SELECT incidnt_num,
      NOW() AT TIME ZONE 'PST' - cleaned_date AS time_ago
FROM tutorial.sf_crime_incidents_cleandate;

-- Replace null values in description using coalesce
SELECT incidnt_num,
      descript,
      COALESCE(descript, 'No Description')
FROM tutorial.sf_crime_incidents_cleandate
ORDER BY descript DESC;

-- Return all unresolved incidents involving warrant arrests
SELECT *
FROM (
    SELECT * 
    FROM tutorial.sf_crime_incidents_2014_01
    WHERE descript ilike 'warrant arrest') warrant
WHERE warrant.resolution ilike 'none';

-- Display average number of monthly incidents for each category
SELECT sub.category,
      AVG(sub.incidents) AS avg_incidents_per_month
FROM (
    SELECT EXTRACT('month' FROM cleaned_date) AS month,
    category,
    COUNT(1) AS incidents
    FROM tutorial.sf_crime_incidents_cleandate
    GROUP BY 1, 2
    ) as sub
GROUP BY 1;

-- display all rows from three categories with fewest incidents reported
SELECT incidents.*
FROM tutorial.sf_crime_incidents_2014_01 incidents
JOIN (
    SELECT category,
          COUNT(incidnt_num)
    FROM tutorial.sf_crime_incidents_2014_01
    GROUP BY 1
    ORDER BY 2
    LIMIT 3) sub
  ON incidents.category = sub.category;
  
-- Count the number of companies founded and acquired by quarter starting in Q1 2012
-- create the aggregations in two sep queries, then join them
SELECT COALESCE(companies.quarter, acquisitions.quarter) AS quarter,
      companies.companies_founded,
      acquisitions.companies_acquired
FROM (
    SELECT founded_quarter as quarter,
          COUNT(permalink) AS companies_founded
    FROM tutorial.crunchbase_companies
    WHERE founded_year >= 2012
    GROUP BY 1
    ) companies

LEFT JOIN (
    SELECT acquired_quarter as quarter,
          COUNT(company_permalink) AS companies_acquired
    FROM tutorial.crunchbase_acquisitions
    WHERE acquired_year >= 2012
    GROUP BY 1
    ) acquisitions
    
  ON companies.quarter = acquisitions.quarter
ORDER BY 1;

-- Rank investors from the combined dataset by the total number of investments made
SELECT distinct investor_name,
      COUNT(investor_permalink)
FROM (
      SELECT * 
      FROM tutorial.crunchbase_investments_part1
      UNION ALL
      SELECT *
      FROM tutorial.crunchbase_investments_part2
      ) sub
GROUP BY 1
ORDER BY 2 DESC;

-- Now only for companies that are still operating
SELECT distinct investor_name,
      COUNT(investor_permalink)
FROM tutorial.crunchbase_companies companies
JOIN (
      SELECT * 
      FROM tutorial.crunchbase_investments_part1
      UNION ALL
      SELECT *
      FROM tutorial.crunchbase_investments_part2
      ) investments
ON investments.company_permalink = companies.permalink
WHERE companies.status = 'operating'
GROUP BY 1
ORDER BY 2 DESC;

-- Window Functions, return running total of ride duration from start terminal
SELECT start_terminal,
      duration_seconds,
      SUM(duration_seconds) OVER
      (PARTITION BY start_terminal ORDER BY start_time)
      AS running_total
FROM tutorial.dc_bikeshare_q1_2012
WHERE start_time < '2012-01-08';

-- Show duration of each ride as a percentage of the total time from each start terminal
SELECT start_terminal,
      duration_seconds,
      (duration_seconds/SUM(duration_seconds) OVER (PARTITION BY start_terminal))*100 AS pct_of_total_time
FROM tutorial.dc_bikeshare_q1_2012;

-- Use all aggregates
SELECT start_terminal,
      duration_seconds,
      SUM(duration_seconds) OVER
        (PARTITION BY start_terminal) AS running_total,
      COUNT(duration_seconds) OVER
        (PARTITION BY start_terminal) AS running_count,
      AVG(duration_seconds) OVER
        (PARTITION BY start_terminal) AS running_avg
FROM tutorial.dc_bikeshare_q1_2012
WHERE start_time < '2012-01-08';

SELECT start_terminal,
      duration_seconds,
      SUM(duration_seconds) OVER
        (PARTITION BY start_terminal ORDER BY start_time) AS running_total,
      COUNT(duration_seconds) OVER
        (PARTITION BY start_terminal ORDER BY start_time) AS running_count,
      AVG(duration_seconds) OVER
        (PARTITION BY start_terminal ORDER BY start_time) AS running_avg
FROM tutorial.dc_bikeshare_q1_2012
WHERE start_time < '2012-01-08';

-- Show running total of duration of bike rides grouped by end terminal and with
-- ride duration sorted in descending order
SELECT end_terminal,
      duration_seconds,
      SUM(duration_seconds) OVER 
        (PARTITION BY end_terminal ORDER BY duration_seconds desc) as running_total
FROM tutorial.dc_bikeshare_q1_2012
WHERE start_time < '2012-01-08';

