--Create Hash distributed table on Payment_type column
--There are only 4 unique values for Payment_type in the .csv file. 
--The .csv file is being referenced through the external table [NYTaxiSTG].[Trips]
CREATE TABLE [NYCTaxi].[TripsHash]
WITH
(
	HEAP,
    DISTRIBUTION = HASH([Payment_type])
)
AS SELECT * FROM [NYTaxiSTG].[Trips]
OPTION (LABEL = 'CTAS:HashPaymentType');

--Table row count
SELECT COUNT (*) FROM [NYCTaxi].[TripsHash]

--Validate that there are only 4 unique values for Payment_type column
SELECT DISTINCT [Payment_type] FROM [NYCTaxi].[TripsHash]

Select * 
FROM sys.dm_pdw_dms_workers dw
JOIN sys.dm_pdw_exec_requests r 
ON r.request_id = dw.request_id
WHERE r.[label] = 'CTAS:HashPaymentType'


Select * 
FROM sys.dm_pdw_dms_workers dw
JOIN sys.dm_pdw_exec_requests r 
ON r.request_id = dw.request_id
WHERE r.[label] = 'CTAS:HashPaymentType'
and type = 'WRITER' and bytes_processed <> 0


ALTER DATABASE synapsededsqlpo
MODIFY (SERVICE_OBJECTIVE = 'DW100c');









