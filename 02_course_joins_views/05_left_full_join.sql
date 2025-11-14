-- insert new customers

SELECT * FROM clientes;

INSERT INTO clientes (id, nome, telefone, email, endereco)
VALUES (28, 'João Santos', '215555678', 'joao.santos@email.com', 'Avenida Principal, 456, Cidade B'),
       (29, 'Carla Ferreira', '315557890', 'carla.ferreira@email.com', 'Travessa das Ruas, 789, Cidade C');
       
-- if i'd like to delete the rows       
DELETE FROM clientes
WHERE id IN (28, 29);


-- LEFT JOIN
SELECT * FROM clientes;
 
-- who it's the clients that is not doing orders 
SELECT 
 	c.nome,
    c.telefone
FROM clientes c 
LEFT JOIN pedidos p 
	ON c.id = p.idcliente
 WHERE p.id IS NULL;
 

-- searching for products that were sold in october
SELECT
	p.idcliente, 
	c.nome
FROM clientes c 
LEFT JOIN pedidos p 
	ON c.id = p.idcliente
WHERE strftime('%m', p.datahorapedido) = '10';


-- searching for products that were not sold in october
SELECT 
	-- x.id,
	c.nome
FROM clientes c
LEFT JOIN
(
	SELECT p.id, p.idcliente 
	FROM pedidos p
	WHERE strftime('%m', p.datahorapedido) = '09')x
ON c.id = x.idcliente
WHERE x.idcliente is NULL;


-- FULL JOIN

-- orders that don't have customers
SELECT 
	c.nome, 
    p.id 
FROM clientes c
FULL JOIN pedidos p
	ON c.id = p.idcliente
WHERE c.id is NULL;


-- customers that don't have orders
SELECT 
	c.nome, 
    p.id 
FROM clientes c
FULL JOIN pedidos p
	ON c.id = p.idcliente
WHERE p.idcliente is NULL;







