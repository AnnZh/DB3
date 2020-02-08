USE AdventureWorks2012;
GO

--a)
ALTER TABLE Anna_Zhurok.dbo.Address
ADD
AccountNumber NVARCHAR(15) NULL,
MaxPrice MONEY NULL,
AccountID AS 'ID' + AccountNumber;

--b)
CREATE TABLE #Address (
ID INT NOT NULL PRIMARY KEY,
AddressID INT NOT NULL,
AddressLine1 NVARCHAR(60) NOT NULL,
AddressLine2 NVARCHAR(60) NULL,
City NVARCHAR(30) NOT NULL,
StateProvinceID INT NOT NULL,
PostalCode NVARCHAR(15) NOT NULL,
ModifiedDate DATETIME NOT NULL,
AccountNumber NVARCHAR(15),
MaxPrice MONEY
);

--ñ)
WITH MaxPrice_CTE (BusinessEntityID, MaxPrice) AS (
SELECT ProdVend.BusinessEntityID,	
MAX(ProdVend.StandardPrice) AS MaxPrice
FROM Purchasing.ProductVendor ProdVend
GROUP BY ProdVend.BusinessEntityID
)
INSERT INTO #Address (
ID,
AddressID,
AddressLine1,
AddressLine2,
City,
StateProvinceID,
PostalCode,
ModifiedDate,
AccountNumber,
MaxPrice
) SELECT
Addr.ID,
Addr.AddressID,
Addr.AddressLine1,
Addr.AddressLine2,
Addr.City,
Addr.StateProvinceID,
Addr.PostalCode,
Addr.ModifiedDate,
Vend.AccountNumber, 
Price.MaxPrice    
FROM Anna_Zhurok.dbo.Address AS Addr
INNER JOIN Person.BusinessEntityAddress AS BusAddr 
ON BusAddr.AddressID = Addr.AddressID
INNER JOIN Purchasing.Vendor AS Vend 
ON BusAddr.BusinessEntityID = Vend.BusinessEntityID
INNER JOIN MaxPrice_CTE AS Price 
ON Vend.BusinessEntityID = Price.BusinessEntityID;

-- d)
DELETE FROM Anna_Zhurok.dbo.Address
WHERE ID = 293;

-- e)
MERGE Anna_Zhurok.dbo.Address AS TARGET
USING #Address AS SOURSE
ON (TARGET.ID = SOURSE.ID)
WHEN MATCHED THEN
UPDATE 
SET 
TARGET.AccountNumber = SOURSE.AccountNumber,
TARGET.MaxPrice = SOURSE.MaxPrice
WHEN NOT MATCHED BY TARGET THEN
INSERT
(
AddressID,
AddressLine1,
AddressLine2,
City,
StateProvinceID,
PostalCode,
ModifiedDate,
AccountNumber,
MaxPrice
)
VALUES
(
SOURSE.AddressID,
SOURSE.AddressLine1,
SOURSE.AddressLine2,
SOURSE.City,
SOURSE.StateProvinceID,
SOURSE.PostalCode,
SOURSE.ModifiedDate,
SOURSE.AccountNumber,
SOURSE.MaxPrice
)
WHEN NOT MATCHED BY SOURCE THEN 
DELETE;

