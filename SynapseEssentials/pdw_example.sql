SELECT * FROM sys.dm_pdw_exec_requests
WHERE status = 'Running'


--sys.dm_pdw_exec_requests
----sys.dm_pdw_request_steps
------sys.dm_pdw_sql_requests
------sys.dm_pdw_dms_workers

SELECT * from sys.dm_pdw_request_steps
WHERE request_id = 'QID7448'

SELECT * FROM sys.dm_pdw_sql_requests
WHERE request_id = 'QID7448'
AND step_index = 1

SELECT * FROM sys.dm_pdw_dms_workers
WHERE request_id = 'QID7448'
AND step_index = 2
