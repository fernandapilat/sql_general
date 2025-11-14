SELECT
	*
FROM pedidos p;

-- sellings per month
SELECT
    strftime('%Y-%m', p.datahorapedido) AS date,
    ROUND(SUM(ip.precounitario), 0) AS total_orders
FROM itenspedidos ip
LEFT JOIN pedidos p
	ON ip.idpedido = p.id
LEFT JOIN produtos pr
	ON ip.idproduto = pr.id
GROUP BY 1;

-- selling per customer
SELECT
    c.nome,
    ROUND(SUM(ip.precounitario), 0) AS total_orders
FROM clientes c
JOIN pedidos p
	ON c.id = p.idcliente
JOIN itenspedidos ip
	ON p.id = ip.idpedido
GROUP BY 1;


-- selling per order
SELECT
	p.id,
    p.datahorapedido,
    c.nome,
    ROUND(SUM(ip.precounitario), 0) AS total_orders
FROM clientes c
JOIN pedidos p
	ON c.id = p.idcliente
JOIN itenspedidos ip
	ON p.id = ip.idpedido
GROUP BY 1;

-- creating a view for the general orders
create VIEW v_total_orders AS
SELECT
	p.id,
    p.datahorapedido,
    c.nome,
    ROUND(SUM(ip.precounitario), 0) AS total_price
FROM clientes c
JOIN pedidos p
	ON c.id = p.idcliente
JOIN itenspedidos ip
	ON p.id = ip.idpedido
GROUP BY 1;

----------------------------
-- view queries

SELECT * FROM v_total_orders;

SELECT nome FROM v_total_orders;

SELECT 
	* 
FROM v_total_orders
WHERE
	total_price >= 10;
    
    
SELECT 
	* 
FROM v_total_orders
WHERE
	total_price > 10
    AND total_price < 14;
    
 
SELECT 
	* 
FROM v_total_orders
WHERE strftime('%m', datahorapedido) = '08';