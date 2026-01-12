-- 1. Running Total (The "Elevator" Problem)
-- This query calculates a cumulative sum of weights, ordered from heaviest to lightest.
-- UNBOUNDED PRECEDING ensures we start calculating from the very first row of the set.
SELECT
  name,
  weight,
  SUM(weight) OVER(
    ORDER BY weight DESC 
    ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
  ) AS running_total_weight
FROM cats;

--------------------------------------------------------------------------------

-- 2. Partitioned Running Total
-- Here we group cats by breed (PARTITION BY) and calculate the running total 
-- within each group. The sum resets whenever the breed changes.
SELECT
  name,
  breed,
  SUM(weight) OVER(
    PARTITION BY breed 
    ORDER BY name
  ) AS running_total_weight
FROM cats;

--------------------------------------------------------------------------------

-- 3. Moving Average (Sliding Window)
-- This calculates the average weight using the current row, the one before, 
-- and the one after. It's used to smooth out data fluctuations (noise).
SELECT
  name,
  weight,
  AVG(weight) OVER(
    ORDER BY weight 
    ROWS BETWEEN 1 PRECEDING AND 1 FOLLOWING
  ) AS average_weight
FROM cats;

--------------------------------------------------------------------------------

-- 4. Static Grand Total
-- By leaving OVER() empty, we calculate the total weight of all cats in the table.
-- This is useful for calculating percentages (Market Share).
SELECT
  name,
  weight,
  SUM(weight) OVER() AS total_weight_all_cats
FROM cats;

/*
  QUICK REFERENCE: WINDOW FUNCTION CONCEPTS
  
  1. OVER(): Defines the "window" of rows the function will look at. 
     If empty, it considers the entire dataset.
     
  2. PARTITION BY: Divides the rows into groups (buckets) based on a column 
     (e.g., breed). The calculation starts over for each group.
     
  3. ORDER BY: Sets the sequence of rows within the window. Essential for 
     calculating totals that depend on a specific order (like time or weight).
     
  4. ROWS BETWEEN: Defines the specific "frame" or boundaries of the calculation:
     - UNBOUNDED PRECEDING: From the very beginning of the partition.
     - CURRENT ROW: Up to the row you are currently on.
     - 1 PRECEDING / 1 FOLLOWING: Looking at immediate neighbors.
*/


--------------------------------------------------------------------------------

-- 5. Row Number (Unique Sequencing)
-- Useful for creating unique IDs, deduplicating data, or finding the "first" occurrence.
-- In this case, we assign a unique sequential number to each cat, ordered by color and name.
SELECT
  ROW_NUMBER() OVER(ORDER BY color, name) AS unique_number, 
  name,
  color
FROM cats;

--------------------------------------------------------------------------------

-- 6. Rank (Competition Ranking)
-- Assigns the same rank to ties but skips the next position(s). 
-- (e.g., 1, 2, 2, 4). Best for: Leaderboards and sales competitions.
SELECT
  RANK() OVER(ORDER BY weight DESC) AS ranking, 
  weight,
  name
FROM cats
ORDER BY ranking, name;

--------------------------------------------------------------------------------

-- 7. Dense Rank (Categorical Clusters)
-- Assigns ranks without gaps. Ideal for creating groups or tiers.
-- As seen in practice: It creates "clusters" of rows with the same value.
SELECT
  DENSE_RANK() OVER(ORDER BY age DESC) AS ranking, 
  name,
  age
FROM cats
ORDER BY ranking, name;

-- Example 1
-- Creating Cluster with CASE WHEN

SELECT 
    name,
    age,
    DENSE_RANK() OVER(ORDER BY age DESC) AS ranking,
    CASE 
        WHEN DENSE_RANK() OVER(ORDER BY age DESC) = 1 THEN 'Senior'
        WHEN DENSE_RANK() OVER(ORDER BY age DESC) = 2 THEN 'Adults'
        ELSE 'Youngs'
    END AS age_category
FROM cats
ORDER BY age DESC, name;

-- Example 3
-- Using a CTE to organize the ranking logic
WITH RankedCats AS (
    SELECT
        name,
        age,
        DENSE_RANK() OVER(ORDER BY age DESC) AS age_rank
    FROM cats
)
SELECT 
    name,
    age,
    age_rank,
    CASE 
        WHEN age_rank = 1 THEN 'Senior Leader'
        WHEN age_rank = 2 THEN 'Adult'
        WHEN age_rank = 3 THEN 'Young Adult'
        ELSE 'Junior'
    END AS age_status
FROM RankedCats
ORDER BY age_rank, name;

--------------------------------------------------------------------------------

