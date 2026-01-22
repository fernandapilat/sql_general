# SQL for Data Analysis

This module contains the analytical development and study materials from the **Data Analysis with SQL** specialization, provided by **Alura**.

The focus of this module is to transition from basic data retrieval to generating business insights, utilizing statistical functions, trend analysis, time series, and performance reporting.

## Folder Organization

The structure includes datasets, analytical scripts, and final reports in different formats:

* **exercises_sales.sql**: Comprehensive sales performance analysis, seasonality, and supplier tracking.
* **exercises_school.sql**: Academic management analysis and student approval performance metrics.
* **Databases**: SQLite databases (`db_sales.db` and `db_school.db`) used for the exercises.
* **Reports & Assets**: Documentation including a Black Friday performance report and statistical tendency analysis.

## Topics Developed

The table below details the analytical concepts and technical implementation applied in the scripts:

| Category | Analytical Description | Functions & Commands | Related Files |
| :--- | :--- | :--- | :--- |
| **Data Quality** | Record count validation across tables and pricing statistics. | `COUNT`, `UNION ALL`, `MIN`, `AVG`, `MAX`, `ROUND` | sales.sql |
| **Time Series** | Sales trend analysis grouped by Year and Month. | `strftime`, `GROUP BY`, `DISTINCT`, `ORDER BY` | sales.sql |
| **Seasonality** | Black Friday (Nov) and high-volume months performance tracking. | `WHERE`, `IN`, `strftime('%m', ...)` | sales.sql |
| **Supplier Analysis** | Historical performance and MoM tracking for specific suppliers. | `JOIN`, `GROUP BY`, `DESC/ASC` | sales.sql |
| **Pivoting Data** | Comparative monthly sales across key suppliers in a matrix format. | `WITH (CTE)`, `SUM`, `CASE WHEN`, `THEN/ELSE` | sales.sql |
| **Business Metrics** | Percentage contribution per category and historical variance (Black Friday 2022 vs. History). | `Scalar Subqueries`, `WITH`, Floating point division (`* 1.0`) | sales.sql |
| **Academic KPI** | Student approval rates per subject and overall school performance. | `JOIN`, `LEFT JOIN`, `COALESCE`, Subqueries | school.sql |

## Technical Reference

* **Institution**: Alura
* **Course**: [SQL Online: Data Analysis With SQL](https://cursos.alura.com.br/course/sql-data-analysis)
* **Certificate**: [View Certificate](https://cursos.alura.com.br/certificate/pilatfernanda/sqlite-online-analise-dados-sql?lang=en)
* **Technologies**: SQL, SQLite (Data Analysis)