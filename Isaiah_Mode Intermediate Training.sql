## MODE INTERMEDIATE SQL TRAINING

# SQL COUNT - counts number of rows in column
SELECT COUNT(*)
  FROM tutorial.aapl_historical_stock_price
SELECT COUNT(low) AS low
  FROM tutorial.aapl_historical_stock_price
SELECT COUNT(year) AS year, COUNT(month) AS month, COUNT(open) AS open, COUNT(high) AS high,
       COUNT(low) AS low, COUNT(close) AS close, COUNT(volume) AS volume
  FROM tutorial.aapl_historical_stock_price

# SQL SUM - totals values on given column
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
 GROUP BY 1 ORDER BY 1
SELECT year, month, MIN(low), MAX(high)
  FROM tutorial.aapl_historical_stock_price
 GROUP BY 1, 2 ORDER BY 1, 2
 
 # SQL HAVING - similar to where clause but for groups
SELECT year, month, MAX(high)
  FROM tutorial.aapl_historical_stock_price
 GROUP BY year, month HAVING MAX(high) > 400 ORDER BY year, month
 
# SQL CASE - checks rows against a certain condition
SELECT player_name, year,
       CASE WHEN year = 'SR' THEN 'yes' ELSE NULL END AS is_a_senior
  FROM benn.college_football_players
SELECT player_name, state,
       CASE WHEN state = 'CA' THEN 'yes' ELSE NULL END AS from_california
  FROM benn.college_football_players ORDER BY 3
SELECT player_name, height,
       CASE WHEN height > 74 THEN 'over 74'
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
       COUNT(1) AS total_players
  FROM benn.college_football_players GROUP BY state ORDER BY total_players DESC
SELECT CASE WHEN school_name < 'n' THEN 'A-M' WHEN school_name >= 'n' THEN 'N-Z' ELSE NULL END AS school_name_group,
       COUNT(1) AS players
  FROM benn.college_football_players GROUP BY 1
  
# SQL DISTINCT - looks at only unique values in a particular column
SELECT DISTINCT year
  FROM tutorial.aapl_historical_stock_price ORDER BY year
SELECT month, AVG(volume)
  FROM tutorial.aapl_historical_stock_price
 GROUP BY month ORDER BY 2 DESC
SELECT year, COUNT(DISTINCT month)
  FROM tutorial.aapl_historical_stock_price
 GROUP BY year ORDER BY year
SELECT COUNT(DISTINCT year), COUNT(DISTINCT month)
  FROM tutorial.aapl_historical_stock_price
  
# SQL JOINS - collates two tables of data by joining on specific column
SELECT teams.conference, AVG(players.weight)
  FROM benn.college_football_players players
  JOIN benn.college_football_teams teams ON teams.school_name = players.school_name
 GROUP BY teams.conference ORDER BY AVG(players.weight) DESC
SELECT players.school_name, players.player_name, players.position, players.weight
  FROM benn.college_football_players players
 WHERE players.state = 'GA' ORDER BY players.weight DESC

# SQL INNER JOIN - joins the data shared in both tables
SELECT players.school_name, teams.school_name
  FROM benn.college_football_players players
  JOIN benn.college_football_teams team ON teams.school_name = players.school_name
SELECT players.player_name, players.school_name, teams.conference
  FROM benn.college_football_players players
  JOIN benn.college_football_teams teams ON teams.school_name = players.school_name
 WHERE teams.division = 'FBS (Division I-A Teams)'
 
 # SQL OUTER JOIN - joins both tables regardless of null data
 # SQL LEFT JOIN - similar to right join, joins table 2 with matching info in table 1 but also
				# shows table 2 values that are null (no corresponding entries in 1)
SELECT companies.permalink, companies.name, acquisitions.company_permalink, acquisitions.acquired_at
  FROM tutorial.crunchbase_companies companies
  LEFT JOIN tutorial.crunchbase_acquisitions acquisitions ON companies.permalink = acquisitions.company_permalink
SELECT COUNT(companies.permalink), COUNT(acquisitions.company_permalink)
  FROM tutorial.crunchbase_companies companies
  LEFT JOIN tutorial.crunchbase_acquisitions acquisitions ON companies.permalink = acquisitions.company_permalink
SELECT companies.state_code, COUNT(DISTINCT companies.permalink), COUNT(DISTINCT acquisitions.company_permalink)
  FROM tutorial.crunchbase_companies companies
  LEFT JOIN tutorial.crunchbase_acquisitions acquisitions ON companies.permalink = acquisitions.company_permalink
 WHERE companies.state_code IS NOT NULL
 GROUP BY 1 ORDER BY 3 DESC

# SQL RIGHT JOIN
SELECT companies.state_code, COUNT(DISTINCT companies.permalink), COUNT(DISTINCT acquisitions.company_permalink)
  FROM tutorial.crunchbase_acquisitions acquisitions
 RIGHT JOIN tutorial.crunchbase_companies companies ON companies.permalink = acquisitions.company_permalink
 WHERE companies.state_code IS NOT NULL
 GROUP BY 1 ORDER BY 3 DESC
 
# SQL JOINS WITH WHERE & ON - 