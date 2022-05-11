--In SQL Server Management Studio, right click on the Synapse SQL instance
--and click New Query.

--Type in the following statement that assigns LargeRC resource class
--and a CONTROL permission for the SQL user that were created in previous lab exercise. 
--Replace jdsqlpool below with the actual name of your Synapse SQL instance.

EXEC sp_addrolemember 'largerc', 'DWLoader';
GRANT CONTROL ON DATABASE::[jdsqlpool] to DWLoader;


--Before loading data to Synapse SQL Pool, it is a best practice to always 
--start with large Data Warehouse Units (DWU) for optimal parallelism. 
--Connect to the master database in your Synapse SQL using SQLAdmin login 
--and open a New Query. Execute the following statement over the master database. 
--The statement will scale out the Synapse SQL Pool to DWU1000.

ALTER DATABASE jdsqlpool
MODIFY (SERVICE_OBJECTIVE = 'DW1000c');

--Run the following statement to monitor the scale out progress. It could typically take 3-5 minutes. 
--Replace with the value for major_resource_id with the Synapse SQL instance name.

WHILE
(
SELECT TOP 1 state_desc
FROM sys.dm_operation_status
WHERE 1=1
	AND resource_type_desc = 'Database'
	AND major_resource_id = 'jdsqlpool'
	AND operation = 'ALTER DATABASE'
ORDER BY
	start_time DESC
) = 'IN PROGRESS'
BEGIN
	RAISERROR('Scale operation in progress' 0,0) WITH NOWAIT;
	WAITFOR DELAY '00:00:05';
END
PRINT 'COMPLETE'

