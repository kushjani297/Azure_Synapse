COPY INTO [dbo].[Date]
FROM 'https://nytaxiblob.blob.core.windows.net/2013/Date'
WITH
(
    FILE_TYPE = 'CSV',
	FIELDTERMINATOR = ',',
	FIELDQUOTE = ''
)
OPTION (LABEL = 'COPY : Load [dbo].[Date] - Taxi dataset');


COPY INTO [dbo].[Geography]
FROM 'https://nytaxiblob.blob.core.windows.net/2013/Geography'
WITH
(
    FILE_TYPE = 'CSV',
	FIELDTERMINATOR = ',',
	FIELDQUOTE = ''
)
OPTION (LABEL = 'COPY : Load [dbo].[Geography] - Taxi dataset');

COPY INTO [dbo].[HackneyLicense]
FROM 'https://nytaxiblob.blob.core.windows.net/2013/HackneyLicense'
WITH
(
    FILE_TYPE = 'CSV',
	FIELDTERMINATOR = ',',
	FIELDQUOTE = ''
)
OPTION (LABEL = 'COPY : Load [dbo].[HackneyLicense] - Taxi dataset');

COPY INTO [dbo].[Medallion]
FROM 'https://nytaxiblob.blob.core.windows.net/2013/Medallion'
WITH
(
    FILE_TYPE = 'CSV',
	FIELDTERMINATOR = ',',
	FIELDQUOTE = ''
)
OPTION (LABEL = 'COPY : Load [dbo].[Medallion] - Taxi dataset');

COPY INTO [dbo].[Time]
FROM 'https://nytaxiblob.blob.core.windows.net/2013/Time'
WITH
(
    FILE_TYPE = 'CSV',
	FIELDTERMINATOR = ',',
	FIELDQUOTE = ''
)
OPTION (LABEL = 'COPY : Load [dbo].[Time] - Taxi dataset');

COPY INTO [dbo].[Weather]
FROM 'https://nytaxiblob.blob.core.windows.net/2013/Weather'
WITH
(
    FILE_TYPE = 'CSV',
	FIELDTERMINATOR = ',',
	FIELDQUOTE = '',
	ROWTERMINATOR='0X0A'
)
OPTION (LABEL = 'COPY : Load [dbo].[Weather] - Taxi dataset');

COPY INTO [dbo].[Trip]
FROM 'https://nytaxiblob.blob.core.windows.net/2013/Trip2013'
WITH
(
    FILE_TYPE = 'CSV',
	FIELDTERMINATOR = '|',
	FIELDQUOTE = '',
	ROWTERMINATOR='0X0A',
	COMPRESSION = 'GZIP'
)
OPTION (LABEL = 'COPY : Load [dbo].[Trip] - Taxi dataset');




-- Fully Populate the Medallion table for all values in the Trip table
INSERT [dbo].[Medallion]
SELECT DISTINCT MedallionID, 'xxxxxxxxx -' + CAST(MedallionID AS VARCHAR(38)), CAST(MedallionID AS VARCHAR(50))
    FROM [dbo].[Trip]
        WHERE MedallionID NOT IN (SELECT MedallionID
                                      FROM [dbo].[Medallion])




-- Fully Populate the HackneyLicense table for all values in the Trip table
INSERT [dbo].[HackneyLicense]
SELECT DISTINCT HackneyLicenseID, 'xxxxxxxxx -' + CAST(HackneyLicenseID AS VARCHAR(38)), CAST(HackneyLicenseID AS VARCHAR(50))
    FROM [dbo].[Trip]
        WHERE HackneyLicenseID NOT IN (SELECT HackneyLicenseID
                                      FROM [dbo].[HackneyLicense])



