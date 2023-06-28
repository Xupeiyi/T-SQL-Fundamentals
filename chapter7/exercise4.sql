USE TSQLV6;

SELECT empid, [2020] AS cnt2020, [2021] AS cnt2021, [2022] AS cnt2022
FROM (SELECT empid, YEAR(orderdate) as year_ FROM dbo.Orders) AS orders
	PIVOT(COUNT(year_) FOR year_ IN ([2020], [2021], [2022])) AS p; 