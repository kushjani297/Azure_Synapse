DECLARE @Label		VARCHAR(64) = 'Skewed Data Query' -- The label value from the previous query

DECLARE @QID		VARCHAR(64)
SELECT @QID = MAX(request_id)
FROM sys.dm_pdw_exec_requests
WHERE [label] = @Label 
 AND  [command] NOT LIKE '%sys.dm_pdw_exec_requests%' -- Dont return this query

-- EXEC_REQUESTS
SELECT *
FROM sys.dm_pdw_exec_requests 
WHERE request_id = @QID

-- REQUEST_STEPS
SELECT *
FROM sys.dm_pdw_request_steps
WHERE request_id = @QID

-- DMS Workers
SELECT *
FROM sys.dm_pdw_dms_workers
WHERE request_id = @QID
 AND  step_index = 2
ORDER BY [type], distribution_id


DBCC PDW_SHOWSPACEUSED ('Trip_MedallionID_Skewed');



