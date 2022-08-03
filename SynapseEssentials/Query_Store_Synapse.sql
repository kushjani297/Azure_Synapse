ALTER DATABASE JDSQLPOOL SET QUERY_STORE = ON;
GO


--Copy & Paste to new window to Execute
SELECT  A.PassengerCount,
      SUM(A.TripDistanceMiles+B.TripDistanceMiles) as SumTripDistance,
      AVG(A.TripDistanceMiles+B.TripDistanceMiles) as AvgTripDistance
FROM  dbo.Trip A, dbo.Trip B 
WHERE A.TripDistanceMiles > 0 AND A.PassengerCount > 0
GROUP BY A.PassengerCount
ORDER BY A.PassengerCount

--Once all the queries have been completed open a New query and paste this code, 
--then press execute. Explain the QS shows the entire command
SELECT q.query_id, t.query_sql_text
FROM sys.query_store_query AS q
	JOIN sys.query_store_query_text AS t 
		ON q.query_text_id = t.query_text_id;

--Top 20 most executed queries in your Sql pool

SELECT TOP 20
	q.query_id AS [query_id],
	t.query_sql_text AS [command],
	SUM(rs.count_executions) AS [execution_count]
FROM sys.query_store_query AS q
	INNER JOIN sys.query_store_query_text AS t 
		ON q.query_text_id = t.query_text_id
	INNER JOIN sys.query_store_plan AS p 
		ON p.query_id = q.query_id
	INNER JOIN sys.query_store_runtime_stats AS rs 
		ON rs.plan_id = p.plan_id
GROUP BY q.query_id , t.query_sql_text 
ORDER BY [execution_count] DESC;

--Information about Avg, min and max duration 
SELECT q.query_id  AS [query_id],
       t.query_sql_text AS [command],
       rs.avg_duration  AS [avg_duration],
       rs.min_duration  AS [min_duration],
       rs.max_duration  AS [max_duration]
FROM   sys.query_store_query AS q
	JOIN sys.query_store_query_text AS t 
		ON q.query_text_id = t.query_text_id
	JOIN sys.query_store_plan AS p 
		ON p.query_id = q.query_id
	JOIN sys.query_store_runtime_stats AS rs 
		ON rs.plan_id = p.plan_id



