-- A: Create a master key.
-- Only necessary if one does not already exist.
-- Required to encrypt the credential secret in the next step.

CREATE MASTER KEY;


--######################################################################################################
-- Step 1: Create Database Scoped Credential (linked to Azure Blob Storage Account) 
--######################################################################################################

-- Connect to the SQL Pool
-- Create a database scoped credential
CREATE DATABASE SCOPED CREDENTIAL credentialname
WITH IDENTITY = 'Blob Storage',  
SECRET = 'SampleSampleSampleSampleSampleSample5akd1wpWw=='   --Storage Access Key to be replaced with the Access key


--######################################################################################################
-- Step 2: Create External Data Source (Link to a particular container of the Azure Blob Storage Account)
--######################################################################################################

--SELECT * FROM sys.external_data_sources

-- Connect to the SQL Pool
CREATE EXTERNAL DATA SOURCE datasourcename with (  
    	TYPE = HADOOP,
        	LOCATION = 'wasbs://pocmigrations@blobaccountname.blob.core.windows.net',  -- blobaccountname: replace w actual name
        	CREDENTIAL = credentialname --This name must match the database scoped credential name 
				)


--######################################################################################################
-- Step 3: Create External File Format
--######################################################################################################

--SELECT * FROM sys.external_file_formats

-- Connect to the SQL Pool
CREATE EXTERNAL FILE FORMAT ParquetFile
WITH (  
    FORMAT_TYPE = PARQUET,  
    DATA_COMPRESSION = 'org.apache.hadoop.io.compress.SnappyCodec'  
);

