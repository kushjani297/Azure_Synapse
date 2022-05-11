CREATE SCHEMA [NYCTaxi];


IF NOT EXISTS (SELECT * FROM sys.objects WHERE NAME = 'TripsStg' AND TYPE = 'U')
CREATE TABLE [NYCTaxi].[TripsStg]
	(
	 VendorID nvarchar(30),
	 tpep_pickup_datetime nvarchar(30),
	 tpep_dropoff_datetime nvarchar(30),
	 passenger_count nvarchar(30),
	 trip_distance nvarchar(30),
	 RatecodeID nvarchar(30),
	 store_and_fwd_flag nvarchar(30),
	 PULocationID nvarchar(30),
	 DOLocationID nvarchar(30),
	 payment_type nvarchar(30),
	 fare_amount nvarchar(10),
	 extra nvarchar(10),
	 mta_tax nvarchar(10),
	 tip_amount nvarchar(10),
	 tolls_amount nvarchar(10),
	 improvement_surcharge nvarchar(10),
	 total_amount nvarchar(10)
	)
WITH
	(
	DISTRIBUTION = ROUND_ROBIN,
	 HEAP
	)
GO