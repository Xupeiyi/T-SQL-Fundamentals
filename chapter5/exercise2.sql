USE TSQLV6;

-- exercise 2.1
SELECT empid, MAX(orderdate) AS maxorderdate
FROM Sales.Orders
GROUP BY empid;

-- exercise 2.2
SELECT orders.empid, orders.orderdate, orders.orderid, orders.custid
FROM
Sales.Orders AS orders 
JOIN (SELECT empid, MAX(orderdate) AS maxorderdate
	  FROM Sales.Orders
	  GROUP BY empid) AS latest_orders 
ON orders.empid = latest_orders.empid 
AND orders.orderdate = latest_orders.maxorderdate;