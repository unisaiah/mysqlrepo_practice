## MODE BASIC SQL TRAINING

# SQL SELECT - select chooses the columns, from chooses the table
SELECT year, month, west
	FROM tutorial.us_housing_units
SELECT *
	FROM tutorial.us_housing_units
SELECT year, month, month_name, south, west, midwest,northeast 
	FROM tutorial.us_housing_units
SELECT west AS "West Region"
  FROM tutorial.us_housing_units
SELECT west AS West_Region
  FROM tutorial.us_housing_units
SELECT year AS "Year", month AS "Month", month_name AS "Month Name", west AS "West",
       midwest AS "Midwest", south AS "South", northeast AS "Northeast"
  FROM tutorial.us_housing_units
  
# SQL LIMIT - restricts the number of rows shown in result
SELECT *
  FROM tutorial.us_housing_units LIMIT 15
  
# SQL WHERE - filters results based on a condition
SELECT *
  FROM tutorial.us_housing_units WHERE month = 1
  
 # SQL Comparison Operators - used for filtering results
SELECT *
  FROM tutorial.us_housing_units WHERE west > 50
SELECT south
  FROM tutorial.us_housing_units WHERE west <= 20
SELECT *
  FROM tutorial.us_housing_units WHERE month_name != 'January'
SELECT *
  FROM tutorial.us_housing_units WHERE month_name > 'January'    # goes in alphabetical order
SELECT *
  FROM tutorial.us_housing_units WHERE month_name = 'February'
SELECT *
  FROM tutorial.us_housing_units WHERE month_name <= 'N'    # this will show words starting with 'M'
SELECT *
  FROM tutorial.us_housing_units WHERE month_name <= 'o'    # this will show words starting with 'N'
SELECT year, month, west, south, west + south - 4 * year AS nonsense_column
  FROM tutorial.us_housing_units
SELECT west + south + midwest + northeast
  FROM tutorial.us_housing_units
SELECT * 
  FROM tutorial.us_housing_units WHERE west > midwest + northeast
SELECT year, month, (west / (west+south+midwest+northeast)*100),
  (south / (west+south+midwest+northeast)*100), (midwest / (west+south+midwest+northeast)*100), 
  (northeast / (west+south+midwest+northeast)*100) 
  FROM tutorial.us_housing_units WHERE year >= 2000
  
# SQL Logical Operators - used for filtering based on multiple comparison operators

# SQL LIKE - allows matching on similar values instead of exact values
SELECT *
  FROM tutorial.billboard_top_100_year_end WHERE "group" LIKE 'Snoop%'    # % means any char(s)
	# "group" is in quotes as it shares names with a built-in SQL function
SELECT *
  FROM tutorial.billboard_top_100_year_end WHERE "group" ILIKE 'snoop%'    # ILIKE ignores case sensitivity
SELECT *
  FROM tutorial.billboard_top_100_year_end WHERE artist ILIKE 'dr_ke'    # _ means any char
SELECT *
  FROM tutorial.billboard_top_100_year_end WHERE "group" ILIKE '%ludacris%'
SELECT *
  FROM tutorial.billboard_top_100_year_end WHERE "group" LIKE 'DJ%'

# SQL IN - specifies a list of values that must be included in result
SELECT *
  FROM tutorial.billboard_top_100_year_end WHERE year_rank IN (1, 2, 3)
SELECT *
  FROM tutorial.billboard_top_100_year_end WHERE artist IN ('Taylor Swift', 'Usher', 'Ludacris')
SELECT *
  FROM tutorial.billboard_top_100_year_end WHERE "group" IN ('M.C. Hammer', 'Hammer', 'Elvis Presley')
	# must use LIKE to find different ways to write the artists (wildcard chars don't work with IN)
    
# SQL BETWEEN - checks for rows in a specific range, includes range bounds in result
SELECT *
  FROM tutorial.billboard_top_100_year_end WHERE year_rank BETWEEN 5 AND 10
SELECT *
  FROM tutorial.billboard_top_100_year_end WHERE year BETWEEN 1985 AND 1990

# SQL IS NULL - highlights rows with missing data from results
SELECT *
  FROM tutorial.billboard_top_100_year_end WHERE artist IS NULL    # will return rows without artist
SELECT *
  FROM tutorial.billboard_top_100_year_end WHERE song_name IS NULL

# SQL AND - selects rows that satisfy two conditions
SELECT *
  FROM tutorial.billboard_top_100_year_end WHERE year = 2012
  AND year_rank <= 10 AND "group" ILIKE '%feat%'
SELECT *
  FROM tutorial.billboard_top_100_year_end WHERE "group" ILIKE '&ludacris%'
  AND year_rank <= 10
SELECT *
  FROM tutorial.billboard_top_100_year_end WHERE year_rank = 1 AND year IN (1990, 2000, 2010)
SELECT *
  FROM tutorial.billboard_top_100_year_end WHERE (year BETWEEN 1960 AND 1969) 
  AND song_name ILIKE '%love%'    # no brackets necessary
  
# SQL OR - selects rows that satisfy either of the two conditions
SELECT *
  FROM tutorial.billboard_top_100_year_end WHERE year_rank = 5 OR artist = 'Gotye'
SELECT *
  FROM tutorial.billboard_top_100_year_end WHERE year = 2013
   AND ("group" ILIKE '%macklemore%' OR "group" ILIKE '%timberlake%')

# SQL NOT - logical operator placed before condition to check for the converse
SELECT *
  FROM tutorial.billboard_top_100_year_end WHERE year = 2013
  AND year_rank NOT BETWEEN 2 AND 3
SELECT *
  FROM tutorial.billboard_top_100_year_end WHERE year = 2013
  AND "group" NOT ILIKE '%macklemore%'
SELECT *
  FROM tutorial.billboard_top_100_year_end WHERE year = 2013
  AND artist IS NOT NULL    # must use IS before NOT NULL

# SQL ORDER BY - reorders results based on data in one of more columns, asc by default
SELECT *
  FROM tutorial.billboard_top_100_year_end ORDER BY artist
SELECT *
  FROM tutorial.billboard_top_100_year_end WHERE year = 2012 ORDER BY song_name DESC
SELECT *
  FROM tutorial.billboard_top_100_year_end WHERE year_rank <= 3 ORDER BY year DESC, year_rank
  # only year column will be desc order
SELECT *
  FROM tutorial.billboard_top_100_year_end WHERE year_rank <= 3 ORDER BY 2, 1 DESC
  # numbers refer to order listed in SELECT clause
SELECT *
  FROM tutorial.billboard_top_100_year_end WHERE year_rank BETWEEN 10 AND 20
  AND year IN (1993, 2003, 2013) ORDER BY year, year_rank
  