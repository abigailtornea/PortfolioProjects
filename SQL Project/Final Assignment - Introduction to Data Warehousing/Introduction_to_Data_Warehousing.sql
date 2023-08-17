-- Final Assignment - Introduction to Data Warehousing --


-- Task 1 - Design the dimension table MyDimDate --
/*
MyDimDate
- dateid 
- year 
- month 
- monthname 
- quarter 
- quartername 
- day 
- weekdayname
 */

-- Task 2 - Design the dimension table MyDimWaste
/*
MyDimWaste
- wastetypeid 
- wastetype
 */

-- Task 3 - Design the dimension table MyDimZone
/*
MyDimZone
- zoneid 
- zonename 
- city
 */

-- Task 4 - Design the fact table MyFactTrips
/*
MyFactTrips
- tripid 
- dateid 
- wastetypeid 
- zoneid 
- wastecollected
 */

-- Task 5 - Create the dimension table MyDimDate
CREATE TABLE MyDimDate(
dateid  integer,
year integer, 
month integer,
monthname varchar(9), 
quarter integer,
quartername varchar(2), 
day integer, 
weekday integer,
weekdayname varchar(9)
);


-- Task 6 - Create the dimension table MyDimWaste
CREATE TABLE MyDimWaste(
wastetypeid integer,
wastetype varchar(10)
);


-- Task 7 - Create the dimension table MyDimZone
CREATE TABLE MyDimZone(
zoneid integer,
zonename varchar(7),
city varchar(14)
);

-- Task 8 - Create the fact table MyFactTrips
CREATE TABLE MyFactTrips(
tripid integer,
dateid integer,
wastetypeid integer,
zoneid integer,
wastecollected float
);

-- Task 9 - Load data into the dimension table DimDate
-- Take a screenshot of the first 5 rows 
SELECT * FROM DIMDATE LIMIT 5;


-- Task 10 - Load data into the dimension table DimTruck
-- Take a screenshot of the first 5 rows 
SELECT * FROM DIMTRUCK LIMIT 5;

-- Task 11 - Load data into the dimension table DimStation
-- Take a screenshot of the first 5 rows 
SELECT * FROM DIMSTATION LIMIT 5;

-- Task 12 - Load data into the dimension table FactTrips
-- Take a screenshot of the first 5 rows 
SELECT * FROM FACTTRIPS LIMIT 5;

-- Task 13 - Create a grouping sets query
-- Create a grouping sets query using the columns stationid, trucktype, total waste collected.
SELECT DIMSTATION. stationid, trucktype, SUM (wastecollected) AS total_waste_collected 
FROM FACTTRIPS LEFT JOIN DIMSTATION ON FACTTRIPS.stationid = DIMSTATION.stationid 
LEFT JOIN DIMTRUCK ON FACTTRIPS.truckid = DIMTRUCK.truckid
GROUP BY GROUPING SETS (DIMSTATION. stationid, trucktype);

-- Task 14 - Create a rollup query
-- Create a rollup query using the columns year, city, stationid, and total waste collected.
SELECT year, city, DIMSTATION. stationid, SUM (wastecollected) AS total_waste_collected FROM FACTTRIPS 
LEFT JOIN DIMDATE ON FACTTRIPS.dateid = DIMDATE.dateid
JOIN DIMSTATION ON FACTTRIPS.stationid = DIMSTATION. stationid
GROUP BY ROLLUP (year, city, DIMSTATION. stationid)
ORDER BY year, city, DIMSTATION. stationid;

-- Task 15 - Create a cube query
-- Create a cube query using the columns year, city, stationid, and average waste collected.
SELECT year, city, DIMSTATION.stationid, AVG (wastecollected) AS average_waste_collected 
FROM FACTTRIPS 
LEFT JOIN DIMDATE ON FACTTRIPS.dateid = DIMDATE.dateid
JOIN DIMSTATION ON FACTTRIPS.stationid = DIMSTATION.stationid
GROUP BY CUBE (year, city, DIMSTATION. stationid)
ORDER BY year, city, DIMSTATION.stationid;


-- Task 16 - Create an MQT
-- Create an MQT named max_waste_stats using the columns city, stationid, trucktype, and max waste collected.
CREATE TABLE maxwastestats (city, stationid, trucktype, max_waste_collected) AS (
SELECT city, DIMSTATION. stationid, trucktype, MAX(wastecollected) 
FROM FACTTRIPS
LEFT JOIN DIMSTATION ON FACTTRIPS.stationid = DIMSTATION.stationid 
LEFT JOIN DIMTRUCK ON FACTTRIPS.truckid = DIMTRUCK.truckid
GROUP BY city, DIMSTATION. stationid, trucktype)
DATA INITIALLY DEFERRED
REFRESH DEFERRED
MAINTAINED BY SYSTEM;
REFRESH TABLE maxwastestats;
SELECT * FROM maxwastestats;









