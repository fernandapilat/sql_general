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