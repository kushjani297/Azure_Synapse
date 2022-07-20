/*
	M03 Design for Performance
	L02 Table Geometries

Pre-requisite:
	Compile vSkew

	
NOTE
	Visual Studio must be used in order to open the EXPLAIN plan output.
	If using SSMS, use the Estimated Query Plan button instead. 
*/


-- a. Cleanup
IF OBJECT_ID('dimDate') IS NOT NULL    DROP TABLE [dimDate]
IF OBJECT_ID('fctTrip') IS NOT NULL    DROP TABLE [fctTrip]
IF OBJECT_ID('fctTrip_RR') IS NOT NULL DROP TABLE [fctTrip_RR]


-- b. Create tables - REPLICATED / HASH DISTRIBUTED / ROUND-ROBIN DISTRIBUTED
CREATE TABLE [dimDate]
WITH
	(DISTRIBUTION = REPLICATE,
	 CLUSTERED INDEX (DateID) )
AS
SELECT *
	FROM [dbo].[Date]

CREATE TABLE [fctTrip]
WITH
	(DISTRIBUTION = HASH(DateID),
	 CLUSTERED COLUMNSTORE INDEX )
AS
SELECT *
	FROM [dbo].[Trip]

CREATE TABLE [fctTrip_RR]
WITH
	(DISTRIBUTION = ROUND_ROBIN,
	 CLUSTERED COLUMNSTORE INDEX )
AS
SELECT *
	FROM [dbo].[Trip]


-- c. Refresh Object Explorer - show new tables added, different icons by geometry


-- d. Show table details & Skew
--    Show 60 Distributions
DBCC PDW_SHOWSPACEUSED ('dbo.fctTrip')
SELECT * FROM vSkew where table_name = 'fctTrip'

DBCC PDW_SHOWSPACEUSED ('dbo.fctTrip_RR');
SELECT * FROM vSkew where table_name = 'fctTrip_RR'


-- e. Check the REPL table status for dimDate
SELECT	o.[name] AS TableName,
		rcs.[state]
	FROM sys.pdw_replicated_table_cache_state rcs
		INNER JOIN sys.objects o
			ON rcs.object_id = o.object_id
WHERE o.[name] = 'dimDate'


-- f. Cache the dimDate table
SELECT top 1 *
FROM dimDate


-- g. Check the REPL table status for dimDate (will take a few seconds to cache)
SELECT	o.[name] AS TableName,
		rcs.[state]
	FROM sys.pdw_replicated_table_cache_state rcs
		INNER JOIN sys.objects o
			ON rcs.object_id = o.object_id
WHERE o.[name] = 'dimDate'


-- z. Cleanup
IF OBJECT_ID('dimDate') IS NOT NULL    DROP TABLE [dimDate]
IF OBJECT_ID('fctTrip') IS NOT NULL    DROP TABLE [fctTrip]
IF OBJECT_ID('fctTrip_RR') IS NOT NULL DROP TABLE [fctTrip_RR]
