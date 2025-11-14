
-- INNER JOIN

SELECT * FROM clientes;

SELECT * FROM pedidos;


SELECT  *
FROM clientes c 
INNER JOIN pedidos p 
ON c.id = p.idcliente;

SELECT c.nome, p.id, p.datahorapedido 
FROM clientes c 
INNER JOIN pedidos p 
ON c.id = p.idcliente;


-- RIGHT JOIN

SELECT * FROM produtos;

INSERT INTO Produtos (ID, Nome, Descricao, Preco, Categoria)VALUES 
(31, 'Lasanha à Bolonhesa', 'Deliciosa lasanha caseira com molho bolonhesa', 12.50, 'Almoço');

SELECT * FROM itenspedidos;


SELECT pr.nome, ip.id, ip.idproduto 
 FROM itenspedidos AS ip
 RIGHT JOIN  Produtos AS pr
 ON pr.id = ip.idproduto;

SELECT pr.nome,  x.idproduto,  x.idpedido 
FROM(
    SELECT ip.idpedido, ip.idproduto
    FROM pedidos p
    JOIN itenspedidos ip 
    ON p.id = ip.idpedido
    WHERE strftime('%m', p.DataHoraPedido) = '10' ) x
RIGHT JOIN produtos pr
ON pr.id =  x.idproduto;

























