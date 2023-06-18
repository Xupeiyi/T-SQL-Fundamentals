USE TSQLV6;
GO 

-- 6.1
CREATE OR ALTER FUNCTION Production.TopProducts(@supid AS INT, @n AS INT) RETURNS TABLE
AS
RETURN
	SELECT TOP (@n) productid, productname, unitprice
	FROM Production.Products
	WHERE supplierid = @supid
	ORDER BY unitprice DESC;
GO

SELECT * FROM Production.TopProducts(5, 2);

-- 6.2
SELECT suppliers.supplierid, suppliers.companyname, products.productid, products.productname, products.unitprice
FROM Production.Suppliers AS suppliers
CROSS APPLY 
Production.TopProducts(suppliers.supplierid, 2) AS products;

DROP VIEW IF EXISTS Sales.VEmpOrders;

DROP FUNCTION IF EXISTS Production.TopProducts;
