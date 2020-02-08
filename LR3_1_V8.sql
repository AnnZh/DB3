USE Anna_Zhurok
GO

-- a)
ALTER TABLE Anna_Zhurok.dbo.Address 
ADD PersonName NVARCHAR(100);

-- b)
DECLARE @addressVariable TABLE
(
AddressID INT NOT NULL PRIMARY KEY,
AddressLine1 NVARCHAR(60) NOT NULL,
AddressLine2 NVARCHAR(60) NOT NULL,
City NVARCHAR(30) NOT NULL,
StateProvinceID INT NOT NULL,
PostalCode NVARCHAR(15) NOT NULL,
ModifiedDate DATETIME NOT NULL,
ID INT NOT NULL UNIQUE,
PersonName NVARCHAR(100) NULL
);

INSERT INTO @addressVariable
(
AddressID,
AddressLine1,
AddressLine2,
City,
StateProvinceID,
PostalCode,
ModifiedDate,
ID,
PersonName
)
SELECT
Addr.AddressID,
Addr.AddressLine1,
Region.CountryRegionCode + ', ' + Province.Name + ', ' + Addr.City,
Addr.City,
Addr.StateProvinceID,
Addr.PostalCode,
Addr.ModifiedDate,
Addr.ID,
Addr.PersonName
FROM Anna_Zhurok.dbo.Address AS Addr
INNER JOIN AdventureWorks2012.Person.StateProvince AS Province
ON Addr.StateProvinceID = Province.StateProvinceID
INNER JOIN AdventureWorks2012.Person.CountryRegion AS Region
ON Region.CountryRegionCode = Province.CountryRegionCode
WHERE
addr.StateProvinceID = 77

-- c)
UPDATE Anna_Zhurok.dbo.Address
SET
Anna_Zhurok.dbo.Address.AddressLine2 = Variable.AddressLine2,
Anna_Zhurok.dbo.Address.PersonName = Pers.FirstName + ' ' + Pers.LastName
FROM @addressVariable AS Variable
INNER JOIN AdventureWorks2012.Person.BusinessEntityAddress AS Business
ON Business.AddressID = Variable.AddressID
INNER JOIN AdventureWorks2012.Person.Person AS Pers
ON Pers.BusinessEntityID = Business.BusinessEntityID;

-- d)
DELETE Anna_Zhurok.dbo.Address
FROM Anna_Zhurok.dbo.Address AS Addr
INNER JOIN AdventureWorks2012.Person.BusinessEntityAddress AS Business
ON Business.AddressID = Addr.AddressID
INNER JOIN AdventureWorks2012.Person.AddressType AS AddrType
ON AddrType.AddressTypeID = Business.AddressTypeID
WHERE AddrType.Name = 'Main Office'

--e)
ALTER TABLE Anna_Zhurok.dbo.Address 
DROP COLUMN PersonName;

SELECT Anna_Zhurok.INFORMATION_SCHEMA.CONSTRAINT_TABLE_USAGE.CONSTRAINT_NAME 
FROM Anna_Zhurok.INFORMATION_SCHEMA.CONSTRAINT_TABLE_USAGE
WHERE TABLE_SCHEMA = 'dbo' AND TABLE_NAME = 'Address';

SELECT def_constr.name
FROM Anna_Zhurok.sys.default_constraints AS def_constr
INNER JOIN Anna_Zhurok.sys.objects AS Obj
ON def_constr.parent_object_id = Obj.object_id 
WHERE schema_name(Obj.schema_id) + '.' + Obj.name = 'dbo.Address';

ALTER TABLE Anna_Zhurok.dbo.Address
DROP CONSTRAINT
PK__Address__091C2A1BAB7C59D1,
UQ__Address__3214EC2662E77E5E,
CH_Address_StateProvinceID,
DF_Address_AddressLine2;

--f)
DROP TABLE Anna_Zhurok.dbo.Address;
