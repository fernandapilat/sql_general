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