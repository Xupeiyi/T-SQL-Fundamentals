USE TSQLV6;

WITH management AS (
	SELECT empid, mgrid, firstname, lastname
	FROM HR.Employees
	WHERE empid = 9

	UNION ALL

	SELECT e.empid, e.mgrid, e.firstname, e.lastname
	FROM management AS m
	JOIN HR.Employees as e
	ON e.empid = m.mgrid 
)
SELECT empid, mgrid, firstname, lastname
FROM management;