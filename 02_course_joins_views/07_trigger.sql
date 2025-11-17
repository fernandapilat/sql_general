-- Retrieve the total daily sales
SELECT
	DATE(datahorapedido) AS day,
    ROUND(SUM(ip.precounitario), 0) as sales
from pedidos p
join itenspedidos ip
	on p.id = ip.idpedido
GROUP BY 1
ORDER BY 1;

---

-- Create the dedicated table for storing aggregated daily sales
CREATE TABLE daily_sales (
    day DATE,
    sales DECIMAL(10, 2)
);

---

-- Insert calculated daily sales into the daily_sales table
-- The data is calculated by joining the 'pedidos' and 'itenspedidos' tables.

INSERT INTO daily_sales (day, sales)
SELECT
	DATE(datahorapedido) AS day,
    ROUND(SUM(ip.precounitario), 0) as sales
from pedidos p
join itenspedidos ip
	on p.id = ip.idpedido
GROUP BY 1
ORDER BY 1;

SELECT * FROM daily_sales;

---

-- Create a trigger to automatically recalculate and update daily sales
CREATE TRIGGER calculate_daily_sales -- Trigger Name
AFTER INSERT ON itenspedidos         -- Executes after a new item is added to an order
FOR EACH ROW
BEGIN
    -- WARNING: Deleting all data to recalculate is inefficient for large tables.
    -- A better approach is to UPDATE the existing day's data or INSERT new days.
    DELETE FROM daily_sales; -- Delete current data before recalculation

    INSERT INTO daily_sales (day, sales)
    SELECT
        DATE(datahorapedido) AS day,
        ROUND(SUM(ip.precounitario), 0) as sales
    from pedidos p
    join itenspedidos ip
        on p.id = ip.idpedido
    GROUP BY 1
    ORDER BY 1;
END;

-- Check the contents of the calculated table
SELECT * from daily_sales;

---

-- Insert a new order to test the trigger functionality
INSERT INTO pedidos(id, idcliente, datahorapedido, status)
VALUES (451, 27, '2023-10-07 14:30:00', 'Em Andamento');

-- Verify the new order insertion
SELECT * from pedidos;

---

-- Insert items into the new order to fire the 'AFTER INSERT' trigger on itenspedidos
INSERT INTO itenspedidos(idpedido, idproduto, quantidade, precoUnitario)
VALUES (451, 14, 1, 6.0), (451, 13, 1, 7.0);