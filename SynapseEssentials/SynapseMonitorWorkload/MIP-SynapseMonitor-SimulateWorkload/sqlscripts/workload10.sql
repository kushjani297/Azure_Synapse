-------------------invalidate replicated table------------------

--just an update, no data change actually - this still invalidated the replicated copy
update [synmon].[dimDate_RPL] set [DayofMonth] = [DayofMonth] where DateID = 20000101


--Check the REPL table status for dimDate (will take a few seconds to cache)
SELECT	o.[name] AS TableName,
	rcs.[state]
FROM sys.pdw_replicated_table_cache_state rcs
INNER JOIN sys.objects o
	ON rcs.object_id = o.object_id
WHERE o.[name] = 'dimDate_RPL';


--[synmon].[dimDate_RPL] is not cached at this point
SELECT *
FROM [synmon].[fctTrip_RR] rr
	INNER JOIN [synmon].[dimDate_RPL] d
	ON rr.DateID = d.DateID
WHERE d.DateID between '20130301' and '20130331';
--15 seconds


SELECT *
FROM [synmon].[fctTrip_RR] rr
	INNER JOIN [synmon].[dimDate_RR] d
	ON rr.DateID = d.DateID
WHERE d.DateID between '20130301' and '20130331';
--16 seconds


--Check the REPL table status for dimDate (will take a few seconds to cache)
SELECT	o.[name] AS TableName,
	rcs.[state]
FROM sys.pdw_replicated_table_cache_state rcs
INNER JOIN sys.objects o
	ON rcs.object_id = o.object_id
WHERE o.[name] = 'dimDate_RPL';


--[synmon].[dimDate_RPL] should be cached at this point
SELECT *
FROM [synmon].[fctTrip_HackneyLicenseID] rr
	INNER JOIN [synmon].[dimDate_RPL] d
	ON rr.DateID = d.DateID
WHERE d.DateID between '20130301' and '20130331';


--[synmon].[dimDate_RPL] should be cached at this point
SELECT *
FROM [synmon].[fctTrip_MedallionID] rr
	INNER JOIN [synmon].[dimDate_RPL] d
	ON rr.DateID = d.DateID
WHERE d.DateID between '20130301' and '20130331';


