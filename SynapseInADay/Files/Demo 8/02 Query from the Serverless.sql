-- 1. Connect to the builtin ***SERVERLESS SQL POOL***
-- 2. Verify you are in Master database
-- 3. Create a serverless database


CREATE DATABASE ServerlessSynapseinaday
GO

-- Make sure that you are in your ***newly created database*** that you just created in the above step in the ***SERVERLESS SQL Pool***

-- 00 CREATE A DATA SOURCE
--######################################################################################################
-- Step 1: Create Database Scoped Credential 
--######################################################################################################

CREATE MASTER KEY

-- Create a database scoped credential.  Make sure that you are using the Shared Access Signature for the Storage account that you used in 00 script.  

CREATE DATABASE SCOPED CREDENTIAL credentialname
WITH IDENTITY = 'SHARED ACCESS SIGNATURE',  
SECRET = 'CreateYourOwnSASKeyFROmStorageAccount'   
--Storage Access Key to be replaced with the Access key


--######################################################################################################
-- Step 2: Create External Data Source (Pointing to your "Archive" container. Same location from script 00, Step 2)
--######################################################################################################

--SELECT * FROM sys.external_data_sources

-- Connect to the SQL Pool
CREATE EXTERNAL DATA SOURCE BlobDataSource with (  
    	  	LOCATION = 'wasbs://archive@synapseinadayadlsg2.blob.core.windows.net',  -- blobaccountname: replace w actual name
        	CREDENTIAL = credentialname --This name must match the database scoped credential name 
				)

--######################################################################################################
-- Step 3: Read the data from the blob previously data you did archive
--######################################################################################################
SELECT 
   TOP 1000 *
FROM  
    OPENROWSET(BULK '/FactSaleNov2012/*.snappy',
	DATA_SOURCE = 'BlobDataSource',
    DATA_COMPRESSION = 'org.apache.hadoop.io.compress.SnappyCodec',
        FORMAT = 'PARQUET') AS r






