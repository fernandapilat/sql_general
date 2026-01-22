-- Start a new transaction block.
BEGIN TRANSACTION;

-- Review the current data in the 'clientes' table.
SELECT * FROM clientes;

-- Review the current data in the 'Pedidos' table.
SELECT * FROM Pedidos;

-- This command will update the status of ALL orders.
UPDATE Pedidos SET Status = 'Concluído';

-- This command will delete ALL records from the 'clientes' table.
DELETE FROM clientes;

-- Rollback the transaction: This command undoes the UPDATE and DELETE operations, 
-- restoring the database to its state before the BEGIN TRANSACTION command.
ROLLBACK;

-- Start a new transaction block.
BEGIN TRANSACTION;

-- Review the current data in the 'Pedidos' table before updating.
SELECT * FROM Pedidos;

-- Update the status of only the orders that are currently marked as 'Em Andamento' (In Progress) to 'Concluído' (Completed).
UPDATE Pedidos SET Status = 'Concluído' WHERE status = 'Em Andamento';

-- Commit the transaction: This command finalizes the UPDATE operation, 
-- making the changes permanent in the database.
COMMIT;