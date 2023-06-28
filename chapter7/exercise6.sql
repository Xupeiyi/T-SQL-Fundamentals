USE TSQLV6;

WITH cte AS (
	SELECT empid, custid, YEAR(orderdate) AS orderyear, qty
	FROM dbo.Orders
)
SELECT GROUPING_ID(empid, custid, orderyear) AS groupingset, empid, custid, orderyear, SUM(qty) AS sumqty
FROM cte
GROUP BY 
	GROUPING SETS ( 
		(empid, custid, orderyear),
		(empid, orderyear),
		(custid, orderyear)
	)