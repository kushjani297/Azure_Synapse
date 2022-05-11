IF( object_id ('Trip_HackneyLicenseID')) IS NOT NULL DROP TABLE Trip_HackneyLicenseID
IF( object_id ('Medallion_HD')) IS NOT NULL DROP TABLE Medallion_HD
IF( object_id ('HackneyLicense_HD')) IS NOT NULL DROP TABLE HackneyLicense_HD
GO

-- Copy the filtered Trip table, HASHED on HackneyLicenseID
CREATE TABLE Trip_HackneyLicenseID
WITH ( DISTRIBUTION = HASH ( [HackneyLicenseID] ),
       CLUSTERED COLUMNSTORE INDEX )
AS 
SELECT *
FROM [Trip_MedallionID];


-- Create a HASH Distributed copy of the Medallion table (HD = Hash Distributed)
CREATE TABLE Medallion_HD
WITH ( DISTRIBUTION = HASH ( [MedallionID] ),
       HEAP )
AS 
SELECT *
FROM [Medallion];


-- Create a HASH Distributed copy of the HackneyLicense table (HD = Hash Distributed)
CREATE TABLE HackneyLicense_HD
WITH ( DISTRIBUTION = HASH ( [HackneyLicenseID] ),
       HEAP )
AS 
SELECT *
FROM [HackneyLicense]

