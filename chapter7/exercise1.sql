USE TSQLV6;

SELECT custid, orderid, qty, 
	RANK() OVER(PARTITION BY custid ORDER BY qty) AS rnk,
	DENSE_RANK() OVER (PARTITION BY custid ORDER BY qty) AS drnk
FROM dbo.Orders;
