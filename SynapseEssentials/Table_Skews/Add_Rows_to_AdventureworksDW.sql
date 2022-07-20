/*
This Sample Code is provided for the purpose of illustration only and is not intended to be used in a production environment.  THIS SAMPLE CODE AND ANY RELATED INFORMATION ARE PROVIDED "AS IS" WITHOUT WARRANTY OF ANY KIND, EITHER EXPRESSED OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE IMPLIED WARRANTIES OF MERCHANTABILITY AND/OR FITNESS FOR A PARTICULAR PURPOSE.  We grant You a nonexclusive, royalty-free right to use and modify the Sample Code and to reproduce and distribute the object code form of the Sample Code, provided that You agree: (i) to not use Our name, logo, or trademarks to market Your software product in which the Sample Code is embedded; (ii) to include a valid copyright notice on Your software product in which the Sample Code is embedded; and (iii) to indemnify, hold harmless, and defend Us and Our suppliers from and against any claims or lawsuits, including attorneys? fees, that arise or result from the use or distribution of the Sample Code.
Please note: None of the conditions outlined in the disclaimer above will supercede the terms and conditions contained within the Premier Customer Services Description.
*/


SET NOCOUNT ON

--First Create a Numbers table with 100k rows
IF OBJECT_ID('dbo.Nums') is not null
		DROP TABLE dbo.Nums;
GO
		
CREATE TABLE dbo.Nums
WITH
(
	DISTRIBUTION = REPLICATE,
	CLUSTERED COLUMNSTORE INDEX
)
AS
  SELECT TOP (100000) ROW_NUMBER() OVER (ORDER BY s1.[object_id]) - 1 as Number
  FROM sys.all_columns AS s1
  CROSS JOIN sys.all_columns AS s2;
GO



--Now we use a CTAS comand to create a new Product dimension with about 670k products 
IF OBJECT_ID('DimProductBig') is not null
		DROP TABLE DimProductBig;
GO	 

CREATE TABLE dbo.DimProductBig
WITH
(DISTRIBUTION = HASH(Productkey),
CLUSTERED COLUMNSTORE INDEX
)
AS
SELECT [ProductKey] + (a.number * 10000) AS ProductKey
      ,[ProductAlternateKey] + CONVERT(varchar,a.number * 1000) as ProductAlternateKey
      ,[ProductSubcategoryKey]
      ,[WeightUnitMeasureCode]
      ,[SizeUnitMeasureCode]
      ,[EnglishProductName]+ CONVERT(VARCHAR, (a.number * 1000)) AS EnglishProductName
      ,[SpanishProductName]
      ,[FrenchProductName]
      ,[StandardCost]
      ,[FinishedGoodsFlag]
      ,[Color]
      ,[SafetyStockLevel]
      ,[ReorderPoint]
      ,[ListPrice]
      ,[Size]
      ,[SizeRange]
      ,[Weight]
      ,[DaysToManufacture]
      ,[ProductLine]
      ,[DealerPrice]
      ,[Class]
      ,[Style]
      ,[ModelName]
      ,[EnglishDescription]
      ,[FrenchDescription]
      ,[ChineseDescription]
      ,[ArabicDescription]
      ,[HebrewDescription]
      ,[ThaiDescription]
	  ,[GermanDescription] 
	  ,[TurkishDescription]
	  ,[JapaneseDescription]
      ,[StartDate]
      ,[EndDate]
      ,p.[Status]
  FROM [dbo].[DimProduct] p
CROSS JOIN dbo.Nums AS a
WHERE a.number BETWEEN 0 AND 3000;
GO

--Now we blow up the factinternetSales table to 180M 
IF OBJECT_ID('FactInternetSalesBig') is not null
		DROP TABLE dbo.FactInternetSalesBig;
GO		 

CREATE TABLE dbo.FactInternetSalesBig
WITH
(DISTRIBUTION = HASH(SalesOrderNumber),
CLUSTERED COLUMNSTORE INDEX
)
AS
SELECT rs.[ProductKey] + (a.number * 10000 ) AS ProductKey
      ,[OrderDateKey]
      ,[DueDateKey]
      ,[ShipDateKey]
      ,[CustomerKey]
      ,[PromotionKey]
      ,[CurrencyKey]
      ,[SalesTerritoryKey]
      ,[SalesOrderNumber]
      ,[SalesOrderLineNumber]
      ,[RevisionNumber]
      ,[OrderQuantity]
      ,[UnitPrice]
      ,[ExtendedAmount]
      ,[UnitPriceDiscountPct]
      ,[DiscountAmount]
      ,[ProductStandardCost]
      ,[TotalProductCost]
      ,[SalesAmount]
      ,[TaxAmt]
      ,[Freight]
      ,[CarrierTrackingNumber]
      ,[CustomerPONumber]
  FROM ([dbo].[FactInternetSales] rs 
CROSS JOIN dbo.Nums AS a)
 JOIN dbo.dimProductbig p
  ON rs.Productkey = p.ProductKey
WHERE a.number BETWEEN 0 AND 21000;
GO

-- Same for FactResellerSales (ca 66M rows)
IF OBJECT_ID('FactResellerSalesBig') is not null
		DROP TABLE dbo.FactResellerSalesBig;
GO

CREATE TABLE dbo.FactResellerSalesBig
WITH
(DISTRIBUTION = HASH(Productkey),
CLUSTERED COLUMNSTORE INDEX
)
AS
SELECT rs.[ProductKey]  + (a.number * 10000 ) AS ProductKey
      ,[OrderDateKey]
      ,[DueDateKey]
      ,[ShipDateKey]
      ,[ResellerKey]
      ,[EmployeeKey]
      ,[PromotionKey]
      ,[CurrencyKey]
      ,[SalesTerritoryKey]
      ,[SalesOrderNumber]
      ,[SalesOrderLineNumber]
      ,[RevisionNumber]
      ,[OrderQuantity]
      ,[UnitPrice]
      ,[ExtendedAmount]
      ,[UnitPriceDiscountPct]
      ,[DiscountAmount]
      ,[ProductStandardCost]
      ,[TotalProductCost]
      ,[SalesAmount]
      ,[TaxAmt]
      ,[Freight]
      ,[CarrierTrackingNumber]
      ,[CustomerPONumber]
       FROM ([dbo].[FactResellerSales] rs 
CROSS JOIN dbo.Nums AS a)
 JOIN dbo.dimProductbig p
  ON rs.Productkey = p.ProductKey
WHERE a.number BETWEEN 0 AND 16000;
GO




-- Drop the old tables and rename the new ones
DROP TABLE [dbo].[FactInternetSales];
GO
DROP TABLE [dbo].[FactResellerSales];
GO
DROP TABLE [dbo].[DimProduct];
GO


RENAME OBJECT dbo.DimProductBig TO DimProduct;
GO
RENAME OBJECT dbo.FactInternetSalesBig TO FactInternetSales;
GO
RENAME OBJECT dbo.FactResellerSalesBig TO FactResellerSales;
GO

select count(*) from dbo.FactInternetSales
select count(*) from dbo.FactResellerSales;

