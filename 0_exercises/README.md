# SQL General Practice

This folder serves as a dedicated practice laboratory, containing solutions to various challenges from specialized platforms. It focuses on logic building, data manipulation, and the application of advanced analytical functions.

## Folder Organization

The scripts are divided by technical focus and source platform:

* **easy_queries.sql**: Solutions for foundational challenges from **HackerRank**, focusing on data filtering, basic aggregation, and string manipulation.
* **advanced_queries.sql**: Advanced analytical exercises from **WindowFunctions.com**, centered on complex result set partitioning and temporal navigation.

## Practice Platforms

| Platform | Difficulty/Focus | Technical Goal |
| :--- | :--- | :--- |
| **HackerRank** | Easy / Intermediate | Mastering `SELECT` logic, complex filtering, and foundational aggregations. |
| **WindowFunctions.com** | Advanced | Mastery of analytical functions, ranking, and row-frame definitions. |

## Topics Developed

The table below details the technical implementation and logic applied in the practice scripts:

| Category | Technical Description | Functions & Commands | Related Files |
| :--- | :--- | :--- | :--- |
| **Basic Retrieval** | Precise data extraction and conditional filtering. | `SELECT`, `WHERE`, `AND/OR`, `IN`, `DISTINCT` | easy_queries.sql |
| **String Logic** | Pattern matching and character-based sorting. | `LIKE`, `REGEXP`, `LENGTH`, `RIGHT()`, `SUBSTR` | easy_queries.sql |
| **Aggregations** | Calculated metrics and descriptive statistics. | `COUNT`, `SUM`, `AVG`, `MIN`, `MAX`, `FLOOR` | easy_queries.sql |
| **Control Flow** | Complex classification logic and geometric validation. | `CASE WHEN`, `THEN/ELSE`, Nested `CASE` | easy_queries.sql |
| **Ranking** | Competition-style and sequential numbering. | `ROW_NUMBER()`, `RANK()`, `DENSE_RANK()`, `PERCENT_RANK()` | advanced_queries.sql |
| **Analytical Totals** | Running totals and cumulative sums across partitions. | `SUM() OVER`, `PARTITION BY`, `ORDER BY` | advanced_queries.sql |
| **Navigation** | Accessing neighboring rows without self-joins. | `LAG()`, `LEAD()`, `FIRST_VALUE()`, `NTH_VALUE()` | advanced_queries.sql |
| **Data Frames** | Defining precise boundaries for calculations. | `ROWS BETWEEN`, `UNBOUNDED PRECEDING`, `FOLLOWING` | advanced_queries.sql |
| **Segmentation** | Population distribution into quartiles and halves. | `NTILE()`, `WINDOW` (Named Windows) | advanced_queries.sql |
| **Modern SQL** | Advanced grouping and data denormalization. | `FILTER (WHERE ...)`, `ARRAY_AGG()`, `COALESCE` | advanced_queries.sql |

## References
* **HackerRank**: [https://www.hackerrank.com/](https://www.hackerrank.com/)
* **Window Functions**: [https://www.windowfunctions.com/](https://www.windowfunctions.com/questions/intro/0)