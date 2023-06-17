USE TSQLV6;
GO

CREATE OR ALTER VIEW Sales.VEmpOrders 
AS
WITH SalesDetails AS (
	SELECT orders.empid, YEAR(orders.orderdate) AS orderyear, details.qty
	FROM Sales.Orders AS orders
	JOIN Sales.OrderDetails AS details
	ON orders.orderid = details.orderid
)
SELECT empid, orderyear, SUM(qty) as qty
FROM SalesDetails
GROUP BY empid, orderyear
GO

-- 5.1
SELECT * FROM Sales.VEmpOrders ORDER BY empid, orderyear;

-- 5.2
SELECT empid, orderyear, qty, SUM(qty) OVER (PARTITION BY empid ORDER BY orderyear) AS runqty
FROM Sales.VEmpOrders;