--1. Create a test user
CREATE USER TestUser WITHOUT LOGIN;

--2. Specify which columns are accessible for query
GRANT SELECT ON [NYCTaxi].[Trips]([VendorID],[tpep_pickup_date],[tpep_dropoff_date],[passenger_count],[trip_distance],[RateCodeID],[store_and_fwd_flag],[PULocationID],[DOLocationID],[payment_type],[fare_amount]) TO TestUser;

--3. Execute a SELECT query as the user created previously
-- Note that the columns extra, mta_tax, tip_amount, tolls_amount, improvement_surcharge and total_amount are not granted for SELECT in the above statement
EXECUTE AS USER = 'TestUser';   
SELECT * FROM [NYCTaxi].[Trips];   
REVERT;

--4. Select subset columns
EXECUTE AS USER = 'TestUser';   
SELECT [VendorID],[tpep_pickup_date],[tpep_dropoff_date],[passenger_count],[trip_distance],[RateCodeID],[store_and_fwd_flag],[PULocationID],[DOLocationID],[payment_type],[fare_amount] 
FROM [NYCTaxi].[Trips] 
WHERE [PULocationID] = 197;   
REVERT;

--5. Cleanup
DROP USER TestUser