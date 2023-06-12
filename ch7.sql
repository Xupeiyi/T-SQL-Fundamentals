USE TSQLV4;


-- 1. Window Functions

SELECT empid, ordermonth, val, 
	SUM(val) OVER (PARTITION BY empid
				   ORDER BY ordermonth
				   ROWS BETWEEN UNBOUNDED PRECEDING 
						AND CURRENT ROW) AS runval
FROM Sales.EmpOrders;

-- 1) Ranking window functions
SELECT orderid, custid, val,
	ROW_NUMBER() OVER (ORDER BY val) AS rownum, --result nondeterministic if val has the same value
	RANK() OVER(ORDER BY val) AS rank,
	DENSE_RANK() OVER(ORDER BY val) as dense_rank,
	NTILE(100) OVER(ORDER BY val) AS ntile
FROM Sales.OrderValues
ORDER BY val;


SELECT orderid, custid, val,
	ROW_NUMBER() OVER(PARTITION BY custid
					  ORDER BY val) AS rownum
FROM Sales.OrderValues
ORDER BY custid, val;


-- window functions are logically evaluated as part of the SELECT list, before the DISTINCT clause is evaluated.
-- if multiple columns are selected, DISTINCT uses the combination of values in all specified columns to evaluate the uniqueness 
-- therefore, the distinct here has no effect
SELECT DISTINCT val, ROW_NUMBER() OVER (ORDER BY val) AS rownum FROM Sales.OrderValues;


-- GROUP BY is processed before SELECT, USE GROUP BY to drop duplicate.
SELECT val, ROW_NUMBER() OVER (ORDER BY val) AS rownum FROM Sales.OrderValues GROUP BY val;


-- 2) Offset window functions
SELECT custid, orderid, val,
	LAG(val, 2, -1) OVER (PARTITION BY custid
				   ORDER BY orderdate, orderid) AS preval,
	LEAD(val) OVER (PARTITION BY custid
					ORDER BY orderdate, orderid) AS nextval
FROM Sales.OrderValues
ORDER BY custid, orderdate, orderid;


SELECT custid, orderid, val,
	FIRST_VALUE(val) OVER (PARTITION BY custid
						   ORDER BY orderdate, orderid
						   ROWS BETWEEN UNBOUNDED PRECEDING -- n preceding
								AND CURRENT ROW) AS firstval, 
	LAST_VALUE(val) OVER (PARTITION BY custid
						  ORDER BY orderdate, orderid
						  ROWS BETWEEN CURRENT ROW
							   AND UNBOUNDED FOLLOWING) AS lastval
FROM Sales.OrderValues
ORDER BY custid, orderdate, orderid;


-- 3) Aggregate window functions
SELECT orderid, custid, val,
	SUM(val) OVER() AS totalvalue,
	SUM(val) OVER(PARTITION BY custid) AS custtotalvalue
FROM Sales.OrderValues;

SELECT orderid, custid, val,
	100. * val / SUM(val) OVER() as pctall,
	100. * val / SUM(val) OVER (PARTITION BY custid) as pctcust
FROM Sales.OrderValues;


-- De-duplication
DROP TABLE if exists users;
CREATE TABLE users (
    id INT PRIMARY KEY IDENTITY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(255) NOT NULL
);

INSERT INTO users (first_name,last_name,email) 
VALUES ('Chuan ','Jiang','HiJiangChuan@gmail.com'),
       ('Chuan ','Jiang','HiJiangChuan@gmail.com'),
       ('Ch. ','Jiang','HiJiangChuan@gmail.com'),
       ('Ke','Xie','xieke@sina.com'),
       ('Ke','Xie','xieke@qq.com'),
       ('Amei','Song','amei@163.com');

DELETE u1 from users u1, users u2
where u1.id < u2.id and u1.first_name = u2.first_name and u1.last_name = u2.last_name;

select * from users;