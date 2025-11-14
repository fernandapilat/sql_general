-- subqueries
-- can be used w/ SELECT, FROM, WHERE and HAVING

SELECT * FROM clientes;

SELECT * FROM pedidos;

-- manual filter for specific criteria/values.
SELECT idcliente FROM pedidos WHERE datahorapedido = '2023-01-02 08:15:00';

-- manual filter w/ subquery
SELECT nome
FROM clientes
WHERE id = (SELECT idcliente FROM pedidos WHERE datahorapedido = '2023-01-02 08:15:00');

-- partition per customer (it's not what i want)
SELECT
	*
FROM (SELECT 
	c.id,
    c.nome,
    p.datahorapedido,
    ROW_NUMBER() OVER (PARTITION BY c.id ORDER BY p.datahorapedido ASC) as rank
FROM clientes AS c
JOIN pedidos p on c.id = p.idcliente)
WHERE
	rank = 1;  
    
 -- refactoring: removing PARTITION BY to calculate overall rank.
SELECT
	id,
    nome
FROM (SELECT 
	c.id,
    c.nome,
    p.datahorapedido,
    ROW_NUMBER() OVER (/*PARTITION BY c.id*/ ORDER BY p.datahorapedido ASC) as rank
FROM clientes AS c
JOIN pedidos p on c.id = p.idcliente)
WHERE
	rank = 1;


-- subqueries w/ IN
SELECT nome FROM clientes;

SELECT idcliente
FROM pedidos
WHERE strftime('%m', datahorapedido) = '01';

SELECT nome
FROM clientes
WHERE id IN (
    SELECT idcliente
    FROM pedidos
    WHERE strftime('%m', datahorapedido) = '01');
    
    
-- function data

SELECT 
	datahorapedido AS original,
    strftime('%Y-%m-%d', datahorapedido) AS date,
    strftime('%Y/%m/%d', datahorapedido) AS date_format,
    strftime('%d', datahorapedido) AS day,
    strftime('%m', datahorapedido) AS month,
    strftime('%Y', datahorapedido) AS year,
    strftime('%Y-%m', datahorapedido) AS year_month,
    strftime('%Y-%m-%d', datahorapedido, 'start of month') AS first_day,
    strftime('%w', datahorapedido) AS week_day,
    CASE WHEN strftime('%w', datahorapedido) = '1' THEN 'Monday' END AS week_day_txt,
    strftime('%Y-%m-%d', 'now', '-30 day') AS last_30d
FROM pedidos
LIMIT 1;

-- subqueries w/ HAVING

SELECT * FROM produtos;

SELECT AVG(preco) FROM produtos;

SELECT nome, preco
FROM produtos
GROUP BY nome, preco
HAVING preco > (SELECT AVG(preco) FROM produtos);

SELECT 
	categoria, 
	ROUND(SUM(preco), 0) as total_orders
FROM produtos
GROUP BY 1
HAVING preco > (SELECT AVG(preco) FROM produtos);