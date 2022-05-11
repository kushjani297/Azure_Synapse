--1. Add Dynamic Data Masking to TaxiZones table
ALTER TABLE [NYCTaxi].[TaxiZones]  
ALTER COLUMN [Zone] varchar(100) MASKED WITH (FUNCTION = 'partial(2,"XXX",0)');  

--2. Create a test user
CREATE USER TestUser WITHOUT LOGIN; 
GO 
GRANT SELECT ON [NYCTaxi].[TaxiZones] TO TestUser; 
GO  

--3. Query the table as Test user - Queries executed the as the TestUser view masked data. 
EXECUTE AS USER = 'TestUser';   
SELECT * FROM [NYCTaxi].[TaxiZones] ;   
REVERT;    
GO 

--4. Remove masking on Zone column
ALTER TABLE [NYCTaxi].[TaxiZones] ALTER COLUMN [Zone] DROP MASKED

--5. Cleanup
DROP USER TestUser 