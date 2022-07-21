
--Copy & Paste to new window to Execute
SELECT  A.PassengerCount,
      SUM(A.TripDistanceMiles+B.TripDistanceMiles) as SumTripDistance,
      AVG(A.TripDistanceMiles+B.TripDistanceMiles) as AvgTripDistance
FROM  dbo.Trip A, dbo.Trip B 
WHERE A.TripDistanceMiles > 0 AND A.PassengerCount > 0
GROUP BY A.PassengerCount
ORDER BY A.PassengerCount

--John run this view... NOW!
SELECT * FROM sys.dm_pdw_exec_requests
WHERE status = 'Running'


--sys.dm_pdw_exec_requests
----sys.dm_pdw_request_steps
------sys.dm_pdw_sql_requests
------sys.dm_pdw_dms_workers

SELECT * from sys.dm_pdw_request_steps
WHERE request_id = 'QID2320'

SELECT * FROM sys.dm_pdw_sql_requests
WHERE request_id = 'QID2320'
AND step_index = 5

SELECT * FROM sys.dm_pdw_dms_workers
WHERE request_id = 'QID2320'
AND step_index = 2


SELECT C.client_id
		,S.login_name
		,S.app_name
		,R.session_id
		,R.request_id
		,R.status
		,R.submit_time
		,R.start_time
		,R.end_compile_time
		,R.end_time
		,R.total_elapsed_time
		,R.Command
		,R.importance
		,R.resource_class
FROM sys.dm_pdw_exec_requests R
	INNER JOIN sys.dm_pdw_exec_sessions S
		ON S.session_id = R.session_id
	INNER JOIN sys.dm_pdw_exec_connections C
		ON c.session_id = S.session_id
WHERE R.status = 'running'