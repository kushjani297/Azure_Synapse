DECLARE @Label		VARCHAR(64) = 'MV Query' -- The label value from the previous query

DECLARE @QID		VARCHAR(64)
SELECT @QID = MAX(request_id)
FROM sys.dm_pdw_exec_requests er
WHERE er.[label] = @Label 
 AND  er.[command] NOT LIKE '%sys.dm_pdw_exec_requests%' -- Dont return this query

-- EXEC_REQUESTS
SELECT *
FROM sys.dm_pdw_exec_requests
WHERE request_id = @QID

-- REQUEST_STEPS
SELECT *
FROM sys.dm_pdw_request_steps
WHERE request_id = @QID
