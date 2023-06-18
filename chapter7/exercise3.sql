USE TSQLV6;

-- applys to SQL Server 2022, Azure SQL Database and Azure SQL Managed Instance
SELECT custid, orderid, qty, 
	qty - LAG(qty) OVER W AS diffprev,
	qty - LEAD(qty) OVER W AS diffnext
FROM dbo.Orders
WINDOW W AS (PARTITION BY custid ORDER BY orderdate, orderid);