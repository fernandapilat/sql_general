-- Checking the record count for each reference table

-- Suppliers (10 records)
SELECT * from fornecedores LIMIT 10; 	
SELECT count(*) as rows from fornecedores;

-- Brands (10 records)
SELECT * from marcas LIMIT 10; 	
SELECT count(*) as rows from marcas;

-- Categories (5 records)
SELECT * from categorias LIMIT 5; 	
SELECT count(*) as rows from categorias;

-- Products (10k records)
SELECT * from produtos LIMIT 10; 	
SELECT count(*) as rows from produtos;

-- Clients (10k records)
SELECT * from clientes LIMIT 10; 	
SELECT count(*) as rows from clientes;

-- Sales/Orders (50k records)
SELECT * from vendas LIMIT 10; 	
SELECT count(*) as rows from vendas;

-- Items Sold (approx. 150k records)
SELECT * from itens_venda LIMIT 10; 	
SELECT count(*) as rows from itens_venda;

---

-- Consolidating all record counts into a single table
SELECT COUNT(*) as Qtd, 'Categorias' as Tabela FROM categorias
UNION ALL
SELECT COUNT(*) as Qtd, 'Clientes' as Tabela FROM clientes
UNION ALL
SELECT COUNT(*) as Qtd, 'Fornecedores' as Tabela FROM fornecedores
UNION ALL
SELECT COUNT(*) as Qtd, 'ItensVenda' as Tabela FROM itens_venda
UNION ALL
SELECT COUNT(*) as Qtd, 'Marcas' as Tabela FROM marcas
UNION ALL
SELECT COUNT(*) as Qtd, 'Produtos' as Tabela FROM produtos
UNION ALL
SELECT COUNT(*) as Qtd, 'Vendas' as Tabela FROM vendas;

---

-- Checking product pricing and statistics (for data quality)
SELECT 
	p.nome_produto,
    COUNT(*) AS total_records,
    ROUND(MIN(p.preco), 0) as min_price,
    ROUND(AVG(p.preco), 0) as avg_price,
    ROUND(MAX(p.preco), 0) AS max_price
FROM produtos p
GROUP By p.nome_produto;

-- Query the 'vendas' (sales) table to inspect the structure and initial records
SELECT * FROM vendas LIMIT 10;

---

-- Determine the distinct years for which we have sales data
SELECT DISTINCT
    strftime('%Y', data_venda) AS year -- Function format: strftime(format, datetime_column)
FROM vendas v
ORDER BY year;

---

-- Calculate the total number of orders and the total amount sold, grouped by year
SELECT 
    strftime('%Y', data_venda) AS year,
    COUNT(*) AS orders,
    ROUND(SUM(total_venda), 0) total_sold
FROM vendas v
GROUP BY 1;

---

-- Calculate the total number of orders and amount sold, grouped by month (time series analysis)
SELECT 
    strftime('%Y-%m', data_venda) AS year_month,
    COUNT(*) AS orders,
    ROUND(SUM(total_venda), 0) total_sold
FROM vendas v
GROUP BY 1;

---

-- Calculate sales data specifically for November (often associated with Black Friday)
SELECT 
    strftime('%Y-%m', data_venda) AS year_month,
    COUNT(*) AS orders,
    ROUND(SUM(total_venda), 0) total_sold
FROM vendas v
WHERE strftime('%m', data_venda) = '11'
GROUP BY 1;

---

-- Calculate sales data for the high-volume months: November, December, and January
SELECT 
    strftime('%Y-%m', data_venda) AS year_month,
    COUNT(*) AS orders,
    ROUND(SUM(total_venda), 0) total_sold
FROM vendas v
WHERE strftime('%m', data_venda) IN ('11', '12', '01')
GROUP BY 1;

---

-- Identify the top-selling suppliers over time (by month)
SELECT
	strftime('%Y-%m', v.data_venda) AS year_month,
	f.nome AS supplier_name,
    -- p.nome_produto,
    COUNT(it.produto_id) AS items_sold_count 
from itens_venda it
JOIN produtos p
	ON it.produto_id = p.id_produto
JOIN fornecedores f
	ON p.fornecedor_id = f.id_fornecedor
JOIN vendas v
	ON it.venda_id = v.id_venda
GROUP BY 1, 2
ORDER BY 2;

-- Analyze best and worst supplier performance during last year's Black Friday (November 2022)
SELECT
	strftime('%Y-%m', v.data_venda) AS year_month,
	f.nome AS supplier_name,
    -- p.nome_produto,
    COUNT(it.produto_id) AS items_sold_count
from itens_venda it
JOIN produtos p
	ON it.produto_id = p.id_produto
JOIN fornecedores f
	ON p.fornecedor_id = f.id_fornecedor
JOIN vendas v
	ON it.venda_id = v.id_venda
WHERE 
	strftime('%Y-%m', v.data_venda) = '2022-11' -- Filters for a specific year and month (November 2022)
GROUP BY year_month, f.nome
ORDER BY items_sold_count DESC; -- Orders from best (highest sales) to worst

-- Track the historical performance (month-over-month sales) for a specific low-performing supplier
SELECT
	strftime('%Y-%m', v.data_venda) AS year_month,
	-- f.nome, -- Supplier name commented out since the WHERE clause already filters for one specific supplier
    COUNT(it.produto_id) AS items_sold_count -- Renomeado para clareza
FROM itens_venda it
JOIN produtos p
	ON it.produto_id = p.id_produto
JOIN fornecedores f
	ON p.fornecedor_id = f.id_fornecedor
JOIN vendas v
	ON it.venda_id = v.id_venda
WHERE 
	 f.nome = 'NebulaNetworks' -- Filter to focus on the specific supplier
GROUP BY year_month -- Grouping only by month since the supplier is fixed
ORDER BY year_month ASC; -- Order chronologically

---

-- Analyze the performance/representation of categories during the Black Friday month (November)
SELECT
	strftime('%Y-%m', v.data_venda) AS year_month,
	c.nome_categoria AS category_name,
    COUNT(it.produto_id) AS items_sold_count 
from itens_venda it
JOIN produtos p
	ON it.produto_id = p.id_produto
JOIN categorias c
	ON P.categoria_id = c.id_categoria
JOIN vendas v
	ON it.venda_id = v.id_venda
WHERE 
	strftime('%m', data_venda) = '11' -- Filter for November (Month '11')
GROUP BY 1, 2
ORDER BY 2, 1;

-- Identify the categories with the highest and lowest sales volume during last year's Black Friday (November 2022)
SELECT
	strftime('%Y-%m', v.data_venda) AS year_month,
	c.nome_categoria AS category_name,
    COUNT(it.produto_id) AS items_sold_count
from itens_venda it
JOIN produtos p
	ON it.produto_id = p.id_produto
JOIN categorias c
	ON P.categoria_id = c.id_categoria
JOIN vendas v
	ON it.venda_id = v.id_venda
WHERE 
	strftime('%Y-%m', v.data_venda) = '2022-11' -- Filters for a specific year and month (November 2022)
GROUP BY year_month, c.nome_categoria
ORDER BY items_sold_count DESC; -- Orders from highest sales volume to lowest

-- Compare monthly sales volume (items sold) across key suppliers using a pivot structure

WITH suppliers AS (
    SELECT
        strftime('%Y-%m', v.data_venda) AS year_month,
        f.nome AS supplier_name,
        COUNT(it.produto_id) AS items_sold
    FROM itens_venda it
    JOIN produtos p
        ON it.produto_id = p.id_produto
    JOIN fornecedores f
        ON p.fornecedor_id = f.id_fornecedor
    JOIN vendas v
        ON it.venda_id = v.id_venda
    GROUP BY year_month, supplier_name
    ORDER BY year_month Asc
)
SELECT
    year_month,
    SUM(CASE WHEN supplier_name = 'NebulaNetworks' THEN items_sold ELSE 0 end) AS sales_NebulaNetworks,
    SUM(CASE WHEN supplier_name = 'HorizonDistributors' THEN items_sold ELSE 0 END) AS sales_HorizonDistributors,
    SUM(CASE WHEN supplier_name = 'AstroSupply' THEN items_sold ELSE 0 END) AS sales_AstroSupply
FROM suppliers
GROUP BY 1;

-- Calculate the sales percentage contribution of each category (Category Sales / Total Sales)
-- This query uses a Scalar Subquery and the multiplication by 1.0 to ensure float division.
SELECT
	c.nome_categoria AS category_name,
	COUNT(it.produto_id) AS items_sold,
    -- Calculation: (Category Sales / Total Global Sales) * 100
    ROUND((COUNT(it.produto_id) / (SELECT count(*) * 1.0 as rows from itens_venda) * 100), 2) AS perc_sold,
	-- Add string "%"
	ROUND((COUNT(it.produto_id) / (SELECT count(*) * 1.0 as rows from itens_venda) * 100), 2) || '%'  AS perc_sold
FROM itens_venda it
JOIN produtos p
	ON it.produto_id = p.id_produto
JOIN categorias c
	ON P.categoria_id = c.id_categoria
JOIN vendas v
	ON it.venda_id = v.id_venda
GROUP BY c.nome_categoria
ORDER BY items_sold DESC;

-- Analyze the monthly sales seasonality over the last four years (2020-2023).
-- This is achieved by pivoting the data using SUM(CASE WHEN...).

SELECT
	strftime('%m', v.data_venda) AS month, -- Extracts the month (01 to 12) for grouping
    SUM(CASE WHEN strftime('%Y', v.data_venda) = '2020' THEN 1 ELSE 0 end) AS "2020",
    SUM(CASE WHEN strftime('%Y', v.data_venda) = '2021' THEN 1 ELSE 0 end) AS "2021",
    SUM(CASE WHEN strftime('%Y', v.data_venda) = '2022' THEN 1 ELSE 0 end) AS "2022",
    SUM(CASE WHEN strftime('%Y', v.data_venda) = '2023' THEN 1 ELSE 0 end) AS "2023"
FROM vendas v
GROUP BY 1
ORDER BY 1;

-- Calculate the percentage difference between the average historical Black Friday sales
-- (excluding 2022) and the actual Black Friday sales performance in 2022.

WITH avg_sales AS (
    -- CTE 1: Calculates the average sales volume for November across all years, excluding 2022.
    SELECT
        AVG(sales) AS avg_historical_sales
    FROM (
        SELECT strftime('%Y', v.data_venda) AS year, COUNT(*) AS sales
        FROM vendas v
        -- Filter for November (month '11') and exclude the current comparison year (2022)
        WHERE strftime('%m', v.data_venda) = '11' AND strftime('%Y', v.data_venda) != '2022'
        GROUP BY 1
    )
), 
act_sales AS (
    -- CTE 2: Captures the actual sales volume for the target comparison year (November 2022).
    SELECT
        sales AS actual_2022_sales
    FROM (
        SELECT strftime('%Y', v.data_venda) AS year, COUNT(*) AS sales
        FROM vendas v
        -- Filter specifically for November 2022
        WHERE strftime('%m', v.data_venda) = '11' AND strftime('%Y', v.data_venda) = '2022'
        GROUP BY 1
    )
)
SELECT
    avg_va.avg_historical_sales,
    va.actual_2022_sales,
    -- Calculation: ((Actual - Average) / Average) * 100 to find the percentage variance.
    ROUND(((va.actual_2022_sales - avg_va.avg_historical_sales) / avg_va.avg_historical_sales * 100), 2) AS percentage_variance
FROM avg_sales avg_va, act_sales va;
