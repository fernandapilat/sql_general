
-- INNER JOIN

SELECT * FROM clientes;

SELECT * FROM pedidos;


SELECT  *
FROM clientes c 
INNER JOIN pedidos p 
ON c.id = p.idcliente;

-- just some columns
SELECT
    c.nome,
    p.id, 
    p.datahorapedido 
FROM clientes c 
INNER JOIN pedidos p 
ON c.id = p.idcliente
ORDER BY c.id;

-- if i want to know how much orders per customers
SELECT
    c.nome,
    COUNT(p.id) AS order_qty
FROM clientes c 
INNER JOIN pedidos p 
	ON c.id = p.idcliente
GROUP BY c.nome
ORDER BY order_qty DESC;


-- RIGHT JOIN

SELECT * FROM produtos;

INSERT INTO Produtos (ID, Nome, Descricao, Preco, Categoria)VALUES 
(31, 'Lasanha à Bolonhesa', 'Deliciosa lasanha caseira com molho bolonhesa', 12.50, 'Almoço');

SELECT * FROM itenspedidos;

-- qty products sold
SELECT 
	pr.nome,
    pr.id,
    COUNT(ip.idpedido) as qty_order
 FROM itenspedidos AS ip
 RIGHT JOIN  produtos AS pr
 	ON pr.id = ip.idproduto
 GROUP BY pr.nome, pr.id
 ORDER BY qty_order;
 
 -- top 5 worst sellers
 SELECT 
	pr.nome,
    pr.id,
    COUNT(ip.idpedido) as qty_order
 FROM itenspedidos AS ip
 RIGHT JOIN  produtos AS pr
 	ON pr.id = ip.idproduto
 GROUP BY pr.nome, pr.id
 ORDER BY qty_order
 LIMIT 5;
 
-- searching for products that were not sold in october
SELECT 
	pr.nome,  
    x.idproduto,  
    x.idpedido 
FROM(
    SELECT ip.idpedido, ip.idproduto
    FROM pedidos p
    JOIN itenspedidos ip 
    ON p.id = ip.idpedido
    WHERE strftime('%m', p.DataHoraPedido) = '10' ) x
RIGHT JOIN produtos pr
ON pr.id =  x.idproduto
WHERE x.idproduto IS NULL;

























