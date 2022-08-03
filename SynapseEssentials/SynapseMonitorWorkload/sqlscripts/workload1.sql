-------------------fast queries using largerc------------------

EXECUTE AS User = 'synmonProcessUser'; 

--Cache the dimDate table
SELECT top 1 * FROM [synmon].[dimDate_RPL];

--Check the REPL table status for dimDate (will take a few seconds to cache)
SELECT	o.[name] AS TableName,
	rcs.[state]
FROM sys.pdw_replicated_table_cache_state rcs
INNER JOIN sys.objects o
	ON rcs.object_id = o.object_id
WHERE o.[name] = 'dimDate_RPL';

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

SELECT *
FROM [synmon].[fctTrip_HackneyLicenseID] rr
	INNER JOIN [synmon].[dimDate_RPL] d
	ON rr.DateID = d.DateID
WHERE d.DateID between '20130301' and '20130331';


SELECT *
FROM [synmon].[fctTrip_HackneyLicenseID] rr
	INNER JOIN [synmon].[dimDate_RR] d
	ON rr.DateID = d.DateID
WHERE d.DateID between '20130301' and '20130331';


SELECT *
FROM [synmon].[fctTrip_MedallionID] rr
	INNER JOIN [synmon].[dimDate_RPL] d
	ON rr.DateID = d.DateID
WHERE d.DateID between '20130301' and '20130331';


SELECT *
FROM [synmon].[fctTrip_MedallionID] rr
	INNER JOIN [synmon].[dimDate_RR] d
	ON rr.DateID = d.DateID
WHERE d.DateID between '20130301' and '20130331';

REVERT;

