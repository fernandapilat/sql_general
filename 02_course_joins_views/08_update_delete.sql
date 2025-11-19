-- This command is specific to SQLite and enables foreign key constraints.
PRAGMA foreign_keys = ON;

---

-- Retrieve the current data for product ID 31 before updating.
SELECT * from produtos WHERE id = 31;

-- Update the price of product ID 31.
UPDATE produtos set preco = 13.0 WHERE id = 31;

-- Verify the product whose name starts with 'croissant'.
SELECT * from produtos WHERE nome LIKE 'croissant%';

-- Update the description of product ID 28.
UPDATE produtos set descricao = 'Croissant recheado com amêndoas.' WHERE id = 28;
-- Template: UPDATE table SET column = 'new description' WHERE id = define ID

---

-- Using the DELETE command

-- Verify the employee (colaboradores) with ID 3 before deletion.
SELECT * FROM colaboradores WHERE id = 3;

-- Delete the employee with ID 3.
DELETE FROM colaboradores WHERE id = 3;

---

-- Review data before testing cascading deletes (foreign key constraints)

-- Check data for client ID 27.
SELECT * FROM clientes where ID = 27;

-- Check orders associated with client ID 27.
SELECT * FROM pedidos where idcliente = 27;

-- Check item details for order ID 451.
SELECT * FROM itenspedidos where idpedido = 451;

-- Attempt to delete client ID 27.
-- NOTE: If foreign_keys are ON, this deletion will fail or cascade, depending on table settings.
DELETE FROM clientes WHERE id = 27;

---

-- Set the status of all current orders to 'Concluído' (Completed).
UPDATE pedidos SET status = 'Concluído';