-- Optimize columnstore compression
-- By default, SQL Pool stores the table as a clustered columnstore index. 
-- After a load completes, some of the data rows might not be compressed into the columnstore.
-- There's a variety of reasons why this can happen. To learn more, see ... .
--
-- To optimize query performance and columnstore compression after a load, rebuild the table to force
-- the columnstore index to compress all the rows. 

SELECT GETDATE();
GO
ALTER INDEX ALL ON [cso].[FactStrategyPlan]         REBUILD;
ALTER INDEX ALL ON [cso].[DimAccount]               REBUILD;
ALTER INDEX ALL ON [cso].[DimChannel]               REBUILD;
ALTER INDEX ALL ON [cso].[DimCurrency]              REBUILD;
ALTER INDEX ALL ON [cso].[DimCustomer]              REBUILD;
ALTER INDEX ALL ON [cso].[DimDate]                  REBUILD;
ALTER INDEX ALL ON [cso].[DimEmployee]              REBUILD;
ALTER INDEX ALL ON [cso].[DimEntity]                REBUILD;
ALTER INDEX ALL ON [cso].[DimGeography]             REBUILD;
ALTER INDEX ALL ON [cso].[DimMachine]               REBUILD;
ALTER INDEX ALL ON [cso].[DimOutage]                REBUILD;
ALTER INDEX ALL ON [cso].[DimProduct]               REBUILD;
ALTER INDEX ALL ON [cso].[DimProductCategory]       REBUILD;
ALTER INDEX ALL ON [cso].[DimScenario]              REBUILD;
ALTER INDEX ALL ON [cso].[DimPromotion]             REBUILD;
ALTER INDEX ALL ON [cso].[DimProductSubcategory]    REBUILD;
ALTER INDEX ALL ON [cso].[DimSalesTerritory]        REBUILD;
ALTER INDEX ALL ON [cso].[DimStore]                 REBUILD;
ALTER INDEX ALL ON [cso].[FactITMachine]            REBUILD;
ALTER INDEX ALL ON [cso].[FactITSLA]                REBUILD;
ALTER INDEX ALL ON [cso].[FactInventory]            REBUILD;
ALTER INDEX ALL ON [cso].[FactOnlineSales]          REBUILD;
ALTER INDEX ALL ON [cso].[FactSales]                REBUILD;
ALTER INDEX ALL ON [cso].[FactSalesQuota]           REBUILD;
ALTER INDEX ALL ON [cso].[FactExchangeRate]         REBUILD;