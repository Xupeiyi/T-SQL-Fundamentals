USE TSQLV4;

--1. Variables
-- set one value
DECLARE @empname AS NVARCHAR(61);

SET @empname = (SELECT firstname + N' ' + lastname from HR.Employees WHERE empid = 3);

SELECT @empname AS empname;

-- set multiple values
DECLARE @firstname AS NVARCHAR(20), @lastname AS NVARCHAR(40);

SELECT
	@firstname = firstname,
	@lastname = lastname
FROM HR.Employees
WHERE empid = 3;

SELECT @firstname AS firstname, @lastname AS lastname;

-- 2. Batches
-- batch: parsing(syntax check), binding(check existence of referenced object and permission), optimization
-- sets of command that are parsed and executed as a unit
-- a variable is local to a batch
-- a lot of CREATE statements cannot be combined in the same batch
-- use GO to seperate DDL and DML in different batches


--3. Flow Elements

-- IF ... ELSE ...
-- ELSE is activated when predicate is either FALSE or UNKNOWN
IF DAY(SYSDATETIME()) = 1
BEGIN
	PRINT 'Today is the first day of month';
END;
ELSE
BEGIN
	PRINT 'Today is not the first day of the month';
END;
GO;

-- WHILE
DECLARE @i AS INT = 1;
WHILE @i <= 10
BEGIN
	IF @i = 6 BREAK;
	PRINT @i;
	SET @i = @i + 1;
END;





--4. Cursors
-- Use cursors to process rows one at a time


-- ....


-- 7. Routines
-- 7.1 User Defined Functions
-- A UDF can return scalar or table, and it must has a RETURN clause
-- A UDF cannot have side effects

DROP FUNCTION IF EXISTS dbo.GetAge;
GO

CREATE FUNCTION dbo.GetAge(@birthdate AS DATE, @eventdate AS DATE) RETURNS INT 
AS
BEGIN
	RETURN DATEDIFF(year, @birthdate, @eventdate) 
		   - CASE WHEN 100 * MONTH(@eventdate) + DAY(@eventdate)
					< 100 * MONTH(@birthdate) + DAY(@birthdate) THEN 1 
				  ELSE 0
			 END;
END;
GO

SELECT empid, firstname, lastname, birthdate, dbo.GetAge(birthdate, SYSDATETIME()) AS age
FROM HR.Employees;


-- 7.2 Stored Procedures
-- can have input and output parameters
-- can return result sets of queries
-- are allowed to have side effects
-- can grant a user permission to execute the procedure but not underlying activities
DROP PROC IF EXISTS Sales.GetCustomerOrders;
GO

CREATE PROC Sales.GetCustomerOrders
	@custid AS INT,
	@fromdate AS DATETIME = '19000101',
	@todate AS DATETIME = '99991231',
	@numrows AS INT OUTPUT
AS
SET NOCOUNT ON;

SELECT orderid, custid, empid, orderdate 
FROM Sales.Orders
WHERE custid = @custid
	AND orderdate >= @fromdate
	AND orderdate < @todate;

SET @numrows = @@ROWCOUNT;
GO

DECLARE @rc AS INT;
EXEC Sales.GetCustomerOrders
	@custid = 1,
	@fromdate = '20150101',
	@todate = '20160101',
	@numrows = @rc OUTPUT;

SELECT @rc AS numrows;
GO





















