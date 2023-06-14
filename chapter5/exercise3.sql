USE TSQLV6;

-- exercise 3.1
SELECT orderid, orderdate, custid, empid, 
	   ROW_NUMBER() OVER(ORDER BY orderdate, orderid) AS rownum
FROM Sales.Orders;

-- exercise 3.2
WITH order_rows AS (
	SELECT orderid, orderdate, custid, empid, 
	   ROW_NUMBER() OVER(ORDER BY orderdate, orderid) AS rownum
	FROM Sales.Orders
)
SELECT * FROM order_rows WHERE rownum BETWEEN 11 AND 20;