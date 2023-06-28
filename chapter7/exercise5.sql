USE TSQLV6;

DROP TABLE IF EXISTS dbo.EmpYearOrders;

CREATE TABLE dbo.EmpYearOrders(
	empid INT NOT NULL CONSTRAINT PK_EmpYearOrders PRIMARY KEY,
	cnt2020 INT NULL,
	cnt2021 INT NULL,
	cnt2022 INT NULL
);

INSERT INTO dbo.EmpYearOrders(empid, cnt2020, cnt2021, cnt2022)
	SELECT empid, [2020] AS cnt2020, [2021] AS cnt2021, [2022] AS cnt2022
	FROM (SELECT empid, YEAR(orderdate) AS orderyear FROM dbo.Orders) AS D
			PIVOT (COUNT(orderyear) FOR orderyear in ([2020], [2021], [2022])) AS P

SELECT empid, CAST(RIGHT(orderyear, 4) AS INT) AS orderyear,  numorders
FROM dbo.EmpYearOrders
    UNPIVOT (numorders FOR orderyear in (cnt2020, cnt2021, cnt2022)) AS U
WHERE numorders != 0;