-- the problem is that the WHERE clause is logically processed prior to the SELECT clause

USE TSQLV6;

SELECT orderid, orderdate, custid, empid, endofyear
FROM (SELECT orderid, orderdate, custid, empid, DATEFROMPARTS(YEAR(orderdate), 12, 31) AS endofyear 
	  FROM Sales.Orders) AS D
WHERE orderdate <> endofyear;