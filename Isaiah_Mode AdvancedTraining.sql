## MODE ADVANCED SQL TRAINING

# SQL DATA TYPES - lots of data types stored as different information
SELECT CAST(funding_total_usd AS varchar) AS funding_total_usd_string, founded_at_clean::varchar AS founded_at_string
  FROM tutorial.crunchbase_companies_clean_date    # can change data types using cast or ::
  
# SQL DATE FORMAT - data must be cleaned appropriately to avoid incorrect sorting
SELECT permalink, founded_at
  FROM tutorial.crunchbase_companies_clean_date ORDER BY founded_at
 SELECT permalink, founded_at, founded_at_clean
  FROM tutorial.crunchbase_companies_clean_date ORDER BY founded_at_clean
SELECT companies.permalink, companies.founded_at_clean, acquisitions.acquired_at_cleaned,
       acquisitions.acquired_at_cleaned - companies.founded_at_clean::timestamp    # subtracting dates will give interval data type
  FROM tutorial.crunchbase_companies_clean_date companies
  JOIN tutorial.crunchbase_acquisitions_clean_date acquisitions ON acquisitions.company_permalink = companies.permalink 
  WHERE founded_at_clean IS NOT NULL
SELECT companies.permalink, companies.founded_at_clean,
       companies.founded_at_clean::timestamp + INTERVAL '1 week' AS plus_one_week    # can also use interval keyword
  FROM tutorial.crunchbase_companies_clean_date companies WHERE founded_at_clean IS NOT NULL
SELECT companies.permalink, companies.founded_at_clean,
       NOW() - companies.founded_at_clean::timestamp    # can use NOW() to add current time and query run
  FROM tutorial.crunchbase_companies_clean_date companies WHERE founded_at_clean IS NOT NULL
  
SELECT companies.category_code,
       COUNT(CASE WHEN acquisitions.acquired_at_cleaned <= companies.founded_at_clean::timestamp + INTERVAL '3 years'
                       THEN 1 ELSE NULL END) AS acquired_3_yrs,
       COUNT(CASE WHEN acquisitions.acquired_at_cleaned <= companies.founded_at_clean::timestamp + INTERVAL '5 years'
                       THEN 1 ELSE NULL END) AS acquired_5_yrs,
       COUNT(CASE WHEN acquisitions.acquired_at_cleaned <= companies.founded_at_clean::timestamp + INTERVAL '10 years'
                       THEN 1 ELSE NULL END) AS acquired_10_yrs,
       COUNT(1) AS total
  FROM tutorial.crunchbase_companies_clean_date companies 
  JOIN tutorial.crunchbase_acquisitions_clean_date acquisitions ON acquisitions.company_permalink = companies.permalink
 WHERE founded_at_clean IS NOT NULL GROUP BY 1 ORDER BY 5 DESC
 
# SQL STRING FUNCTIONS
# LEFT - Pulls a certain number of chars from left side of string (simmilar for RIGHT)
SELECT incidnt_num, date,
       LEFT(date, 10) AS cleaned_date, RIGHT(date, 17) AS cleaned_time
  FROM tutorial.sf_crime_incidents_2014_01
  
# LENGTH - gives the length of a string
SELECT incidnt_num, date,
       LEFT(date, 10) AS cleaned_date, RIGHT(date, LENGTH(date) - 11) AS cleaned_time
  FROM tutorial.sf_crime_incidents_2014_01
  
# TRIM - removes characters from beginning and end of a string
SELECT location, TRIM(both '()' FROM location)    # uses FROM to specify trim location
  FROM tutorial.sf_crime_incidents_2014_01
  
# POSITION - specifies a substring and returns a number value based on character position (STRPOS does same thing)
SELECT incidnt_num, descript,
       POSITION('A' IN descript) AS a_position
  FROM tutorial.sf_crime_incidents_2014_01
SELECT incidnt_num, descript,
       STRPOS(descript, 'A') AS a_position
  FROM tutorial.sf_crime_incidents_2014_01    # both are case-sensitive, must use UPPER or LOWER to avoid this
  
# SUBSTR - same as LEFT & RIGHT but can start in middle
SELECT incidnt_num, date,
       SUBSTR(date, 4, 2)    # 4 is position, 2 is number of chars
  FROM tutorial.sf_crime_incidents_2014_01
SELECT location,
       TRIM(leading '(' FROM LEFT(location, POSITION(',' IN location) - 1)) AS lattitude,
       TRIM(trailing ')' FROM RIGHT(location, LENGTH(location) - POSITION(',' IN location) ) ) AS longitude
  FROM tutorial.sf_crime_incidents_2014_01

# CONCAT - combine strings from several columns together
SELECT incidnt_num, day_of_week,
       LEFT(date, 10) AS cleaned_date, CONCAT(day_of_week, ', ', LEFT(date, 10)) AS day_and_date
  FROM tutorial.sf_crime_incidents_2014_01
SELECT CONCAT('(', lat, ', ', lon, ')') AS concat_location, location
  FROM tutorial.sf_crime_incidents_2014_01
SELECT '(' || lat || ', ' || lon || ')' AS concat_location, location    # may also use || instead
  FROM tutorial.sf_crime_incidents_2014_01
SELECT incidnt_num, date, SUBSTR(date, 7, 4) || '-' || LEFT(date, 2) || '-' || SUBSTR(date, 4, 2) AS cleaned_date
      FROM tutorial.sf_crime_incidents_2014_01
      
# UPPER makes everything uppercase, LOWER for lower
SELECT incidnt_num, category, 
UPPER(LEFT(category, 1)) || LOWER(RIGHT(category, LENGTH(category) - 1)) AS category_cleaned
  FROM tutorial.sf_crime_incidents_2014_01
  
SELECT incidnt_num,
       (SUBSTR(date, 7, 4) || '-' || LEFT(date, 2) ||
        '-' || SUBSTR(date, 4, 2) || ' ' || time || ':00')::timestamp AS timestamp,
       (SUBSTR(date, 7, 4) || '-' || LEFT(date, 2) ||
        '-' || SUBSTR(date, 4, 2) || ' ' || time || ':00')::timestamp
        + INTERVAL '1 week' AS timestamp_plus_interval
  FROM tutorial.sf_crime_incidents_2014_01
  
# EXTRACT pulls apart the data from specific fields
SELECT cleaned_date,
       EXTRACT('year'   FROM cleaned_date) AS year,
       EXTRACT('month'  FROM cleaned_date) AS month,
       EXTRACT('day'    FROM cleaned_date) AS day,
       EXTRACT('hour'   FROM cleaned_date) AS hour,
       EXTRACT('minute' FROM cleaned_date) AS minute,
       EXTRACT('second' FROM cleaned_date) AS second,
       EXTRACT('decade' FROM cleaned_date) AS decade,
       EXTRACT('dow'    FROM cleaned_date) AS day_of_week
  FROM tutorial.sf_crime_incidents_cleandate
  
# DATE_TRUNC will round the dates to the nearest unit of measurement
SELECT cleaned_date,
       DATE_TRUNC('year'   , cleaned_date) AS year,
       DATE_TRUNC('month'  , cleaned_date) AS month,
       DATE_TRUNC('week'   , cleaned_date) AS week,
       DATE_TRUNC('day'    , cleaned_date) AS day,
       DATE_TRUNC('hour'   , cleaned_date) AS hour,
       DATE_TRUNC('minute' , cleaned_date) AS minute,
       DATE_TRUNC('second' , cleaned_date) AS second,
       DATE_TRUNC('decade' , cleaned_date) AS decade
  FROM tutorial.sf_crime_incidents_cleandate
  
SELECT DATE_TRUNC('week', cleaned_date)::date AS week_beginning,
       COUNT(*) AS incidents
  FROM tutorial.sf_crime_incidents_cleandate
 GROUP BY 1 ORDER BY 1    # counts number of incidents reported by week and casts week as date to get rid of h/m/s
 
SELECT CURRENT_DATE AS date,
       CURRENT_TIME AS time,
       CURRENT_TIMESTAMP AS timestamp,
       LOCALTIME AS localtime,
       LOCALTIMESTAMP AS localtimestamp,
       NOW() AS now
SELECT CURRENT_TIME AS time,
       CURRENT_TIME AT TIME ZONE 'PST' AS time_pst
       
# COALESCE - replaces null values
SELECT incidnt_num, descript, COALESCE(descript, 'No Description')
  FROM tutorial.sf_crime_incidents_cleandate
 ORDER BY descript DESC

# SUBQUERIES SQL - 
