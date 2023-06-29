USE TSQLV6;

DECLARE 
	@bucketwidth AS INT = 1,
	@origin AS DATE = '19000701'

WITH C AS 
(
	SELECT shipperid, qty, val, DATE_BUCKET(year, @bucketwidth, orderdate, @origin) AS startofyear
	FROM Sales.OrderValues
)
SELECT shipperid, startofyear, 
	DATEADD(day, -1, DATEADD(year, @bucketwidth, startofyear)) AS endofyear,
	SUM(qty) as totalqty,
	SUM(val) AS totalval
FROM C
GROUP BY shipperid, startofyear
ORDER BY shipperid, startofyear;