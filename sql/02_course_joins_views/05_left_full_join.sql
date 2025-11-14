

-- INSERINDO NOVOS CLIENTES

INSERT INTO Clientes (Nome, Telefone, Email, Endereco)
VALUES (28, 'João Santos', '215555678', 'joao.santos@email.com', 'Avenida Principal, 456, Cidade B'),
       (29, 'Carla Ferreira', '315557890', 'carla.ferreira@email.com', 'Travessa das Ruas, 789, Cidade C');


-- LEFT JOIN
SELECT * FROM clientes;
 
SELECT c.nome, p.id
 FROM clientes c 
 LEFT JOIN Pedidos p 
 ON c.id = p.idcliente;
 

SELECT c.nome, P.idcliente 
 FROM clientes c 
 LEFT JOIN Pedidos p 
 ON c.id = p.idcliente
WHERE strftime('%m', p.datahorapedido) = '10' ;


SELECT c.nome, x.id 
FROM clientes c
LEFT JOIN
(
	SELECT p.id, p.idcliente 
	FROM pedidos p
	WHERE strftime('%m', p.datahorapedido) = '09')x
ON c.id = x.idcliente
WHERE x.idcliente is NULL;


-- FULL JOIN

SELECT c.nome, p.id 
FROM clientes c
FULL JOIN pedidos p
ON c.id = p.idcliente;


SELECT c.nome, p.id 
FROM clientes c
FULL JOIN pedidos p
ON c.id = p.idcliente
WHERE c.id is NULL;

SELECT c.nome, p.id 
FROM clientes c
FULL JOIN pedidos p
ON c.id = p.idcliente
WHERE p.id is NULL;







