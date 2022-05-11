SELECT
    OrderDateKey, StockItemKey, Description,
    CAST(SUM(TotalIncludingTax) AS decimal(18,2)) AS [(sum) TotalIncludingTax],
    CAST(AVG(TotalIncludingTax) AS decimal(18,2)) AS [(avg) TotalIncludingTax],
    SUM(Quantity) AS [(sum) Quantity]
 FROM [wwi].[FactOrder]
 AS [result]
    GROUP BY OrderDateKey, StockItemKey, Description
