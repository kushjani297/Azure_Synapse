CREATE MASTER KEY;

--Credential used to authenticate to External Data Source 
CREATE DATABASE SCOPED CREDENTIAL AzureStorageCredential
WITH
    IDENTITY = 'user',
    SECRET = '<Replace with Storage Account Access Key>'
;

--Describes where the data is located at a coarse grain
--This will be on the nycstaging container that were created in Module 1's lab where the datasets are uploaded to Data Lake folders
CREATE EXTERNAL DATA SOURCE NYTBlob
WITH
(
    TYPE = Hadoop,
    LOCATION = 'wasbs://nyctaxistaging@<Replace with Data Lake Storage Account name>.blob.core.windows.net/',
	CREDENTIAL = AzureStorageCredential
);

--File formats describes how the files are written
--We will load one file which is a fact table. This will be an uncompressed file. 
CREATE EXTERNAL FILE FORMAT csvfact
WITH (
    FORMAT_TYPE = DELIMITEDTEXT,
    FORMAT_OPTIONS ( 
	FIELD_TERMINATOR = ',',
        STRING_DELIMITER = '',
        USE_TYPE_DEFAULT = False,		
		FIRST_ROW = 3
    )
);

--Dimension tables are in csv file having a pipe (|) character as delimiter.
CREATE EXTERNAL FILE FORMAT csvdimension
WITH (
    FORMAT_TYPE = DELIMITEDTEXT,
    FORMAT_OPTIONS ( 
	FIELD_TERMINATOR = '|',
        STRING_DELIMITER = '',
        USE_TYPE_DEFAULT = False,		
		FIRST_ROW = 2
    )
);


--Create a schema for the staging/external tables
CREATE SCHEMA [NYTaxiSTG];


--External table creates a reference to the file in the blob storage, the table is not created in Synapse SQL Pool physically
--The below external table will references only one .csv file as this will be loaded incrementally for December 2018 only.
CREATE EXTERNAL TABLE [NYTaxiSTG].[Trips]
(
    [VendorID] varchar(10) NOT NULL,
    [tpep_pickup_datetime] datetime NOT NULL,
    [tpep_dropoff_datetime] datetime NOT NULL,
    [passenger_count] int NOT NULL,
    [trip_distance] float NOT NULL,
    [RateCodeID] int NULL,
    [store_and_fwd_flag] varchar(3) NULL,
    [PULocationID] int NULL,
    [DOLocationID] int NULL,
    [payment_type] int NULL,
    [fare_amount] money NULL,
    [extra] money NULL,
    [mta_tax] money NULL,
    [tip_amount] money NULL,
    [tolls_amount] money NULL,
    [improvement_surcharge] money NULL,
    [total_amount] money NULL
)
WITH
(
    LOCATION = 'fact/yellow_tripdata_2018-12.csv',
    DATA_SOURCE = NYTBlob,
    FILE_FORMAT = csvfact,
    REJECT_TYPE = value,
    REJECT_VALUE = 0
);




--The following statements creates external table reference to the csv files in Azure Data Lake for all the dimension tables
CREATE EXTERNAL TABLE [NYTaxiSTG].[TaxiZones]
(
    [LocationID] int NOT NULL,
    [Borough] varchar(30) NOT NULL,
	[Zone] varchar(100) NOT NULL,
	[service_zone] varchar(30) NOT NULL
)
WITH
(
    LOCATION = 'dimension/taxi_zone_lookup.csv',
    DATA_SOURCE = NYTBlob,
    FILE_FORMAT = csvdimension,
    REJECT_TYPE = value,
    REJECT_VALUE = 0
);

CREATE EXTERNAL TABLE [NYTaxiSTG].[RateCode]
(
    [RateCodeID] int NOT NULL,
    [Description] varchar(30) NOT NULL
)
WITH
(
    LOCATION = 'dimension/RateCode.csv',
    DATA_SOURCE = NYTBlob,
    FILE_FORMAT = csvdimension,
    REJECT_TYPE = value,
    REJECT_VALUE = 0
);


CREATE EXTERNAL TABLE [NYTaxiSTG].[StoreFwdFlag]
(
    [Flag] varchar(2) NOT NULL,
    [Description] varchar(40) NOT NULL
)
WITH
(
    LOCATION = 'dimension/StoreFwdFlag.csv',
    DATA_SOURCE = NYTBlob,
    FILE_FORMAT = csvdimension,
    REJECT_TYPE = value,
    REJECT_VALUE = 0
);


CREATE EXTERNAL TABLE [NYTaxiSTG].[Vendor]
(
    [VendorID] int NOT NULL,
    [Description] varchar(40) NOT NULL
)
WITH
(
    LOCATION = 'dimension/Vendor.csv',
    DATA_SOURCE = NYTBlob,
    FILE_FORMAT = csvdimension,
    REJECT_TYPE = value,
    REJECT_VALUE = 0
);

CREATE EXTERNAL TABLE [NYTaxiSTG].[Date]
(
    [Date] date NOT NULL,
    [DateKey] int NOT NULL,
	[Month] varchar(15) NOT NULL,
	[Year] int NOT NULL,
	[MonthNo] int NOT NULL,
	[QuarterNo] int NOT NULL,
	[Quarter] varchar(5) NOT NULL,
	[MMM-YYYY] varchar(20) NOT NULL,
	[DayOfWeekNo] int NOT NULL,
	[DayOfWeek] varchar(11) NOT NULL,
	[Day] int
)
WITH
(
    LOCATION = 'dimension/Date.csv',
    DATA_SOURCE = NYTBlob,
    FILE_FORMAT = csvdimension,
    REJECT_TYPE = value,
    REJECT_VALUE = 0
);


CREATE EXTERNAL TABLE [NYTaxiSTG].[PaymentType]
(
    [PaymentTypeID] int NOT NULL,
    [PaymentType] varchar(40) NOT NULL
)
WITH
(
    LOCATION = 'dimension/PaymentType.csv',
    DATA_SOURCE = NYTBlob,
    FILE_FORMAT = csvdimension,
    REJECT_TYPE = value,
    REJECT_VALUE = 0
);