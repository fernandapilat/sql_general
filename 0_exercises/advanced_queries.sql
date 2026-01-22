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

-- 8. PERCENT_RANK (Positioning in the Ranking)
-- Logic: Calculates the relative rank of a row as a percentage (0 to 100).
SELECT
  name,
  weight,
  ROUND(PERCENT_RANK() OVER (ORDER BY weight) * 100, 2) AS percent
FROM cats;

--------------------------------------------------------------------------------

-- 9. CUME_DIST with CAST
-- Using CAST(... AS integer) to convert the decimal result into a whole number.
-- This is useful when we don't need the precision of decimals and want a cleaner output.
SELECT
  name,
  weight,
  CAST(CUME_DIST() OVER (ORDER BY weight) * 100 AS integer) AS percent
FROM cats;

--------------------------------------------------------------------------------

/* THE GOLDEN RATIONALE:
   Every Window Function requires the OVER() clause.
   The OVER() clause is what tells SQL to perform calculations 'row by row',
   creating new columns while preserving the original detail of each record.
*/

--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- 10. DATA SEGMENTATION (QUARTILES)
-- Logic: Assigns each cat to a quartile (1 to 4) based on their weight.
-- Use Case: Segmenting a population into four equal groups for analysis.
SELECT
  name,
  weight,
  NTILE(4) OVER (ORDER BY weight) AS weight_quartile
FROM cats;

--------------------------------------------------------------------------------
-- 11. HANDLING NULLS IN NAVIGATION (LAG + COALESCE)
-- The Problem: The first row always returns NULL because there is no previous row.
-- The Solution: COALESCE(value, 0) converts that NULL into a 0 for cleaner reporting.
SELECT
  name,
  weight,
  COALESCE(weight - LAG(weight) OVER (ORDER BY weight), 0) AS weight_to_lose
FROM cats;

--------------------------------------------------------------------------------
-- 12. INTERNAL vs EXTERNAL ORDERING
-- result by 'breed' as well to keep groups together.
SELECT
  name,
  breed,
  weight,
  COALESCE(weight - LAG(weight) OVER (PARTITION BY breed ORDER BY weight), 0) AS weight_to_lose
FROM cats
ORDER BY breed, weight;

--------------------------------------------------------------------------------
-- WINDOW FUNCTION SYNTAX FORMULA
-- Rationale: Action + Window (OVER) + (Grouping PARTITION BY + Sorting ORDER BY)
--------------------------------------------------------------------------------
-- Structure:
-- SELECT 
--    column,
--    FUNCTION() OVER (
--        PARTITION BY category_column
--        ORDER BY sort_column
--    ) AS alias_name
-- FROM table_name;


--------------------------------------------------------------------------------
-- 13. COLOR-BASED BENCHMARKING (FIRST_VALUE + PARTITION BY)
-- Logic: Within each color group, find the weight of the lightest cat.
SELECT
  name,
  color,
  weight,
  FIRST_VALUE(weight) OVER (PARTITION BY color ORDER BY weight) AS lowest_weight_by_color
FROM cats
ORDER BY color, name;

--------------------------------------------------------------------------------
-- 14. PARTITIONED LEAD WITH TYPE CASTING
-- Logic: Finding the next heaviest cat WITHIN the same breed.
-- Technical Note: Using CAST to VARCHAR because 'COALESCE' requires 
SELECT
  name,
  weight,
  breed,
  COALESCE(
    CAST(LEAD(weight) OVER(PARTITION BY breed ORDER BY weight) AS VARCHAR), 
    'fattest cat'
  ) AS next_heaviest
FROM cats
ORDER BY weight; -- Global sort for presentation purposes.

--------------------------------------------------------------------------------
-- 15. CONDITIONAL LOGIC USING WINDOW FUNCTIONS (COALESCE + NTH_VALUE)
-- Logic: Assigns the 4th lightest cat's weight to everyone as a "standard".
SELECT
  name,
  weight,
  breed,
  COALESCE(
    CAST(NTH_VALUE(weight, 4) OVER (ORDER BY weight) AS VARCHAR), 
    '99.9'
  ) AS imagined_weight
FROM cats;

-- Another way how to calculate
SELECT
  name,
  weight,
  CASE 
    WHEN ROW_NUMBER() OVER (ORDER BY weight) <= 3 THEN 99.9
    ELSE NTH_VALUE(weight, 4) OVER (ORDER BY weight 
                                    ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING)
  END AS imagined_weight
FROM cats;

--------------------------------------------------------------------------------
-- 16. AGGREGATING ANALYTICAL RESULTS (DISTINCT + NTH_VALUE)
-- Logic: Finding the 2nd lightest cat per breed and collapsing the results.
-- The 'ROWS BETWEEN' clause is essential here to ensure 
-- NTH_VALUE sees the entire partition regardless of the current row position.
-- Without it, the first row of each partition would return NULL for the 2nd value.
SELECT DISTINCT
  breed,
  NTH_VALUE(weight, 2) OVER (
    PARTITION BY breed 
    ORDER BY weight
    ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
  ) AS second_lightest_weight
FROM cats
ORDER BY breed;

--------------------------------------------------------------------------------
-- 17. DATA DISTRIBUTION USING NTILE AND NAMED WINDOWS
-- Logic: Dividing the feline population into halves, thirds, and quartiles 
-- based on their weight to analyze mass distribution.
-- Technical Highlight: Using the 'WINDOW' clause to define a named window 'w'. 
--------------------------------------------------------------------------------
SELECT
  name,
  weight,
  NTILE(2) OVER w AS by_half,
  NTILE(3) OVER w AS thirds,
  NTILE(4) OVER w AS quartile
FROM cats
WINDOW w AS (ORDER BY weight)
ORDER BY weight;

--------------------------------------------------------------------------------
-- 18. ADVANCED AGGREGATION WITH CONDITIONALS (FILTER CLAUSE)
--  Using the FILTER (WHERE ...) clause attached to 
-- aggregate functions. This is a more performant and readable alternative 
-- to using CASE WHEN inside AVG() or creating complex subqueries.
SELECT
  breed,
  AVG(weight) AS average_weight,
  AVG(weight) FILTER (WHERE age > 1) AS average_old_weight
FROM cats
GROUP BY breed
ORDER BY breed;

--------------------------------------------------------------------------------
-- 19. MASTERING MODERN AGGREGATION: FILTER & ARRAY_AGG
-- 1. FILTER: Efficiently handles conditional averages without CASE WHEN hacks.
-- 2. ARRAY_AGG: Collects all entity names into a single array field per group,
--    perfect for data denormalization and JSON preparation.
--------------------------------------------------------------------------------
SELECT
  breed,
  AVG(weight) AS average_weight,
  AVG(weight) FILTER (WHERE age > 1) AS average_old_weight,
  ARRAY_AGG(name) AS cat_list
FROM cats
GROUP BY breed
ORDER BY breed;