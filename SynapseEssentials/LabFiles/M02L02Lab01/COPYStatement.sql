


COPY INTO [NYCTaxi].[TripsStg]
FROM 'https://farghamstrorageadf.blob.core.windows.net/nyctaxistaging/*.parquet'
WITH
(
	CREDENTIAL=(IDENTITY= 'Storage Account Key', SECRET='2lWqfm8DT1WZmqm63lPJtx3K/YqINJyPnAan/IGOqnTU3N4/thigMmZd9apQPv6x3k/fAgiuldZPvL1VATzG9g=='),
	FILE_TYPE = 'Parquet'
	,MAXERRORS = 0
	,IDENTITY_INSERT = 'OFF'
	)
GO


COPY INTO [NYCTaxi].[TripsStg]
FROM 'https://farghamstrorageadf.blob.core.windows.net/nyctaxistaging/fact/*.parquet'
WITH
(
	CREDENTIAL=(IDENTITY= 'Shared Access Signature', SECRET='?sv=2019-12-12&ss=bfqt&srt=sco&sp=rwdlacupx&se=2021-01-31T03:08:07Z&st=2021-01-04T19:08:07Z&spr=https&sig=mh81nUyJ2BPVoSvLUZIAsm%2BSwsSlhozWwqSgW0DNjco%3D'),
	FILE_TYPE = 'PARQUET'
	,MAXERRORS = 0
	,IDENTITY_INSERT = 'OFF'
	)
GO


