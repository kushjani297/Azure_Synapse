IF( object_id ('Trip_MedallionID')) IS NOT NULL	     DROP TABLE Trip_MedallionID
IF( object_id ('Trip_MedallionID_NULL')) IS NOT NULL DROP TABLE Trip_MedallionID_NULL
IF( object_id ('Trip_MedallionID_Dflt')) IS NOT NULL DROP TABLE Trip_MedallionID_Dflt
IF( object_id ('Trip_RR')) IS NOT NULL		     DROP TABLE Trip_RR
GO

-- Copy the Trip table, HASHED on MedallionID, filtered to 323,931 rows
CREATE TABLE Trip_MedallionID 
WITH
(	DISTRIBUTION = HASH ( [MedallionID] ),
	CLUSTERED COLUMNSTORE INDEX )
AS 
SELECT *
FROM [Trip]
WHERE PaymentType IN ('DIS', 'UNK')


-- Copy the filtered Trip table, HASHED on a NULLED MedallionID
CREATE TABLE Trip_MedallionID_NULL 
WITH
(	DISTRIBUTION = HASH ( [MedallionID] ),
	CLUSTERED COLUMNSTORE INDEX )
AS 
SELECT [DateID],
	CAST (NULL AS [int]) AS [MedallionID] ,
	[HackneyLicenseID],
	[PickupTimeID],
	[DropoffTimeID],
	[PickupGeographyID],
	[DropoffGeographyID],
	[PickupLatitude],
	[PickupLongitude],
	[PickupLatLong],
	[DropoffLatitude],
	[DropoffLongitude],
	[DropoffLatLong],
	[PassengerCount],
	[TripDurationSeconds],
	[TripDistanceMiles],
	[PaymentType],
	[FareAmount],
	[SurchargeAmount],
	[TaxAmount],
	[TipAmount],
	[TollsAmount],
	[TotalAmount]
FROM [Trip_MedallionID];


-- Copy the filtered Trip table, HASHED on a Default MedallionID
CREATE TABLE Trip_MedallionID_Dflt 
WITH
(	DISTRIBUTION = HASH ( [MedallionID] ),
	CLUSTERED COLUMNSTORE INDEX )
AS 
SELECT [DateID],
	CAST (99 AS [int]) AS [MedallionID] ,
	[HackneyLicenseID],
	[PickupTimeID],
	[DropoffTimeID],
	[PickupGeographyID],
	[DropoffGeographyID],
	[PickupLatitude],
	[PickupLongitude],
	[PickupLatLong],
	[DropoffLatitude],
	[DropoffLongitude],
	[DropoffLatLong],
	[PassengerCount],
	[TripDurationSeconds],
	[TripDistanceMiles],
	[PaymentType],
	[FareAmount],
	[SurchargeAmount],
	[TaxAmount],
	[TipAmount],
	[TollsAmount],
	[TotalAmount]
FROM [Trip_MedallionID];

-- Copy the Trip table, as Round_Robin distributed
CREATE TABLE Trip_RR 
WITH
(	DISTRIBUTION = ROUND_ROBIN,
	CLUSTERED COLUMNSTORE INDEX)
AS 
SELECT *
FROM [Trip_MedallionID]; 
