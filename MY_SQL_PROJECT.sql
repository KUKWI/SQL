CREATE DATABASE PROJECT;
USE PROJECT;

SELECT * FROM FOREST_AREA;
SELECT * FROM LAND_AREA;
SELECT * FROM REGION;

--What are the total number of countries involved in deforestation? 

SELECT DISTINCT COUNTRY_NAME
FROM region;
SELECT COUNT(COUNTRY_NAME) AS Total_number_of_countries
from region;

--Show the income groups of countries having total area ranging from 75,000 to 150,000 square meter?

select r.country_name, income_group, total_area_sq_mi
from [land_area] L JOIN region R ON L.country_code = r.country_code
GROUP BY r.country_name, income_group, total_area_sq_mi
HAVING total_area_sq_mi >= 75000 AND total_area_sq_mi <=150000;

--Calculate the average area in square miles for countries in the ¡®upper middle-income region¡¯. 
--Compare the result with the rest of the income categories.


SELECT AVG(total_area_sq_mi) AS Average_area_sqmi
FROM (
    SELECT r.country_name, income_group, total_area_sq_mi
    FROM [region] r
    JOIN [land_area] L ON r.country_code = L.country_code
    WHERE income_group = 'upper middle income'
    GROUP BY r.country_name, income_group, total_area_sq_mi
) AS Table_3;

-- Determine the total forest area in square km for countries in the 'high income' group.
--Compare result with the rest of the income categories.

SELECT SUM(forest_area_sqkm) AS total_forest_area
FROM (
    SELECT f.country_name, income_group, forest_area_sqkm
    FROM [forest_area] f
    JOIN [region] r ON f.country_code = r.country_code
    WHERE income_group = 'high income'
    GROUP BY f.country_name, income_group, forest_area_sqkm
) AS Table_4;


--Show countries from each region(continent) having the highest total forest areas. 

WITH Region_1 AS 
   ( SELECT r.country_name, r.region, SUM(f.forest_area_sqkm) AS Total_forest_area,
    DENSE_RANK() OVER(PARTITION BY r.region ORDER BY SUM(f.forest_area_sqkm) DESC) AS Rank
    FROM [forest_area] f 
    JOIN [region] r ON f.country_code = r.country_code
    GROUP BY r.country_name, r.region)
SELECT * 
FROM Region_1
WHERE Rank = 1;

