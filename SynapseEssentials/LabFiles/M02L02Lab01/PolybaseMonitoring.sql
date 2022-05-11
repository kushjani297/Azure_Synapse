 SELECT DISTINCT ew.*, r.command
FROM[sys].[dm_pdw_dms_external_work] ew 
JOIN sys.dm_pdw_exec_requests r 
ON r.request_id = ew.request_id
JOIN Sys.dm_pdw_request_steps s
ON r.request_id = s.request_id
WHERE r.[label] = 'Trips:PolybaseIncrementalLoad'
ORDER BY  input_name, dms_step_index