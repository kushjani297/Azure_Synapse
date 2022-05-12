/*
Setup script - Assuming you have Synapse dedicated sql pool provisioned 
*/
print '-----------The whole setup process may take 12-15 mins-----------'

print 'UTC: ' + cast(getdate() as varchar(30))
print 'creating schema, users and tables...'


IF OBJECT_ID(N'[synmon].[Date]') IS NOT NULL DROP TABLE [synmon].[Date];
IF OBJECT_ID(N'[synmon].[Geography]') IS NOT NULL DROP TABLE [synmon].[Geography];
IF OBJECT_ID(N'[synmon].[HackneyLicense]') IS NOT NULL DROP TABLE [synmon].[HackneyLicense];
IF OBJECT_ID(N'[synmon].[Medallion]') IS NOT NULL DROP TABLE [synmon].[Medallion];
IF OBJECT_ID(N'[synmon].[Time]') IS NOT NULL DROP TABLE [synmon].[Time];
IF OBJECT_ID(N'[synmon].[Trip]') IS NOT NULL DROP TABLE [synmon].[Trip];
IF OBJECT_ID(N'[synmon].[Weather]') IS NOT NULL DROP TABLE [synmon].[Weather];

IF OBJECT_ID(N'synmon.dimDate_RR') IS NOT NULL DROP TABLE [synmon].[dimDate_RR];
IF OBJECT_ID(N'synmon.dimDate_RPL') IS NOT NULL DROP TABLE [synmon].[dimDate_RPL];
IF OBJECT_ID(N'synmon.fctTrip') IS NOT NULL DROP TABLE [synmon].[fctTrip];
IF OBJECT_ID(N'synmon.fctTrip_RR') IS NOT NULL DROP TABLE [synmon].[fctTrip_RR];
IF OBJECT_ID(N'synmon.fctTrip_HackneyLicenseID') IS NOT NULL DROP TABLE [synmon].[fctTrip_HackneyLicenseID];
IF OBJECT_ID(N'synmon.fctTrip_MedallionID') IS NOT NULL DROP TABLE [synmon].[fctTrip_MedallionID];
IF OBJECT_ID(N'synmon.fctTrip_MedallionID_BIGINT') IS NOT NULL DROP TABLE [synmon].[fctTrip_MedallionID_BIGINT];

IF EXISTS(SELECT * FROM sys.schemas WHERE NAME = 'synmon')
	DROP SCHEMA synmon;
IF EXISTS(SELECT * FROM sys.schemas WHERE NAME = 'synmonext')
	DROP SCHEMA synmonext;
GO

IF EXISTS(SELECT * FROM sys.database_principals WHERE NAME = 'synmonNormalUser')
	DROP USER synmonNormalUser;
IF EXISTS(SELECT * FROM sys.database_principals WHERE NAME = 'synmonProcessUser')
	DROP USER synmonProcessUser;
IF EXISTS(SELECT * FROM sys.database_principals WHERE NAME = 'synmonReportUser')
	DROP USER synmonReportUser;


CREATE USER synmonNormalUser WITHOUT LOGIN;
CREATE USER synmonProcessUser WITHOUT LOGIN;
CREATE USER synmonReportUser WITHOUT LOGIN;
GO

EXEC sp_addrolemember 'db_owner', synmonNormalUser;
EXEC sp_addrolemember 'db_owner', synmonProcessUser;
EXEC sp_addrolemember 'db_owner', synmonReportUser;

EXEC sp_addrolemember 'mediumrc', synmonProcessUser;
EXEC sp_addrolemember 'largerc', synmonProcessUser;
GO

create schema synmon;
GO
create schema synmonext;
GO


------------------setp #1 - create/populate small tables using smallrc user----------------------
EXECUTE AS User = 'synmonNormalUser'; 

CREATE TABLE [synmon].[Date]
(
    [DateID] int NOT NULL,
    [Date] datetime NULL,
    [DateBKey] char(10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
    [DayOfMonth] varchar(2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
    [DaySuffix] varchar(4) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
    [DayName] varchar(9) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
    [DayOfWeek] char(1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
    [DayOfWeekInMonth] varchar(2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
    [DayOfWeekInYear] varchar(2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
    [DayOfQuarter] varchar(3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
    [DayOfYear] varchar(3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
    [WeekOfMonth] varchar(1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
    [WeekOfQuarter] varchar(2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
    [WeekOfYear] varchar(2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
    [Month] varchar(2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
    [MonthName] varchar(9) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
    [MonthOfQuarter] varchar(2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
    [Quarter] char(1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
    [QuarterName] varchar(9) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
    [Year] char(4) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
    [YearName] char(7) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
    [MonthYear] char(10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
    [MMYYYY] char(6) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
    [FirstDayOfMonth] date NULL,
    [LastDayOfMonth] date NULL,
    [FirstDayOfQuarter] date NULL,
    [LastDayOfQuarter] date NULL,
    [FirstDayOfYear] date NULL,
    [LastDayOfYear] date NULL,
    [IsHolidayUSA] bit NULL,
    [IsWeekday] bit NULL,
    [HolidayUSA] varchar(50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
)
WITH
(
    DISTRIBUTION = ROUND_ROBIN,
    CLUSTERED COLUMNSTORE INDEX
);

CREATE TABLE [synmon].[Geography]
(
    [GeographyID] int NOT NULL,
    [ZipCodeBKey] varchar(10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
    [County] varchar(50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
    [City] varchar(50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
    [State] varchar(50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
    [Country] varchar(50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
    [ZipCode] varchar(50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
)
WITH
(
    DISTRIBUTION = ROUND_ROBIN,
    CLUSTERED COLUMNSTORE INDEX
);

CREATE TABLE [synmon].[HackneyLicense]
(
    [HackneyLicenseID] int NOT NULL,
    [HackneyLicenseBKey] varchar(50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
    [HackneyLicenseCode] varchar(50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
)
WITH
(
    DISTRIBUTION = ROUND_ROBIN,
    CLUSTERED COLUMNSTORE INDEX
);

CREATE TABLE [synmon].[Medallion]
(
    [MedallionID] int NOT NULL,
    [MedallionBKey] varchar(50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
    [MedallionCode] varchar(50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
)
WITH
(
    DISTRIBUTION = ROUND_ROBIN,
    CLUSTERED COLUMNSTORE INDEX
);

CREATE TABLE [synmon].[Time]
(
    [TimeID] int NOT NULL,
    [TimeBKey] varchar(8) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
    [HourNumber] tinyint NOT NULL,
    [MinuteNumber] tinyint NOT NULL,
    [SecondNumber] tinyint NOT NULL,
    [TimeInSecond] int NOT NULL,
    [HourlyBucket] varchar(15) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
    [DayTimeBucketGroupKey] int NOT NULL,
    [DayTimeBucket] varchar(100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
)
WITH
(
    DISTRIBUTION = ROUND_ROBIN,
    CLUSTERED COLUMNSTORE INDEX
);

CREATE TABLE [synmon].[Trip]
(
    [DateID] int NOT NULL,
    [MedallionID] int NOT NULL,
    [HackneyLicenseID] int NOT NULL,
    [PickupTimeID] int NOT NULL,
    [DropoffTimeID] int NOT NULL,
    [PickupGeographyID] int NULL,
    [DropoffGeographyID] int NULL,
    [PickupLatitude] float NULL,
    [PickupLongitude] float NULL,
    [PickupLatLong] varchar(50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
    [DropoffLatitude] float NULL,
    [DropoffLongitude] float NULL,
    [DropoffLatLong] varchar(50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
    [PassengerCount] int NULL,
    [TripDurationSeconds] int NULL,
    [TripDistanceMiles] float NULL,
    [PaymentType] varchar(50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
    [FareAmount] money NULL,
    [SurchargeAmount] money NULL,
    [TaxAmount] money NULL,
    [TipAmount] money NULL,
    [TollsAmount] money NULL,
    [TotalAmount] money NULL
)
WITH
(
    DISTRIBUTION = ROUND_ROBIN,
    CLUSTERED COLUMNSTORE INDEX
);

CREATE TABLE [synmon].[Weather]
(
    [DateID] int NOT NULL,
    [GeographyID] int NOT NULL,
    [PrecipitationInches] float NOT NULL,
    [AvgTemperatureFahrenheit] float NOT NULL
)
WITH
(
    DISTRIBUTION = ROUND_ROBIN,
    CLUSTERED COLUMNSTORE INDEX
);


-----------------pupolate data from public storage----------------


COPY INTO [synmon].[Date]
FROM 'https://nytaxiblob.blob.core.windows.net/2013/Date'
WITH
(
    FILE_TYPE = 'CSV',
	FIELDTERMINATOR = ',',
	FIELDQUOTE = ''
)
OPTION (LABEL = 'COPY : Load [synmon].[Date] - Taxi dataset');


COPY INTO [synmon].[Geography]
FROM 'https://nytaxiblob.blob.core.windows.net/2013/Geography'
WITH
(
    FILE_TYPE = 'CSV',
	FIELDTERMINATOR = ',',
	FIELDQUOTE = ''
)
OPTION (LABEL = 'COPY : Load [synmon].[Geography] - Taxi dataset');

COPY INTO [synmon].[HackneyLicense]
FROM 'https://nytaxiblob.blob.core.windows.net/2013/HackneyLicense'
WITH
(
    FILE_TYPE = 'CSV',
	FIELDTERMINATOR = ',',
	FIELDQUOTE = ''
)
OPTION (LABEL = 'COPY : Load [synmon].[HackneyLicense] - Taxi dataset');

COPY INTO [synmon].[Medallion]
FROM 'https://nytaxiblob.blob.core.windows.net/2013/Medallion'
WITH
(
    FILE_TYPE = 'CSV',
	FIELDTERMINATOR = ',',
	FIELDQUOTE = ''
)
OPTION (LABEL = 'COPY : Load [synmon].[Medallion] - Taxi dataset');

COPY INTO [synmon].[Time]
FROM 'https://nytaxiblob.blob.core.windows.net/2013/Time'
WITH
(
    FILE_TYPE = 'CSV',
	FIELDTERMINATOR = ',',
	FIELDQUOTE = ''
)
OPTION (LABEL = 'COPY : Load [synmon].[Time] - Taxi dataset');

COPY INTO [synmon].[Weather]
FROM 'https://nytaxiblob.blob.core.windows.net/2013/Weather'
WITH
(
    FILE_TYPE = 'CSV',
	FIELDTERMINATOR = ',',
	FIELDQUOTE = '',
	ROWTERMINATOR='0X0A'
)
OPTION (LABEL = 'COPY : Load [synmon].[Weather] - Taxi dataset');

REVERT;


--------------------populate large table using largerc user------------------
print 'UTC: ' + cast(getdate() as varchar(30))
print 'populating a large table (this step may take 10-11 mins....please be patient...)'


EXECUTE AS User = 'synmonProcessUser'; 

COPY INTO [synmon].[Trip]
FROM 'https://nytaxiblob.blob.core.windows.net/2013/Trip2013'
WITH
(
    FILE_TYPE = 'CSV',
	FIELDTERMINATOR = '|',
	FIELDQUOTE = '',
	ROWTERMINATOR='0X0A',
	COMPRESSION = 'GZIP'
)
OPTION (LABEL = 'COPY : Load [synmon].[Trip] - Taxi dataset');


REVERT; 


/*
SELECT r.[request_id], r.[status], r.resource_class, r.command, 
	sum(bytes_processed) AS bytes_processed, 
	sum(rows_processed) AS rows_processed
FROM sys.dm_pdw_exec_requests r
	INNER JOIN sys.dm_pdw_dms_workers w
		ON r.[request_id] = w.request_id
WHERE [label] IN (
	'COPY : Load [synmon].[Date] - Taxi dataset',
    'COPY : Load [synmon].[Geography] - Taxi dataset',
    'COPY : Load [synmon].[HackneyLicense] - Taxi dataset',
    'COPY : Load [synmon].[Medallion] - Taxi dataset',
    'COPY : Load [synmon].[Time] - Taxi dataset',
    'COPY : Load [synmon].[Weather] - Taxi dataset',
    'COPY : Load [synmon].[Trip] - Taxi dataset')
	AND session_id <> session_id() AND type = 'WRITER'
GROUP BY r.[request_id], r.[status], r.resource_class, r.command;


select * from  sys.dm_pdw_exec_requests
where session_id = 'SID1146'
order by submit_time desc

*/

print 'UTC: ' + cast(getdate() as varchar(30))
print 'populating other tables (this step may take 2 mins....)'


EXECUTE AS User = 'synmonProcessUser'; 

CREATE TABLE [synmon].[dimDate_RR]
WITH
	(DISTRIBUTION = ROUND_ROBIN,
	 CLUSTERED INDEX (DateID) )
AS
SELECT * FROM [synmon].[Date];


CREATE TABLE [synmon].[dimDate_RPL]
WITH
	(DISTRIBUTION = REPLICATE,
	 CLUSTERED INDEX (DateID) )
AS
SELECT * FROM [synmon].[Date];


CREATE TABLE [synmon].[fctTrip_RR]
WITH
	(DISTRIBUTION = ROUND_ROBIN,
	 CLUSTERED COLUMNSTORE INDEX )
AS
SELECT TOP (5000000) * FROM [synmon].[Trip];
--1 mins 42 seconds


CREATE TABLE [synmon].[fctTrip]
WITH
	(DISTRIBUTION = HASH(DateID),
	 CLUSTERED COLUMNSTORE INDEX )
AS
SELECT * FROM [synmon].[fctTrip_RR];
--12 seconds

CREATE TABLE [synmon].[fctTrip_HackneyLicenseID]
WITH
	(DISTRIBUTION = HASH(HackneyLicenseID),
	 CLUSTERED COLUMNSTORE INDEX )
AS
SELECT * FROM [synmon].[fctTrip_RR];
--12 seconds

CREATE TABLE [synmon].[fctTrip_MedallionID]
WITH
	(DISTRIBUTION = HASH(MedallionID),
	 CLUSTERED COLUMNSTORE INDEX )
AS
SELECT * FROM [synmon].[fctTrip_RR];
--12 seconds

CREATE TABLE [synmon].[fctTrip_MedallionID_BIGINT]
WITH
	(DISTRIBUTION = HASH(MedallionID),
	 CLUSTERED COLUMNSTORE INDEX ) AS
SELECT [DateID]
      ,CAST([MedallionID] AS BIGINT) AS [MedallionID]
      ,[HackneyLicenseID]
      ,[PickupTimeID]
      ,[DropoffTimeID]
      ,[PickupGeographyID]
      ,[DropoffGeographyID]
      ,[PickupLatitude]
      ,[PickupLongitude]
      ,[PickupLatLong]
      ,[DropoffLatitude]
      ,[DropoffLongitude]
      ,[DropoffLatLong]
      ,[PassengerCount]
      ,[TripDurationSeconds]
      ,[TripDistanceMiles]
      ,[PaymentType]
      ,[FareAmount]
      ,[SurchargeAmount]
      ,[TaxAmount]
      ,[TipAmount]
      ,[TollsAmount]
      ,[TotalAmount]
  FROM [synmon].[fctTrip_MedallionID];
  --17 seconds
  
  REVERT;

   
--create a workload group, classifier for Report Users
IF EXISTS (SELECT 1 FROM sys.workload_management_workload_classifiers WHERE name = 'synmonWLCReportUser')
	DROP WORKLOAD CLASSIFIER synmonWLCReportUser;

IF EXISTS (SELECT 1 FROM sys.workload_management_workload_groups WHERE name = 'synmonWGReportUser')
	DROP WORKLOAD GROUP synmonWGReportUser;

CREATE WORKLOAD GROUP synmonWGReportUser
WITH
(   
	MIN_PERCENTAGE_RESOURCE = 40,
	CAP_PERCENTAGE_RESOURCE = 100,
	REQUEST_MIN_RESOURCE_GRANT_PERCENT = 40
);

CREATE WORKLOAD CLASSIFIER synmonWLCReportUser
WITH (WORKLOAD_GROUP = 'synmonWGReportUser'
      ,MEMBERNAME = 'synmonReportUser'
      ,IMPORTANCE = NORMAL);

/*
SELECT * FROM sys.workload_management_workload_groups;
SELECT * FROM sys.workload_management_workload_classifiers;
*/

print 'UTC: ' + cast(getdate() as varchar(30))
print '------------------------setup completed---------------------------'


