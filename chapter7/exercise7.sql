USE TSQLV6;

WITH cte AS (
	SELECT DATE_BUCKET(week, 1, orderdate, CAST('19000107' AS DATE)) AS startofweek
	FROM Sales.Orders
)
SELECT startofweek, DATEADD(day, 6, startofweek) AS endofweek, count(*) AS numorders
FROM cte
GROUP BY startofweek
ORDER BY startofweek;

