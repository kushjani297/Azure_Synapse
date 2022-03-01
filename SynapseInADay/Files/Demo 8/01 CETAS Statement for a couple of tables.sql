CREATE schema [arc]
GO

CREATE EXTERNAL TABLE [arc].[FactSaleNov2012]
WITH
(
	LOCATION = '/FactSaleNov2012',
	DATA_SOURCE = [datasourcename],
	FILE_FORMAT = [ParquetFile]
)
AS
SELECT * FROM wwi.FactSale
WHERE InvoiceDateKey BETWEEN '2012-11-01 00:00:00.000' AND '2012-12-01 00:00:00.000'

