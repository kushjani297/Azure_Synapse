--Load data from external tables to managed tables into Synapse SQL Pool

--First load all the dimension tables
CREATE  TABLE [NYCTaxi].[TaxiZones]
WITH
(
	CLUSTERED INDEX ([LocationID]),
    DISTRIBUTION = HASH(LocationID)
)
AS SELECT * FROM [NYTaxiSTG].[TaxiZones]
OPTION (LABEL = 'CTAS:TaxiZones')
;


CREATE TABLE [NYCTaxi].[PaymentType]
WITH
(
	CLUSTERED INDEX ([PaymentType]),
    DISTRIBUTION = ROUND_ROBIN
)
AS SELECT * FROM [NYTaxiSTG].[PaymentType]
OPTION (LABEL = 'CTAS:PaymentType')
;


CREATE TABLE [NYCTaxi].[RateCode]
WITH
(
	CLUSTERED INDEX ([RateCodeID]),
    DISTRIBUTION = ROUND_ROBIN
)
AS SELECT * FROM [NYTaxiSTG].[RateCode]
OPTION (LABEL = 'CTAS:RateCode')
;


CREATE TABLE [NYCTaxi].[Vendor]
WITH
(
	CLUSTERED INDEX ([VendorID]),
    DISTRIBUTION = ROUND_ROBIN
)
AS SELECT * FROM [NYTaxiSTG].[Vendor]
OPTION (LABEL = 'CTAS:Vendor')
;