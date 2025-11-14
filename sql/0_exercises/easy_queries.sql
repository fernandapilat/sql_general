-- Revising the Select Query I
-- 1. Query all columns for all American cities in the CITY table with populations larger than 100000. The CountryCode for America is USA.

SELECT * FROM city
WHERE CountryCode = 'USA' AND Population >= 100000;

-- Revising the Select Query II
-- 2. Query the NAME field for all American cities in the CITY table with populations larger than 120000. The CountryCode for America is USA.

SELECT Name FROM City
WHERE Population >= 120000 and CountryCode = 'USA';

-- Select All
-- 3. Query all columns (attributes) for every row in the CITY table.

SELECT * FROM City;

-- Select By ID
-- 4. Query all columns for a city in CITY with the ID 1661.

SELECT * FROM City
WHERE ID = 1661;

-- Japanese Cities' Attributes
-- 5. Query all attributes of every Japanese city in the CITY table. The COUNTRYCODE for Japan is JPN.

SELECT * FROM City
WHERE CountryCode = 'JPN';

-- Weather Observation Station 1
-- 6. Query a list of CITY and STATE from the STATION table. The STATION table is described as follows.

SELECT CITY, STATE
FROM STATION;

-- Weather Observation Station 3
-- 7. Query a list of CITY names from STATION for cities that have an even ID number. Print the results in any order, but exclude duplicates from the answer.

SELECT DISTINCT CITY
FROM STATION
WHERE ID % 2 = 0;

-- Weather Observation Station 4
-- 8. Find the difference between the total number of CITY entries in the table and the number of distinct CITY entries in the table.

SELECT COUNT(CITY) - COUNT(DISTINCT(CITY))
FROM STATION;

-- Weather Observation Station 5
-- 9. Query the two cities in STATION with the shortest and longest CITY names, as well as their respective lengths (i.e.: number of characters in the name). If there is more than one smallest or largest city, choose the one that comes first when ordered alphabetically.

SELECT CITY, LENGTH(CITY) as city_length
FROM STATION
ORDER BY city_length DESC
LIMIT 1;
SELECT CITY, LENGTH(CITY) as city_length
FROM STATION
ORDER BY city_length, city ASC
LIMIT 1;

-- Weather Observation Station 6
-- 10. Query the list of CITY names starting with vowels (i.e., a, e, i, o, or u) from STATION. Your result cannot contain duplicates.

select distinct city
from station
where city like 'A%'
or city like 'E%'
or city like 'I%'
or city like 'O%'
or city like 'U%';

-- Weather Observation Station 7
-- 11. Query the list of CITY names ending with vowels (a, e, i, o, u) from STATION. Your result cannot contain duplicates.

select distinct city
from station
where city like '%a'
or city like '%e'
or city like '%i'
or city like '%o'
or city like '%u';

-- Weather Observation Station 8
-- 12. Query the list of CITY names from STATION which have vowels (i.e., a, e, i, o, and u) as both their first and last characters. Your result cannot contain duplicates.

SELECT DISTINCT CITY
FROM STATION
WHERE CITY REGEXP '^[aeiou].*[aeiou]$';

-- Weather Observation Station 9
-- 13. Query the list of CITY names from STATION that do not start with vowels. Your result cannot contain duplicates.

SELECT DISTINCT CITY
FROM STATION
WHERE CITY REGEXP '^[^aeiou].*';

-- Weather Observation Station 10
-- 14. Query the list of CITY names from STATION that do not end with vowels. Your result cannot contain duplicates.

SELECT DISTINCT CITY
FROM STATION
WHERE CITY REGEXP '.*[^aeiou]$';

-- Weather Observation Station 11
-- 15. Query the list of CITY names from STATION that either do not start with vowels or do not end with vowels. Your result cannot contain duplicates.

SELECT DISTINCT CITY
FROM STATION
WHERE CITY NOT REGEXP '^[aeiou].*[aeiou]$';

-- Weather Observation Station 12
-- 16. Query the list of CITY names from STATION that do not start with vowels and do not end with vowels. Your result cannot contain duplicates.

SELECT DISTINCT CITY
FROM STATION
WHERE CITY REGEXP '^[^aeiou].*[^aeiou]$';


-- Higher Than 75 Marks
-- 17. Query the Name of any student in STUDENTS who scored higher than 75 Marks. Order your output by the last three characters of each name. If two or more students both have names ending in the same last three characters (i.e.: Bobby, Robby, etc.), secondary sort them by ascending ID.
SELECT NAME
FROM STUDENTS
WHERE MARKS > 75
ORDER BY RIGHT(NAME, 3), ID ASC;

-- Employee Names
-- 18. Write a query that prints a list of employee names (i.e.: the name attribute) from the Employee table in alphabetical order.

SELECT NAME
FROM EMPLOYEE
ORDER BY NAME ASC;

-- Employee Salaries
-- 19. Write a query that prints a list of employee names (i.e.: the name attribute) for employees in Employee having a salary greater than  per month who have been employees for less than  months. Sort your result by ascending employee_id.

SELECT NAME
FROM EMPLOYEE
WHERE SALARY > 2000 AND MONTHS < 10
ORDER BY EMPLOYEE_ID;

-- Revising Aggregations - The Count Function
-- 20. Query a count of the number of cities in CITY having a Population larger than 100,000.

SELECT COUNT(*)
FROM CITY
WHERE POPULATION > 100000;

-- Revising Aggregations - The Sum Function
-- 21. Query the total population of all cities in CITY where District is California.

SELECT SUM(POPULATION)
FROM CITY
WHERE DISTRICT = 'California';

-- Revising Aggregations - Averages
-- 22. Query the average population of all cities in CITY where District is California.

SELECT AVG(POPULATION)
FROM CITY
WHERE DISTRICT = 'California';

-- Average Population
-- 23. Query the average population for all cities in CITY, rounded down to the nearest integer.

SELECT FLOOR(AVG(POPULATION))
FROM CITY;

-- Japan Population
-- 24. Query the sum of the populations for all Japanese cities in CITY. The COUNTRYCODE for Japan is JPN.

SELECT SUM(POPULATION)
FROM CITY
WHERE COUNTRYCODE = 'JPN';

-- Population Density Difference
-- 25. Query the difference between the maximum and minimum populations in CITY.

SELECT MAX(POPULATION) - MIN(POPULATION)
FROM CITY;

-- Type of Triangle
-- 26. Write a query identifying the type of each record in the TRIANGLES table using its three side lengths. Output one of the following statements for each record in the table:

-- Equilateral: It's a triangle with  sides of equal length.
-- Isosceles: It's a triangle with  sides of equal length.
-- Scalene: It's a triangle with  sides of differing lengths.
-- Not A Triangle: The given values of A, B, and C don't form a triangle.

SELECT 
    CASE 
        WHEN A + B > C AND A + C > B AND B + C > A THEN 
            CASE 
                WHEN A = B AND A = C THEN 'Equilateral'
                WHEN A = B OR A = C OR B = C THEN 'Isosceles'
                ELSE 'Scalene'
            END
        ELSE 'Not A Triangle'
    END AS result
FROM TRIANGLES;