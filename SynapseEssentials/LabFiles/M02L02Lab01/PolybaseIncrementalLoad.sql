-- Incrementally load the fact table Trips with Polybase
INSERT INTO [NYCTaxi].[Trips]
SELECT cast([VendorID] as varchar(10)) as [VendorID],
    cast([tpep_pickup_datetime] as date) as [tpep_pickup_date],
    cast([tpep_dropoff_datetime] as date) as [tpep_dropoff_date],
    cast([passenger_count] as int) as [passenger_count],
    cast([trip_distance] as float) as [trip_distance],
    cast([RateCodeID] as int) as [RateCodeID],
    cast([store_and_fwd_flag] as varchar(3)) as [store_and_fwd_flag],
    cast([PULocationID] as int ) as [PULocationID],
    cast([DOLocationID] as int ) as [DOLocationID],
    cast([payment_type] as int ) as [payment_type], 
    cast([fare_amount] as money ) as [fare_amount],
    cast([extra] as money ) as [extra],
    cast([mta_tax] as money ) as [mta_tax],
    cast([tip_amount] as money ) as [tip_amount],
    cast([tolls_amount] as money ) as [tolls_amount],
    cast([improvement_surcharge] as money ) as [improvement_surcharge],
    cast([total_amount] as money) as [total_amount]
 FROM [NYTaxiSTG].[Trips]
 OPTION (LABEL='Trips:PolybaseIncrementalLoad')