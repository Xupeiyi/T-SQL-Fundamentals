USE TSQLV6;

SELECT DISTINCT val, DENSE_RANK() OVER (ORDER BY val) AS rownum
FROM Sales.OrderValues; 

-- or
WITH C AS (
	SELECT DISTINCT val
	FROM Sales.OrderValues
)
SELECT val, ROW_NUMBER() OVER (ORDER BY val) AS rownum
FROM C;