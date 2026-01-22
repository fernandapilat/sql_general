-- Practice time

-- 1. Retrieve all data for the client Maria Silva
SELECT 
	* FROM clientes c
WHERE 
	nome LIKE 'Maria S%';
	
-- 2. Fetch the order ID and client ID for orders whose status is 'Entregue' (Delivered)
SELECT
	p.id,
	p.idcliente
from pedidos p
WHERE status = 'Entregue';

-- 3. Return all products where the price is greater than 10 and less than 15
SELECT 
* FROM produtos pr
WHERE
	pr.preco > 10
	AND pr.preco < 15;

-- 4. Fetch the name and job title of employees hired between 2022-01-01 and 2022-06-30

SELECT
	co.Nome,
	co.Cargo
FROM colaboradores co
WHERE
	co.DataContratacao >= '2022-01-01'
	and co.DataContratacao < '2022-06-30';

-- 5. Retrieve the name of the client who placed the very first order.

SELECT
	c.nome
FROM clientes c
WHERE c.id = (
	SELECT idcliente 
	FROM pedidos 
	WHERE status = 'Concluído' 
	ORDER BY datahorapedido ASC LIMIT 1);

-- 6. List the products that have never been ordered.

SELECT 
	* FROM produtos pr
WHERE id NOT IN (
	SELECT idproduto 
	FROM itenspedidos);

-- 7. List the names of clients who placed orders between 2023-01-01 and 2023-12-31.

SELECT
	c.nome
FROM clientes c
WHERE c.id IN (
	SELECT DISTINCT idcliente 
	FROM pedidos 
	WHERE datahorapedido BETWEEN '2023-01-01' AND '2023-01-31');
	
SELECT 
	c.nome
FROM clientes c
INNER JOIN pedidos p 
	ON c.id = p.idCliente
WHERE p.datahorapedido BETWEEN '2023-01-01' AND '2023-01-31';

-- 8. Retrieve the names of products that are in fewer than 15 orders.

SELECT * FROM itenspedidos;

SELECT
	p.nome,
	COUNT(p.nome) AS qty
FROM produtos p
LEFT join itenspedidos ip
	ON p.id = ip.idproduto
GROUP BY p.nome
HAVING qty < 15
order by qty; 	
	
-- 9. List the products and the order ID placed by the client "Pedro Alves" or the client "Ana Rodrigues".

SELECT
	p.nome as productname,
	ip.idpedido
FROM itenspedidos ip
LEFT JOIN produtos p
	ON p.id = ip.idproduto
LEFT JOIN pedidos pd
	ON pd.id = ip.idpedido
LEFT JOIN clientes c
	ON pd.idcliente = c.id
WHERE c.nome IN ('Pedro Alves', 'Ana Rodrigues');

-- 10. Retrieve the name and ID of the client who made the most purchases (total value) at Serenatto.

SELECT
	c.id,
	c.nome,
	ROUND(SUM(precounitario), 0) AS total_orders
FROM itenspedidos ip
LEFT JOIN produtos p
	ON p.id = ip.idproduto
LEFT JOIN pedidos pd
	ON pd.id = ip.idpedido
LEFT JOIN clientes c
	ON pd.idcliente = c.id
GROUP BY c.id, c.nome
order by total_orders DESC
LIMIT 1;