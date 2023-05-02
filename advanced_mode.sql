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
