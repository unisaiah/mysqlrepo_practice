## MODE INTERMEDIATE SQL TRAINING

# SQL COUNT - counts number of rows in column, does not include null values for individual column counts
SELECT COUNT(*)
  FROM tutorial.aapl_historical_stock_price
SELECT COUNT(low) AS low
  FROM tutorial.aapl_historical_stock_price
SELECT COUNT(year) AS year, COUNT(month) AS month, COUNT(open) AS open, COUNT(high) AS high,
       COUNT(low) AS low, COUNT(close) AS close, COUNT(volume) AS volume
  FROM tutorial.aapl_historical_stock_price

# SQL SUM - totals values in a given column, only works on numerical columns
 SELECT SUM(volume)
  FROM tutorial.aapl_historical_stock_price
SELECT SUM(open)/COUNT(open)
  FROM tutorial.aapl_historical_stock_price
  
# SQL MIN/MAX - returns lowest number, earlies date, earliest letter etc.
SELECT MIN(volume), MAX(volume)
  FROM tutorial.aapl_historical_stock_price
SELECT MIN(low)
  FROM tutorial.aapl_historical_stock_price
SELECT MAX(close - open)    # can use operators in brackets
  FROM tutorial.aapl_historical_stock_price
  
# SQL AVG - returns average value (ignores null)
SELECT AVG(high)
  FROM tutorial.aapl_historical_stock_price WHERE high IS NOT NULL
SELECT AVG(high)
  FROM tutorial.aapl_historical_stock_price
SELECT AVG(volume)
  FROM tutorial.aapl_historical_stock_price
  
# SQL GROUP BY - separates data into group for aggregate function use
SELECT year, COUNT(*)
  FROM tutorial.aapl_historical_stock_price GROUP BY year
SELECT year, month, SUM(volume)
  FROM tutorial.aapl_historical_stock_price 
  GROUP BY year, month ORDER BY year, month    # can use column numbers too
SELECT year, AVG(close - open)
  FROM tutorial.aapl_historical_stock_price
 GROUP BY 1 ORDER BY 1    # same as typing year
SELECT year, month, MIN(low), MAX(high)
  FROM tutorial.aapl_historical_stock_price
 GROUP BY 1, 2 ORDER BY 1, 2
 
 # SQL HAVING - similar to where clause but for groups
SELECT year, month, MAX(high)
  FROM tutorial.aapl_historical_stock_price
 GROUP BY year, month HAVING MAX(high) > 400 ORDER BY year, month
 
# SQL CASE - checks rows against a certain condition, 'if' condition satisfied 'then' do something, must include CASE, WHEN, THEN & END statement
SELECT player_name, year,
       CASE WHEN year = 'SR' THEN 'yes' ELSE NULL END AS is_a_senior    # prints yes to column 'is a senior' if satisfied, else it will leave a null value
  FROM benn.college_football_players
SELECT player_name, state,
       CASE WHEN state = 'CA' THEN 'yes' ELSE NULL END AS from_california
  FROM benn.college_football_players ORDER BY 3
SELECT player_name, height,
       CASE WHEN height > 74 THEN 'over 74'    # good practice to not have overalapping cases, SQL reads cases in order from first to last though
            WHEN height > 72 AND height <= 74 THEN '73-74'
            WHEN height > 70 AND height <= 72 THEN '71-72'
            ELSE 'under 70' END AS height_group
  FROM benn.college_football_players
SELECT CASE WHEN state IN ('CA', 'OR', 'WA') THEN 'West Coast' WHEN state = 'TX' THEN 'Texas'
            ELSE 'Other' END AS arbitrary_regional_designation, COUNT(1) AS players
  FROM benn.college_football_players WHERE weight >= 300 GROUP BY 1
SELECT CASE WHEN year IN ('FR', 'SO') THEN 'underclass' WHEN year IN ('JR', 'SR') THEN 'upperclass'
            ELSE NULL END AS class_group, SUM(weight) AS combined_player_weight
  FROM benn.college_football_players WHERE state = 'CA' GROUP BY 1
SELECT state,
       COUNT(CASE WHEN year = 'FR' THEN 1 ELSE NULL END) AS fr_count,
       COUNT(CASE WHEN year = 'SO' THEN 1 ELSE NULL END) AS so_count,
       COUNT(CASE WHEN year = 'JR' THEN 1 ELSE NULL END) AS jr_count,
       COUNT(CASE WHEN year = 'SR' THEN 1 ELSE NULL END) AS sr_count,
       COUNT(1) AS total_players    # could also use WHERE clause for single cases (not multiple)
  FROM benn.college_football_players GROUP BY state ORDER BY total_players DESC
SELECT CASE WHEN school_name < 'n' THEN 'A-M' WHEN school_name >= 'n' THEN 'N-Z' ELSE NULL END AS school_name_group,
       COUNT(1) AS players
  FROM benn.college_football_players GROUP BY 1
  
# SQL DISTINCT - looks at only unique values in a particular column (or pair of columns), 
SELECT DISTINCT year
  FROM tutorial.aapl_historical_stock_price ORDER BY year
SELECT COUNT(DISTINCT month) AS unique_months
  FROM tutorial.aapl_historical_stock_price
SELECT month, AVG(volume)
  FROM tutorial.aapl_historical_stock_price
 GROUP BY month ORDER BY 2 DESC
SELECT year, COUNT(DISTINCT month)
  FROM tutorial.aapl_historical_stock_price
 GROUP BY year ORDER BY year
SELECT COUNT(DISTINCT year), COUNT(DISTINCT month)
  FROM tutorial.aapl_historical_stock_price
  
# SQL JOINS - collates two tables of data by joining on specific column to share relational data
SELECT teams.conference, AVG(players.weight)
  FROM benn.college_football_players players
  JOIN benn.college_football_teams teams ON teams.school_name = players.school_name
 GROUP BY teams.conference ORDER BY AVG(players.weight) DESC
SELECT players.school_name, players.player_name, players.position, players.weight
  FROM benn.college_football_players players
 WHERE players.state = 'GA' ORDER BY players.weight DESC

# SQL INNER JOIN - joins the data shared in both tables
SELECT players.*, teams.*
  FROM benn.college_football_players players
  JOIN benn.college_football_teams teams ON teams.school_name = players.school_name
SELECT players.school_name, teams.school_name
  FROM benn.college_football_players players
  JOIN benn.college_football_teams teams ON teams.school_name = players.school_name
SELECT players.player_name, players.school_name, teams.conference
  FROM benn.college_football_players players
  JOIN benn.college_football_teams teams ON teams.school_name = players.school_name
 WHERE teams.division = 'FBS (Division I-A Teams)'
 
 # SQL OUTER JOIN - joins both tables regardless of null data, same as FULL OUTER JOIN
 # SQL LEFT JOIN - similar to right join, joins table 2 with matching info in table 1 but also
				 # shows table 2 values that are null (no corresponding entries in 1), same as OUTER LEFT JOIN
SELECT companies.permalink, companies.name, acquisitions.company_permalink, acquisitions.acquired_at
  FROM tutorial.crunchbase_companies companies
  LEFT JOIN tutorial.crunchbase_acquisitions acquisitions ON companies.permalink = acquisitions.company_permalink
SELECT COUNT(companies.permalink), COUNT(acquisitions.company_permalink)
  FROM tutorial.crunchbase_companies companies
  LEFT JOIN tutorial.crunchbase_acquisitions acquisitions ON companies.permalink = acquisitions.company_permalink    # will count number of non-null table 1 values
SELECT companies.state_code, COUNT(DISTINCT companies.permalink), COUNT(DISTINCT acquisitions.company_permalink)
  FROM tutorial.crunchbase_companies companies
  LEFT JOIN tutorial.crunchbase_acquisitions acquisitions ON companies.permalink = acquisitions.company_permalink
 WHERE companies.state_code IS NOT NULL
 GROUP BY 1 ORDER BY 3 DESC

# SQL RIGHT JOIN - same as LEFT but for table 2
SELECT companies.state_code, COUNT(DISTINCT companies.permalink), COUNT(DISTINCT acquisitions.company_permalink)
  FROM tutorial.crunchbase_acquisitions acquisitions
 RIGHT JOIN tutorial.crunchbase_companies companies ON companies.permalink = acquisitions.company_permalink
 WHERE companies.state_code IS NOT NULL
 GROUP BY 1 ORDER BY 3 DESC

 
# SQL JOINS WITH WHERE or ON - WHERE filters data after tables have been joined but we can filter during the ON clause before joining
SELECT companies.permalink AS companies_permalink,
       companies.name AS companies_name,
       acquisitions.company_permalink AS acquisitions_permalink,
       acquisitions.acquired_at AS acquired_date
  FROM tutorial.crunchbase_companies companies
  LEFT JOIN tutorial.crunchbase_acquisitions acquisitions ON companies.permalink = acquisitions.company_permalink
 ORDER BY 1
SELECT companies.permalink AS companies_permalink,
       companies.name AS companies_name,
       acquisitions.company_permalink AS acquisitions_permalink,
       acquisitions.acquired_at AS acquired_date
  FROM tutorial.crunchbase_companies companies
  LEFT JOIN tutorial.crunchbase_acquisitions acquisitions ON companies.permalink = acquisitions.company_permalink
   AND acquisitions.company_permalink != '/company/1000memories'
 ORDER BY 1
SELECT companies.permalink AS companies_permalink,
       companies.name AS companies_name,
       acquisitions.company_permalink AS acquisitions_permalink,
       acquisitions.acquired_at AS acquired_date
  FROM tutorial.crunchbase_companies companies
  LEFT JOIN tutorial.crunchbase_acquisitions acquisitions ON companies.permalink = acquisitions.company_permalink
 WHERE acquisitions.company_permalink != '/company/1000memories' OR acquisitions.company_permalink IS NULL
 ORDER BY 1    # this would filter after join, would also filter NULL values so we account for this too
SELECT companies.name AS company_name,
       companies.status,
       COUNT(DISTINCT investments.investor_name) AS unqiue_investors
  FROM tutorial.crunchbase_companies companies
  LEFT JOIN tutorial.crunchbase_investments investments ON companies.permalink = investments.company_permalink
 WHERE companies.state_code = 'NY'
 GROUP BY 1,2 ORDER BY 3 DESC
SELECT CASE WHEN investments.investor_name IS NULL THEN 'No Investors'
            ELSE investments.investor_name END AS investor,
       COUNT(DISTINCT companies.permalink) AS companies_invested_in
  FROM tutorial.crunchbase_companies companies
  LEFT JOIN tutorial.crunchbase_investments investments ON companies.permalink = investments.company_permalink
 GROUP BY 1 ORDER BY 2 DESC

# FULL OUTER JOIN - returns everything from both tables including unmatched data, commonly used to understand overlapping data
SELECT COUNT(CASE WHEN companies.permalink IS NOT NULL AND acquisitions.company_permalink IS NULL
                  THEN companies.permalink ELSE NULL END) AS companies_only,
       COUNT(CASE WHEN companies.permalink IS NOT NULL AND acquisitions.company_permalink IS NOT NULL
                  THEN companies.permalink ELSE NULL END) AS both_tables,
       COUNT(CASE WHEN companies.permalink IS NULL AND acquisitions.company_permalink IS NOT NULL
                  THEN acquisitions.company_permalink ELSE NULL END) AS acquisitions_only
  FROM tutorial.crunchbase_companies companies
  FULL JOIN tutorial.crunchbase_acquisitions acquisitions ON companies.permalink = acquisitions.company_permalink
SELECT COUNT(CASE WHEN c.permalink IS NOT NULL AND i1.company_permalink IS NULL
                  THEN c.permalink ELSE NULL END) AS companies_only,
       COUNT(CASE WHEN c.permalink IS NOT NULL AND i1.company_permalink IS NOT NULL
                  THEN c.permalink ELSE NULL END) AS both_tables,
       COUNT(CASE WHEN c.permalink IS NULL AND i1.company_permalink IS NOT NULL
                  THEN i1.company_permalink ELSE NULL END) AS investments_only
  FROM tutorial.crunchbase_companies c
  FULL JOIN tutorial.crunchbase_investments_part1 i1 ON c.permalink = i1.company_permalink
  
# UNION - allows you to write two separate SELECT statements and display results of one in a different table
SELECT *
  FROM tutorial.crunchbase_investments_part1
 UNION    # UNION will only append distinct values, any rows in the appended table 2 that are similar to table 1 will be dropped
 SELECT *
   FROM tutorial.crunchbase_investments_part2
SELECT *
  FROM tutorial.crunchbase_investments_part1
 UNION ALL   # UNION ALL will only append everything (duplicates are included)
 SELECT *
   FROM tutorial.crunchbase_investments_part2
SELECT company_permalink, company_name, investor_name
  FROM tutorial.crunchbase_investments_part1
  WHERE company_name ILIKE 'T%'
 UNION
 SELECT company_permalink, company_name, investor_name
   FROM tutorial.crunchbase_investments_part2
   WHERE company_name ILIKE 'M%'
   
SELECT 'investments_part1' AS dataset_name,
       companies.status,
       COUNT(DISTINCT investments.investor_permalink) AS investors
  FROM tutorial.crunchbase_companies companies
  LEFT JOIN tutorial.crunchbase_investments_part1 investments ON companies.permalink = investments.company_permalink
 GROUP BY 1,2
 UNION ALL
 SELECT 'investments_part2' AS dataset_name,
       companies.status,
       COUNT(DISTINCT investments.investor_permalink) AS investors
  FROM tutorial.crunchbase_companies companies
  LEFT JOIN tutorial.crunchbase_investments_part2 investments ON companies.permalink = investments.company_permalink
 GROUP BY 1,2
 
 # JOINS with Comparison Operators - can join based on conditional statements
 SELECT companies.permalink,
       companies.name,
       companies.status,
       COUNT(investments.investor_permalink) AS investors
  FROM tutorial.crunchbase_companies companies
  LEFT JOIN tutorial.crunchbase_investments_part1 investments ON companies.permalink = investments.company_permalink
   AND investments.funded_year > companies.founded_year + 5
 GROUP BY 1,2, 3
 SELECT companies.permalink,
       companies.name,
       companies.status,
       COUNT(investments.investor_permalink) AS investors
  FROM tutorial.crunchbase_companies companies
  LEFT JOIN tutorial.crunchbase_investments_part1 investments ON companies.permalink = investments.company_permalink
 WHERE investments.funded_year > companies.founded_year + 5    # will produce different result to above due to being filtered after joining
 GROUP BY 1,2, 3
 
# JOINS on multiple keys - can join on multiple keys for accuracy reasons of for indexing (improves query performance)
SELECT companies.permalink,
       companies.name,
       investments.company_name,
       investments.company_permalink
  FROM tutorial.crunchbase_companies companies
  LEFT JOIN tutorial.crunchbase_investments_part1 investments ON companies.permalink = investments.company_permalink
   AND companies.name = investments.company_name
   
# SELF JOINS - sometimes useful for analysing data in singular table (filters results)
SELECT DISTINCT japan_investments.company_name,
	   japan_investments.company_permalink
  FROM tutorial.crunchbase_investments_part1 japan_investments
  JOIN tutorial.crunchbase_investments_part1 gb_investments ON japan_investments.company_name = gb_investments.company_name
   AND gb_investments.investor_country_code = 'GBR' AND gb_investments.funded_at > japan_investments.funded_at
 WHERE japan_investments.investor_country_code = 'JPN'
 ORDER BY 1